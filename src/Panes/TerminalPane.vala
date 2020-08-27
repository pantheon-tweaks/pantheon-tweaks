/*
 * Copyright (C) Elementary Tweaks Developers, 2016 - 2020
 *               Pantheon Tweaks Developers, 2020
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

public class PantheonTweaks.Panes.TerminalPane : Categories.Pane {
    private const string TERMINAL_OLD_SCHEMA = "org.pantheon.terminal.settings";
    private const string TERMINAL_NEW_SCHEMA = "io.elementary.terminal.settings";

    private GLib.Settings settings;

    private Gtk.ColorButton background;

    public TerminalPane () {
        base (_("Terminal"), "utilities-terminal");
    }

    construct {
        if (!(Util.schema_exists (TERMINAL_OLD_SCHEMA) || Util.schema_exists (TERMINAL_NEW_SCHEMA))) {
            return;
        }

        settings = new GLib.Settings ((Util.schema_exists (TERMINAL_NEW_SCHEMA)) ? TERMINAL_NEW_SCHEMA : TERMINAL_OLD_SCHEMA);

        var box = new Widgets.SettingsBox ();

        background = new Gtk.ColorButton ();
        background.use_alpha = true;
        box.add_widget (_("Background color"), background);

        var follow_last_tab = box.add_switch (_("Follow last tab"));
        var unsafe_paste_alert = box.add_switch (_("Unsafe paste alert"));
        var rem_tabs = box.add_switch (_("Remember tabs"));
        var term_bell = box.add_switch (_("Terminal bell"));

        grid.add (box);

        grid.show_all ();

        update_background_value ();

        background.color_set.connect (() => {
            settings.set_string ("background", background.rgba.to_string ());
        });

        settings.bind ("follow-last-tab", follow_last_tab, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell, "active", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"background", "unsafe-paste-alert", "natural-copy-paste",
                                "follow-last-tab", "audible-bell", "remember-tabs"};

            foreach (string key in keys) {
                settings.reset (key);
            }

            update_background_value ();
        });
    }

    private void update_background_value () {
        var rgba = Gdk.RGBA ();
        rgba.parse (settings.get_string ("background"));
        background.rgba = rgba;
    }
}
