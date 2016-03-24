/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
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
    public class Panes.AnimationsPane : Categories.Pane {
        public Gtk.Adjustment open_adj = new Gtk.Adjustment (0,0,1000,1,10,10);
        public Gtk.Adjustment close_adj = new Gtk.Adjustment (0,0,1000,1,10,10);
        public Gtk.Adjustment snap_adj = new Gtk.Adjustment (0,0,1000,1,10,10);
        public Gtk.Adjustment minimize_adj = new Gtk.Adjustment (0,0,1000,1,10,10);
        public Gtk.Adjustment workspace_adj = new Gtk.Adjustment (0,0,1000,1,10,10);

        public AnimationsPane () {
            base (_("Animations"), "go-jump");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var master_box = new Widgets.SettingsBox ();
            var animations_box = new Widgets.SettingsBox ();

            var master_switch = master_box.add_switch ("Animations");

            var open_duration = animations_box.add_spin_button ("Open duration", open_adj);
            var close_duration = animations_box.add_spin_button ("Close duration", close_adj);
            var snap_duration = animations_box.add_spin_button ("Snap duration", snap_adj);
            var minimize_duration = animations_box.add_spin_button ("Minimize duration", minimize_adj);
            var workspace_duration = animations_box.add_spin_button ("Workspace switch duration", workspace_adj);

            grid.add (master_box);
            grid.add (animations_box);
        }

        private void connect_signals () {

        }
    }
}
