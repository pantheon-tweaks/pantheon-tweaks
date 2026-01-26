/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 *
 * Some code borrowed from:
 * elementary/settings-desktop, src/Views/Appearance.vala
 */

public class PantheonTweaks.ThemeSettings {
    private const string ELEMENTARY_STYLESHEET_PREFIX = "io.elementary.stylesheet.";

    public enum AccentColor {
        /**
         * Valid preferences
         *
         * See also: https://github.com/elementary/default-settings/blob/e91cdb0f4ba80cb09d823fbfa5556e3473c76997/accountsservice/io.elementary.pantheon.AccountsService.xml#L19-L42
         */
        NO_PREFERENCE = 0,
        RED,
        ORANGE,
        YELLOW,
        GREEN,
        MINT,
        BLUE,
        PURPLE,
        PINK,
        BROWN,
        GRAY,
        BEIGE,

        /**
         * Invalid preference; workaround for Settings Daemon
         *
         * @see parse_accent_color
         */
        CUSTOM = -1;
    }

    public static AccentColor parse_accent_color (string full_style_name) {
        if (!full_style_name.has_prefix (ThemeSettings.ELEMENTARY_STYLESHEET_PREFIX)) {
            // Settings Daemon overwrites gtk-theme on startup according to a selected accent color,
            // which results forcing either of the elementary stylesheet variants.
            // Selecting out-of-range value as an accent color works as a workaround.
            // See also: https://github.com/elementary/settings-daemon/blob/f04fcb39c198bcfdbcdb0928be0b5e4af30c6f66/src/Backends/AccentColorManager.vala#L85-L103
            return AccentColor.CUSTOM;
        }

        string variant_name = full_style_name.substring (ELEMENTARY_STYLESHEET_PREFIX.length);
        switch (variant_name) {
            case "strawberry":
                return AccentColor.RED;
            case "orange":
                return AccentColor.ORANGE;
            case "banana":
                return AccentColor.YELLOW;
            case "lime":
                return AccentColor.GREEN;
            case "mint":
                return AccentColor.MINT;
            case "blueberry":
                return AccentColor.BLUE;
            case "grape":
                return AccentColor.PURPLE;
            case "bubblegum":
                return AccentColor.PINK;
            case "cocoa":
                return AccentColor.BROWN;
            case "slate":
                return AccentColor.GRAY;
            case "latte":
                return AccentColor.BEIGE;
            case "auto":
                return AccentColor.NO_PREFERENCE;
            default:
                warning ("Unexpected variant of elementary stylesheet '%s', falling back to blueberry", variant_name);
                return AccentColor.BLUE;
        }
    }

    private const string[] IGNORE_LIST = {
        "Adwaita", "Emacs", "Default", "default", "gnome", "hicolor"
    };

    /**
     * Checks if #dir contains a valid theme.
     */
    private delegate bool ValidateThemeFunc (string dir);

    public static bool fetch_gtk_themes (Gtk.StringList list) {
        return fetch_themes (list, "themes", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "gtk-3.0"));
                                return path.query_exists ();
                            });
    }

    public static bool fetch_icon_themes (Gtk.StringList list) {
        return fetch_themes (list, "icons", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "index.theme"));
                                return path.query_exists ();
                            });
    }

    public static bool fetch_cursor_themes (Gtk.StringList list) {
        return fetch_themes (list, "icons", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "cursors"));
                                return path.query_exists ();
                            });
    }

    public static bool fetch_sound_themes (Gtk.StringList list) {
        return fetch_themes (list, "sounds", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "index.theme"));
                                return path.query_exists ();
                            });
    }

    private static bool fetch_themes (Gtk.StringList list, string subdir, ValidateThemeFunc valid_func) {
        var themes = new Gtk.StringList (null);
        unowned string home_dir = Environment.get_home_dir ();

        string[] theme_dirs = {
            Path.build_filename (Config.SYSTHEME_ROOTDIR, subdir),
            Path.build_filename (home_dir, ".%s".printf (subdir)),
            Path.build_filename (home_dir, ".local", "share", subdir),
        };

        foreach (unowned string theme_dir in theme_dirs) {
            var file = File.new_for_path (theme_dir);
            if (!file.query_exists ()) {
                continue;
            }

            FileEnumerator enumerator;
            try {
                enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            } catch (Error err) {
                warning ("Failed to enumerate children under '%s': %s", theme_dir, err.message);
                return false;
            }

            // Search for directories until reaching end of enumerator
            var file_info = new FileInfo ();
            while (file_info != null) {
                try {
                    file_info = enumerator.next_file ();
                } catch (Error err) {
                    warning ("Failed to refer info of next file under '%s': %s", theme_dir, err.message);
                    return false;
                }

                // End of enumerator
                if (file_info == null) {
                    continue;
                }

                var name = file_info.get_name ();
                if (name in IGNORE_LIST) {
                    continue;
                }

                bool ret = valid_func (Path.build_filename (theme_dir, name));
                if (!ret) {
                    continue;
                }

                themes.append (name);
            }
        }

        while (list.n_items > 0) {
            list.remove (0);
        }

        for (int i = 0; i < themes.n_items; i++) {
            list.append (themes.get_string (i));
        }

        return true;
    }
}
