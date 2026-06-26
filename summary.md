# Kuru Kuru Bar (Bocchibar) - Project Summary

## Overview
This directory contains the **Kuru Kuru Bar** (also known as `bocchibar`), a compact and adorable top bar for Linux desktop environments designed with Google's Material 3 guidelines. It is built as a modular shell using **Quickshell** (QtQuick/QML) and focuses heavily on dynamic, physics-based liquid-morphing animations.

The bar features a spinning "Kuru Kuru" character element and scales dynamically through multiple states: collapsed (a small trigger pill), expanded (a functional status bar), and fully expanded (a comprehensive settings dashboard).

## Core Architecture
The shell utilizes a dynamic layout driven by QtQuick and Quickshell's WlrLayerShell integration.
- **[shell.qml](./shell.qml)**: The root application file that manages multi-monitor instantiation and initializes the main shell components.
- **[Layers/Notch.qml](./Layers/Notch.qml)**: The primary layer file. It acts as a top-screen overlay and manages the expansion states of the main bar.
- **[Layers/LockScreen.qml](./Layers/LockScreen.qml)**: Manages screen locking functionality and authentication.
- **[Layers/Wallpaper.qml](./Layers/Wallpaper.qml)**: Handles background rendering.

## Physics & Animations (`Caelestia.Blobs`)
A central technical feature of the project is its liquid-morphing system.
- Driven by `Caelestia.Blobs`, the interface uses `BlobGroup` and `BlobRect` instances to create a liquid shape that merges nearby UI elements dynamically using an SDF (Signed Distance Field) shader.
- Child items inside the `Notch` are connected via a `Matrix4x4` transform to the main `BlobRect`. This forces the widgets to physically stretch, squish, and bounce in perfect sync with the outer liquid container.

## Component Directory Breakdown

### `Containers/` (Structural Layouts)
Provides the structural scaffolding for the different modules inside the bar.
- **`CentralSwipable.qml`**: Houses the `SwipeView` and sidebar, implementing a liquid selection indicator.
- **`KuruKuru.qml`**: The spinning character panel and floating notification dots.
- **`Primary.qml`**: The expanded dashboard panel.
- **`TopBar.qml`**: Coordinates the primary top status line.
- **`Inbox.qml`**: The layout wrapper for incoming notifications.

### `Data/` (Backend & State)
- **`Colors.qml`**: Centralized Material 3 color palette.
- **`Globals.qml`**: Singleton for tracking system-wide states (scales, active menus).
- **`NotifServer.qml`**: DBus notification server implementation.
- **`Paths.qml`**: Resolves asset paths, configs, and wallpapers.

### `Widgets/` (Functional UI Elements)
Components that make up the active elements within containers.
- **`BatteryPill.qml` & `BatteryDot.qml`**: Battery status visualizations.
- **`WorkspacePill.qml`**: Active/inactive workspace indication.
- **`AudioSwiper.qml`**: Quick-access volume controls.
- **`SettingsView.qml`**: The detailed settings and control center tab.

### `Generics/` (Reusable UI Bits)
- **`MatIcon.qml`**: Wrapper to display Material Icons.
- **`AudioSlider.qml`**: Standardized volume slider.
- **`Notification.qml`**: Structure for individual notification items.

## Further Reading
- **[README_1.md](./README_1.md)**: Includes installation dependencies, background/lockscreen layer extraction (rembg), and complete NixOS instructions.
- **[overview.md](./overview.md)**: Deep dive into the `Notch` layer and blob physics.
