update() {
   brew update
   brew upgrade
   mise upgrade

   brew bundle install --file ~/.Brewfile

   npm i -g npm@latest neovim@latest npm-check-updates@latest

   uv tool upgrade --all

   gem update --system
   gem update
   gem install neovim

   brew bundle dump --file ~/.Brewfile --force
}
