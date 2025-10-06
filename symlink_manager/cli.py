"""
Command-line interface for the symlink manager.
"""

import argparse
import sys
from typing import List, Optional

from .core import SymlinkManager
from .exceptions import ConfigError


class CLI:
    """Command-line interface handler."""

    def __init__(self):
        self.parser = self._create_parser()
        self.symlink_manager: Optional[SymlinkManager] = None

    def _create_parser(self) -> argparse.ArgumentParser:
        """Create argument parser."""
        parser = argparse.ArgumentParser(
            description="Manage symbolic links for configuration files", add_help=False
        )

        parser.add_argument(
            "configs",
            nargs="*",
            help="Configuration flags to install (e.g., zsh, tmux)",
        )
        parser.add_argument(
            "--force",
            "-f",
            action="store_true",
            help="Overwrite existing files/directories",
        )
        parser.add_argument(
            "--all", "-a", action="store_true", help="Install all configurations"
        )
        parser.add_argument(
            "--list",
            "-l",
            action="store_true",
            help="List all available configurations",
        )
        parser.add_argument(
            "--help", "-h", action="store_true", help="Show this help message"
        )
        parser.add_argument(
            "--config-file",
            "-c",
            default="configs.toml",
            help="Path to configuration file (default: configs.toml)",
        )

        return parser

    def parse_args(self, args: List[str] = None):
        """Parse command line arguments."""
        return self.parser.parse_known_args(args)

    def initialize_manager(self, config_file: str) -> None:
        """Initialize the symlink manager."""
        try:
            self.symlink_manager = SymlinkManager(config_file)
        except ConfigError as e:
            print(f"[ERR] {e}")
            sys.exit(1)

    def run(self, args: List[str] = None) -> int:
        """Run the CLI application."""
        # Parse arguments
        parsed_args, unknown = self.parse_args(args)

        # Check for unknown flags
        if unknown:
            print(f"[ERR] Unknown flag(s): {', '.join(unknown)}")
            print("Use -h or --help for usage information.")
            return 1

        # Show help if requested
        if parsed_args.help:
            self.parser.print_help()
            print("\nExamples:")
            print("  symlink-manager zsh tmux          # Install zsh and tmux configs")
            print("  symlink-manager --all             # Install all configs")
            print("  symlink-manager --list            # List available configs")
            print("  symlink-manager --force zsh       # Force overwrite zsh config")
            return 0

        # Initialize symlink manager
        self.initialize_manager(parsed_args.config_file)
        self.symlink_manager.set_force_mode(parsed_args.force)

        # Handle list command
        if parsed_args.list:
            self.symlink_manager.list_configs()
            return 0

        # Handle install all command
        if parsed_args.all:
            print("Installing all configurations...")
            results = self.symlink_manager.install_all()
            successful = sum(results.values())
            total = len(results)
            print(
                f"\nSummary: {successful}/{total} configurations installed successfully."
            )
            return 0 if successful == total else 1

        # Handle specific configs
        if not parsed_args.configs:
            print("[ERR] No configuration flags provided.")
            print("Use -h or --help for usage information.")
            return 1

        # Install requested configs
        results = {}
        for config in parsed_args.configs:
            results[config] = self.symlink_manager.create_symlink(config)

        successful = sum(results.values())
        total = len(results)

        if total > 1:
            print(
                f"\nSummary: {successful}/{total} configurations installed successfully."
            )

        return 0 if successful == total else 1
