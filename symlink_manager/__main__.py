#!/usr/bin/env python3
"""
Main entry point for the symlink manager.
"""

import os
import sys

# Add the current package directory to Python path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from symlink_manager.cli import CLI


def main():
    """Main entry point."""
    cli = CLI()
    sys.exit(cli.run())


if __name__ == "__main__":
    main()
