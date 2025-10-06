"""
Symlink Manager package for configuration file management.
"""

__version__ = "1.0.0"
__author__ = "gugulenok"
__description__ = "A tool to manage symbolic links for configuration files"

from .cli import CLI
from .config import ConfigLoader
from .core import SymlinkManager
from .exceptions import ConfigError, SymlinkError, SymlinkManagerError, ValidationError

__all__ = [
    "SymlinkManager",
    "CLI",
    "ConfigLoader",
    "SymlinkManagerError",
    "ConfigError",
    "SymlinkError",
    "ValidationError",
]
