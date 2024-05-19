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

        var restore_tabs_label = new SummaryLabel (_("Restore tabs:"));
        var restore_tabs_switch = new Switch ();

        var date_format_map = new Gee.HashMap<string, string> ();
        date_format_map.set ("locale", _("Locale"));
        date_format_map.set ("iso", _("ISO"));
        date_format_map.set ("informal", _("Informal"));

        var date_format_label = new SummaryLabel (_("Date format:"));
        var date_format_combo = new ComboBoxText (date_format_map);

        content_area.attach (restore_tabs_label, 0, 0, 1, 1);
        content_area.attach (restore_tabs_switch, 1, 0, 1, 1);
        content_area.attach (date_format_label, 0, 1, 1, 1);
        content_area.attach (date_format_combo, 1, 1, 1, 1);

        show_all ();

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
