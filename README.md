# Dotfiles

### Install configs

> ⚠️ **Warning!**
> If you already have your configuration files and/or `.config` folder, make sure that you copied/moved your files somewhere else from home directory, this way you won't lose your current configuration.

A tool to manage symbolic links for configuration files.

Execute this command:
```bash
chmod +x symlink-manager
```

Now you can use symlink-manager as follows:
* Show help message.
  ```bash
  ./symlink-manager --help
  ```
* Show the list of all available configs.
  ```bash
  ./symlink-manager --list
  ```
* Install all configurations files from `configs.toml`
  ```bash
  ./symlink-manager --all
  ```
* Install specific configs and overwrite they already exist.
  ```bash
  ./symlink-manager zsh tmux --force
  ```
