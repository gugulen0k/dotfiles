#!/usr/bin/env python3
"""
Universal Theme Switcher for dotfiles
Supports switching themes across nvim, tmux, zsh, ghostty, and alacritty
Uses TOML configuration for theme definitions
"""

import sys
import re
import argparse
import tomllib
from pathlib import Path
from typing import List, Optional


class ThemeSwitcher:
    def __init__(self, config_file: Optional[str] = None):
        self.home = Path.home()
        self.config_dir = self.home / ".config"

        # Default config file locations - define this outside the conditional
        possible_configs = [
            self.config_dir / "theme-switcher" / "themes.toml",
            self.home / ".config" / "themes.toml",
            Path(__file__).parent / "themes.toml",
        ]

        # Default config file locations
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
        except Exception as e:
            print(f"Error loading config file {self.config_file}: {e}")
            sys.exit(1)

    def create_sample_config(self, output_path: str):
        """Create a sample themes.toml configuration file"""
        sample_config = """# Theme Switcher Configuration
# Define your themes here with their respective configurations

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
            "Edit this file to customize your themes and then run the theme switcher again."
        )

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

            # Update background setting
            content = re.sub(
                r"vim\.opt\.background\s*=\s*['\"][^'\"]*['\"]",
                f"vim.opt.background = '{background}'",
                content,
            )

            # Add more colorscheme-specific logic here as needed
            # Update Rose Pine variant
            if colorscheme == "rose-pine":
                content = re.sub(
                    r"variant\s*=\s*['\"][^'\"]*['\"]",
                    f"variant = '{variant}'",
                    content,
                )

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

    def switch_theme(self, theme_name: str, apps: Optional[List[str]] = None):
        """Switch theme across all or specified applications"""
        if theme_name not in self.themes:
            print(f"✗ Theme '{theme_name}' not found!")
            print("Use --list to see available themes")
            return False

        if apps is None:
            apps = ["nvim", "tmux", "zsh", "ghostty", "alacritty"]

        success_count = 0
        total_count = len(apps)

        theme_info = self.themes[theme_name]
        print(f"Switching to theme: {theme_name}")
        if "description" in theme_info:
            print(f"Description: {theme_info['description']}")
        print("-" * 50)

        for app in apps:
            if app == "nvim" and "nvim" in theme_info:
                if self.update_nvim_theme(theme_name):
                    success_count += 1
            elif app == "tmux" and "tmux" in theme_info:
                if self.update_tmux_theme(theme_name):
                    success_count += 1
            elif app == "zsh" and "zsh" in theme_info:
                if self.update_zsh_theme(theme_name):
                    success_count += 1
            elif app == "ghostty" and "ghostty" in theme_info:
                if self.update_ghostty_theme(theme_name):
                    success_count += 1
            elif app == "alacritty" and "alacritty" in theme_info:
                if self.update_alacritty_theme(theme_name):
                    success_count += 1
            elif app not in theme_info:
                print(f"⚠ Theme '{theme_name}' has no configuration for {app}")
            else:
                print(f"✗ Unknown application: {app}")

        print("-" * 50)
        print(f"Updated {success_count}/{total_count} applications successfully")

        if success_count > 0:
            print("\nTo apply changes:")
            if "tmux" in apps and success_count > 0:
                print("  • Tmux: Run 'tmux source ~/.tmux.conf' or restart tmux")
            if "zsh" in apps and success_count > 0:
                print("  • Zsh: Run 'source ~/.zshrc' or restart your shell")
            if "nvim" in apps and success_count > 0:
                print("  • Nvim: Restart nvim")
            if "ghostty" in apps and success_count > 0:
                print("  • Ghostty: Restart ghostty")
            if "alacritty" in apps and success_count > 0:
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

    switcher.switch_theme(args.theme, args.apps)


if __name__ == "__main__":
    main()
