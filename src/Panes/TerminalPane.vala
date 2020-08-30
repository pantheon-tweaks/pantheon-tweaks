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

    private Gtk.ColorButton background_color_button;

    public TerminalPane (PaneName pane_name) {
        base (pane_name);
    }

    construct {
        if (!(Util.schema_exists (TERMINAL_OLD_SCHEMA) || Util.schema_exists (TERMINAL_NEW_SCHEMA))) {
            return;
        }

        settings = new GLib.Settings ((Util.schema_exists (TERMINAL_NEW_SCHEMA)) ? TERMINAL_NEW_SCHEMA : TERMINAL_OLD_SCHEMA);

        var background_color_label = new SummaryLabel (_("Background color:"));
        background_color_button = new Gtk.ColorButton () {
            halign = Gtk.Align.START,
            use_alpha = true
        };

        var follow_last_tab_label = new SummaryLabel (_("Follow last tab:"));
        var follow_last_tab_switch = new Switch ();
        var follow_last_tab_info = new DimLabel (_("Whether to set the working directory of new tabs the same with the one of last open tab."));

        var unsafe_paste_alert_label = new SummaryLabel (_("Unsafe paste alert:"));
        var unsafe_paste_alert_switch = new Switch ();
        var unsafe_paste_alert_info = new DimLabel (_("Show a warning dialog when a pasted command contains 'sudo'."));

        var rem_tabs_label = new SummaryLabel (_("Remember tabs:"));
        var rem_tabs_switch = new Switch ();
        var rem_tabs_info = new DimLabel (_("If enabled, last opened tabs are restored on start."));

        var term_bell_label = new SummaryLabel (_("Terminal bell:"));
        var term_bell_switch = new Switch ();
        var term_bell_info = new DimLabel (_("Notify complete of a task with a sound."));

        content_area.attach (background_color_label, 0, 0, 1, 1);
        content_area.attach (background_color_button, 1, 0, 1, 1);
        content_area.attach (follow_last_tab_label, 0, 1, 1, 1);
        content_area.attach (follow_last_tab_switch, 1, 1, 1, 1);
        content_area.attach (follow_last_tab_info, 1, 2, 1, 1);
        content_area.attach (unsafe_paste_alert_label, 0, 3, 1, 1);
        content_area.attach (unsafe_paste_alert_switch, 1, 3, 1, 1);
        content_area.attach (unsafe_paste_alert_info, 1, 4, 1, 1);
        content_area.attach (rem_tabs_label, 0, 5, 1, 1);
        content_area.attach (rem_tabs_switch, 1, 5, 1, 1);
        content_area.attach (rem_tabs_info, 1, 6, 1, 1);
        content_area.attach (term_bell_label, 0, 7, 1, 1);
        content_area.attach (term_bell_switch, 1, 7, 1, 1);
        content_area.attach (term_bell_info, 1, 8, 1, 1);

        show_all ();

        update_background_value ();

        background_color_button.color_set.connect (() => {
            settings.set_string ("background", background_color_button.rgba.to_string ());
        });

        settings.bind ("follow-last-tab", follow_last_tab_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell_switch, "active", SettingsBindFlags.DEFAULT);

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
        background_color_button.rgba = rgba;
    }
}
