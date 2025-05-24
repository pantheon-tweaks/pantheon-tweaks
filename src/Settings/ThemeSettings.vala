/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 *
 * Some code borrowed from:
 * elementary/switchboard-plug-pantheon-shell, src/Views/Appearance.vala
 */

public class PantheonTweaks.ThemeSettings {
    public const string ELEMENTARY_STYLESHEET_PREFIX = "io.elementary.stylesheet.";

    public enum AccentColor {
        NO_PREFERENCE,
        RED,
        ORANGE,
        YELLOW,
        GREEN,
        MINT,
        BLUE,
        PURPLE,
        PINK,
        BROWN,
        GRAY;
    }

    public static AccentColor parse_accent_color (string full_style_name) {
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

    public static Gee.ArrayList<string>? fetch_gtk_themes () {
        return fetch_themes ("themes", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "gtk-3.0"));
                                return path.query_exists ();
                            });
    }

    public static Gee.ArrayList<string>? fetch_icon_themes () {
        return fetch_themes ("icons", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "index.theme"));
                                return path.query_exists ();
                            });
    }

    public static Gee.ArrayList<string>? fetch_cursor_themes () {
        return fetch_themes ("icons", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "cursors"));
                                return path.query_exists ();
                            });
    }

    public static Gee.ArrayList<string>? fetch_sound_themes () {
        return fetch_themes ("sounds", (found_dir) => {
                                var path = File.new_for_path (Path.build_filename (found_dir, "index.theme"));
                                return path.query_exists ();
                            });
    }

    private static Gee.ArrayList<string>? fetch_themes (string subdir, ValidateThemeFunc valid_func) {
        var themes = new Gee.ArrayList<string> ();
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
                return null;
            }

            // Search for directories until reaching end of enumerator
            var file_info = new FileInfo ();
            while (file_info != null) {
                try {
                    file_info = enumerator.next_file ();
                } catch (Error err) {
                    warning ("Failed to refer info of next file under '%s': %s", theme_dir, err.message);
                    return null;
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

                if (themes.contains (name)) {
                    continue;
                }

                themes.add (name);
            }
        }

        themes.sort ((a, b) => {
            return a.collate (b);
        });

        return themes;
    }
}
