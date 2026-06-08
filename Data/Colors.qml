pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.Data as Dat

Singleton {
  property var current: this

  function withAlpha(color: color, alpha: real): color {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }

  // Wal colors file — updates automatically when wal runs
  FileView {
    path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      const c = JSON.parse(text());
      wal.background  = c.colors.color0;
      wal.color1      = c.colors.color1;
      wal.color2      = c.colors.color2;
      wal.color3      = c.colors.color3;
      wal.color4      = c.colors.color4;
      wal.color5      = c.colors.color5;
      wal.color6      = c.colors.color6;
      wal.foreground  = c.special.foreground;
    }
  }

  QtObject {
    id: wal
    property color background: "#121318"
    property color foreground: "#e3e1e9"
    property color color1: "#b6c4ff"
    property color color2: "#fc8b94"
    property color color3: "#f5ab9d"
    property color color4: "#d4aca2"
    property color color5: "#ffb3b7"
    property color color6: "#fed9d9"
  }

  // Map wal colors to Material 3 roles your UI expects
  property color background:                wal.background
  property color surface:                   wal.background
  property color surface_dim:               wal.background
  property color surface_bright:            Qt.lighter(wal.background, 1.8)
  property color surface_container:         Qt.lighter(wal.background, 1.3)
  property color surface_container_low:     Qt.lighter(wal.background, 1.15)
  property color surface_container_high:    Qt.lighter(wal.background, 1.5)
  property color surface_container_highest: Qt.lighter(wal.background, 1.7)
  property color surface_container_lowest:  Qt.darker(wal.background, 1.2)
  property color surface_tint:              wal.color1
  property color on_background:             wal.foreground
  property color on_surface:                wal.foreground
  property color on_surface_variant:        Qt.lighter(wal.foreground, 0.8)
  property color primary:                   wal.color1
  property color on_primary:                wal.background
  property color primary_container:         Qt.darker(wal.color1, 1.8)
  property color on_primary_container:      Qt.lighter(wal.color1, 1.3)
  property color secondary:                 wal.color4
  property color on_secondary:              wal.background
  property color secondary_container:       Qt.darker(wal.color4, 1.8)
  property color on_secondary_container:    Qt.lighter(wal.color4, 1.3)
  property color tertiary:                  wal.color5
  property color on_tertiary:               wal.background
  property color tertiary_container:        Qt.darker(wal.color5, 1.8)
  property color on_tertiary_container:     Qt.lighter(wal.color5, 1.3)
  property color error:                     wal.color2
  property color on_error:                  wal.background
  property color error_container:           Qt.darker(wal.color2, 1.8)
  property color on_error_container:        Qt.lighter(wal.color2, 1.3)
  property color outline:                   Qt.lighter(wal.background, 2.2)
  property color outline_variant:           Qt.lighter(wal.background, 1.6)
  property color inverse_surface:           wal.foreground
  property color inverse_on_surface:        wal.background
  property color inverse_primary:           Qt.darker(wal.color1, 1.5)
  property color scrim:                     "#000000"
  property color shadow:                    "#000000"
}
