#!/usr/bin/env rust-script

// cargo-deps: anyhow="1.0", users = "0.11"

use std::process::exit;
use anyhow::{Result, bail};
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::ErrorKind;
use std::process::Command;
use users;

#[derive(Debug)]
pub struct CmdResult {
    pub code: Option<i32>,
    pub message: String,
    pub stdout: String,
    pub stderr: String,
}

impl CmdResult {
   pub fn exit_with_result(&self) {
      match self.code {
         Some(0) => println!("{}", self.message),
         Some(code) => {
            eprintln!("{}", self.message);

            if !self.stderr.is_empty() {
               eprintln!("\nlaunctl's stderr:\n{}", self.stderr)
            };

            exit(code)
         }
         None => {
            eprintln!("{}", self.message);
            exit(1)
         }
      }
   }
}

fn main() -> Result<()> {
   let args: Vec<String> = env::args().collect();

   let cmd = args.get(1).map(|s| s.as_str()).unwrap_or("");
   let service_arg = args.get(2).map(|s| s.as_str());

   let home = env::var("HOME")?;
   let root = env::var("LOCAL_SERVICES_DIR")
      .unwrap_or(format!("{}/.services", home));

   let launch_dir = format!("{}/Library/LaunchAgents", home);

   let services = get_local_services(&root)?;
   let domain = get_domain();

   match cmd {
      "start" | "s" => {
         let service = require_service(service_arg)?;
         validate_service(&services, service)?;
         start(&domain, service, &root, &launch_dir)?.exit_with_result();
      }

      "stop" | "t" => {
         let service = require_service(service_arg)?;
         validate_service(&services, service)?;
         stop(&domain, service, &launch_dir)?.exit_with_result();
      }

      "restart" | "rs" => {
         let service = require_service(service_arg)?;
         validate_service(&services, service)?;
         restart(&domain, service, &root, &launch_dir)?.exit_with_result();
      }

      "status" | "st" => {
         let service = require_service(service_arg)?;
         validate_service(&services, service)?;
         status(&domain, service)?;
      }

      "list" | "ls" => {
         list_services(&domain, &services);
      }

      "--help" | "-h" => {
         show_help();
         exit(0);
      }

      _ => {
         show_help();
         exit(1);
      }
   }

   Ok(())
}

fn show_help() {
   eprintln!(
      r#"
Usage:
  services start SERVICE
  services stop SERVICE
  services restart SERVICE
  services status SERVICE
  services list

Env:
  LOCAL_SERVICES_DIR (default: ~/.services)
"#
   );
}

fn get_local_services(root: &str) -> Result<HashMap<String, ()>> {
   let mut map = HashMap::new();

   let entries = fs::read_dir(root).unwrap_or_else(|_| fs::read_dir(".").unwrap());

   for entry in entries {
      let path = entry?.path();

      if path.extension().and_then(|e| e.to_str()) == Some("plist") {
         if let Some(name) = path.file_stem().and_then(|s| s.to_str()) {
            map.insert(name.to_string(), ());
         }
      }
   }

   Ok(map)
}

fn validate_service(services: &HashMap<String, ()>, service: &str) -> Result<()> {
   if !services.contains_key(service) {
      bail!("Service '{}' not found in LOCAL_SERVICES_DIR", service);
   }
   Ok(())
}

fn require_service(arg: Option<&str>) -> Result<&str> {
   arg.ok_or_else(|| anyhow::anyhow!("SERVICE_NAME is required"))
}

fn start(domain: &str, service: &str, root: &str, launch_dir: &str) -> Result<CmdResult> {
   let src = format!("{}/{}.plist", root, service);
   let dst = format!("{}/{}.plist", launch_dir, service);

   if let Err(e) = fs::remove_file(&dst) {
      if e.kind() != ErrorKind::NotFound {
         return Err(e.into());
      }
   }

   std::os::unix::fs::symlink(&src, &dst)?;

   let output = Command::new("launchctl")
      .args(["bootstrap", &domain, &dst])
      .output()?;

   let stdout = String::from_utf8_lossy(&output.stdout);
   let stderr = String::from_utf8_lossy(&output.stderr);

   let code = output.status.code();

   let message = match code {
      Some(0) => format!("Started {}", service),
      Some(5) => format!("Service {} already running!", service),
      Some(c) => {
         let first_line = stderr.lines().next().unwrap_or("UNKNOWN");
         format!("launchctl failed (code {}): {}", c, first_line)
      },
      None => {
         let first_line = stderr.lines().next().unwrap_or("UNKNOWN");
         format!("launchctl killed by signal: {}", first_line)
      },
   };

   Ok(CmdResult {
      code,
      message,
      stdout: stdout.to_string(),
      stderr: stderr.to_string(),
   })
}

fn stop(domain: &str, service: &str, launch_dir: &str) -> Result<CmdResult> {
   let plist = format!("{}/{}.plist", launch_dir, service);
   let target = format!("{}/{}", domain, service);

   let output = Command::new("launchctl")
      .args(["bootout", &target])
      .output()?;

   let stdout = String::from_utf8_lossy(&output.stdout);
   let stderr = String::from_utf8_lossy(&output.stderr);

   let code = output.status.code();

   let message = match code {
      Some(0) => format!("Stopped {}", service),
      Some(3) => format!("Service {} already stopped!", service),
      Some(c) => {
         let first_line = stderr.lines().next().unwrap_or("UNKNOWN");
         format!("launchctl failed (code {}): {}", c, first_line)
      },
      None => {
         let first_line = stderr.lines().next().unwrap_or("UNKNOWN");
         format!("launchctl killed by signal: {}", first_line)
      },
   };

   if matches!(code, Some(0)) {
      if let Err(e) = fs::remove_file(&plist) {
         if e.kind() != ErrorKind::NotFound {
            return Err(e.into());
         };
      };
   };

   Ok(CmdResult {
      code,
      message,
      stdout: stdout.to_string(),
      stderr: stderr.to_string(),
   })
}

fn restart(domain: &String, service: &str, root: &str, launch_dir: &str) -> Result<CmdResult> {
   stop(domain, service, launch_dir)?;
   start(domain, service, root, launch_dir)?;

   Ok(CmdResult {
      code: Some(0),
      message: format!("Restarted {}", service),
      stdout: "".to_string(),
      stderr: "".to_string(),
   })
}

fn status(domain: &String, service: &str) -> Result<()> {
   let output = Command::new("launchctl")
      .args(["list"])
      .output()?;

   let stdout = String::from_utf8_lossy(&output.stdout);

   if stdout.contains(service) {
      println!("{} is running", service);
   } else {
      println!("{} is not running", service);
   }

   Ok(())
}

fn list_services(domain: &String, services: &HashMap<String, ()>) {
   println!("{:<20}\t{}\t{}", "SERVICE", "STATUS", "TYPE");

   for service in services.keys() {
      let status = get_status(&domain, service);
      println!("{:<20}\t{}\tUNKNOWN", service, status);
   }
}

fn get_domain() -> String {
   let uid = users::get_current_uid();

   format!("gui/{}", uid)
}

fn get_status(domain: &String, service: &str) -> &'static str {
   let target = format!("{}/{}", domain, service);
   let output = std::process::Command::new("launchctl")
      .args(["print", &target])
      .output();

   if let Ok(out) = output {
      let text = String::from_utf8_lossy(&out.stdout);
      if text.contains("state = running") {
         return "RUNNING";
      }
   }

   "STOPPED"
}
