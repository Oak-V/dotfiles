export KEYTIMEOUT=1

export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"


eval "$(mise activate zsh)"

export LDFLAGS="-L$(brew --prefix openssl@3)/lib"
export CPPFLAGS="-I$(brew --prefix openssl@3)/include"
export PKG_CONFIG_PATH="$(brew --prefix openssl@3)/lib/pkgconfig"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

export PATH="${HOME}/.local/bin:$PATH"
export PATH="$(brew --prefix curl)/bin:$PATH"
export PATH="$(brew --prefix ffmpeg-full)/bin:$PATH"
