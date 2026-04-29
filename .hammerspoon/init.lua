hs.console.clearConsole()

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", {start = true})

hs.loadSpoon("LocalFocusFollow")

hs.loadSpoon("LocalKeyCastr")

hs.loadSpoon("LocalKeyBinder")
spoon.LocalKeyBinder:start({
   keys = {
      escape = {
         tap = { to="escape" },
         doubleTap = { to="f17", threshold = 0.21 },
         onHold = { to="capslock", threshold = 0.20 },
      },
      [";"] = {
         tap = { to=";" },
         doubleTap = { to="f16", threshold = 0.21 },
      },
   },
   shortcuts = {
      f17 = { s = "alacritty msg create-window" },
   },
})
