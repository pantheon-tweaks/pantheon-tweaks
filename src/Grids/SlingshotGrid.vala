/*
 * Copyright (C) Elementary Tweak Developers, 2014
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


public class SlingshotGrid : Gtk.Grid
{
    public SlingshotGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        /* Sidebar Zoom Level */
        var sidebar_zoom_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var sidebar_zoom = new Gtk.ComboBoxText ();
        sidebar_zoom.append ("smallest", _("Smallest"));
        sidebar_zoom.append ("smaller", _("Smaller"));
        sidebar_zoom.append ("small", _("Small"));
        sidebar_zoom.append ("normal", _("Normal"));
        sidebar_zoom.append ("large", _("Large"));
        sidebar_zoom.append ("larger", _("Larger"));
        sidebar_zoom.append ("largest", _("Largest"));

        sidebar_zoom.active_id = FilesSettings.get_default ().sidebar_zoom_level;
        sidebar_zoom.changed.connect (() => FilesSettings.get_default ().sidebar_zoom_level = sidebar_zoom.active_id );
        sidebar_zoom.halign = Gtk.Align.START;
        sidebar_zoom.width_request = 160;

        var sidebar_zoom_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        sidebar_zoom_default.clicked.connect (() => {
            FilesSettings.get_default ().schema.reset("sidebar-zoom-level");
            FilesSettings.get_default ().sidebar_zoom_level;
        });
        sidebar_zoom_default.halign = Gtk.Align.START;

        sidebar_zoom_box.pack_start (sidebar_zoom, false);
        sidebar_zoom_box.pack_start (sidebar_zoom_default, false);

        /* Slingshot Rows */
        var slingshot_rows_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slingshot_rows = new Gtk.SpinButton.with_range (2, 10, 1);

        slingshot_rows.set_value (SlingshotSettings.get_default ().rows);
        slingshot_rows.value_changed.connect (() => SlingshotSettings.get_default ().rows = slingshot_rows.get_value_as_int() );
        slingshot_rows.width_request = 160;
        slingshot_rows.halign = Gtk.Align.START;

        var slingshot_rows_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slingshot_rows_default.clicked.connect (() => {
            SlingshotSettings.get_default ().schema.reset("rows");
            slingshot_rows.set_value (SlingshotSettings.get_default ().rows);
        });
        slingshot_rows_default.halign = Gtk.Align.START;

        slingshot_rows_box.pack_start (slingshot_rows, false);
        slingshot_rows_box.pack_start (slingshot_rows_default, false);
 

        /* Slingshot Columns */
        var slingshot_columns_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slingshot_columns = new Gtk.SpinButton.with_range (4, 15, 1);

        slingshot_columns.set_value (SlingshotSettings.get_default ().columns);
        slingshot_columns.value_changed.connect (() => SlingshotSettings.get_default ().columns = slingshot_columns.get_value_as_int() );
        slingshot_columns.width_request = 160;
        slingshot_columns.halign = Gtk.Align.START;

        var slingshot_columns_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slingshot_columns_default.clicked.connect (() => {
            SlingshotSettings.get_default ().schema.reset("columns");
            slingshot_columns.set_value (SlingshotSettings.get_default ().columns);
        });
        slingshot_columns_default.halign = Gtk.Align.START;
        slingshot_columns_box.pack_start (slingshot_columns, false);
        slingshot_columns_box.pack_start (slingshot_columns_default, false);

        this.attach (new LLabel.right (_("Rows:")), 0, 0, 1, 1);
        this.attach (slingshot_rows_box, 1, 0, 1, 1);

        this.attach (new LLabel.right (_("Columns:")), 0, 1, 1, 1);
        this.attach (slingshot_columns_box, 1, 1, 1, 1);

    }
}
