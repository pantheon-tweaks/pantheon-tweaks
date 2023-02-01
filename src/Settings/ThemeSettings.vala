/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2023
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

    public static Gee.List<string> get_themes (string path, string condition) {
        var themes = new Gee.ArrayList<string> ();

        string[] dirs = {
            "/usr/share/" + path + "/",
            Environment.get_home_dir () + "/." + path + "/",
            Environment.get_home_dir () + "/.local/share/" + path + "/"};

        foreach (string dir in dirs) {
            var file = File.new_for_path (dir);
            if (!file.query_exists ()) {
                continue;
            }

            try {
                var enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
                FileInfo file_info;
                while ((file_info = enumerator.next_file ()) != null) {
                    var name = file_info.get_name ();
                    if (name in IGNORE_LIST) {
                        continue;
                    }

                    var checktheme = File.new_for_path (dir + name + "/" + condition);
                    var checkicons = File.new_for_path (dir + name + "/48x48/" + condition);
                    if ((checktheme.query_exists () || checkicons.query_exists ()) && !themes.contains (name)) {
                        themes.add (name);
                    }
                }
            } catch (Error e) {
                warning (e.message);
            }
        }

        themes.sort ((a, b) => {
            return a.collate (b);
        });

        return themes;
    }
}
