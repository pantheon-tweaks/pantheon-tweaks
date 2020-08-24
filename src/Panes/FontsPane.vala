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

namespace PantheonTweaks {
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
            init_data ();
            connect_signals ();
        }

        private void build_ui () {
            var fonts_label = new Widgets.Label (_("Font Settings"));
            var fonts_box = new Widgets.SettingsBox ();

            default_font.use_font = true;
            document_font.use_font = true;
            mono_font.use_font = true;
            titlebar_font.use_font = true;

            fonts_box.add_widget (_("Default font"), default_font);
            fonts_box.add_widget (_("Document font"), document_font);
            fonts_box.add_widget (_("Monospace font"), mono_font);
            fonts_box.add_widget (_("Titlebar font"), titlebar_font);

            grid.add (fonts_label);
            grid.add (fonts_box);

            grid.show_all ();
        }

        protected override void init_data () {
            default_font.font_name = InterfaceSettings.get_default ().font_name;
            document_font.font_name = InterfaceSettings.get_default ().document_font_name;
            mono_font.font_name = InterfaceSettings.get_default ().monospace_font_name;
            titlebar_font.font_name = WindowSettings.get_default ().titlebar_font;
        }

        private void connect_signals () {
            connect_font_button (default_font, (val) => { InterfaceSettings.get_default ().font_name = val; });
            connect_font_button (document_font, (val) => { InterfaceSettings.get_default ().document_font_name = val; });
            connect_font_button (mono_font, (val) => { InterfaceSettings.get_default ().monospace_font_name = val; });
            connect_font_button (titlebar_font, (val) => { WindowSettings.get_default ().titlebar_font = val; });

            connect_reset_button (() => {
                InterfaceSettings.get_default().reset_fonts ();
                WindowSettings.get_default().reset_fonts ();
            });
        }
    }
}
