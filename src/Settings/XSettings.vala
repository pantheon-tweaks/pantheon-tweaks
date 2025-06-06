/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
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
    }

    public bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.XSETTINGS_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.XSETTINGS_SCHEMA);
            return false;
        }
        settings = new Settings (SettingsUtil.XSETTINGS_SCHEMA);

        return true;
    }

    public void reset () {
        settings.reset ("overrides");
    }

    public bool has_gnome_menu () {
        return decoration_layout.contains ("menu");
    }

    public void set_gnome_menu (bool set, string new_layout) {
        if (set) {
            if (new_layout.has_suffix (":")) {
                // e.g. "close:" → "close:menu"
                decoration_layout = new_layout + "menu";
            } else {
                if (new_layout.contains (":")) {
                    // e.g. "close:maximize" → "close:menu,maximize"
                    decoration_layout = new_layout.replace (":", ":menu,");
                } else {
                    // e.g. "close,minimize,maximize" → "close,minimize,maximize:menu"
                    decoration_layout = new_layout + ":menu";
                }
            }
        } else {
            decoration_layout = new_layout;
        }

        debug ("XSettings: %s\n", decoration_layout);
    }
}
