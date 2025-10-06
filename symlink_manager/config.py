"""
Configuration loading and management.
"""

from pathlib import Path
from typing import Any, Dict

import tomllib

from .exceptions import ConfigError


class ConfigLoader:
    """Load and manage configuration from TOML file."""

    def __init__(self, config_file: str = "configs.toml"):
        self.config_file = config_file
        self.configs: Dict[str, Dict[str, Any]] = {}

    def load_configs(self) -> Dict[str, Dict[str, Any]]:
        """Load configuration from TOML file."""
        try:
            config_path = Path(self.config_file)
            if not config_path.exists():
                raise ConfigError(f"Configuration file '{self.config_file}' not found.")

            with config_path.open("rb") as f:
                self.configs = tomllib.load(f)
                return self.configs

        except tomllib.TOMLDecodeError as e:
            raise ConfigError(f"Failed to parse '{self.config_file}': {e}")
        except OSError as e:
            raise ConfigError(f"Failed to read '{self.config_file}': {e}")
        except Exception as e:
            raise ConfigError(f"Unexpected error loading config: {e}")

    def get_config(self, config_name: str) -> Dict[str, Any]:
        """Get specific configuration by name."""
        if config_name not in self.configs:
            raise ConfigError(f"No config found for: {config_name}")

        return self.configs[config_name]

    def list_configs(self) -> Dict[str, Dict[str, Any]]:
        """Return all configurations."""
        return self.configs
