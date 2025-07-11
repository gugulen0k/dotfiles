#!/usr/bin/env python3
"""
Universal Theme Switcher for dotfiles
Supports switching themes across nvim, tmux, zsh, ghostty, and alacritty
Uses TOML configuration for theme definitions
Automatically reloads configuration files after successful theme changes
"""

import sys
import re
import argparse
import tomllib
import subprocess
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple


class ThemeSwitcher:
    def __init__(self, config_file: Optional[str] = None):
        self.home = Path.home()
        self.config_dir = self.home / ".config"

        # Default config file locations
        possible_configs = [
            self.config_dir / "theme-switcher" / "themes.toml",
            self.home / ".config" / "themes.toml",
            Path(__file__).parent / "themes.toml",
        ]

        if config_file:
            self.config_file = Path(config_file)
        else:
            # Try multiple locations
            self.config_file = None
            for config_path in possible_configs:
                if config_path.exists():
                    self.config_file = config_path
                    break

        if not self.config_file or not self.config_file.exists():
            print("Error: No theme configuration file found!")
            print("Expected locations:")
            for path in possible_configs:
                print(f"  - {path}")
            print("\nUse --create-config to generate a sample configuration")
            sys.exit(1)

        # Load themes from TOML file
        try:
            with open(self.config_file, "rb") as f:
                self.config = tomllib.load(f)
                self.themes = self.config.get("themes", {})
                self.reload_config = self.config.get("reload", {})
        except Exception as e:
            print(f"Error loading config file {self.config_file}: {e}")
            sys.exit(1)

    def create_sample_config(self, output_path: str):
        """Create a sample themes.toml configuration file"""
        sample_config = """# Theme Switcher Configuration
# Define your themes here with their respective configurations

# Reload configuration - defines how to reload each application
[reload]
# Set to true to enable automatic reloading after theme changes
enabled = true

# Reload timeout in seconds (how long to wait before reloading)
delay = 1.0

# Per-application reload settings
[reload.tmux]
enabled = true
# Commands to run for tmux reload
commands = [
    "tmux source-file ~/.tmux.conf",
    "tmux display-message 'Theme reloaded!'"
]
# Alternative: kill and restart tmux sessions
# commands = ["tmux kill-server"]

[reload.zsh]
enabled = true
# Note: ZSH reload requires sourcing in current shell
# The script will provide instructions since it can't directly reload the current shell
commands = []

[reload.nvim]
enabled = true
# Reload nvim by sending commands to running instances
commands = [
    "nvim --server-name VIM --remote-send '<Esc>:source ~/.config/nvim/init.lua<CR>'",
    "nvim --headless -c 'colorscheme rose-pine' -c 'qa'"
]

[reload.ghostty]
enabled = true
# Ghostty automatically reloads config, but we can send a signal
commands = [
    "pkill -USR1 ghostty"
]

[reload.alacritty]
enabled = true
# Alacritty automatically reloads config when file changes
commands = []

# Theme definitions
[themes.rose-pine-dawn]
mode = "light"
description = "Rose Pine Dawn - Warm light theme"

[themes.rose-pine-dawn.nvim]
variant = "dawn"
background = "light"
colorscheme = "rose-pine"

[themes.rose-pine-dawn.tmux]
yellow_bg = "#ea9d34"
yellow_fg = "#faf4ed"

[themes.rose-pine-dawn.zsh]
theme = "gugulenok-light-rose-pine"

[themes.rose-pine-dawn.ghostty]
theme = "rose-pine-dawn"

[themes.rose-pine-dawn.alacritty]
import_path = "~/.config/alacritty/theme/rose-pine/rose-pine-dawn.toml"

# ============================================================================

[themes.rose-pine]
mode = "dark"
description = "Rose Pine Main - Cozy dark theme"

[themes.rose-pine.nvim]
variant = "main"
background = "dark"
colorscheme = "rose-pine"

[themes.rose-pine.tmux]
yellow_bg = "#f6c177"
yellow_fg = "#191724"

[themes.rose-pine.zsh]
theme = "gugulenok-dark-rose-pine"

[themes.rose-pine.ghostty]
theme = "rose-pine"

[themes.rose-pine.alacritty]
import_path = "~/.config/alacritty/theme/rose-pine/rose-pine.toml"

# ============================================================================

[themes.rose-pine-moon]
mode = "dark"
description = "Rose Pine Moon - Elegant dark theme"

[themes.rose-pine-moon.nvim]
variant = "moon"
background = "dark"
colorscheme = "rose-pine"

[themes.rose-pine-moon.tmux]
yellow_bg = "#f6c177"
yellow_fg = "#232136"

[themes.rose-pine-moon.zsh]
theme = "gugulenok-dark-rose-pine"

[themes.rose-pine-moon.ghostty]
theme = "rose-pine-moon"

[themes.rose-pine-moon.alacritty]
import_path = "~/.config/alacritty/theme/rose-pine/rose-pine-moon.toml"

# ============================================================================

[themes.nordic]
mode = "dark"
description = "Nordic - Cool blue dark theme"

[themes.nordic.nvim]
variant = "main"
background = "dark"
colorscheme = "nordic"

[themes.nordic.tmux]
yellow_bg = "#ebcb8b"
yellow_fg = "#242933"

[themes.nordic.zsh]
theme = "gugulenok-dark-nordic"

[themes.nordic.ghostty]
theme = "nordic"

[themes.nordic.alacritty]
import_path = "~/.config/alacritty/themes/themes/nordic.toml"

# ============================================================================

[themes.catppuccin-mocha]
mode = "dark"
description = "Catppuccin Mocha - Warm dark theme"

[themes.catppuccin-mocha.nvim]
variant = "mocha"
background = "dark"
colorscheme = "catppuccin"

[themes.catppuccin-mocha.tmux]
yellow_bg = "#f9e2af"
yellow_fg = "#1e1e2e"

[themes.catppuccin-mocha.zsh]
theme = "gugulenok-dark-catppuccin"

[themes.catppuccin-mocha.ghostty]
theme = "catppuccin-mocha"

[themes.catppuccin-mocha.alacritty]
import_path = "~/.config/alacritty/theme/catppuccin/catppuccin-mocha.yml"

# ============================================================================

[themes.gruvbox-material-light]
mode = "light"
description = "Gruvbox Material Light - Retro light theme"

[themes.gruvbox-material-light.nvim]
variant = "light"
background = "light"
colorscheme = "gruvbox-material"

[themes.gruvbox-material-light.tmux]
yellow_bg = "#a96b2c"
yellow_fg = "#fbf1c7"

[themes.gruvbox-material-light.zsh]
theme = "gugulenok-light-gruvbox"

[themes.gruvbox-material-light.ghostty]
theme = "gruvbox-light"

[themes.gruvbox-material-light.alacritty]
import_path = "~/.config/alacritty/theme/gruvbox/gruvbox-light.toml"

# ============================================================================

[themes.gruvbox-material-dark]
mode = "dark"
description = "Gruvbox Material Dark - Retro dark theme"

[themes.gruvbox-material-dark.nvim]
variant = "dark"
background = "dark"
colorscheme = "gruvbox-material"

[themes.gruvbox-material-dark.tmux]
yellow_bg = "#d8a657"
yellow_fg = "#282828"

[themes.gruvbox-material-dark.zsh]
theme = "gugulenok-dark-gruvbox"

[themes.gruvbox-material-dark.ghostty]
theme = "gruvbox-dark"

[themes.gruvbox-material-dark.alacritty]
import_path = "~/.config/alacritty/theme/gruvbox/gruvbox-dark.toml"
"""

        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, "w") as f:
            f.write(sample_config)

        print(f"✓ Created sample configuration at: {output_file}")
        print(
            "Edit this file to customize your themes and reload settings, then run the theme switcher again."
        )

    def run_command(self, command: str, ignore_errors: bool = True) -> Tuple[bool, str]:
        """Execute a shell command and return success status and output"""
        try:
            result = subprocess.run(
                command, shell=True, capture_output=True, text=True, timeout=30
            )
            if result.returncode == 0:
                return True, result.stdout.strip()
            else:
                if not ignore_errors:
                    print(f"  Command failed: {command}")
                    print(f"  Error: {result.stderr.strip()}")
                return False, result.stderr.strip()
        except subprocess.TimeoutExpired:
            print(f"  Command timed out: {command}")
            return False, "Command timed out"
        except Exception as e:
            if not ignore_errors:
                print(f"  Error running command '{command}': {e}")
            return False, str(e)

    def reload_application(self, app_name: str) -> bool:
        """Reload configuration for a specific application"""
        if not self.reload_config.get("enabled", False):
            return False

        app_reload_config = self.reload_config.get(app_name, {})
        if not app_reload_config.get("enabled", False):
            return False

        commands = app_reload_config.get("commands", [])
        if not commands:
            # Some applications reload automatically
            return True

        print(f"  Reloading {app_name}...")

        success_count = 0
        for command in commands:
            success, output = self.run_command(command)
            if success:
                success_count += 1
                if output:
                    print(f"    {output}")
            else:
                print(f"    Failed to execute: {command}")

        return success_count == len(commands)

    def reload_all_applications(self, updated_apps: List[str]) -> Dict[str, bool]:
        """Reload all applications that were successfully updated"""
        if not self.reload_config.get("enabled", False):
            print("⚠ Auto-reload is disabled in configuration")
            return {}

        delay = self.reload_config.get("delay", 1.0)
        if delay > 0:
            print(f"Waiting {delay} seconds before reloading...")
            time.sleep(delay)

        print("Reloading configurations...")
        print("-" * 30)

        reload_results = {}
        for app in updated_apps:
            success = self.reload_application(app)
            reload_results[app] = success

            if success:
                print(f"  ✓ {app} reloaded successfully")
            else:
                print(f"  ⚠ {app} reload skipped or failed")

        return reload_results

    def list_themes(self):
        """List all available themes"""
        if not self.themes:
            print("No themes found in configuration file!")
            return

        print(f"Available themes (from {self.config_file}):")
        print()

        for theme_name, config in self.themes.items():
            mode = config.get("mode", "unknown")
            description = config.get("description", "No description")
            print(f"  {theme_name:<25} ({mode}) - {description}")

    def update_nvim_theme(self, theme_name: str):
        """Update Neovim colorscheme configuration"""
        nvim_config = (
            self.config_dir
            / "nvim"
            / "lua"
            / "gugulenok"
            / "plugins"
            / "colorscheme.lua"
        )

        if not nvim_config.exists():
            print(f"Warning: Nvim config file not found at {nvim_config}")
            return False

        theme_config = self.themes[theme_name].get("nvim", {})
        variant = theme_config.get("variant", "main")
        background = theme_config.get("background", "dark")
        colorscheme = theme_config.get("colorscheme", "rose-pine")

        try:
            with open(nvim_config, "r") as f:
                content = f.read()

            # Update Rose Pine variant
            if colorscheme == "rose-pine":
                content = re.sub(
                    r"variant\s*=\s*['\"][^'\"]*['\"]",
                    f"variant = '{variant}'",
                    content,
                )

                # Update background setting
                content = re.sub(
                    r"vim\.opt\.background\s*=\s*['\"][^'\"]*['\"]",
                    f"vim.opt.background = '{background}'",
                    content,
                )

            # Add more colorscheme-specific logic here as needed

            with open(nvim_config, "w") as f:
                f.write(content)

            print(f"✓ Updated Neovim theme to {theme_name}")
            return True

        except Exception as e:
            print(f"✗ Failed to update Neovim theme: {e}")
            return False

    def update_tmux_theme(self, theme_name: str):
        """Update tmux theme configuration"""
        tmux_config = self.home / ".tmux.conf"

        if not tmux_config.exists():
            print(f"Warning: Tmux config file not found at {tmux_config}")
            return False

        theme_config = self.themes[theme_name].get("tmux", {})
        yellow_bg = theme_config.get("yellow_bg", "#f6c177")
        yellow_fg = theme_config.get("yellow_fg", "#191724")

        try:
            with open(tmux_config, "r") as f:
                content = f.read()

            # Update theme colors
            content = re.sub(
                r'thm_yellow_bg="[^"]*"', f'thm_yellow_bg="{yellow_bg}"', content
            )
            content = re.sub(
                r'thm_yellow_fg="[^"]*"', f'thm_yellow_fg="{yellow_fg}"', content
            )

            with open(tmux_config, "w") as f:
                f.write(content)

            print(f"✓ Updated tmux theme to {theme_name}")
            return True

        except Exception as e:
            print(f"✗ Failed to update tmux theme: {e}")
            return False

    def update_zsh_theme(self, theme_name: str):
        """Update zsh theme configuration"""
        zsh_config = self.home / ".zshrc"

        if not zsh_config.exists():
            print(f"Warning: Zsh config file not found at {zsh_config}")
            return False

        theme_config = self.themes[theme_name].get("zsh", {})
        zsh_theme = theme_config.get("theme", "robbyrussell")

        try:
            with open(zsh_config, "r") as f:
                content = f.read()

            # Update ZSH_THEME
            content = re.sub(r'ZSH_THEME="[^"]*"', f'ZSH_THEME="{zsh_theme}"', content)

            with open(zsh_config, "w") as f:
                f.write(content)

            print(f"✓ Updated zsh theme to {zsh_theme}")
            return True

        except Exception as e:
            print(f"✗ Failed to update zsh theme: {e}")
            return False

    def update_ghostty_theme(self, theme_name: str):
        """Update Ghostty theme configuration"""
        ghostty_config = self.config_dir / "ghostty" / "config"

        if not ghostty_config.exists():
            print(f"Warning: Ghostty config file not found at {ghostty_config}")
            return False

        theme_config = self.themes[theme_name].get("ghostty", {})
        ghostty_theme = theme_config.get("theme", "default")

        try:
            with open(ghostty_config, "r") as f:
                content = f.read()

            # Update theme
            content = re.sub(
                r"theme\s*=\s*[^\n\r]*", f"theme = {ghostty_theme}", content
            )

            with open(ghostty_config, "w") as f:
                f.write(content)

            print(f"✓ Updated Ghostty theme to {ghostty_theme}")
            return True

        except Exception as e:
            print(f"✗ Failed to update Ghostty theme: {e}")
            return False

    def update_alacritty_theme(self, theme_name: str):
        """Update Alacritty theme configuration"""
        alacritty_config = self.config_dir / "alacritty" / "alacritty.toml"

        if not alacritty_config.exists():
            print(f"Warning: Alacritty config file not found at {alacritty_config}")
            return False

        theme_config = self.themes[theme_name].get("alacritty", {})
        import_path = theme_config.get("import_path", "")

        try:
            with open(alacritty_config, "r") as f:
                content = f.read()

            # Update import path
            content = re.sub(
                r"import\s*=\s*\[[^\]]*\]", f'import = ["{import_path}"]', content
            )

            with open(alacritty_config, "w") as f:
                f.write(content)

            print(f"✓ Updated Alacritty theme to {import_path}")
            return True

        except Exception as e:
            print(f"✗ Failed to update Alacritty theme: {e}")
            return False

    def switch_theme(
        self, theme_name: str, apps: Optional[List[str]] = None, no_reload: bool = False
    ):
        """Switch theme across all or specified applications"""
        if theme_name not in self.themes:
            print(f"✗ Theme '{theme_name}' not found!")
            print("Use --list to see available themes")
            return False

        if apps is None:
            apps = ["nvim", "tmux", "zsh", "ghostty", "alacritty"]

        success_count = 0
        total_count = len(apps)
        updated_apps = []

        theme_info = self.themes[theme_name]
        print(f"Switching to theme: {theme_name}")
        if "description" in theme_info:
            print(f"Description: {theme_info['description']}")
        print("-" * 50)

        for app in apps:
            if app == "nvim" and "nvim" in theme_info:
                if self.update_nvim_theme(theme_name):
                    success_count += 1
                    updated_apps.append(app)
            elif app == "tmux" and "tmux" in theme_info:
                if self.update_tmux_theme(theme_name):
                    success_count += 1
                    updated_apps.append(app)
            elif app == "zsh" and "zsh" in theme_info:
                if self.update_zsh_theme(theme_name):
                    success_count += 1
                    updated_apps.append(app)
            elif app == "ghostty" and "ghostty" in theme_info:
                if self.update_ghostty_theme(theme_name):
                    success_count += 1
                    updated_apps.append(app)
            elif app == "alacritty" and "alacritty" in theme_info:
                if self.update_alacritty_theme(theme_name):
                    success_count += 1
                    updated_apps.append(app)
            elif app not in theme_info:
                print(f"⚠ Theme '{theme_name}' has no configuration for {app}")
            else:
                print(f"✗ Unknown application: {app}")

        print("-" * 50)
        print(f"Updated {success_count}/{total_count} applications successfully")

        # Reload configurations if successful and not disabled
        if success_count > 0 and not no_reload:
            print()
            reload_results = self.reload_all_applications(updated_apps)

            # Show manual reload instructions for failed/skipped reloads
            manual_reload_needed = []
            for app in updated_apps:
                if not reload_results.get(app, False):
                    manual_reload_needed.append(app)

            if manual_reload_needed:
                print()
                print("Manual reload required for:")
                for app in manual_reload_needed:
                    if app == "tmux":
                        print(
                            "  • Tmux: Run 'tmux source ~/.tmux.conf' or restart tmux"
                        )
                    elif app == "zsh":
                        print("  • Zsh: Run 'source ~/.zshrc' or restart your shell")
                    elif app == "nvim":
                        print(
                            "  • Nvim: Restart nvim or run ':source ~/.config/nvim/init.lua'"
                        )
                    elif app == "ghostty":
                        print(
                            "  • Ghostty: Restart ghostty (auto-reload may be disabled)"
                        )
                    elif app == "alacritty":
                        print("  • Alacritty: Should auto-reload, restart if needed")
        elif success_count > 0 and no_reload:
            print("\nReload was skipped. To apply changes:")
            for app in updated_apps:
                if app == "tmux":
                    print("  • Tmux: Run 'tmux source ~/.tmux.conf' or restart tmux")
                elif app == "zsh":
                    print("  • Zsh: Run 'source ~/.zshrc' or restart your shell")
                elif app == "nvim":
                    print("  • Nvim: Restart nvim")
                elif app == "ghostty":
                    print("  • Ghostty: Restart ghostty")
                elif app == "alacritty":
                    print("  • Alacritty: Restart alacritty")

        return success_count == total_count


