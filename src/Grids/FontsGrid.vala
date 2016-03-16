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

    public class FontsGrid : Gtk.Grid
    {
        public FontsGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Default font tweak
            var default_font = new TweakWidget.with_font_button (
                        _("Default Font:"),
                        _("Used by default by most applications"),
                        null,
                        (() => { return InterfaceSettings.get_default ().font_name; }), // get
                        ((val) => { InterfaceSettings.get_default ().font_name = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("font-name"); }) // reset
                    );
            this.add (default_font);

            // Document font tweak
            var document_font = new TweakWidget.with_font_button (
                        _("Document Font:"),
                        _("Used when displaying documents, if no other font was chosen"),
                        null,
                        (() => { return InterfaceSettings.get_default ().document_font_name; }), // get
                        ((val) => { InterfaceSettings.get_default ().document_font_name = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("document-font-name"); }) // reset
                    );
            this.add (document_font);

            // Monospace font tweak
            var monospace_font = new TweakWidget.with_font_button (
                        _("Monospace Font:"),
                        _("Used in the terminal, for code, and sometimes for plain text"),
                        null,
                        (() => { return InterfaceSettings.get_default ().monospace_font_name; }), // get
                        ((val) => { InterfaceSettings.get_default ().monospace_font_name = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("monospace-font-name"); }) // reset
                    );
            this.add (monospace_font);

            // Window title font tweak
            var window_title_font = new TweakWidget.with_font_button (
                        _("Titlebar Font:"),
                        _("Used to display window titles"),
                        null,
                        (() => { return WindowSettings.get_default ().titlebar_font; }), // get
                        ((val) => { WindowSettings.get_default ().titlebar_font = val; }), // set
                        (() => { WindowSettings.get_default ().schema.reset ("titlebar-font"); }) // reset
                    );
            this.add (window_title_font);
        }
    }
}
