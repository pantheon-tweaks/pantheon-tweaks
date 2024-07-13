/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Panes.FilesPane : Categories.Pane {
    private const string FILES_SCHEMA = "io.elementary.files.preferences";

    public FilesPane () {
        base ("files", _("Files"), "system-file-manager");
    }

    construct {
        if (!if_show_pane ({ FILES_SCHEMA })) {
            return;
        }

        var settings = new GLib.Settings (FILES_SCHEMA);

        /*************************************************/
        /* Restore Tabs                                  */
        /*************************************************/
        var restore_tabs_label = new Granite.HeaderLabel (_("Restore Tabs")) {
            secondary_text = _("Restore tabs from previous session when launched"),
            hexpand = true
        };
        var restore_tabs_switch = new Gtk.Switch () {
            valign = Gtk.Align.START
        };
        var restore_tabs_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        restore_tabs_box.append (restore_tabs_label);
        restore_tabs_box.append (restore_tabs_switch);

        /*************************************************/
        /* Date Format                                   */
        /*************************************************/
        var date_format_map = new Gee.HashMap<string, string> ();
        date_format_map.set ("locale", _("Locale"));
        date_format_map.set ("iso", _("ISO"));
        date_format_map.set ("informal", _("Informal"));

        var date_format_label = new Granite.HeaderLabel (_("Date Format")) {
            secondary_text = _("Date format used in the properties dialog or the list view"),
            hexpand = true
        };
        var date_format_combo = combobox_text_new (date_format_map);
        date_format_combo.valign = Gtk.Align.START;

        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        date_format_box.append (date_format_label);
        date_format_box.append (date_format_combo);

        content_area.attach (restore_tabs_box, 0, 0, 1, 1);
        content_area.attach (date_format_box, 0, 1, 1, 1);

        settings.bind ("restore-tabs", restore_tabs_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("date-format", date_format_combo, "active_id", SettingsBindFlags.DEFAULT);

        on_click_reset (() => {
            string[] keys = {"restore-tabs", "date-format"};

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
