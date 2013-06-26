//  
//  Copyright (C) 2013 Michael Langfermann, Tom Beckmann
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

class LLabel : Gtk.Label
{
    public LLabel (string label)
    {
        this.set_halign (Gtk.Align.START);
        this.label = label;
    }
    public LLabel.indent (string label) 
    {
        this (label);
        this.margin_left = 10;
    }
    public LLabel.markup (string label) 
    {
        this (label);
        this.use_markup = true;
    }
    public LLabel.right (string label) 
    {
        this.set_halign (Gtk.Align.END);
        this.label = label;
    }
    public LLabel.right_with_markup (string label)
    {
        this.set_halign (Gtk.Align.END);
        this.use_markup = true;
        this.label = label;
    }
    public LLabel.left (string label) 
    {
        this.set_halign (Gtk.Align.START);
        this.label = label;
    }
    public LLabel.left_with_markup (string label)
    {
        this.set_halign (Gtk.Align.START);
        this.use_markup = true;
        this.label = label;
    }
    public LLabel.center (string label) 
    {
        this.set_halign (Gtk.Align.CENTER);
        this.label = label;
    }
    public LLabel.center_with_markup (string label)
    {
        this.set_halign (Gtk.Align.CENTER);
        this.use_markup = true;
        this.label = label;
    }
}

public class GalaPlug : Pantheon.Switchboard.Plug
{
    
