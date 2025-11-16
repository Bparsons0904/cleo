# Flutter Development Setup on CachyOS (Linux)

This guide will help you set up a complete Flutter development environment on CachyOS using Neovim as your primary editor.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Flutter Installation](#flutter-installation)
- [Linux Desktop Development Setup](#linux-desktop-development-setup)
- [Android Development Setup (Optional)](#android-development-setup-optional)
- [Neovim Flutter Configuration](#neovim-flutter-configuration)
- [Project Setup](#project-setup)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### 1. Install Base Dependencies

Since CachyOS is Arch-based, use `pacman` or `paru`/`yay`:

```bash
# Base development tools
sudo pacman -S base-devel git curl unzip xz cmake ninja clang gtk3 pkgconf

# Additional dependencies for Flutter on Linux
sudo pacman -S libsecret libjsoncpp
```

## Flutter Installation

### Option 1: Using pacman (Recommended for CachyOS)

```bash
sudo pacman -S flutter dart
```

### Option 2: Manual Installation via Git (Latest Dev Channel)

```bash
# Clone Flutter repo
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add this to your ~/.zshrc or ~/.bashrc)
export PATH="$HOME/flutter/bin:$PATH"

# Reload shell
source ~/.zshrc  # or ~/.bashrc

# Verify installation
flutter --version
```

### Post-Installation

```bash
# Disable analytics (optional)
flutter config --no-analytics

# Run Flutter doctor to check setup
flutter doctor -v

# Pre-download dependencies
flutter precache --linux
```

## Linux Desktop Development Setup

### 1. Install Linux Development Dependencies

```bash
# Required libraries for Flutter Linux apps
sudo pacman -S gtk3 clang cmake ninja pkg-config

# Additional GTK dependencies
sudo pacman -S libx11 xorg-server-devel mesa glu
```

### 2. Verify Linux Toolchain

```bash
flutter doctor
```

You should see something like:
```
[✓] Flutter (Channel stable, 3.x.x, on Linux, locale en_US.UTF-8)
[✓] Linux toolchain - develop for Linux desktop
```

### 3. Enable Linux Desktop Support

```bash
flutter config --enable-linux-desktop
```

## Android Development Setup (Optional)

**Only needed if you want to build for Android devices/emulators.**

### Option A: Without Android Studio (Lightweight)

1. Install Android SDK command-line tools:

```bash
# Install from AUR
paru -S android-sdk android-sdk-cmdline-tools-latest
# or
yay -S android-sdk android-sdk-cmdline-tools-latest

# Set environment variables (add to ~/.zshrc or ~/.bashrc)
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

2. Install required SDK components:

```bash
# Accept licenses
flutter doctor --android-licenses

# Install platform tools
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### Option B: With Android Studio (Full-Featured)

```bash
# Install Android Studio from AUR
paru -S android-studio
# or
yay -S android-studio

# Launch Android Studio
android-studio

# In Android Studio:
# 1. Complete the setup wizard
# 2. Install Android SDK
# 3. Install Android SDK Command-line Tools
# 4. Install Android SDK Build-Tools
# 5. Install Android Emulator (if you want to test on emulator)
```

After installation:
```bash
# Accept licenses
flutter doctor --android-licenses
```

## Neovim Flutter Configuration

Your dotfiles should already have Neovim configured, but here are Flutter-specific recommendations:

### Recommended Plugins

Add these to your Neovim config if not already present:

```lua
-- For nvim-lspconfig
require('lspconfig').dartls.setup({})

-- Useful Flutter plugins (using lazy.nvim or packer)
{
  'akinsho/flutter-tools.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require("flutter-tools").setup({
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        }
      },
      widget_guides = {
        enabled = true,
      },
      lsp = {
        color = {
          enabled = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        }
      }
    })
  end
}
```

### Useful Neovim Commands for Flutter

Once flutter-tools.nvim is installed:

- `:FlutterRun` - Start the app
- `:FlutterDevices` - List available devices
- `:FlutterReload` - Hot reload
- `:FlutterRestart` - Hot restart
- `:FlutterQuit` - Stop the running session
- `:FlutterOutlineToggle` - Toggle widget outline
- `:FlutterLspRestart` - Restart the Dart LSP

## Project Setup

### 1. Clone and Navigate

```bash
cd ~/path/to/cleo
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

This project uses code generation for Riverpod, JSON serialization, etc.:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Run the App

For Linux desktop:
```bash
flutter run -d linux
```

For Android (if set up):
```bash
# List devices
flutter devices

# Run on connected device
flutter run -d <device-id>
```

### 5. Build for Production

Linux:
```bash
flutter build linux --release
# Binary will be in build/linux/x64/release/bundle/
```

Android:
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

## Troubleshooting

### Flutter Doctor Issues

Run `flutter doctor -v` to see detailed diagnostics.

### Linux Build Issues

If you encounter GTK or library errors:
```bash
# Reinstall GTK3 dependencies
sudo pacman -S --needed gtk3 glib2 cairo pango atk gdk-pixbuf2

# Check pkg-config
pkg-config --modversion gtk+-3.0
```

### Dart Analysis Server Issues in Neovim

```bash
# Clear Dart cache
rm -rf ~/.pub-cache/bin/dartls

# Restart LSP in Neovim
:LspRestart
```

### Code Generation Issues

```bash
# Clean and regenerate
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Permission Issues with Android SDK

```bash
# Fix ownership (replace username with your username)
sudo chown -R $USER:$USER /opt/android-sdk
```

## Development Workflow

### Recommended Workflow with Neovim

1. Start code generation watcher in one terminal:
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

2. Open project in Neovim in another terminal:
   ```bash
   nvim .
   ```

3. Start Flutter app:
   ```
   :FlutterRun
   ```

4. Make changes and use:
   - `r` in Flutter console for hot reload
   - `R` for hot restart
   - Or `:FlutterReload` / `:FlutterRestart` in Neovim

### Quick Commands Reference

```bash
# Check everything is set up
flutter doctor -v

# List available devices
flutter devices

# Run on Linux
flutter run -d linux

# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade

# Run tests
flutter test

# Check for outdated packages
flutter pub outdated
```

## Additional Resources

- [Flutter Linux Desktop Docs](https://docs.flutter.dev/platform-integration/linux/building)
- [Dart LSP in Neovim](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dartls)
- [flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim)

## Summary

For your setup on CachyOS with Neovim:

1. **Minimum for Linux desktop development**:
   - Flutter SDK (`pacman -S flutter dart`)
   - GTK3 and build tools
   - Neovim with Dart LSP

2. **For Android development** (optional):
   - Android SDK (via command-line tools or Android Studio)
   - Accept Android licenses

3. **Recommended Neovim plugin**: flutter-tools.nvim for integrated development

You can develop Flutter apps entirely in Neovim without ever touching Android Studio!
