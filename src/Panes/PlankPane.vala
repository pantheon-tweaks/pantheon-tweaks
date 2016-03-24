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
    public class Panes.PlankPane : Categories.Pane {
        private Gtk.Switch current_workspace;
        private Gtk.Switch lock_items;

        private Gtk.Adjustment icon_size = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment hide_delay = new Gtk.Adjustment (0,0,1000,1,10,10);
        private Gtk.Adjustment offset = new Gtk.Adjustment (0,0,1000,1,10,10);

        private Gtk.ComboBox hide_mode;
        private Gtk.ComboBox theme;
        private Gtk.ComboBox monitor;
        private Gtk.ComboBox screen_position;
        private Gtk.ComboBox alignment;
        private Gtk.ComboBox item_alignment;

        public PlankPane () {
            base (_("Dock"), "plank");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var plank_box = new Widgets.SettingsBox ();

            //behabiour


            //look


            plank_box.add_spin_button (_("Icon size"), icon_size);
            hide_mode = plank_box.add_combo_box (_("Hide mode"));
            plank_box.add_spin_button (_("Hide delay"), hide_delay);
            theme = plank_box.add_combo_box (_("Theme"));
            monitor = plank_box.add_combo_box (_("Monitor"));
            screen_position = plank_box.add_combo_box (_("Screen position"));
            alignment = plank_box.add_combo_box (_("Alignment"));
            item_alignment = plank_box.add_combo_box (_("Item alignment"));
            plank_box.add_spin_button (_("Offset"), offset);

            grid.add (plank_box);
            grid.show_all ();
        }

        private void connect_signals () {

        }
    }
}