def main():
    parser = argparse.ArgumentParser(
        description="Universal theme switcher for dotfiles"
    )
    parser.add_argument("theme", nargs="?", help="Theme name to switch to")
    parser.add_argument(
        "--list", "-l", action="store_true", help="List available themes"
    )
    parser.add_argument("--config", "-c", help="Path to custom themes.toml file")
    parser.add_argument(
        "--create-config", help="Create a sample themes.toml file at the specified path"
    )
    parser.add_argument(
        "--apps",
        "-a",
        nargs="+",
        choices=["nvim", "tmux", "zsh", "ghostty", "alacritty"],
        help="Specify which applications to update (default: all)",
    )
    parser.add_argument(
        "--no-reload",
        "-n",
        action="store_true",
        help="Skip automatic configuration reload",
    )

    args = parser.parse_args()

    if args.create_config:
        # Create config without initializing the full switcher
        temp_switcher = object.__new__(ThemeSwitcher)
        temp_switcher.create_sample_config(args.create_config)
        return

    # Initialize the theme switcher with config
    try:
        switcher = ThemeSwitcher(args.config)
    except SystemExit:
        return

    if args.list:
        switcher.list_themes()
        return

    if not args.theme:
        parser.print_help()
        return

    switcher.switch_theme(args.theme, args.apps, args.no_reload)


if __name__ == "__main__":
    main()
