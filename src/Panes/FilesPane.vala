/*
 * Copyright (C) Elementary Tweaks Developers, 2016
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

namespace ElementaryTweaks {
    public class Panes.FilesPane : Categories.Pane {
        private Gtk.Switch single_click;
        private Gtk.Switch restore_tabs;
        private Gtk.ComboBox date_format;
        private Gtk.ComboBox sidebar_size;

        public FilesPane () {
            base (_("Files"), "system-file-manager");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var files_box = new Widgets.SettingsBox ();

            single_click = files_box.add_switch (_("Single click"));
            restore_tabs = files_box.add_switch (_("Restore Tabs"));
            date_format = files_box.add_combo_box (_("Date format"));
            sidebar_size = files_box.add_combo_box (_("Sidebar icon size"));

            grid.add (files_box);
            grid.show_all ();
        }

        private void connect_signals () {

        }
    }
}