    public GalaPlug ()
    {
        
        var notebook = new Granite.Widgets.StaticNotebook (false);
        notebook.set_margin_top (12);        

        /* Appearances Tab */
        var app_grid = new Gtk.Grid ();

        app_grid.row_spacing = 6;
        app_grid.column_spacing = 12;
        app_grid.margin = 24;
        app_grid.column_homogeneous = true;

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
            WindowSettings.get_default ().theme = "elementary";
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
            InterfaceSettings.get_default ().gtk_theme = "elementary";
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
            InterfaceSettings.get_default ().icon_theme = "elementary";
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
            InterfaceSettings.get_default ().cursor_theme = "DMZ-Black";
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
            AppearanceSettings.get_default ().button_layout = "close:maximize";
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
                wingpanel_slim[pos] = "killall wingpanel";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
                (wingpanel.active)?wingpanel_slim[pos] = "wingpanel-slim":wingpanel_slim[pos] = "wingpanel";
                CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            });

            wingpanel.halign = Gtk.Align.START;
            app_grid.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 6, 2, 1);
            app_grid.attach (wingpanel, 2, 6, 2, 1);
           
        } else if (!checkslim.query_exists() && wingpanel_slim[pos] == "wingpanel-slim") {
            wingpanel_slim[pos] = "killall wingpanel";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            wingpanel_slim[pos] = "wingpanel";
            CerbereSettings.get_default ().monitored_processes = wingpanel_slim;
            app_grid.attach (new LLabel.right (_("Slim Wingpanel:")), 0, 6, 2, 1);
            app_grid.attach (new LLabel.left_with_markup (("<span color=\"#FF0000\">"+_("Wingpanel Slim not found. Settings have been reset!")+"</span>")), 2, 6, 2, 1);
        }

        /* Add to Grid */
        app_grid.attach (new LLabel.right (_("Window Decoration Theme:")), 0, 1, 2, 1);
        app_grid.attach (themes_box, 2, 1, 2, 1);

        app_grid.attach (new LLabel.right (_("Interface Theme:")), 0, 2, 2, 1);
        app_grid.attach (ui_box, 2, 2, 2, 1);

        app_grid.attach (new LLabel.right (_("Icon Theme:")), 0, 3, 2, 1);
        app_grid.attach (icon_theme_box, 2, 3, 2, 1);

        app_grid.attach (new LLabel.right (_("Cursor Theme:")), 0, 4, 2, 1);
        app_grid.attach (cursor_theme_box, 2, 4, 2, 1);

        app_grid.attach (new LLabel.right (_("Button Layout:")), 0, 5, 2, 1);
        app_grid.attach (button_layout_box, 2, 5, 2, 1);

        notebook.append_page (app_grid, new Gtk.Label (_("Appearance")));


        /* Font Tab*/
        var font_grid = new Gtk.Grid ();
        font_grid.column_spacing = 12;
        font_grid.row_spacing = 6;
        font_grid.margin = 24;
        font_grid.column_homogeneous = true;

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

        font_grid.attach (new LLabel.right (_("Default Font:")), 1, 0, 1, 1);
        font_grid.attach (default_font_box, 2, 0, 1, 1);

        font_grid.attach (new LLabel.right (_("Document Font:")), 1, 1, 1, 1);
        font_grid.attach (document_font_box, 2, 1, 1, 1);

        font_grid.attach (new LLabel.right (_("Monospace Font:")), 1, 2, 1, 1);
        font_grid.attach (mono_font_box, 2, 2, 1, 1);

        font_grid.attach (new LLabel.right (_("Window Title Font:")), 1, 3, 1, 1);
        font_grid.attach (window_font_box, 2, 3, 1, 1);

        notebook.append_page (font_grid, new Gtk.Label (_("Fonts")));



        /* Animations Tab */
        var anim_grid = new Gtk.Grid ();
        anim_grid.column_homogeneous = true;
        anim_grid.column_spacing = 12;
        anim_grid.margin = 24;


        var open_dur_label = new LLabel.right (_("Open Duration:"));
        var close_dur_label = new LLabel.right (_("Close Duration:"));
        var snap_dur_label = new LLabel.right (_("Snap Duration:"));
        var mini_dur_label = new LLabel.right (_("Minimize Duration:"));
        var work_dur_label = new LLabel.right (_("Workspace Switch Duration:"));

        var open_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var open_dur = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1,2000, 10);
        var open_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        open_dur.set_value (AnimationSettings.get_default ().open_duration);
        open_dur.value_changed.connect (() => {
            AnimationSettings.get_default ().open_duration = (int)open_dur.get_value ();
            open_dur_spin.set_value (open_dur.get_value ());
        });

        open_dur.width_request = 150;
        open_dur_spin.set_value (AnimationSettings.get_default ().open_duration);
        open_dur_spin.value_changed.connect (() => {
            AnimationSettings.get_default ().open_duration = (int)open_dur_spin.get_value ();
            open_dur.set_value (open_dur_spin.get_value ());
        });

        var open_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        open_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("open-duration");
            open_dur.set_value (AnimationSettings.get_default ().open_duration);
        });

        open_dur_box.pack_start (open_dur, false);
        open_dur_box.pack_start (open_dur_spin, false);
        open_dur_box.pack_start (open_dur_default, false);


        var close_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var close_dur = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 2000, 10);
        var close_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);
        close_dur.set_value (AnimationSettings.get_default ().close_duration);
        close_dur.value_changed.connect (() => {
            AnimationSettings.get_default ().close_duration = (int)close_dur.get_value ();
            close_dur_spin.set_value (close_dur.get_value ());
        });
        close_dur.width_request = 150;
        close_dur_spin.set_value (AnimationSettings.get_default ().close_duration);
        close_dur_spin.value_changed.connect (() => {
            AnimationSettings.get_default ().close_duration = (int)close_dur_spin.get_value ();
            close_dur.set_value (close_dur_spin.get_value ());
        });
        var close_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        close_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("close-duration");
            close_dur.set_value (AnimationSettings.get_default ().close_duration);
        });
        close_dur_box.pack_start (close_dur, false);
        close_dur_box.pack_start (close_dur_spin, false);
        close_dur_box.pack_start (close_dur_default, false);

        var snap_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var snap_dur = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 2000, 10);
        var snap_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);
        snap_dur.set_value (AnimationSettings.get_default ().snap_duration);
        snap_dur.value_changed.connect (() => {
            AnimationSettings.get_default ().snap_duration = (int)snap_dur.get_value ();
            snap_dur_spin.set_value (snap_dur.get_value ());
        });
        snap_dur.width_request = 150;
        snap_dur_spin.set_value (AnimationSettings.get_default ().snap_duration);
        snap_dur_spin.value_changed.connect (() => {
            AnimationSettings.get_default ().snap_duration = (int)snap_dur_spin.get_value ();
            snap_dur.set_value (snap_dur_spin.get_value ());
        });
        var snap_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        snap_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("snap-duration");
            snap_dur.set_value (AnimationSettings.get_default ().snap_duration);
        });
        snap_dur_box.pack_start (snap_dur, false);
        snap_dur_box.pack_start (snap_dur_spin, false);
        snap_dur_box.pack_start (snap_dur_default, false);

        var mini_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var mini_dur = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 2000, 10);
        var mini_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);
        mini_dur.set_value (AnimationSettings.get_default ().minimize_duration);
        mini_dur.value_changed.connect (() => {
            AnimationSettings.get_default ().minimize_duration = (int)mini_dur.get_value ();
            mini_dur_spin.set_value (mini_dur.get_value ());
        });
        mini_dur.width_request = 150;
        mini_dur_spin.set_value (AnimationSettings.get_default ().minimize_duration);
        mini_dur_spin.value_changed.connect (() => {
            AnimationSettings.get_default ().minimize_duration = (int)mini_dur_spin.get_value ();
            mini_dur.set_value (mini_dur_spin.get_value ());
        });
        var mini_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        mini_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("minimize-duration");
            mini_dur.set_value (AnimationSettings.get_default ().minimize_duration);
        });
        mini_dur_box.pack_start (mini_dur, false);
        mini_dur_box.pack_start (mini_dur_spin, false);
        mini_dur_box.pack_start (mini_dur_default, false);
        
        var work_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var work_dur = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 2000, 10);
        var work_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);
        work_dur.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        work_dur.value_changed.connect (() => {
            AnimationSettings.get_default ().workspace_switch_duration = (int)work_dur.get_value ();
            work_dur_spin.set_value (work_dur.get_value ());
        });
        work_dur.width_request = 150;
        work_dur_spin.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        work_dur_spin.value_changed.connect (() => {
            AnimationSettings.get_default ().workspace_switch_duration = (int)work_dur_spin.get_value ();
            work_dur.set_value (work_dur_spin.get_value ());
        });
        var work_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        work_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("workspace-switch-duration");
            work_dur.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        });
        work_dur_box.pack_start (work_dur, false);
        work_dur_box.pack_start (work_dur_spin, false);
        work_dur_box.pack_start (work_dur_default, false);
        
        /* Animation Switch */
        var enable_anim = new Gtk.Switch ();
        enable_anim.notify["active"].connect (() => {
            open_dur_box.sensitive = enable_anim.active;
            close_dur_box.sensitive = enable_anim.active;
            snap_dur_box.sensitive = enable_anim.active;
            mini_dur_box.sensitive = enable_anim.active;
            work_dur_box.sensitive = enable_anim.active;
            open_dur_label.sensitive = enable_anim.active;
            close_dur_label.sensitive = enable_anim.active;
            snap_dur_label.sensitive = enable_anim.active;
            mini_dur_label.sensitive = enable_anim.active;
            work_dur_label.sensitive = enable_anim.active;
            AnimationSettings.get_default ().enable_animations = enable_anim.active;
        });
        
        enable_anim.active = AnimationSettings.get_default ().enable_animations;

        open_dur_box.sensitive = enable_anim.active;
        close_dur_box.sensitive = enable_anim.active;
        snap_dur_box.sensitive = enable_anim.active;
        mini_dur_box.sensitive = enable_anim.active;
        work_dur_box.sensitive = enable_anim.active;
        open_dur_label.sensitive = enable_anim.active;
        close_dur_label.sensitive = enable_anim.active;
        snap_dur_label.sensitive = enable_anim.active;
        mini_dur_label.sensitive = enable_anim.active;
        work_dur_label.sensitive = enable_anim.active;

        enable_anim.halign = Gtk.Align.START;

        /* Attach to grid */
        anim_grid.attach (new LLabel.right_with_markup (("<span weight=\"bold\">"+_("Animations:")+"</span>")), 0, 0, 1, 1);
        anim_grid.attach (enable_anim, 1, 0, 1, 1);
        anim_grid.attach (open_dur_label, 0, 1, 1, 1);
        anim_grid.attach (open_dur_box, 1, 1, 1, 1);
        anim_grid.attach (close_dur_label, 0, 2, 1, 1);
        anim_grid.attach (close_dur_box, 1, 2, 1, 1);
        anim_grid.attach (snap_dur_label, 0, 3, 1, 1);
        anim_grid.attach (snap_dur_box, 1, 3, 1, 1);
        anim_grid.attach (mini_dur_label, 0, 4, 1, 1);
        anim_grid.attach (mini_dur_box, 1, 4, 1, 1);
        anim_grid.attach (work_dur_label, 0, 5, 1, 1);
        anim_grid.attach (work_dur_box, 1, 5, 1, 1);
        
        notebook.append_page (anim_grid, new Gtk.Label (_("Animations")));


        /* Shadows*/
        var sha_grid = new Gtk.Grid ();
        sha_grid.column_homogeneous = true;
        sha_grid.column_spacing = 12;
        sha_grid.margin = 24;

        var shadow_scheme = new Settings ("org.pantheon.desktop.gala.shadows");
        var shadow_focused_label = new LLabel.right (_("Focused Windows:"));
        var shadow_unfocused_label = new LLabel.right (_("Unfocused Windows:"));
        var shadow_dfocused_label = new LLabel.right (_("Focused Dialogs:"));
        var shadow_undfocused_label = new LLabel.right (_("Unfocused Dialogs:"));
        var shadow_menu_label = new LLabel.right (_("Menu:"));

        /* Focused Windows */
        var shadow_focused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_focused = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 200, 10);    
        var radius_focused_spin = new Gtk.SpinButton.with_range (0, 200, 1);        
        var shadows_focused = ShadowSettings.get_default ().normal_focused;
        
        radius_focused.set_value(int.parse (shadows_focused[0]));
        radius_focused.value_changed.connect (() => {
            shadows_focused[0] = ((int)radius_focused.get_value()).to_string ();
            shadows_focused[3] = Math.round( double.parse(shadows_focused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_focused = shadows_focused;
            radius_focused_spin.value = int.parse (shadows_focused[0]);
        });
        radius_focused.width_request = 150;

        radius_focused_spin.value = int.parse (shadows_focused[0]);        
        radius_focused_spin.value_changed.connect (() => {
            shadows_focused[0] = ((int)radius_focused_spin.value).to_string ();
            shadows_focused[3] = Math.round( double.parse(shadows_focused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_focused = shadows_focused;
            radius_focused.set_value(int.parse (shadows_focused[0]));
        });

        var focused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        focused_default.clicked.connect (() => {
            shadow_scheme.reset ("normal-focused");
            shadows_focused = ShadowSettings.get_default ().normal_focused;
            radius_focused.set_value(int.parse (shadows_focused[0]));
        });
        focused_default.halign = Gtk.Align.START;

        
        shadow_focused_box.pack_start (radius_focused, false);
        shadow_focused_box.pack_start (radius_focused_spin, false);
        shadow_focused_box.pack_start (focused_default, false);

        /* Unfocused Windows */
        var shadow_unfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_unfocused = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 200, 10);
        var radius_unfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_unfocused = ShadowSettings.get_default ().normal_unfocused;
        
        radius_unfocused.set_value(int.parse (shadows_unfocused[0]));
        radius_unfocused.value_changed.connect (() => {
            shadows_unfocused[0] = ((int)radius_unfocused.get_value()).to_string ();
            shadows_unfocused[3] = Math.round( double.parse(shadows_unfocused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_unfocused = shadows_unfocused;
            radius_unfocused_spin.value = int.parse (shadows_unfocused[0]);
        });
        radius_unfocused.width_request = 150;

        radius_unfocused_spin.value = int.parse (shadows_unfocused[0]);
        radius_unfocused_spin.value_changed.connect (() => {
            shadows_unfocused[0] = ((int)radius_unfocused_spin.value).to_string ();
            shadows_unfocused[3] = Math.round( double.parse(shadows_unfocused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_unfocused = shadows_unfocused;
            radius_unfocused.set_value(int.parse (shadows_unfocused[0]));
        });

        var unfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        unfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("normal-unfocused");
            shadows_unfocused = ShadowSettings.get_default ().normal_unfocused;
            radius_unfocused.set_value(int.parse (shadows_unfocused[0]));
        });
        unfocused_default.halign = Gtk.Align.START;

        
        shadow_unfocused_box.pack_start (radius_unfocused, false);
        shadow_unfocused_box.pack_start (radius_unfocused_spin, false);
        shadow_unfocused_box.pack_start (unfocused_default, false);

        /* Focused Dialoges */
        var shadow_dfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_dfocused = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 200, 10);
        var radius_dfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_dfocused = ShadowSettings.get_default ().dialog_focused;
        
        radius_dfocused.set_value(int.parse (shadows_dfocused[0]));
        radius_dfocused.value_changed.connect (() => {
            shadows_dfocused[0] = ((int)radius_dfocused.get_value()).to_string ();
            shadows_dfocused[3] = Math.round( double.parse(shadows_dfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_focused = shadows_dfocused;
            radius_dfocused_spin.value = int.parse (shadows_dfocused[0]);
        });
        radius_dfocused.width_request = 150;

        radius_dfocused_spin.value = int.parse (shadows_dfocused[0]);
        radius_dfocused_spin.value_changed.connect (() => {
            shadows_dfocused[0] = ((int)radius_dfocused_spin.value).to_string ();
            shadows_dfocused[3] = Math.round( double.parse(shadows_dfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_focused = shadows_dfocused;
            radius_dfocused.set_value(int.parse (shadows_dfocused[0]));
        });

        var dfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        dfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("dialog-focused");
            shadows_dfocused = ShadowSettings.get_default ().dialog_focused;
              radius_dfocused.set_value(int.parse (shadows_dfocused[0]));
        });
        dfocused_default.halign = Gtk.Align.START;

        
        shadow_dfocused_box.pack_start (radius_dfocused, false);
        shadow_dfocused_box.pack_start (radius_dfocused_spin, false);
        shadow_dfocused_box.pack_start (dfocused_default, false);

        /* Unfocused Dialoges */
        var shadow_undfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_undfocused = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 200, 10);
        var radius_undfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_undfocused = ShadowSettings.get_default ().dialog_unfocused;
        
        radius_undfocused.set_value(int.parse (shadows_undfocused[0]));
        radius_undfocused.value_changed.connect (() => {
            shadows_undfocused[0] = ((int)radius_undfocused.get_value()).to_string ();
            shadows_undfocused[3] = Math.round( double.parse(shadows_undfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_unfocused = shadows_undfocused;
            radius_undfocused_spin.value = int.parse (shadows_undfocused[0]);
        });
        radius_undfocused.width_request = 150;

        radius_undfocused_spin.value = int.parse (shadows_undfocused[0]);
        radius_undfocused_spin.value_changed.connect (() => {
            shadows_undfocused[0] = ((int)radius_undfocused_spin.value).to_string ();
            shadows_undfocused[3] = Math.round( double.parse(shadows_undfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_unfocused = shadows_undfocused;
            radius_undfocused.set_value(int.parse (shadows_undfocused[0]));
        });

        var undfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        undfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("dialog-unfocused");
            shadows_undfocused = ShadowSettings.get_default ().dialog_unfocused;
            radius_undfocused.set_value(int.parse (shadows_undfocused[0]));
        });
        undfocused_default.halign = Gtk.Align.START;

        
        shadow_undfocused_box.pack_start (radius_undfocused, false);
        shadow_undfocused_box.pack_start (radius_undfocused_spin, false);
        shadow_undfocused_box.pack_start (undfocused_default, false);

        /* Menu */
        var shadow_menu_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_menu = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 200, 10);
        var radius_menu_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_menu = ShadowSettings.get_default ().menu;
        
        radius_menu.set_value(int.parse (shadows_menu[0]));
        radius_menu.value_changed.connect (() => {
            shadows_menu[0] = ((int)radius_menu.get_value()).to_string ();
            shadows_menu[3] = Math.round( double.parse(shadows_menu[0]) * 0.7).to_string();
            ShadowSettings.get_default ().menu = shadows_menu;
            radius_menu_spin.value = int.parse (shadows_menu[0]);
        });
        radius_menu.width_request = 150;

        radius_menu_spin.value = int.parse (shadows_menu[0]);
        radius_menu_spin.value_changed.connect (() => {
            shadows_menu[0] = ((int)radius_menu_spin.value).to_string ();
            shadows_menu[3] = Math.round( double.parse(shadows_menu[0]) * 0.7).to_string();
            ShadowSettings.get_default ().menu = shadows_menu;
            radius_menu.set_value(int.parse (shadows_menu[0]));
        });

        var menu_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        menu_default.clicked.connect (() => {
            shadow_scheme.reset ("menu");
            shadows_menu = ShadowSettings.get_default ().menu;
              radius_menu.set_value(int.parse (shadows_menu[0]));
        });
        menu_default.halign = Gtk.Align.START;

        
        shadow_menu_box.pack_start (radius_menu, false);
        shadow_menu_box.pack_start (radius_menu_spin, false);
        shadow_menu_box.pack_start (menu_default, false);

        /* Shadow Switch */
        var enable_shadows = new Gtk.Switch ();
        enable_shadows.notify["active"].connect (() => {
            (enable_shadows.active)?shadows_focused[4] = "220":shadows_focused[4] = "0";
            ShadowSettings.get_default ().normal_focused = shadows_focused;
            (enable_shadows.active)?shadows_unfocused[4] = "150":shadows_unfocused[4] = "0";
            ShadowSettings.get_default ().normal_unfocused = shadows_unfocused;
            (enable_shadows.active)?shadows_dfocused[4] = "190":shadows_dfocused[4] = "0";
            ShadowSettings.get_default ().dialog_focused = shadows_dfocused;
            (enable_shadows.active)?shadows_undfocused[4] = "130":shadows_undfocused[4] = "0";
            ShadowSettings.get_default ().dialog_unfocused = shadows_undfocused;
            (enable_shadows.active)?shadows_menu[4] = "130":shadows_menu[4] = "0";
            ShadowSettings.get_default ().menu = shadows_menu;
            shadow_focused_box.sensitive = enable_shadows.active;
            shadow_focused_label.sensitive = enable_shadows.active;
            shadow_unfocused_box.sensitive = enable_shadows.active;
            shadow_unfocused_label.sensitive = enable_shadows.active;
            shadow_dfocused_box.sensitive = enable_shadows.active;
            shadow_dfocused_label.sensitive = enable_shadows.active;
            shadow_undfocused_box.sensitive = enable_shadows.active;
            shadow_undfocused_label.sensitive = enable_shadows.active;
            shadow_menu_box.sensitive = enable_shadows.active;
            shadow_menu_label.sensitive = enable_shadows.active;
        });
        enable_shadows.halign = Gtk.Align.START;
        shadow_focused_box.sensitive = enable_shadows.active;
        shadow_focused_label.sensitive = enable_shadows.active;
        shadow_unfocused_box.sensitive = enable_shadows.active;
        shadow_unfocused_label.sensitive = enable_shadows.active;
        shadow_dfocused_box.sensitive = enable_shadows.active;
        shadow_dfocused_label.sensitive = enable_shadows.active;
        shadow_undfocused_box.sensitive = enable_shadows.active;
        shadow_undfocused_label.sensitive = enable_shadows.active;
        shadow_menu_box.sensitive = enable_shadows.active;
        shadow_menu_label.sensitive = enable_shadows.active;

        if ( shadows_focused[4] != "0" )
        enable_shadows.active = true;

        /* Attach to grid */
        sha_grid.attach (new LLabel.right_with_markup (("<span weight=\"bold\">"+_("Shadows:")+"</span>")), 0, 0, 1, 1);
        sha_grid.attach (enable_shadows, 1, 0, 1, 1);

        sha_grid.attach (shadow_focused_label, 0, 1, 1, 1);
        sha_grid.attach (shadow_focused_box, 1, 1, 1, 1);

        sha_grid.attach (shadow_unfocused_label, 0, 2, 1, 1);
        sha_grid.attach (shadow_unfocused_box, 1, 2, 1, 1);

        sha_grid.attach (shadow_dfocused_label, 0, 3, 1, 1);
        sha_grid.attach (shadow_dfocused_box, 1, 3, 1, 1);

        sha_grid.attach (shadow_undfocused_label, 0, 4, 1, 1);
        sha_grid.attach (shadow_undfocused_box, 1, 4, 1, 1);

        sha_grid.attach (shadow_menu_label, 0, 5, 1, 1);
        sha_grid.attach (shadow_menu_box, 1, 5, 1, 1);
        
        notebook.append_page (sha_grid, new Gtk.Label (_("Shadows")));

        
        /* Dock Tab*/
        var dock_grid = new Gtk.Grid ();
        dock_grid.column_spacing = 12;
        dock_grid.row_spacing = 6;
        dock_grid.margin = 24;
        dock_grid.column_homogeneous = true;

        /* Icon Size */
        var icon_size_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        
        Gtk.Scale icon_size_range = null;
        var icon_size = new Gtk.SpinButton.with_range (32, 96, 1);
        icon_size.set_value (PlankSettings.get_default ().icon_size);
        icon_size.value_changed.connect (() => {
            PlankSettings.get_default ().icon_size = (int)icon_size.get_value ();
            icon_size_range.set_value (icon_size.get_value ());
        });
        icon_size.halign = Gtk.Align.START;
        
        icon_size_range = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 32, 96, 1);
        icon_size_range.set_value (PlankSettings.get_default ().icon_size);
        icon_size_range.button_release_event.connect (() => {icon_size.value = icon_size_range.get_value (); return false;});
        icon_size_range.draw_value = false;
        icon_size_range.width_request = 400;
        
        icon_size_box.pack_start (icon_size_range, false);
        icon_size_box.pack_start (icon_size, false);

        /* Position */
        var label_top = _("Top");
        var label_bottom = _("Bottom");
        var label_left = _("Left");
        var label_right = _("Right");
        var label_center = _("Center");
        var label_panel = _("Panel");


        var dock_position_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var dock_position = new Gtk.ComboBoxText ();
        dock_position.append ("3", label_bottom);
        dock_position.append ("0", label_left);
        dock_position.append ("1", label_right);


        var dock_items_v = new Gtk.ComboBoxText ();
        dock_items_v.append ("3", label_center);
        dock_items_v.append ("1", label_top);
        dock_items_v.append ("2", label_bottom);

        var dock_items_h = new Gtk.ComboBoxText ();
        dock_items_h.append ("3", label_center);
        dock_items_h.append ("1", label_left);
        dock_items_h.append ("2", label_right);

        var dock_alignment_v = new Gtk.ComboBoxText ();
        dock_alignment_v.append ("3", label_center);
        dock_alignment_v.append ("1", label_bottom);
        dock_alignment_v.append ("2", label_top);
        dock_alignment_v.append ("0", label_panel);

        var dock_alignment_h = new Gtk.ComboBoxText ();
        dock_alignment_h.append ("3", label_center);
        dock_alignment_h.append ("1", label_left);
        dock_alignment_h.append ("2", label_right);
        dock_alignment_h.append ("0", label_panel);

        var dock_items = new Gtk.ComboBoxText ();
        var dock_alignment = new Gtk.ComboBoxText ();

       
        var position = PlankSettings.get_default ().dock_position;
        
        if ( position != 3 && position != 0 && position != 1 )
            position = 3;
        
        dock_position.active_id = position.to_string ();
        dock_position.changed.connect (() => {
            PlankSettings.get_default ().dock_position = int.parse (dock_position.active_id);
            if ( PlankSettings.get_default ().dock_position != 0 && PlankSettings.get_default ().dock_position != 1) {
                 dock_items.model = dock_items_h.model;
                 dock_alignment.model = dock_alignment_h.model;
            } else {
                 dock_items.model = dock_items_v.model;
                 dock_alignment.model = dock_alignment_v.model;
            }
            dock_alignment.active_id = PlankSettings.get_default ().dock_alignment.to_string ();
            dock_items.active_id = PlankSettings.get_default ().dock_items.to_string ();
            });
        dock_position.halign = Gtk.Align.START;
        dock_position.width_request = 160;

        var dock_position_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        dock_position_default.clicked.connect (() => {
            PlankSettings.get_default ().dock_position = int.parse ("3");
            dock_position.active_id = PlankSettings.get_default ().dock_position.to_string ();
        });
        dock_position_default.halign = Gtk.Align.START;

        dock_position_box.pack_start (dock_position, false);
        dock_position_box.pack_start (dock_position_default, false);

        /* Alignment */
        var dock_items_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var dock_alignment_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

        if ( PlankSettings.get_default ().dock_position != 0 && PlankSettings.get_default ().dock_position != 1) {
             dock_items.model = dock_items_h.model;
             dock_alignment.model = dock_alignment_h.model;
        } else {
             dock_items.model = dock_items_v.model;
             dock_alignment.model = dock_alignment_v.model;
        }

        var label_items = new LLabel.right (_("Item Alignment:"));

        var alignment = PlankSettings.get_default ().dock_alignment;
        
        if (alignment != 3 && alignment != 2 && alignment != 1 && alignment != 0 )
            alignment = 3;
        
        dock_alignment.active_id = alignment.to_string ();
        dock_alignment.changed.connect (() => {
            PlankSettings.get_default ().dock_alignment = int.parse (dock_alignment.active_id);
            if ( PlankSettings.get_default ().dock_alignment != 0 ) {
                dock_items_box.set_sensitive(false);
                label_items.set_sensitive(false);
            } else {
                dock_items_box.set_sensitive(true);
                label_items.set_sensitive(true);
            }
        });
        dock_alignment.halign = Gtk.Align.START;
        dock_alignment.width_request = 160;

        var dock_alignment_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        dock_alignment_default.clicked.connect (() => {
            PlankSettings.get_default ().dock_alignment = int.parse ("3");
            dock_alignment.active_id = PlankSettings.get_default ().dock_alignment.to_string ();
        });
        dock_position_default.halign = Gtk.Align.START;

        dock_alignment_box.pack_start (dock_alignment, false);
        dock_alignment_box.pack_start (dock_alignment_default, false);

        /* Item Alignment */
        var items = PlankSettings.get_default ().dock_items;

        if ( PlankSettings.get_default ().dock_alignment != 0 ) {
            dock_items_box.set_sensitive(false);
            label_items.set_sensitive(false);
        }
        
        if (alignment != 3 && alignment != 2 && alignment != 1 && alignment != 0 )
            dock_items.append (items.to_string (), _(@"Unknown Value" ));
        
        dock_items.active_id = items.to_string ();
        dock_items.changed.connect (() => PlankSettings.get_default ().dock_items = int.parse (dock_items.active_id));
        dock_items.halign = Gtk.Align.START;
        dock_items.width_request = 160;


        var dock_items_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        dock_items_default.clicked.connect (() => {
            PlankSettings.get_default ().dock_items = int.parse ("3");
            dock_items.active_id = PlankSettings.get_default ().dock_items.to_string ();
        });
        dock_items_default.halign = Gtk.Align.START;

        dock_items_box.pack_start (dock_items, false);
        dock_items_box.pack_start (dock_items_default, false);;

        /* Hide Mode */
        var hide_mode_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var hide_mode = new Gtk.ComboBoxText ();
        hide_mode.append ("0", _("Don't hide"));
        hide_mode.append ("1", _("Intelligent hide"));
        hide_mode.append ("2", _("Auto hide"));
        hide_mode.append ("3", _("Hide on maximize"));
        hide_mode.active_id = PlankSettings.get_default ().hide_mode.to_string ();
        hide_mode.changed.connect (() => PlankSettings.get_default ().hide_mode = int.parse (hide_mode.active_id));
        hide_mode.halign = Gtk.Align.START;
        hide_mode.width_request = 160;

        var hide_mode_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        hide_mode_default.clicked.connect (() => {
            PlankSettings.get_default ().hide_mode = int.parse ("3");
            hide_mode.active_id = PlankSettings.get_default ().hide_mode.to_string ();
        });
        hide_mode_default.halign = Gtk.Align.START;

        hide_mode_box.pack_start (hide_mode, false);
        hide_mode_box.pack_start (hide_mode_default, false);
        
        /* Themes */
        var theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var theme = new Gtk.ComboBoxText ();

        int default_theme = 0;
        int theme_index = 0;
        try {
            
            string name;
            var dirs = Environment.get_system_data_dirs ();
            dirs += Environment.get_user_data_dir ();

            foreach (string dir in dirs) {
                if (FileUtils.test (dir + "/plank/themes", FileTest.EXISTS)) {
                    var d = Dir.open(dir + "/plank/themes");
                    while ((name = d.read_name()) != null) {
                        theme.append(theme_index.to_string (), (name));
                        if (PlankSettings.get_default ().theme.to_string () == name)
                            theme.active = theme_index;
                        if (name == "Pantheon")
                            default_theme = theme_index;
                        theme_index++;
                    }
                }
            }
        } catch (GLib.FileError e){
            warning (e.message);
        }

        theme.changed.connect (() => PlankSettings.get_default ().theme = theme.get_active_text ());
        theme.halign = Gtk.Align.START;
        theme.width_request = 160;

        var theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        theme_default.clicked.connect (() => {
            PlankSettings.get_default ().theme = "Pantheon";
            theme.active = default_theme;
        });
        theme_default.halign = Gtk.Align.START;

        theme_box.pack_start (theme, false);
        theme_box.pack_start (theme_default, false);

       /* Workspace Overview Icon */
        var overview_icon = new Gtk.Switch ();
        overview_icon.set_active(icon_exists("gala-workspace"));
        overview_icon.notify["active"].connect (() => icon_switch("gala-workspace"));
        overview_icon.halign = Gtk.Align.START;

       /* Show Desktop Icon */
        var desktop_icon = new Gtk.Switch ();
        desktop_icon.set_active(icon_exists("show-desktop"));
        desktop_icon.notify["active"].connect (() => icon_switch("show-desktop"));
        desktop_icon.halign = Gtk.Align.START;

        /* Monitor */ 
        var monitor_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);       
        var monitor = new Gtk.ComboBoxText ();
        monitor.append ("-1", _("Primary Monitor"));
        int i = 0;
        for (i = 0; i < Gdk.Screen.get_default ().get_n_monitors () ; i ++) {
            monitor.append ( (i).to_string (), _("Monitor %d").printf (i+1) );
        }
        monitor.active_id = PlankSettings.get_default ().monitor.to_string ();
        monitor.changed.connect (() => PlankSettings.get_default ().monitor = int.parse (monitor.active_id));
        monitor.halign = Gtk.Align.START;
        monitor.width_request = 160;

        var monitor_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        monitor_default.clicked.connect (() => {
            PlankSettings.get_default ().monitor = int.parse("-1");
            monitor.active_id = "-1";
        });
        monitor_default.halign = Gtk.Align.START;

        monitor_box.pack_start (monitor, false);
        monitor_box.pack_start (monitor_default, false);;
        

        /* Add to Grid */
        dock_grid.attach (new LLabel.right (_("Icon Size:")), 0, 0, 1, 1);
        dock_grid.attach (icon_size_box, 1, 0, 3, 1);


        dock_grid.attach (new LLabel.right (_("Hide Mode:")), 0, 1, 2, 1);
        dock_grid.attach (hide_mode_box, 2, 1, 2, 1);


        if (theme_index > 1) {
            dock_grid.attach (new LLabel.right (_("Theme:")), 0, 2, 2, 1);
            dock_grid.attach (theme_box, 2, 2, 2, 1);
        }


        if (i > 1) {
            dock_grid.attach (new LLabel.right (_("Monitor:")), 0, 3, 2, 1);
            dock_grid.attach (monitor_box, 2, 3, 2, 1);
        }

        dock_grid.attach (new LLabel.right (_("Position:")), 0, 4, 2, 1);
        dock_grid.attach (dock_position_box, 2, 4, 2, 1);

        dock_grid.attach (new LLabel.right (_("Alignment:")), 0, 5, 2, 1);
        dock_grid.attach (dock_alignment_box, 2, 5, 2, 1); 

        dock_grid.attach (label_items, 0, 6, 2, 1);
        dock_grid.attach (dock_items_box, 2, 6, 2, 1);

        dock_grid.attach (new LLabel.right (_("Workspace Overview Icon:")), 0, 7, 2, 1);
        dock_grid.attach (overview_icon, 2, 7, 1, 1);

        dock_grid.attach (new LLabel.right (_("Show Desktop Icon:")), 0, 8, 2, 1);
        dock_grid.attach (desktop_icon, 2, 8, 1, 1);

        notebook.append_page (dock_grid, new Gtk.Label (_("Dock")));



        /* Misc Tab*/
        var misc_grid = new Gtk.Grid ();
        misc_grid.column_spacing = 12;
        misc_grid.row_spacing = 6;
        misc_grid.margin = 24;
        misc_grid.column_homogeneous = true;


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
        var checkschema = File.new_for_path ("/usr/lib/indicators3/7/libsynapse.so");
        var checksearch = File.new_for_path ("/usr/share/glib-2.0/schemas/net.launchpad.synapse-project.gschema.xml");

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


            misc_grid.attach (new LLabel.right (_("Search Indicator Shortcut:")), 1, 10, 1, 1);
            misc_grid.attach (search_entry_box, 2, 10, 2, 1);
        }


        /* Spacer */
        var spacer = new LLabel.right ((""));
        spacer.width_request = 10;


        misc_grid.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Slingshot:")+"</span>")), 1, 0, 1, 1);
        misc_grid.attach (spacer, 0, 0, 1, 1);

        misc_grid.attach (new LLabel.right (_("Rows:")), 1, 1, 1, 1);
        misc_grid.attach (slingshot_rows_box, 2, 1, 2, 1);

        misc_grid.attach (new LLabel.right (_("Columns:")), 1, 2, 1, 1);
        misc_grid.attach (slingshot_columns_box, 2, 2, 2, 1);

        misc_grid.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Files:")+"</span>")), 1, 3, 1, 1);

        misc_grid.attach (new LLabel.right (_("Single Click:")), 1, 4, 1, 1);
        misc_grid.attach (single_click, 2, 4, 2, 1);

        misc_grid.attach (new LLabel.right (_("Date Format:")), 1, 5, 1, 1);
        misc_grid.attach (date_format_box, 2, 5, 2, 1);

        misc_grid.attach (new LLabel.right (_("Sidebar Icon Size:")), 1, 6, 1, 1);
        misc_grid.attach (sidebar_zoom_box, 2, 6, 2, 1);

        misc_grid.attach (new LLabel.left_with_markup (("<span weight=\"bold\">"+_("Other Settings:")+"</span>")), 1, 7, 1, 1);

        misc_grid.attach (new LLabel.right (_("Audible Bell:")), 1, 8, 1, 1);
        misc_grid.attach (audible_bell, 2, 8, 2, 1);

        misc_grid.attach (new LLabel.right (_("Overlay Scrollbars:")), 1, 9, 1, 1);
        misc_grid.attach (overlay_scrollbar, 2, 9, 2, 1);

        notebook.append_page (misc_grid, new Gtk.Label (_("Miscellaneous")));


        /* Add Tabs */        
        add (notebook);
        

    }

    void icon_switch (string dockitem) {
            try {
                var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/" + dockitem + ".dockitem");
                var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/" + dockitem + ".dockitem");

                file_dest.query_exists ()?file_dest.delete ():file_src.copy (file_dest, FileCopyFlags.NONE);
            } catch (GLib.FileError e){
                warning (e.message);
            }
    }

    bool icon_exists (string dockitem) {
        try {            
            var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/" + dockitem + ".dockitem");
            return file_dest.query_exists ();
        } catch (GLib.FileError e){
            warning (e.message);
        }
    }


}

public static int main (string[] args) {

    Gtk.init (ref args);
    
    var plug = new GalaPlug ();
    plug.register ("Tweaks");
    plug.show_all ();
    
    Gtk.main ();
    return 0;
}

