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

public class WingpanelslimGrid : Gtk.Grid
{
    public WingpanelslimGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        /* Wingpanel Slim */
        var wingpanel = new Gtk.Switch ();
        var wingpanel_slim = CerbereSettings.get_default ().monitored_processes;

        int pos = -1;
        for (int i = 0; i < wingpanel_slim.length ; i++) {
            if ( wingpanel_slim[i] == "wingpanel" || wingpanel_slim[i] == "wingpanel-slim" )
            pos = i; 
        }

        /* Wingpanel Position */
        var slim_pos_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slim_pos = new Gtk.ComboBoxText ();
        var slim_label = new LLabel.right (_("Position:"));
        slim_pos.append ("Elementary Right", _("Right"));
        slim_pos.append ("Middle", _("Middle"));
        slim_pos.append ("Elementary Left", _("Left"));
        slim_pos.append ("Flush Left", _("Flush Left"));
        slim_pos.append ("Flush Right", _("Flush Right"));

        slim_pos.active_id = WingpanelslimSettings.get_default ().panel_position;
        slim_pos.changed.connect (() => WingpanelslimSettings.get_default ().panel_position = slim_pos.active_id );
        slim_pos.halign = Gtk.Align.START;
        slim_pos.width_request = 160;

        var slim_pos_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slim_pos_default.clicked.connect (() => {
            WingpanelslimSettings.get_default ().schema.reset ("panel-position");
            slim_pos.active_id = WingpanelslimSettings.get_default ().panel_position;
        });
        slim_pos_default.halign = Gtk.Align.START;

        slim_pos_box.pack_start (slim_pos, false);
        slim_pos_box.pack_start (slim_pos_default, false);

        this.attach (slim_label, 0, 7, 2, 1);
        this.attach (slim_pos_box, 2, 7, 2, 1);

        /* Wingpanel Edge */
        var slim_edge_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slim_edge = new Gtk.ComboBoxText ();
        var slim_label_edge = new LLabel.right (_("Edge:"));
        slim_edge.append ("Slanted", _("Slanted"));
        slim_edge.append ("Squared", _("Squared"));
        slim_edge.append ("Curved 1", _("Curved 1"));
        slim_edge.append ("Curved 2", _("Curved 2"));
        slim_edge.append ("Curved 3", _("Curved 3"));

        slim_edge.active_id = WingpanelslimSettings.get_default ().panel_edge;
        slim_edge.changed.connect (() => WingpanelslimSettings.get_default ().panel_edge = slim_edge.active_id );
        slim_edge.halign = Gtk.Align.START;
        slim_edge.width_request = 160;

        var slim_edge_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slim_edge_default.clicked.connect (() => {
            WingpanelslimSettings.get_default ().schema.reset ("panel-edge");
            slim_edge.active_id = WingpanelslimSettings.get_default ().panel_edge;
        });
        slim_edge_default.halign = Gtk.Align.START;

        slim_edge_box.pack_start (slim_edge, false);
        slim_edge_box.pack_start (slim_edge_default, false);

        this.attach (slim_label_edge, 0, 8, 2, 1);
        this.attach (slim_edge_box, 2, 8, 2, 1);

        if ( wingpanel_slim[pos] == "wingpanel-slim" )
            wingpanel.set_active(true);
        else {
            slim_label.set_sensitive(wingpanel.active);
            slim_label_edge.set_sensitive(wingpanel.active);
            slim_pos_box.set_sensitive(wingpanel.active);
            slim_edge_box.set_sensitive(wingpanel.active);
        }

        wingpanel.notify["active"].connect (() => {
            wingpanel_slim = CerbereSettings.get_default ().monitored_processes;
            for (int i = 0; i < wingpanel_slim.length ; i++) {
                if ( wingpanel_slim[i] == "wingpanel" || wingpanel_slim[i] == "wingpanel-slim" )
                pos = i; 
            }
            slim_label.set_sensitive(wingpanel.active);
            slim_label_edge.set_sensitive(wingpanel.active);
            slim_pos_box.set_sensitive(wingpanel.active);
            slim_edge_box.set_sensitive(wingpanel.active);
            (wingpanel.active)?wingpanel_slim[pos] = "killall wingpanel":wingpanel_slim[pos] = "killall wingpanel-slim";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            (wingpanel.active)?wingpanel_slim[pos] = "wingpanel-slim":wingpanel_slim[pos] = "wingpanel";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
        });
        wingpanel.halign = Gtk.Align.START;

        this.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 6, 2, 1);
        this.attach (wingpanel, 2, 6, 2, 1);

    }
}
