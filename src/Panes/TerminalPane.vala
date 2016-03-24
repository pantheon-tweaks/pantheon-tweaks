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
    public class Panes.TerminalPane : Categories.Pane {
        private Gtk.ComboBox default_font_combobox;

        public TerminalPane () {
            base (_("Terminal"), "terminal");
        }

        construct {
            if (Utils.schema_exists ("org.pantheon.terminal.settings")) {
                build_ui ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var fonts_label = new Widgets.Label (_("Font Settings"));
            var fonts_box = new Widgets.SettingsBox ();

            default_font_combobox = fonts_box.add_combo_box (_("Default font"));

            grid.add (fonts_label);
            grid.add (fonts_box);

            grid.show_all ();
        }

        private void connect_signals () {

        }
    }
}
