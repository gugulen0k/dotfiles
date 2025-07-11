# Makefile for theme-switcher installation

PREFIX ?= $(HOME)/.local
BINDIR = $(PREFIX)/bin
CONFIGDIR = $(HOME)/.config/theme-switcher

.PHONY: install uninstall create-config clean

install:
	@echo "Installing theme-switcher..."
	@mkdir -p $(BINDIR)
	@cp theme-switcher.py $(BINDIR)/theme-switcher
	@chmod +x $(BINDIR)/theme-switcher
	@echo "✓ Installed theme-switcher to $(BINDIR)/theme-switcher"
	@echo ""
	@echo "Make sure $(BINDIR) is in your PATH:"
	@echo "  export PATH=\"$(BINDIR):\$$PATH\""
	@echo ""
	@echo "Add this to your ~/.zshrc if not already present."

uninstall:
	@echo "Uninstalling theme-switcher..."
	@rm -f $(BINDIR)/theme-switcher
	@echo "✓ Removed theme-switcher"

create-config:
	@echo "Creating sample configuration..."
	@mkdir -p $(CONFIGDIR)
	@$(BINDIR)/theme-switcher --create-config $(CONFIGDIR)/themes.toml
	@echo "✓ Configuration created at $(CONFIGDIR)/themes.toml"

system-install:
	@echo "Installing theme-switcher system-wide..."
	@sudo cp theme-switcher.py /usr/local/bin/theme-switcher
	@sudo chmod +x /usr/local/bin/theme-switcher
	@echo "✓ Installed theme-switcher to /usr/local/bin/theme-switcher"

system-uninstall:
	@echo "Uninstalling theme-switcher system-wide..."
	@sudo rm -f /usr/local/bin/theme-switcher
	@echo "✓ Removed system-wide theme-switcher"

clean:
	@rm -rf build/ dist/ *.egg-info/
	@echo "✓ Cleaned build artifacts"

help:
	@echo "Available targets:"
	@echo "  install         - Install to ~/.local/bin (user-only)"
	@echo "  uninstall       - Remove from ~/.local/bin"
	@echo "  create-config   - Create sample themes.toml"
	@echo "  system-install  - Install to /usr/local/bin (system-wide)"
	@echo "  system-uninstall- Remove from /usr/local/bin"
	@echo "  clean          - Clean build artifacts"
	@echo "  help           - Show this help"
