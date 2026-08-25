# fedora-quickshell SDDM theme

A minimal QML SDDM theme matching this rice's look: dark background
(`#222422`), JetBrains Mono, the same accent colours used in
`quickshell/modules/Theme.qml` and `hypr/hyprlock.conf` (yellow accent,
blue "focused" outline, red "error" outline), and a hyprlock-style layout
(large clock top-right, centered rounded password field).

## Layout

- Clock + date, top right (mirrors `hyprlock.conf`).
- Username (cycle with the arrows) and a rounded password field, centered.
- Session picker, bottom left (click to cycle sessions).
- Suspend / restart / power-off, bottom right.

## Try it locally (no install)

```sh
sddm-greeter-qt6 --test-mode --theme sddm/fedora-quickshell
# or, on older/Qt5 systems:
sddm-greeter --test-mode --theme sddm/fedora-quickshell
```

## Install (Fedora)

```sh
sudo mkdir -p /usr/share/sddm/themes/fedora-quickshell
sudo cp -r sddm/fedora-quickshell/. /usr/share/sddm/themes/fedora-quickshell/
```

Point SDDM at it, in `/etc/sddm.conf` (or a drop-in under `/etc/sddm.conf.d/`):

```ini
[Theme]
Current=fedora-quickshell
```

Then restart SDDM (or reboot) to see it on the next login screen:

```sh
sudo systemctl restart sddm
```

## Customizing

Edit `sddm/fedora-quickshell/theme.conf`:

- `background` — absolute path to a wallpaper. Leave empty to keep the flat
  `colBg` background (no wallpaper shipped in this repo, so a real image
  path needs to be filled in, e.g. the same one `hyprpaper.conf` uses).
- `colBg`, `colFg`, `colBgAlt`, `colAccent`, `colError`, `colCheck` — colours,
  kept in sync with `quickshell/modules/Theme.qml` by hand since SDDM can't
  read the QML singleton directly.
- `hourFormat` / `dateFormat` — Qt date/time format strings.

After editing, re-copy the theme directory to
`/usr/share/sddm/themes/fedora-quickshell` (or symlink it there instead of
copying, so edits apply without reinstalling).
