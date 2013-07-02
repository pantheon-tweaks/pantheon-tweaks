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

public class SynapseGrid : Gtk.Grid
{
    public SynapseGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        var checksearch = File.new_for_path ("/usr/lib/indicators3/7/libsynapse.so");
        //FIXME: Use GLib.list_schemas
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


            this.attach (new LLabel.right (_("Search Indicator Shortcut:")), 0, 0, 1, 1);
            this.attach (search_entry_box, 1, 0, 1, 1);
        }
    }
}
