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
    public class Panes.FontsPane : Categories.Pane {
        private Gtk.FontButton default_font = new Gtk.FontButton ();
        private Gtk.FontButton document_font = new Gtk.FontButton ();
        private Gtk.FontButton mono_font = new Gtk.FontButton ();
        private Gtk.FontButton titlebar_font = new Gtk.FontButton ();

        public FontsPane () {
            base (_("Fonts"), "applications-fonts");
        }

        construct {
            build_ui ();
            connect_signals ();
        }

        private void build_ui () {
            var fonts_label = new Widgets.Label (_("Font Settings"));
            var fonts_box = new Widgets.SettingsBox ();

            fonts_box.add_widget (_("Default font"), default_font);
            fonts_box.add_widget (_("Document font"), document_font);
            fonts_box.add_widget (_("Monospace font"), mono_font);
            fonts_box.add_widget (_("Titlebar font"), titlebar_font);


            grid.add (fonts_label);
            grid.add (fonts_box);

            grid.show_all ();
        }

        private void connect_signals () {

        }
    }
}
