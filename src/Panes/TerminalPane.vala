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
    private Gtk.DropDown cursor_shape_dropdown;
    private Gtk.FontDialogButton term_font_button;

    private Settings settings;
    private ListStore tab_bar_list;
    private ListStore cursor_shape_list;

    public TerminalPane () {
        Object (
            name: "terminal",
            title: _("Terminal"),
            icon: new ThemedIcon ("utilities-terminal")
        );
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
        var tab_bar_label = new Granite.HeaderLabel (_("Show Tabs")) {
            hexpand = true
        };

        tab_bar_list = new ListStore (typeof (StringIdObject));
        tab_bar_list.append (new StringIdObject ("Always Show Tabs", _("Always")));
        tab_bar_list.append (new StringIdObject ("Hide When Single Tab", _("Hide when single tab")));
        tab_bar_list.append (new StringIdObject ("Never Show Tabs", _("Never")));

        tab_bar_dropdown = DropDownId.new (tab_bar_list);

        var tab_bar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        tab_bar_box.append (tab_bar_label);
        tab_bar_box.append (tab_bar_dropdown);

        /*************************************************/
        /*  Cursor Shape                                 */
        /*************************************************/
        var cursor_shape_label = new Granite.HeaderLabel (_("Cursor Shape")) {
            hexpand = true
        };

        cursor_shape_list = new ListStore (typeof (StringIdObject));
        cursor_shape_list.append (new StringIdObject ("Block", _("Block")));
        cursor_shape_list.append (new StringIdObject ("I-Beam", _("I-Beam")));
        cursor_shape_list.append (new StringIdObject ("Underline", _("Underline")));

        cursor_shape_dropdown = DropDownId.new (cursor_shape_list);

        var cursor_shape_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        cursor_shape_box.append (cursor_shape_label);
        cursor_shape_box.append (cursor_shape_dropdown);

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

        content_area.append (follow_last_tab_box);
        content_area.append (unsafe_paste_alert_box);
        content_area.append (rem_tabs_box);
        content_area.append (term_bell_box);
        content_area.append (tab_bar_box);
        content_area.append (cursor_shape_box);
        content_area.append (term_font_box);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.TERMINAL_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.TERMINAL_SCHEMA);
            return false;
        }
        settings = new Settings (SettingsUtil.TERMINAL_SCHEMA);

        settings.bind ("follow-last-tab", follow_last_tab_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("unsafe-paste-alert", unsafe_paste_alert_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("remember-tabs", rem_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("audible-bell", term_bell_switch, "active", SettingsBindFlags.DEFAULT);

        settings.bind_with_mapping ("tab-bar-behavior",
            tab_bar_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdownid_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdownid_selected,
            tab_bar_list, null);

        settings.bind_with_mapping ("cursor-shape",
            cursor_shape_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdownid_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdownid_selected,
            cursor_shape_list, null);

        settings.bind_with_mapping ("font",
            term_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_fontbutton_fontdesc,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_fontbutton_fontdesc,
            null, null);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        string[] keys = {"follow-last-tab", "unsafe-paste-alert", "remember-tabs",
                         "audible-bell", "tab-bar-behavior", "cursor-shape", "font"};

        foreach (unowned var key in keys) {
            settings.reset (key);
        }
    }
}
