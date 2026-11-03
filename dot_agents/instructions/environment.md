## Global packages and dotfiles

- Use mise for globally added libraries, runtimes, and CLI packages, including
  npm packages. Manage their declarations in
  `~/ghq/github.com/kfujii-6jo/dotfiles/private_dot_config/mise/config.toml`.
- Edit that source file, then run `chezmoi apply ~/.config/mise/config.toml`
  and `mise install`.
