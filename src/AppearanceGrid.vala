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

public class AppearanceGrid : Gtk.Grid
{
    public AppearanceGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin = 24;
        this.column_homogeneous = true;

        /* Window Decoration and Interface Themes */
        var themes_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var ui_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var themes = new Gtk.ComboBoxText ();
        var ui = new Gtk.ComboBoxText ();
        var duplicate_themes = ":";

        try {
            var enumerator = File.new_for_path ("/usr/share/themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/usr/share/themes/" + name + "/gtk-3.0");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default") {
                    themes.append (file_info.get_name (), name);
                    duplicate_themes += name + ":";
                }
            }
        } catch (Error e) { warning (e.message); }

        try {
        var enumerator = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
        FileInfo file_info;
        while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/" + name + "/gtk-3.0");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default" && duplicate_themes.contains(name) == false)
                    themes.append (file_info.get_name (), name);
            }
        } catch (Error e) { warning (e.message); }

        themes.active_id = WindowSettings.get_default ().theme;
        themes.changed.connect (() => WindowSettings.get_default ().theme = themes.active_id );
        themes.halign = Gtk.Align.START;
        themes.width_request = 160;

        var themes_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        themes_default.clicked.connect (() => {
            WindowSettings.get_default ().schema.reset ("theme");
            themes.active_id = WindowSettings.get_default ().theme;
        });

        themes_default.halign = Gtk.Align.START;

        themes_box.pack_start (themes, false);
        themes_box.pack_start (themes_default, false);

        ui.model = themes.model;
        ui.halign = Gtk.Align.START;
        ui.active_id = InterfaceSettings.get_default ().gtk_theme;
        ui.changed.connect (() => InterfaceSettings.get_default ().gtk_theme = ui.active_id );
        ui.width_request = 160;

        var ui_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        ui_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("gtk-theme");
            ui.active_id = InterfaceSettings.get_default ().gtk_theme;
        });
        ui_default.halign = Gtk.Align.START;

        ui_box.pack_start (ui, false);
        ui_box.pack_start (ui_default, false);

        /* Icon Themes */
        var icon_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var icon_theme = new Gtk.ComboBoxText ();
        var duplicate_icons = ":";
        try {
        var enumerator = File.new_for_path ("/usr/share/icons/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
               var checktheme = File.new_for_path ("/usr/share/icons/" + name + "/apps");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default") {
                    duplicate_icons += name + ":";
                    icon_theme.append (file_info.get_name (), name);
                }
            }
        } catch (Error e) { warning (e.message); }

        try {
            var enumerator = File.new_for_path ("/home/" + Environment.get_user_name () + "/.icons/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/home/" + Environment.get_user_name () + "/.icons/" + name + "/apps");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default" && duplicate_icons.contains(name) == false)
                    icon_theme.append (file_info.get_name (), name);
            }
        } catch (Error e) { warning (e.message); }

        icon_theme.halign = Gtk.Align.START;
        icon_theme.active_id = InterfaceSettings.get_default ().icon_theme;
        icon_theme.changed.connect (() => InterfaceSettings.get_default ().icon_theme = icon_theme.active_id );
        icon_theme.width_request = 160;

        var icon_theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        icon_theme_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("icon-theme");
            icon_theme.active_id = InterfaceSettings.get_default ().icon_theme;
        });
        icon_theme_default.halign = Gtk.Align.START;

        icon_theme_box.pack_start (icon_theme, false);
        icon_theme_box.pack_start (icon_theme_default, false);

        /* Cursor Themes */
        var cursor_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var cursor_theme = new Gtk.ComboBoxText ();
        try {
            var enumerator = File.new_for_path ("/usr/share/icons/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/usr/share/icons/" + name + "/cursors");
                if (checktheme.query_exists())
                    cursor_theme.append (file_info.get_name (), name);
            }
        } catch (Error e) { warning (e.message); }


        cursor_theme.halign = Gtk.Align.START;
        cursor_theme.active_id = InterfaceSettings.get_default ().cursor_theme;
        cursor_theme.changed.connect (() => InterfaceSettings.get_default ().cursor_theme = cursor_theme.active_id );
        cursor_theme.width_request = 160;

        var cursor_theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        cursor_theme_default.clicked.connect (() => {
            InterfaceSettings.get_default ().schema.reset ("cursor-theme");
            cursor_theme.active_id = InterfaceSettings.get_default ().cursor_theme;
        });
        cursor_theme_default.halign = Gtk.Align.START;

        cursor_theme_box.pack_start (cursor_theme, false);
        cursor_theme_box.pack_start (cursor_theme_default, false);

        /* Button Layout */
        var button_layout_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var button_layout = new Gtk.ComboBoxText ();
        button_layout.append ("close:maximize", ("elementary"));
        button_layout.append ("close,minimize:maximize", _("Minimize Left"));
        button_layout.append ("close:minimize,maximize", _("Minimize Right"));
        button_layout.append (":minimize,maximize,close", _("Windows"));
        button_layout.append ("close,maximize,minimize:", _("OS X"));

        button_layout.active_id = AppearanceSettings.get_default ().button_layout;
        button_layout.changed.connect (() => AppearanceSettings.get_default ().button_layout = button_layout.active_id );
        button_layout.halign = Gtk.Align.START;
        button_layout.width_request = 160;

        var button_layout_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        button_layout_default.clicked.connect (() => {
            AppearanceSettings.get_default ().schema.reset ("button-layout");
            button_layout.active_id = AppearanceSettings.get_default ().button_layout;
        });
        button_layout_default.halign = Gtk.Align.START;

        button_layout_box.pack_start (button_layout, false);
        button_layout_box.pack_start (button_layout_default, false);


        /* Wingpanel Slim */
        var wingpanel = new Gtk.Switch ();
        var wingpanel_slim = CerbereSettings.get_default ().monitored_processes;
        var checkslim = File.new_for_path ("/usr/bin/wingpanel-slim");
        int pos = -1;

        for (int i = 0; i < wingpanel_slim.length ; i++) {
            if ( wingpanel_slim[i] == "wingpanel" || wingpanel_slim[i] == "wingpanel-slim" )
            pos = i; 
        }

        if (checkslim.query_exists() && pos != -1){

            if ( wingpanel_slim[pos] == "wingpanel-slim" )
                wingpanel.set_active(true);

            wingpanel.notify["active"].connect (() => {
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

        /* Add to Grid */
        this.attach (new LLabel.right (_("Window Decoration Theme:")), 0, 1, 2, 1);
        this.attach (themes_box, 2, 1, 2, 1);

        this.attach (new LLabel.right (_("Interface Theme:")), 0, 2, 2, 1);
        this.attach (ui_box, 2, 2, 2, 1);

        this.attach (new LLabel.right (_("Icon Theme:")), 0, 3, 2, 1);
        this.attach (icon_theme_box, 2, 3, 2, 1);

        this.attach (new LLabel.right (_("Cursor Theme:")), 0, 4, 2, 1);
        this.attach (cursor_theme_box, 2, 4, 2, 1);

        this.attach (new LLabel.right (_("Button Layout:")), 0, 5, 2, 1);
        this.attach (button_layout_box, 2, 5, 2, 1);
    }
}
