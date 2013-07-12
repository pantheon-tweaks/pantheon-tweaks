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
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;


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

        /* Natural Scrolling */
        var scroll = new Gtk.Switch ();
        scroll.set_active(scroll_exists ());
        scroll.notify["active"].connect (() => {
            var command = new Granite.Services.SimpleCommand("/usr/bin","xinput list --short");
            string[] output = { };
            command.run ();
            command.done.connect (() => { 
                output = command.output_str.split ("\n");
                foreach (string str in output) {
                    if (str.contains("id=") && str.contains("pointer") && str.contains ("slave") && !str.contains ("XTEST")) {
                        int index = str.index_of ("id=") + 3;
                        int pointer_id = int.parse(str.substring (index, str.index_of ("\t", index) - index));

                        var command_map = new Granite.Services.SimpleCommand("/usr/bin","xinput get-button-map " + pointer_id.to_string());
                        command_map.run ();
                        command_map.done.connect (() => { 
                            string current_mapping = command_map.output_str.replace("\n","");
                            if (current_mapping.contains("4 5 6 7"))
                                current_mapping = current_mapping.replace("4 5 6 7","5 4 7 6");
                            else
                                current_mapping = current_mapping.replace("5 4 7 6","4 5 6 7");
                            var command_change = new Granite.Services.SimpleCommand("/usr/bin","xinput set-button-map " + pointer_id.to_string() + " " + current_mapping);
                            command_change.run ();
                            command_change.done.connect (() => scroll_switch (current_mapping));
                        });
                    }
                }
            });
        });
        scroll.halign = Gtk.Align.START;


        this.attach (new LLabel.right (_("Audible Bell:")), 0, 0, 1, 1);
        this.attach (audible_bell, 1, 0, 1, 1);

        this.attach (new LLabel.right (_("Overlay Scrollbars:")), 0, 1, 1, 1);
        this.attach (overlay_scrollbar, 1, 1, 1, 1);

        this.attach (new LLabel.right (_("Natural Scrolling:")), 0, 2, 1, 1);
        this.attach (scroll, 1, 2, 1, 1);
    }
}

public void scroll_switch (string mapping) {
    try {
        var file = File.new_for_path ("/home/" + Environment.get_user_name () + "/.Xmodmap");
        if (!file.query_exists ()) {
            var file_stream = file.create (FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string ("pointer = " + mapping);
        } else {
            file.delete ();
        }
    } catch (GLib.FileError e){
                warning (e.message);
    }
}

public bool scroll_exists () {
        try {
            var file = File.new_for_path ("/home/" + Environment.get_user_name () + "/.Xmodmap");
            return (file.query_exists ());
        } catch (GLib.FileError e){
            warning (e.message);
        }
    }
