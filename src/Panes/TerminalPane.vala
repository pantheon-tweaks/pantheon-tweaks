/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2023
 */

public class PantheonTweaks.Panes.TerminalPane : Categories.Pane {
    private const string TERMINAL_SCHEMA = "io.elementary.terminal.settings";

    private GLib.Settings settings;

    public TerminalPane () {
        base (_("Terminal"), "utilities-terminal");
    }

    construct {
        if (!if_show_pane ({ TERMINAL_SCHEMA })) {
            return;
        }

        settings = new GLib.Settings (TERMINAL_SCHEMA);

        var follow_last_tab_label = new SummaryLabel (_("Follow last tab:"));
        var follow_last_tab_switch = new Switch ();
        var follow_last_tab_info = new DimLabel (
            _("Creating a new tab sets the working directory of the last opened tab.")
        );

        var unsafe_paste_alert_label = new SummaryLabel (_("Unsafe paste alert:"));
        var unsafe_paste_alert_switch = new Switch ();
        var unsafe_paste_alert_info = new DimLabel (_("Show a warning dialog when a pasted command contains 'sudo'."));

        var rem_tabs_label = new SummaryLabel (_("Remember tabs:"));
        var rem_tabs_switch = new Switch ();
        var rem_tabs_info = new DimLabel (_("If enabled, last opened tabs are restored on start."));

        var term_bell_label = new SummaryLabel (_("Terminal bell:"));
        var term_bell_switch = new Switch ();
        var term_bell_info = new DimLabel (
            _("Sound when hitting the end of a line and also for tab-completion when there are either no or multiple possible completions.") // vala-lint=line-length
        );

        var tab_bar_map = new Gee.HashMap<string, string> ();
        tab_bar_map.set ("Always Show Tabs", _("Always"));
        tab_bar_map.set ("Hide When Single Tab", _("Hide when single tab"));
        tab_bar_map.set ("Never Show Tabs", _("Never"));

        var tab_bar_label = new SummaryLabel (_("Show tabs:"));
        var tab_bar_combo = new ComboBoxText (tab_bar_map);

        content_area.attach (follow_last_tab_label, 0, 0, 1, 1);
        content_area.attach (follow_last_tab_switch, 1, 0, 1, 1);
        content_area.attach (follow_last_tab_info, 1, 1, 1, 1);
        content_area.attach (unsafe_paste_alert_label, 0, 2, 1, 1);
        content_area.attach (unsafe_paste_alert_switch, 1, 2, 1, 1);
        content_area.attach (unsafe_paste_alert_info, 1, 3, 1, 1);
        content_area.attach (rem_tabs_label, 0, 4, 1, 1);
        content_area.attach (rem_tabs_switch, 1, 4, 1, 1);
        content_area.attach (rem_tabs_info, 1, 5, 1, 1);
        content_area.attach (term_bell_label, 0, 6, 1, 1);
        content_area.attach (term_bell_switch, 1, 6, 1, 1);
        content_area.attach (term_bell_info, 1, 7, 1, 1);
        content_area.attach (tab_bar_label, 0, 8, 1, 1);
        content_area.attach (tab_bar_combo, 1, 8, 1, 1);

        show_all ();

        settings.bind ("follow-last-tab", follow_last_tab_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("tab-bar-behavior", tab_bar_combo, "active_id", SettingsBindFlags.DEFAULT);

        on_click_reset (() => {
            string[] keys = {"unsafe-paste-alert", "natural-copy-paste",
                             "follow-last-tab", "audible-bell", "remember-tabs", "tab-bar-behavior"};

            foreach (string key in keys) {
                settings.reset (key);
            }
        });
    }
}
