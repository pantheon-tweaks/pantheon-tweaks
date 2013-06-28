//  
//  Copyright (C) 2013 Michael Langfermann
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 

public class FontsGrid : Gtk.Grid
{
    public FontsGrid () {
        this.column_spacing = 12;
        this.row_spacing = 6;
        this.margin = 24;
        this.column_homogeneous = true;

        /* Default Font */
        var default_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var default_font = new Gtk.FontButton.with_font (InterfaceSettings.get_default ().font_name);
        default_font.font_set.connect (() => InterfaceSettings.get_default ().font_name = default_font.get_font_name ());
        default_font.width_request = 160;
        default_font.use_font = true;

        var default_font_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        default_font_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("font-name");
            default_font.font_name = InterfaceSettings.get_default ().font_name;
        });

        default_font_box.pack_start (default_font, false);
        default_font_box.pack_start (default_font_default, false);

        /* Document Font */
        var document_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var document_font = new Gtk.FontButton.with_font (InterfaceSettings.get_default ().document_font_name);
        document_font.font_set.connect (() => InterfaceSettings.get_default ().document_font_name = document_font.get_font_name ());
        document_font.width_request = 160;
        document_font.use_font = true;

        var document_font_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        document_font_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("document-font-name");
            document_font.font_name = InterfaceSettings.get_default ().document_font_name;
        });

        document_font_box.pack_start (document_font, false);
        document_font_box.pack_start (document_font_default, false);

        /* Monospace Font */
        var mono_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var mono_font = new Gtk.FontButton.with_font (InterfaceSettings.get_default ().monospace_font_name);
        mono_font.set_filter_func((family, face) => {
            return family.is_monospace();
        });
        mono_font.font_set.connect (() => InterfaceSettings.get_default ().monospace_font_name = mono_font.get_font_name ());
        mono_font.width_request = 160;
        mono_font.use_font = true;

        var mono_font_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        mono_font_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("monospace-font-name");
            mono_font.font_name = InterfaceSettings.get_default ().monospace_font_name;
        });

        mono_font_box.pack_start (mono_font, false);
        mono_font_box.pack_start (mono_font_default, false);

        /* Window Font */
        var window_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var window_font = new Gtk.FontButton.with_font (WindowSettings.get_default ().titlebar_font);
        window_font.font_set.connect (() => WindowSettings.get_default ().titlebar_font = window_font.get_font_name ());
        window_font.width_request = 160;
        window_font.use_font = true;

        var window_font_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        window_font_default.clicked.connect (() => {
            WindowSettings.get_default ().schema.reset ("titlebar-font");
            window_font.font_name = WindowSettings.get_default ().titlebar_font;
        });

        window_font_box.pack_start (window_font, false);
        window_font_box.pack_start (window_font_default, false);

        this.attach (new LLabel.right (_("Default Font:")), 1, 0, 1, 1);
        this.attach (default_font_box, 2, 0, 1, 1);

        this.attach (new LLabel.right (_("Document Font:")), 1, 1, 1, 1);
        this.attach (document_font_box, 2, 1, 1, 1);

        this.attach (new LLabel.right (_("Monospace Font:")), 1, 2, 1, 1);
        this.attach (mono_font_box, 2, 2, 1, 1);

        this.attach (new LLabel.right (_("Window Title Font:")), 1, 3, 1, 1);
        this.attach (window_font_box, 2, 3, 1, 1);
    }
}
