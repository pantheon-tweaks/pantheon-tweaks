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

public class PantheonTweaks.Panes.FilesPane : Categories.Pane {
    private const string FILES_OLD_SCHEMA = "org.pantheon.files.preferences";
    private const string FILES_NEW_SCHEMA = "io.elementary.files.preferences";

    public FilesPane () {
        base (_("Files"), "system-file-manager");
    }

    construct {
        if (!(schema_exists (FILES_OLD_SCHEMA) || schema_exists (FILES_NEW_SCHEMA))) {
            return;
        }

        var settings = new GLib.Settings ((schema_exists (FILES_NEW_SCHEMA)) ? FILES_NEW_SCHEMA : FILES_OLD_SCHEMA);

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

        connect_reset_button (() => {
            string[] keys = {"restore-tabs", "date-format"};

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
