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
        public AnimationsPane () {
            base (_("Animations"), "preferences-desktop-sound");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var test_box = new Widgets.SettingsBox ();
            test_box.add_switch ("test");
            test_box.add_switch ("another test");
            grid.add (test_box);

            grid.show_all ();
        }

        private void connect_signals () {

        }
    }
}
