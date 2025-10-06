"""
Utility functions for path handling and file operations.
"""

import shutil
from pathlib import Path
from typing import Union


def expand_path(path: Union[str, Path]) -> Path:
    """Expand ~ and resolve relative paths, but don't resolve symlinks."""
    return Path(path).expanduser()


def resolve_path(path: Union[str, Path]) -> Path:
    """Fully resolve a path, including symlinks."""
    return Path(path).expanduser().resolve()


def ensure_parent_exists(path: Path) -> None:
    """Ensure parent directory of a path exists."""
    parent = path.parent
    if not parent.exists():
        parent.mkdir(parents=True, exist_ok=True)


def safe_remove_path(path: Path) -> None:
    """
    Safely remove a file, directory, or symlink.

    Args:
        path: Path to remove

    Raises:
        OSError: If removal fails
    """
    # Check if it's a symlink first (before resolving)
    if path.is_symlink():
        path.unlink()
    elif path.is_file():
        path.unlink()
    elif path.is_dir():
        shutil.rmtree(path)


def is_symlink_to(path: Path, target: Path) -> bool:
    """
    Check if a path is a symlink pointing to a specific target.

    Args:
        path: The symlink to check
        target: The target it should point to

    Returns:
        bool: True if path is a symlink pointing to target
    """
    if not path.is_symlink():
        return False

    try:
        # Compare the resolved paths
        return resolve_path(path.readlink()) == resolve_path(target)
    except (OSError, ValueError):
        return False
