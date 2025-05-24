/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Panes.FilesPane : BasePane {
    private const string FILES_SCHEMA = "io.elementary.files.preferences";

    private Settings settings;
    private ListStore date_format_list;
    private Gtk.DropDown date_format_combo;

    public FilesPane () {
        base ("files", _("Files"), "system-file-manager");
    }

    construct {
        if (!if_show_pane ({ FILES_SCHEMA })) {
            return;
        }

        settings = new Settings (FILES_SCHEMA);

        /*************************************************/
        /* Restore Tabs                                  */
        /*************************************************/
        var restore_tabs_label = new Granite.HeaderLabel (_("Restore Tabs")) {
            secondary_text = _("Restore tabs from previous session when launched."),
            hexpand = true
        };
        var restore_tabs_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var restore_tabs_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        restore_tabs_box.append (restore_tabs_label);
        restore_tabs_box.append (restore_tabs_switch);

        /*************************************************/
        /* Date Format                                   */
        /*************************************************/
        date_format_list = new ListStore (typeof (ListItemModel));
        date_format_list.append (new ListItemModel ("locale", _("Locale")));
        date_format_list.append (new ListItemModel ("iso", _("ISO")));
        date_format_list.append (new ListItemModel ("informal", _("Informal")));

        var date_format_label = new Granite.HeaderLabel (_("Date Format")) {
            secondary_text = _("Date format used in the properties dialog or the list view."),
            hexpand = true
        };
        date_format_combo = dropdown_new (date_format_list);

        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        date_format_box.append (date_format_label);
        date_format_box.append (date_format_combo);

        content_area.attach (restore_tabs_box, 0, 0, 1, 1);
        content_area.attach (date_format_box, 0, 1, 1, 1);

        date_format_settings_to_combo ();

        settings.bind ("restore-tabs", restore_tabs_switch, "active", SettingsBindFlags.DEFAULT);

        settings.changed["date-format"].connect (date_format_settings_to_combo);
        date_format_combo.notify["selected"].connect (date_format_combo_to_settings);
    }

    private void date_format_settings_to_combo () {
        string selected_id = settings.get_string ("date-format");
        uint selected_pos = ListItemModel.liststore_get_position (date_format_list, selected_id);

        if (date_format_combo.selected == selected_pos) {
            return;
        }

        date_format_combo.selected = selected_pos;
    }

    private void date_format_combo_to_settings () {
        uint selected_pos = date_format_combo.selected;
        string? selected_id = ListItemModel.liststore_get_id (date_format_list, selected_pos);

        if (selected_id == null) {
            return;
        }

        settings.set_string ("date-format", selected_id);
    }

    protected override void do_reset () {
        string[] keys = {"restore-tabs", "date-format"};

        foreach (var key in keys) {
            settings.reset (key);
        }
    }
}
