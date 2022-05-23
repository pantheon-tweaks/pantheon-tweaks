/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2020
 *               Pantheon Tweaks Developers, 2020 - 2022
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
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
