/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

public class PantheonTweaks.XSettings {
    private const string SCHEMA_ID_XSETTINGS = "org.gnome.settings-daemon.plugins.xsettings";
    private const string SCHEMA_KEY_OVERRIDES = "overrides";
    private const string OVERRIDES_KEY_DECORAT = "Gtk/DecorationLayout";

    public string decoration_layout {
        get {
            var overrides = settings.get_value (SCHEMA_KEY_OVERRIDES);
            var layout = overrides.lookup_value (OVERRIDES_KEY_DECORAT, VariantType.STRING);

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

            var overrides = settings.get_value (SCHEMA_KEY_OVERRIDES);
            var dict = new VariantDict (overrides);

            dict.insert_value (OVERRIDES_KEY_DECORAT, new Variant.string (value));
            settings.set_value (SCHEMA_KEY_OVERRIDES, dict.end ());
        }
    }

    private Settings settings;

    public XSettings () {
    }

    public bool load () {
        if (!SettingsUtil.schema_exists (SCHEMA_ID_XSETTINGS)) {
            warning ("Could not find settings schema %s", SCHEMA_ID_XSETTINGS);
            return false;
        }
        settings = new Settings (SCHEMA_ID_XSETTINGS);

        return true;
    }

    public void reset () {
        settings.reset (SCHEMA_KEY_OVERRIDES);
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
