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
        var checkslim = File.new_for_path ("/usr/bin/wingpanel-slim");
        var checkschema = File.new_for_path ("/usr/share/glib-2.0/schemas/org.pantheon.desktop.wingpanel-slim.gschema.xml");
        int pos = -1;

        for (int i = 0; i < wingpanel_slim.length ; i++) {
            if ( wingpanel_slim[i] == "wingpanel" || wingpanel_slim[i] == "wingpanel-slim" )
            pos = i; 
        }

        if (checkschema.query_exists() && checkslim.query_exists() && pos != -1){

            /* Wingpanel Position */
            var slim_pos_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var slim_pos = new Gtk.ComboBoxText ();
            var slim_label = new LLabel.right (_("Position:"));
            slim_pos.append ("Right", _("Right"));
            slim_pos.append ("Middle", _("Middle"));
            slim_pos.append ("Left", _("Left"));

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

            if ( wingpanel_slim[pos] == "wingpanel-slim" )
                wingpanel.set_active(true);

            wingpanel.notify["active"].connect (() => {
                slim_label.set_sensitive(wingpanel.active);
                slim_pos_box.set_sensitive(wingpanel.active);
                (wingpanel.active)?wingpanel_slim[pos] = "killall wingpanel":wingpanel_slim[pos] = "killall wingpanel-slim";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
                (wingpanel.active)?wingpanel_slim[pos] = "wingpanel-slim":wingpanel_slim[pos] = "wingpanel";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            });

            wingpanel.halign = Gtk.Align.START;
            this.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 6, 2, 1);
            this.attach (wingpanel, 2, 6, 2, 1);

        } else if (!checkslim.query_exists() && wingpanel_slim[pos] == "wingpanel-slim") {
            wingpanel_slim[pos] = "killall wingpanel";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            wingpanel_slim[pos] = "wingpanel";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            this.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 6, 2, 1);
            this.attach (new LLabel.left_with_markup (("<span color=\"#FF0000\">"+_("Wingpanel Slim not found. Settings have been reset!")+"</span>")), 2, 6, 2, 1);
        }
    }
}
