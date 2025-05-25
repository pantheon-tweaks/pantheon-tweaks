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
        date_format_list = new ListStore (typeof (StringIdListItem));
        date_format_list.append (new StringIdListItem ("locale", _("Locale")));
        date_format_list.append (new StringIdListItem ("iso", _("ISO")));
        date_format_list.append (new StringIdListItem ("informal", _("Informal")));

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

        settings.bind ("restore-tabs", restore_tabs_switch, "active", SettingsBindFlags.DEFAULT);

        settings.bind_with_mapping ("date-format",
            date_format_combo, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) settings_value_to_selected,
            (SettingsBindSetMappingShared) selected_to_settings_value,
            date_format_list, null);
    }

    protected override void do_reset () {
        string[] keys = {"restore-tabs", "date-format"};

        foreach (var key in keys) {
            settings.reset (key);
        }
    }
}
