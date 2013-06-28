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

public class MiscGrid : Gtk.Grid
{
    public MiscGrid () {
        this.column_spacing = 12;
        this.row_spacing = 6;
        this.margin = 24;
        this.column_homogeneous = true;


        /* Single Click */
        var single_click = new Gtk.Switch ();

        single_click.set_active(FilesSettings.get_default ().single_click);
        single_click.notify["active"].connect (() => FilesSettings.get_default ().single_click = single_click.active );
        single_click.halign = Gtk.Align.START;


        /* Date Format */
        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var date_format = new Gtk.ComboBoxText ();
        date_format.append ("locale", _("Locale"));
        date_format.append ("iso", _("ISO"));
        date_format.append ("informal", _("Informal"));

        date_format.active_id = FilesSettings.get_default ().date_format;
        date_format.changed.connect (() => FilesSettings.get_default ().date_format = date_format.active_id );
        date_format.halign = Gtk.Align.START;
        date_format.width_request = 160;

        var date_format_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        date_format_default.clicked.connect (() => {
            FilesSettings.get_default ().schema.reset("date-format");
            date_format.active_id = FilesSettings.get_default ().date_format;
        });
        date_format_default.halign = Gtk.Align.START;

        date_format_box.pack_start (date_format, false);
        date_format_box.pack_start (date_format_default, false);

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

        /* Audible Bell */
        var audible_bell = new Gtk.Switch ();
        audible_bell.set_active(WindowSettings.get_default ().audible_bell);
        audible_bell.notify["active"].connect (() => WindowSettings.get_default ().audible_bell = audible_bell.active );
        audible_bell.halign = Gtk.Align.START;

        /* Overlay Scrollbar */
        var overlay_scrollbar = new Gtk.Switch ();
        overlay_scrollbar.set_active(InterfaceSettings.get_default ().ubuntu_overlay_scrollbars);
        overlay_scrollbar.notify["active"].connect (() => InterfaceSettings.get_default ().ubuntu_overlay_scrollbars = overlay_scrollbar.active );
        overlay_scrollbar.halign = Gtk.Align.START;

        /* Search Indicator */
        var checksearch = File.new_for_path ("/usr/lib/indicators3/7/libsynapse.so");
        var checkschema = File.new_for_path ("/usr/share/glib-2.0/schemas/net.launchpad.synapse-project.gschema.xml");

        if (checksearch.query_exists() && checkschema.query_exists()){

            var search_entry_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var search_entry = new Gtk.Entry();
            search_entry.text = SynapseSettings.get_default ().shortcut;
            search_entry.changed.connect (() => SynapseSettings.get_default ().shortcut = search_entry.text);
            search_entry.width_request = 160;
            search_entry.halign = Gtk.Align.START;

            var search_entry_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            search_entry_default.clicked.connect (() => {
                SynapseSettings.get_default ().schema.reset("shortcut");
                search_entry.text = SynapseSettings.get_default ().shortcut;
            });

            search_entry_box.pack_start (search_entry, false);
            search_entry_box.pack_start (search_entry_default, false);


            this.attach (new LLabel.right (_("Search Indicator Shortcut:")), 1, 10, 1, 1);
            this.attach (search_entry_box, 2, 10, 2, 1);
        }


        /* Spacer */
        var spacer = new LLabel.right ((""));
        spacer.width_request = 10;


        this.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Slingshot:")+"</span>")), 1, 0, 1, 1);
        this.attach (spacer, 0, 0, 1, 1);

        this.attach (new LLabel.right (_("Rows:")), 1, 1, 1, 1);
        this.attach (slingshot_rows_box, 2, 1, 2, 1);

        this.attach (new LLabel.right (_("Columns:")), 1, 2, 1, 1);
        this.attach (slingshot_columns_box, 2, 2, 2, 1);

        this.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Files:")+"</span>")), 1, 3, 1, 1);

        this.attach (new LLabel.right (_("Single Click:")), 1, 4, 1, 1);
        this.attach (single_click, 2, 4, 2, 1);

        this.attach (new LLabel.right (_("Date Format:")), 1, 5, 1, 1);
        this.attach (date_format_box, 2, 5, 2, 1);

        this.attach (new LLabel.right (_("Sidebar Icon Size:")), 1, 6, 1, 1);
        this.attach (sidebar_zoom_box, 2, 6, 2, 1);

        this.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Other Settings:")+"</span>")), 1, 7, 1, 1);

        this.attach (new LLabel.right (_("Audible Bell:")), 1, 8, 1, 1);
        this.attach (audible_bell, 2, 8, 2, 1);

        this.attach (new LLabel.right (_("Overlay Scrollbars:")), 1, 9, 1, 1);
        this.attach (overlay_scrollbar, 2, 9, 2, 1);
    }
}
