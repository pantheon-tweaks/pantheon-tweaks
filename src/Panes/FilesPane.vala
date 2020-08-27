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
        if (!(Util.schema_exists (FILES_OLD_SCHEMA) || Util.schema_exists (FILES_NEW_SCHEMA))) {
            return;
        }

        var settings = new GLib.Settings ((Util.schema_exists (FILES_NEW_SCHEMA)) ? FILES_NEW_SCHEMA : FILES_OLD_SCHEMA);

        var files_box = new Widgets.SettingsBox ();

        var single_click = files_box.add_switch (_("Single click"));
        var restore_tabs = files_box.add_switch (_("Restore Tabs"));

        var date_format_map = new Gee.HashMap<string, string> ();
        date_format_map.set ("locale", _("Locale"));
        date_format_map.set ("iso", _("ISO"));
        date_format_map.set ("informal", _("Informal"));

        var date_format = files_box.add_combo_box_text (_("Date format"), date_format_map);

        grid.add (files_box);
        grid.show_all ();

        settings.bind ("single-click", single_click, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("restore-tabs", restore_tabs, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("date-format", date_format, "active_id", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"single-click", "restore-tabs", "date-format"};

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
