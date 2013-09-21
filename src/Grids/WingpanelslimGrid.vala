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

        /* Auto Hide */
        var auto_hide = new Gtk.Switch ();
        var auto_label = new LLabel.right (_("Auto Hide:"));

        auto_hide.set_active(WingpanelslimSettings.get_default ().auto_hide);
        auto_hide.notify["active"].connect (() => WingpanelslimSettings.get_default ().auto_hide = auto_hide.active );
        auto_hide.halign = Gtk.Align.START;

        /* Show Launcher */
        var show_launcher = new Gtk.Switch ();
        var show_label = new LLabel.right (_("Show Launcher:"));

        show_launcher.set_active(WingpanelslimSettings.get_default ().show_launcher);
        show_launcher.notify["active"].connect (() => WingpanelslimSettings.get_default ().show_launcher = show_launcher.active );
        show_launcher.halign = Gtk.Align.START;

        /* Default Launcher */
        var default_launcher_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var default_launcher = new Gtk.Entry();
        var launcher_label = new LLabel.right (_("Launcher:"));
        default_launcher.text = WingpanelslimSettings.get_default ().default_launcher;
        default_launcher.changed.connect (() => WingpanelslimSettings.get_default ().default_launcher = default_launcher.text);
        default_launcher.width_request = 160;
        default_launcher.halign = Gtk.Align.START;

        var default_launcher_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        default_launcher_default.clicked.connect (() => {

            WingpanelslimSettings.get_default ().schema.reset ("default-launcher");
            slim_pos.active_id = WingpanelslimSettings.get_default ().panel_position;
        });
        default_launcher_default.halign = Gtk.Align.START;

        default_launcher_box.pack_start (default_launcher, false);
        default_launcher_box.pack_start (default_launcher_default, false);

        if ( pos != -1 && wingpanel_slim[pos] == "wingpanel-slim" )
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
                else
                    pos = -1;
            }
            slim_label.set_sensitive(wingpanel.active);
            slim_label_edge.set_sensitive(wingpanel.active);
            slim_pos_box.set_sensitive(wingpanel.active);
            slim_edge_box.set_sensitive(wingpanel.active);
            if (pos != -1) {
                (wingpanel.active)?wingpanel_slim[pos] = "killall wingpanel":wingpanel_slim[pos] = "killall wingpanel-slim";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
                (wingpanel.active)?wingpanel_slim[pos] = "wingpanel-slim":wingpanel_slim[pos] = "wingpanel";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            } else {
                wingpanel_slim += "wingpanel-slim";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            }
        });
        wingpanel.halign = Gtk.Align.START;

        this.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 0, 1, 1);
        this.attach (wingpanel, 1, 0, 1, 1);

        this.attach (slim_label, 0, 1, 1, 1);
        this.attach (slim_pos_box, 1, 1, 1, 1);

        this.attach (slim_label_edge, 0, 2, 1, 1);
        this.attach (slim_edge_box, 1, 2, 1, 1);

        this.attach (auto_label, 0, 3, 1, 1);
        this.attach (auto_hide, 1, 3, 1, 1);

        this.attach (show_label, 0, 4, 1, 1);
        this.attach (show_launcher, 1, 4, 1, 1);

        this.attach (launcher_label, 0, 5, 1, 1);
        this.attach (default_launcher_box, 1, 5, 1, 1);
    }
}
