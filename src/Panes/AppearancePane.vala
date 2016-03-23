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
    public class Panes.AppearancePane : Categories.Pane {
        private Gtk.Switch prefer_dark_switch;
        private Gtk.ComboBox gtk_theme_combobox;
        private Gtk.ComboBox metacity_theme_combobox;
        private Gtk.ComboBox icon_theme_combobox;
        private Gtk.ComboBox cursor_theme_combobox;

        private Gtk.ComboBox window_controls_combobox;

        public AppearancePane () {
            base (_("Appearance"), "applications-graphics");
        }

        construct {
            build_ui ();
            init_data ();
            connect_signals ();
        }

        private void build_ui () {
            var theme_label = new Widgets.Label (_("Theme Settings"));
            var theme_box = new Widgets.SettingsBox ();

            gtk_theme_combobox = theme_box.add_combo_box (_("GTK+"));
            prefer_dark_switch = theme_box.add_switch (_("Prefer dark variant"));
            metacity_theme_combobox = theme_box.add_combo_box (_("Metacity (Non-GTK+ applications)"));
            icon_theme_combobox = theme_box.add_combo_box (_("Icons"));
            cursor_theme_combobox = theme_box.add_combo_box (_("Cursor"));

            grid.add (theme_label);
            grid.add (theme_box);

            var layout_label = new Widgets.Label (_("Window Controls"));
            var layout_box = new Widgets.SettingsBox ();

            window_controls_combobox = layout_box.add_combo_box (_("Layout"));

            grid.add (layout_label);
            grid.add (layout_box);

            grid.show_all ();
        }

        private void init_data () {
            var gtk_index = 0;
            var metacity_index = 0;
            var icon_index = 0;
            var cursor_index = 0;

            var gtk_store = Util.get_themes_store ("themes", "gtk-3.0", InterfaceSettings.get_default ().gtk_theme, out gtk_index);
            var metacity_store = Util.get_themes_store ("themes", "metacity-1", WindowSettings.get_default ().theme, out metacity_index);
            var icon_store = Util.get_themes_store ("icons", "index.theme", InterfaceSettings.get_default ().icon_theme, out icon_index);
            var cursor_store = Util.get_themes_store ("icons", "cursors", InterfaceSettings.get_default ().cursor_theme, out cursor_index);

            gtk_theme_combobox.set_model (gtk_store);
            metacity_theme_combobox.set_model (metacity_store);
            icon_theme_combobox.set_model (icon_store);
            cursor_theme_combobox.set_model (cursor_store);

            gtk_theme_combobox.set_active (gtk_index);
            metacity_theme_combobox.set_active (metacity_index);
            icon_theme_combobox.set_active (icon_index);
            cursor_theme_combobox.set_active (cursor_index);

            prefer_dark_switch.set_state (GtkSettings.get_default ().prefer_dark_theme);
        }

        private void connect_signals () {}
    }
}
