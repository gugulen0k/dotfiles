"""
Custom exceptions for the symlink manager.
"""


class SymlinkManagerError(Exception):
    """Base exception for symlink manager errors."""

    pass


class ConfigError(SymlinkManagerError):
    """Configuration related errors."""

    pass


class SymlinkError(SymlinkManagerError):
    """Symlink operation errors."""

    pass


class ValidationError(SymlinkManagerError):
    """Input validation errors."""

    pass
