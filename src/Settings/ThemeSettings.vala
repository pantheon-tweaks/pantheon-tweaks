/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
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
                warning ("Unexpected variant of elementary stylesheet, falling back to blueberry");
                return AccentColor.BLUE;
        }
    }

    private const string[] IGNORE_LIST = {
        "Adwaita", "Emacs", "Default", "default", "gnome", "hicolor"
    };

    public static Gee.ArrayList<string>? get_themes (string path, string condition) {
        var themes = new Gee.ArrayList<string> ();

        string system_dir = "/usr/share/" + path + "/";
        string prefix = Environment.get_variable ("USR_DIR_PREFIX");
        if (prefix != null) {
            system_dir = prefix + system_dir;
        }

        string[] dirs = {
            system_dir,
            Environment.get_home_dir () + "/." + path + "/",
            Environment.get_home_dir () + "/.local/share/" + path + "/"};

        foreach (string dir in dirs) {
            var file = File.new_for_path (dir);
            if (!file.query_exists ()) {
                continue;
            }

            FileEnumerator enumerator;
            try {
                enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            } catch (Error e) {
                warning (e.message);
                return null;
            }

            // Search for directories until reaching end of enumerator
            var file_info = new FileInfo ();
            while (file_info != null) {
                try {
                    file_info = enumerator.next_file ();
                } catch (Error e) {
                    warning (e.message);
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

                var checktheme = File.new_for_path (dir + name + "/" + condition);
                var checkicons = File.new_for_path (dir + name + "/48x48/" + condition);
                if (!checktheme.query_exists () && !checkicons.query_exists ()) {
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
