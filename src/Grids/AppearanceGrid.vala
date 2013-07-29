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
        this.margin_top = 24;
        this.column_homogeneous = true;

        /* Window Decoration */
        var themes_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var themes = new Gtk.ComboBoxText ();
        var duplicate_themes = ":"; // FIXME: Use StringBuilder

        try {
        var enumerator = File.new_for_path ("/usr/share/themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
               var checktheme = File.new_for_path ("/usr/share/themes/" + name + "/metacity-1");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default") {
                    duplicate_themes += name + ":";
                    themes.append (file_info.get_name (), name);
                }
            }
        } catch (Error e) { warning (e.message); }

        try {
        var enumerator = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
        FileInfo file_info;
        while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/" + name + "/metacity-1");
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

        /* Interface Themes */
        var ui_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var ui = new Gtk.ComboBoxText ();
        var duplicate_ui = ":"; // FIXME: Use StringBuilder

        try {
        var enumerator = File.new_for_path ("/usr/share/themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
               var checktheme = File.new_for_path ("/usr/share/themes/" + name + "/gtk-3.0");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default") {
                    duplicate_ui += name + ":";
                    ui.append (file_info.get_name (), name);
                }
            }
        } catch (Error e) { warning (e.message); }

        try {
        var enumerator = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
        FileInfo file_info;
        while ((file_info = enumerator.next_file ()) != null) {
            var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/home/" + Environment.get_user_name () + "/.themes/" + name + "/gtk-3.0");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default" && duplicate_ui.contains(name) == false)
                    ui.append (file_info.get_name (), name);
            }
        } catch (Error e) { warning (e.message); }

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
        var duplicate_icons = ":"; // FIXME: Use StringBuilder

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
        var custom_layout_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var custom_layout = new Gtk.Entry();
        var custom_text = new LLabel.right (_("Custom Layout:"));

        button_layout.append ("close:maximize", ("elementary"));
        button_layout.append (":close", _("Close Only"));
        button_layout.append ("close,minimize:maximize", _("Minimize Left"));
        button_layout.append ("close:minimize,maximize", _("Minimize Right"));
        button_layout.append (":minimize,maximize,close", _("Windows"));
        button_layout.append ("close,minimize,maximize:", _("OS X"));
        button_layout.append ("custom", _("Custom"));

        if ( AppearanceSettings.get_default ().button_layout == "close:maximize" ||
             AppearanceSettings.get_default ().button_layout == ":close" ||
             AppearanceSettings.get_default ().button_layout == "close,minimize:maximize" ||
             AppearanceSettings.get_default ().button_layout == "close:minimize,maximize" ||
             AppearanceSettings.get_default ().button_layout == ":minimize,maximize,close" ||
             AppearanceSettings.get_default ().button_layout == "close,minimize,maximize:")
                button_layout.active_id = AppearanceSettings.get_default ().button_layout;
        else
                button_layout.active_id = "custom";

        custom_layout.text = AppearanceSettings.get_default ().button_layout;

        if ( button_layout.active_id == "custom" ) {
            custom_layout_box.set_sensitive(true);
            custom_text.set_sensitive(true);
        } else {
            custom_layout_box.set_sensitive(false);
            custom_text.set_sensitive(false);
        }

        button_layout.changed.connect (() => {
            if ( button_layout.active_id == "custom" ) {
                custom_layout_box.set_sensitive(true);
                custom_text.set_sensitive(true);
            } else {
                custom_layout_box.set_sensitive(false);
                custom_text.set_sensitive(false);
                AppearanceSettings.get_default ().button_layout = button_layout.active_id;
                custom_layout.text = AppearanceSettings.get_default ().button_layout;
            }
        });
        button_layout.halign = Gtk.Align.START;
        button_layout.width_request = 160;

        custom_layout.activate.connect (() => AppearanceSettings.get_default ().button_layout = custom_layout.text);
        custom_layout.halign = Gtk.Align.START;
        custom_layout.width_request = 160;

        var button_layout_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        button_layout_default.clicked.connect (() => {
            AppearanceSettings.get_default ().schema.reset ("button-layout");
            button_layout.active_id = AppearanceSettings.get_default ().button_layout;
        });
        button_layout_default.halign = Gtk.Align.START;

        button_layout_box.pack_start (button_layout, false);
        button_layout_box.pack_start (button_layout_default, false);

        var custom_layout_apply = new Gtk.ToolButton.from_stock (Gtk.Stock.APPLY);
        custom_layout_apply.clicked.connect (() => AppearanceSettings.get_default ().button_layout = custom_layout.text);

        custom_layout_box.pack_start (custom_layout, false);
        custom_layout_box.pack_start (custom_layout_apply, false);


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

        this.attach (custom_text, 0, 6, 2, 1);
        this.attach (custom_layout_box, 2, 6, 2, 1);

    }
}
