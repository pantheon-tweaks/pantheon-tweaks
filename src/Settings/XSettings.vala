/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2023
 */

public class PantheonTweaks.XSettings {
    public string decoration_layout {
        get {
            var overrides = settings.get_value ("overrides");
            var layout = overrides.lookup_value ("Gtk/DecorationLayout", VariantType.STRING);

            if (layout != null) {
                return layout.get_string ();
            } else {
                return "";
            }
        }
        set {
            if (value == "") {
                return;
            }

            var overrides = settings.get_value ("overrides");
            var dict = new VariantDict (overrides);

            dict.insert_value ("Gtk/DecorationLayout", new Variant.string (value));
            settings.set_value ("overrides", dict.end ());
        }
    }

    private Settings settings;

    public XSettings () {
        settings = new Settings ("org.gnome.settings-daemon.plugins.xsettings");
    }

    public void reset () {
        settings.reset ("overrides");
    }

    public bool has_gnome_menu () {
        return decoration_layout.contains ("menu");
    }

    public void set_gnome_menu (bool set, string new_layout) {
        if (set) {
            decoration_layout = new_layout + ",menu";
            if (decoration_layout.contains (":,")) {
                decoration_layout = decoration_layout.replace (":,", ":");
            } else if (!decoration_layout.contains (":")) {
                decoration_layout = new_layout + ":menu";
            }
        } else {
            decoration_layout = new_layout;
        }

        debug ("XSettings: %s\n", decoration_layout);
    }
}
