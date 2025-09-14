"""
Core symlink management functionality.
"""

from pathlib import Path
from typing import Dict

from .config import ConfigLoader
from .exceptions import ConfigError, SymlinkError
from .utils import (
    ensure_parent_exists,
    expand_path,
    is_symlink_to,
    resolve_path,
    safe_remove_path,
)


class SymlinkManager:
    """Main symlink management class."""

    def __init__(self, config_file: str = "configs.toml"):
        self.config_loader = ConfigLoader(config_file)
        self.configs = self.config_loader.load_configs()
        self.force_mode = False

    def set_force_mode(self, force: bool) -> None:
        """Set force mode for operations."""
        self.force_mode = force

    def create_symlink(self, config_name: str) -> bool:
        """Create a symbolic link for a specific configuration."""
        try:
            config = self.config_loader.get_config(config_name)
            # Use expand_path (not resolve) for dst to avoid resolving symlinks
            src = resolve_path(config["src"])
            dst = expand_path(config["dst"])

            if not src.exists():
                raise SymlinkError(f"Source path does not exist: {src}")

            return self._create_symlink_internal(src, dst, config_name)

        except ConfigError as e:
            print(f"[ERR] {e}")
            return False
        except SymlinkError as e:
            print(f"[ERR] {e}")
            return False
        except Exception as e:
            print(f"[ERR] Unexpected error for {config_name}: {e}")
            return False

    def _create_symlink_internal(self, src: Path, dst: Path, config_name: str) -> bool:
        """Internal method to handle symlink creation."""
        # Check if destination exists (without resolving symlinks)
        dst_exists = dst.exists() or dst.is_symlink()

        if dst_exists:
            # Check if it's already the correct symlink
            if is_symlink_to(dst, src):
                print(f"[OK] Already correctly linked: {src} → {dst}")
                return True

            if not self.force_mode:
                print(f"[WARN] Already exists: {dst}")
                return False

            # Force mode: remove existing file/directory/symlink
            try:
                safe_remove_path(dst)
                print(f"[FORCE] Replaced {src} → {dst}")
            except OSError as e:
                raise SymlinkError(f"Failed to remove existing path {dst}: {e}")

        # Ensure parent directory exists
        ensure_parent_exists(dst)

        # Create symlink
        try:
            # Remove existing symlink if it's broken
            if dst.is_symlink() and not dst.exists():
                dst.unlink()

            dst.symlink_to(src, target_is_directory=src.is_dir())
            print(f"[OK] Linked {src} → {dst}")
            return True
        except OSError as e:
            raise SymlinkError(f"Failed to create symlink: {e}")

    def install_all(self) -> Dict[str, bool]:
        """Install all configurations."""
        results = {}

        for config_name in self.configs:
            results[config_name] = self.create_symlink(config_name)

        return results

    def list_configs(self) -> None:
        """List all available configurations."""
        print("Available configurations:")
        for config_name, config in self.configs.items():
            print(f"* {config['flag']}")
