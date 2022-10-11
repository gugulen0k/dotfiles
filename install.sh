#!/bin/bash

CURRENT_DIR=$(pwd)
GREEN='\033[1;32m'
NC='\033[0m'

set -e

ln -sf "$CURRENT_DIR"/.config ~/
ln -sf "$CURRENT_DIR"/.zshrc ~/.zshrc
ln -sf "$CURRENT_DIR"/.zshenv ~/.zshenv
ln -sf "$CURRENT_DIR"/.tmux.conf ~/.tmux.conf

echo -e "${GREEN}Links created successfully!${NC}"
