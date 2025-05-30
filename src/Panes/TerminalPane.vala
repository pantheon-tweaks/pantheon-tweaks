/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Panes.TerminalPane : BasePane {
    private Gtk.Switch follow_last_tab_switch;
    private Gtk.Switch unsafe_paste_alert_switch;
    private Gtk.Switch rem_tabs_switch;
    private Gtk.Switch term_bell_switch;
    private Gtk.DropDown tab_bar_dropdown;
    private Gtk.FontDialogButton term_font_button;

    private Settings settings;
    private ListStore tab_bar_list;

    public TerminalPane () {
        base ("terminal", _("Terminal"), "utilities-terminal");
    }

    construct {
        /*************************************************/
        /* Follow Last Tab                               */
        /*************************************************/
        var follow_last_tab_label = new Granite.HeaderLabel (_("Follow Last Tab")) {
            secondary_text = _("Creating a new tab sets the working directory of the last opened tab."),
            hexpand = true
        };
        follow_last_tab_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var follow_last_tab_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        follow_last_tab_box.append (follow_last_tab_label);
        follow_last_tab_box.append (follow_last_tab_switch);

        /*************************************************/
        /* Unsafe Paste Alert                            */
        /*************************************************/
        var unsafe_paste_alert_label = new Granite.HeaderLabel (_("Unsafe Paste Alert")) {
            secondary_text = _("Warn when pasted text contains multiple or administrative commands."),
            hexpand = true
        };
        unsafe_paste_alert_switch = new Gtk.Switch () {
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
        rem_tabs_switch = new Gtk.Switch () {
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
        term_bell_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var term_bell_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        term_bell_box.append (term_bell_label);
        term_bell_box.append (term_bell_switch);

        /*************************************************/
        /* Show Tabs                                     */
        /*************************************************/
        tab_bar_list = new ListStore (typeof (StringIdObject));
        tab_bar_list.append (new StringIdObject ("Always Show Tabs", _("Always")));
        tab_bar_list.append (new StringIdObject ("Hide When Single Tab", _("Hide when single tab")));
        tab_bar_list.append (new StringIdObject ("Never Show Tabs", _("Never")));

        var tab_bar_label = new Granite.HeaderLabel (_("Show Tabs")) {
            hexpand = true
        };
        tab_bar_dropdown = DropDownId.new (tab_bar_list);

        var tab_bar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        tab_bar_box.append (tab_bar_label);
        tab_bar_box.append (tab_bar_dropdown);

        /*************************************************/
        /* Terminal Font                                 */
        /*************************************************/
        var term_font_label = new Granite.HeaderLabel (_("Terminal Font")) {
            hexpand = true
        };
        term_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
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
    }

    public override bool load () {
        if (!SchemaUtil.schema_exists (SchemaUtil.TERMINAL_SCHEMA)) {
            warning ("Could not find settings schema %s", SchemaUtil.TERMINAL_SCHEMA);
            return false;
        }
        settings = new Settings (SchemaUtil.TERMINAL_SCHEMA);

        settings.bind ("follow-last-tab", follow_last_tab_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell_switch, "active", SettingsBindFlags.DEFAULT);

        settings.bind_with_mapping ("tab-bar-behavior",
            tab_bar_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) DropDownId.settings_value_to_selected,
            (SettingsBindSetMappingShared) DropDownId.selected_to_settings_value,
            tab_bar_list, null);

        settings.bind_with_mapping ("font",
            term_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) font_button_bind_get,
            (SettingsBindSetMappingShared) font_button_bind_set,
            null, null);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        string[] keys = {"follow-last-tab", "unsafe-paste-alert", "remember-tabs",
                         "audible-bell", "tab-bar-behavior", "font"};

        foreach (unowned var key in keys) {
            settings.reset (key);
        }
    }
}
