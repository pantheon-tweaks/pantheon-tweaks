/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Panes.TerminalPane : BasePane {
    private const string TERMINAL_SCHEMA = "io.elementary.terminal.settings";

    private Settings settings;

    public TerminalPane () {
        base ("terminal", _("Terminal"), "utilities-terminal");
    }

    construct {
        if (!if_show_pane ({ TERMINAL_SCHEMA })) {
            return;
        }

        settings = new Settings (TERMINAL_SCHEMA);

        /*************************************************/
        /* Follow Last Tab                               */
        /*************************************************/
        var follow_last_tab_label = new Granite.HeaderLabel (_("Follow Last Tab")) {
            secondary_text = _("Creating a new tab sets the working directory of the last opened tab."),
            hexpand = true
        };
        var follow_last_tab_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var follow_last_tab_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        follow_last_tab_box.append (follow_last_tab_label);
        follow_last_tab_box.append (follow_last_tab_switch);

        /*************************************************/
        /* Unsafe Paste Alert                            */
        /*************************************************/
        var unsafe_paste_alert_label = new Granite.HeaderLabel (_("Unsafe Paste Alert")) {
            secondary_text = _("Show a warning dialog when pasting a command with 'sudo' or multiple lines."),
            hexpand = true
        };
        var unsafe_paste_alert_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var unsafe_paste_alert_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        unsafe_paste_alert_box.append (unsafe_paste_alert_label);
        unsafe_paste_alert_box.append (unsafe_paste_alert_switch);

        /*************************************************/
        /* Remember Tabs                                 */
        /*************************************************/
        var rem_tabs_label = new Granite.HeaderLabel (_("Remember Tabs")) {
            secondary_text = _("If enabled, last opened tabs are restored on start."),
            hexpand = true
        };
        var rem_tabs_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var rem_tabs_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        rem_tabs_box.append (rem_tabs_label);
        rem_tabs_box.append (rem_tabs_switch);

        /*************************************************/
        /* Terminal Bell                                 */
        /*************************************************/
        var term_bell_label = new Granite.HeaderLabel (_("Terminal Bell")) {
            secondary_text = _("Sound when hitting the end of a line and also for tab-completion when there are either no or multiple possible completions."), // vala-lint=line-length
            hexpand = true
        };
        var term_bell_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var term_bell_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        term_bell_box.append (term_bell_label);
        term_bell_box.append (term_bell_switch);

        /*************************************************/
        /* Show Tabs                                     */
        /*************************************************/
        var tab_bar_map = new Gee.HashMap<string, string> ();
        tab_bar_map.set ("Always Show Tabs", _("Always"));
        tab_bar_map.set ("Hide When Single Tab", _("Hide when single tab"));
        tab_bar_map.set ("Never Show Tabs", _("Never"));

        var tab_bar_label = new Granite.HeaderLabel (_("Show Tabs")) {
            hexpand = true
        };
        var tab_bar_combo = combobox_text_new (tab_bar_map);

        var tab_bar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        tab_bar_box.append (tab_bar_label);
        tab_bar_box.append (tab_bar_combo);

        /*************************************************/
        /* Terminal Font                                 */
        /*************************************************/
        var term_font_label = new Granite.HeaderLabel (_("Terminal Font")) {
            hexpand = true
        };
        var term_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true
        };
        var term_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        term_font_box.append (term_font_label);
        term_font_box.append (term_font_button);

        content_area.attach (follow_last_tab_box, 0, 0, 1, 1);
        content_area.attach (unsafe_paste_alert_box, 0, 1, 1, 1);
        content_area.attach (rem_tabs_box, 0, 2, 1, 1);
        content_area.attach (term_bell_box, 0, 3, 1, 1);
        content_area.attach (tab_bar_box, 0, 4, 1, 1);
        content_area.attach (term_font_box, 0, 5, 1, 1);

        settings.bind ("follow-last-tab", follow_last_tab_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("tab-bar-behavior", tab_bar_combo, "active_id", SettingsBindFlags.DEFAULT);
        settings.bind_with_mapping ("font", term_font_button, "font-desc", SettingsBindFlags.DEFAULT,
                                    font_button_bind_get, font_button_bind_set, null, null);
    }

    protected override void do_reset () {
        string[] keys = {"follow-last-tab", "unsafe-paste-alert", "remember-tabs",
                         "audible-bell", "tab-bar-behavior", "font"};

        foreach (string key in keys) {
            settings.reset (key);
        }
    }
}
