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
		
		try {
			var enumerator = File.new_for_path ("/usr/share/themes/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) {
				var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/usr/share/themes/" + name + "/gtk-3.0");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default")
				    themes.append (file_info.get_name (), name);
			}
		} catch (Error e) { warning (e.message); }

		var ui_theme = new Settings ("org.gnome.desktop.wm.preferences");

		themes.active_id = ui_theme.get_string ("theme");
		themes.changed.connect (() => ui_theme.set_string ("theme", themes.active_id) );
		themes.halign = Gtk.Align.START;
        themes.width_request = 140;


		var themes_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		themes_default.clicked.connect (() => {
            ui_theme.set_string ("theme", "elementary");
            themes.active_id = ui_theme.get_string ("theme");
        });
		themes_default.halign = Gtk.Align.START;

		themes_box.pack_start (themes, false);
		themes_box.pack_start (themes_default, false);
		
		var ui_scheme = new Settings ("org.gnome.desktop.interface");
		
		ui.model = themes.model;
		ui.halign = Gtk.Align.START;
		ui.active_id = ui_scheme.get_string ("gtk-theme");
		ui.changed.connect (() => ui_scheme.set_string ("gtk-theme", ui.active_id) );
        ui.width_request = 140;

		var ui_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		ui_default.clicked.connect (() => {
            ui_scheme.set_string ("gtk-theme", "elementary");
            ui.active_id = ui_scheme.get_string ("gtk-theme");
        });
		ui_default.halign = Gtk.Align.START;

		ui_box.pack_start (ui, false);
		ui_box.pack_start (ui_default, false);

        /* Icon Themes */
		var icon_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		var icon_theme = new Gtk.ComboBoxText ();
		try {
			var enumerator = File.new_for_path ("/usr/share/icons/").enumerate_children (FileAttribute.STANDARD_NAME, 0);
			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) {
				var name = file_info.get_name ();
                var checktheme = File.new_for_path ("/usr/share/icons/" + name + "/apps");
                if (checktheme.query_exists() && name != "Emacs" && name != "Default")
				    icon_theme.append (file_info.get_name (), name);
			}
		} catch (Error e) { warning (e.message); }

		
		var icon_scheme = new Settings ("org.gnome.desktop.interface");
		icon_theme.halign = Gtk.Align.START;
		icon_theme.active_id = icon_scheme.get_string ("icon-theme");
		icon_theme.changed.connect (() => icon_scheme.set_string ("icon-theme", icon_theme.active_id) );
        icon_theme.width_request = 140;

		var icon_theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		icon_theme_default.clicked.connect (() => {
            icon_scheme.set_string ("icon-theme", "elementary");
            icon_theme.active_id = icon_scheme.get_string ("icon-theme");
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

		
		var cursor_scheme = new Settings ("org.gnome.desktop.interface");
		cursor_theme.halign = Gtk.Align.START;
		cursor_theme.active_id = cursor_scheme.get_string ("cursor-theme");
		cursor_theme.changed.connect (() => cursor_scheme.set_string ("cursor-theme", cursor_theme.active_id) );
        cursor_theme.width_request = 140;

		var cursor_theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		cursor_theme_default.clicked.connect (() => {
            cursor_scheme.set_string ("cursor-theme", "elementary");
            icon_theme.active_id = icon_scheme.get_string ("cursor-theme");
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
        button_layout.append ("close,maximize,minimize:", _("Mac"));

		button_layout.active_id = AppearanceSettings.get_default ().button_layout;
		button_layout.changed.connect (() => AppearanceSettings.get_default ().button_layout = button_layout.active_id );
		button_layout.halign = Gtk.Align.START;
        button_layout.width_request = 140;

		var button_layout_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		button_layout_default.clicked.connect (() => {
            AppearanceSettings.get_default ().button_layout = "close:maximize";
            button_layout.active_id = AppearanceSettings.get_default ().button_layout;
        });
		button_layout_default.halign = Gtk.Align.START;

		button_layout_box.pack_start (button_layout, false);
		button_layout_box.pack_start (button_layout_default, false);

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

		var anim_scheme = new Settings ("org.pantheon.desktop.gala.animations");

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
            anim_scheme.reset ("open-duration");
            open_dur.set_value (anim_scheme.get_int ("open-duration"));
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
            anim_scheme.reset ("close-duration");
            close_dur.set_value (anim_scheme.get_int ("close-duration"));
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
            anim_scheme.reset ("snap-duration");
            snap_dur.set_value (anim_scheme.get_int ("snap-duration"));
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
            anim_scheme.reset ("minimize-duration");
            mini_dur.set_value (anim_scheme.get_int ("minimize-duration"));
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
            anim_scheme.reset ("workspace-switch-duration");
            work_dur.set_value (anim_scheme.get_int ("workspace-switch-duration"));
        });
		work_dur_box.pack_start (work_dur, false);
		work_dur_box.pack_start (work_dur_spin, false);
		work_dur_box.pack_start (work_dur_default, false);
		
		var enable_anim_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
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
        var anim_spacer = new LLabel.right ((""));
        anim_spacer.width_request = 235;
		anim_spacer.halign = Gtk.Align.START;

		enable_anim_box.pack_start (anim_spacer, false);
		enable_anim_box.pack_start (enable_anim, true);

		
		anim_grid.attach (new LLabel.right_with_markup ("<b>"+_("Animations:")+"</b>"), 0, 0, 1, 1);
		anim_grid.attach (enable_anim_box, 1, 0, 1, 1);
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
		var dock_position_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var dock_position = new Gtk.ComboBoxText ();
        dock_position.append ("3", _("Bottom"));
        dock_position.append ("0", _("Left"));
        dock_position.append ("1", _("Right"));
        
        var position = PlankSettings.get_default ().dock_position;
        
        if ( position != 3 && position != 0 && position != 1 )
            position = 3;
        
        dock_position.active_id = position.to_string ();
        dock_position.changed.connect (() => PlankSettings.get_default ().dock_position = int.parse (dock_position.active_id));
        dock_position.halign = Gtk.Align.START;
        dock_position.width_request = 140;

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
        var dock_items = new Gtk.ComboBoxText ();
        dock_items.append ("3", _("Center"));
        dock_items.append ("1", _("Left/Bottom"));
        dock_items.append ("2", _("Right/Top"));

		var dock_alignment_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var dock_alignment = new Gtk.ComboBoxText ();
        dock_alignment.append ("3", _("Center"));
        dock_alignment.append ("1", _("Left/Bottom"));
        dock_alignment.append ("2", _("Right/Top"));
        dock_alignment.append ("0", _("Panel"));

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
        dock_alignment.width_request = 140;

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
        dock_items.width_request = 140;


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
        hide_mode.width_request = 140;

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
        theme.width_request = 140;

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
        try {            
            var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/gala-workspace.dockitem");
            var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/gala-workspace.dockitem");

            if (file_dest.query_exists ()) {
                overview_icon.set_active(true);
            } else {
                overview_icon.set_active(false);
            }
        } catch (GLib.FileError e){
            warning (e.message);
        }

		overview_icon.notify["active"].connect (overview_switch);
        overview_icon.halign = Gtk.Align.END;

       /* Show Desktop Icon */
        var desktop_icon = new Gtk.Switch ();

        try {            
            var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/show-desktop.dockitem");
            var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/show-desktop.dockitem");

            if (file_dest.query_exists ()) {
                desktop_icon.set_active(true);
            } else {
                desktop_icon.set_active(false);
            }
        } catch (GLib.FileError e){
            warning (e.message);
        }

		desktop_icon.notify["active"].connect (desktop_switch);
        desktop_icon.halign = Gtk.Align.END;

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
        monitor.width_request = 140;

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
            dock_grid.attach (theme_box, 2, 2, 1, 1);
        }


        if (i > 1) {
            dock_grid.attach (new LLabel.right (_("Monitor:")), 0, 3, 2, 1);
            dock_grid.attach (monitor_box, 2, 3, 1, 1);
        }

        dock_grid.attach (new LLabel.right (_("Position:")), 0, 4, 2, 1);
        dock_grid.attach (dock_position_box, 2, 4, 1, 1);

        dock_grid.attach (new LLabel.right (_("Alignment:")), 0, 5, 2, 1);
        dock_grid.attach (dock_alignment_box, 2, 5, 1, 1); 

        dock_grid.attach (label_items, 0, 6, 2, 1);
        dock_grid.attach (dock_items_box, 2, 6, 1, 1);

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
		var click_scheme = new Settings ("org.pantheon.files.preferences");
		var single_click_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var single_click = new Gtk.Switch ();

		single_click.set_active(click_scheme.get_boolean ("single-click"));
		single_click.notify["active"].connect (() => click_scheme.set_boolean ("single-click", single_click.active) );
        single_click.halign = Gtk.Align.START;

        var click_spacer = new LLabel.right ((""));
        click_spacer.width_request = 125;
		click_spacer.halign = Gtk.Align.START;

		single_click_box.pack_start (click_spacer, false);
		single_click_box.pack_start (single_click, false);


        /* Date Format */
		var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var date_format = new Gtk.ComboBoxText ();
        date_format.append ("locale", _("Locale"));
        date_format.append ("iso", _("ISO"));
        date_format.append ("informal", _("Informal"));

		date_format.active_id = click_scheme.get_string ("date-format");
		date_format.changed.connect (() => click_scheme.set_string ("date-format", date_format.active_id) );
		date_format.halign = Gtk.Align.START;
        date_format.width_request = 140;

		var date_format_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		date_format_default.clicked.connect (() => {
            click_scheme.reset ("date-format");
            date_format.active_id = click_scheme.get_string ("date-format");
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

		sidebar_zoom.active_id = click_scheme.get_string ("sidebar-zoom-level");
		sidebar_zoom.changed.connect (() => click_scheme.set_string ("sidebar-zoom-level", sidebar_zoom.active_id) );
		sidebar_zoom.halign = Gtk.Align.START;
        sidebar_zoom.width_request = 140;

		var sidebar_zoom_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		sidebar_zoom_default.clicked.connect (() => {
            click_scheme.reset ("sidebar-zoom-level");
            sidebar_zoom.active_id = click_scheme.get_string ("sidebar-zoom-level");
        });
		sidebar_zoom_default.halign = Gtk.Align.START;

		sidebar_zoom_box.pack_start (sidebar_zoom, false);
		sidebar_zoom_box.pack_start (sidebar_zoom_default, false);

        /* Slingshot Rows */
		var slingshot_scheme = new Settings ("org.pantheon.desktop.slingshot");
		var slingshot_rows_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		var slingshot_rows = new Gtk.SpinButton.with_range (2, 5, 1);

		slingshot_rows.set_value (slingshot_scheme.get_int ("rows"));
		slingshot_rows.value_changed.connect (() => slingshot_scheme.set_int ("rows", slingshot_rows.get_value_as_int()) );
        slingshot_rows.width_request = 140;
		slingshot_rows.halign = Gtk.Align.START;

		var slingshot_rows_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		slingshot_rows_default.clicked.connect (() => {
            slingshot_scheme.reset ("rows");
            slingshot_rows.set_value (slingshot_scheme.get_int ("rows"));
        });
		slingshot_rows_default.halign = Gtk.Align.START;

		slingshot_rows_box.pack_start (slingshot_rows, false);
		slingshot_rows_box.pack_start (slingshot_rows_default, false);
 

        /* Slingshot Columns */
		var slingshot_columns_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		var slingshot_columns = new Gtk.SpinButton.with_range (4, 9, 1);

		slingshot_columns.set_value (slingshot_scheme.get_int ("columns"));
		slingshot_columns.value_changed.connect (() => slingshot_scheme.set_int ("columns", slingshot_columns.get_value_as_int()) );
        slingshot_columns.width_request = 140;
		slingshot_columns.halign = Gtk.Align.START;

		var slingshot_columns_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

		slingshot_columns_default.clicked.connect (() => {
            slingshot_scheme.reset ("columns");
            slingshot_columns.set_value (slingshot_scheme.get_int ("columns"));
        });
		slingshot_columns_default.halign = Gtk.Align.START;
		slingshot_columns_box.pack_start (slingshot_columns, false);
		slingshot_columns_box.pack_start (slingshot_columns_default, false);


		misc_grid.attach (new LLabel.center_with_markup (("<span size=\"large\" weight=\"bold\">"+_("Slingshot:")+"</span>")), 0, 0, 4, 1);

		misc_grid.attach (new LLabel.right (_("Rows:")), 0, 1, 2, 1);
		misc_grid.attach (slingshot_rows_box, 2, 1, 1, 1);

		misc_grid.attach (new LLabel.right (_("Columns:")), 0, 2, 2, 1);
		misc_grid.attach (slingshot_columns_box, 2, 2, 1, 1);

		misc_grid.attach (new LLabel.center_with_markup (("<span size=\"large\" weight=\"bold\">"+_("Files:")+"</span>")), 0, 3, 4, 1);

        misc_grid.attach (new LLabel.right (_("Single Click:")), 0, 4, 2, 1);
        misc_grid.attach (single_click_box, 2, 4, 1, 1);

        misc_grid.attach (new LLabel.right (_("Date Format:")), 0, 5, 2, 1);
        misc_grid.attach (date_format_box, 2, 5, 1, 1);

        misc_grid.attach (new LLabel.right (_("Sidebar Icon Size:")), 0, 6, 2, 1);
        misc_grid.attach (sidebar_zoom_box, 2, 6, 1, 1);

       
        notebook.append_page (misc_grid, new Gtk.Label (_("Miscellaneous")));


        /* Add Tabs */        
        add (notebook);
        

    }
    
 
    void overview_switch () {
            try {
                
                var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/gala-workspace.dockitem");
                var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/gala-workspace.dockitem");

                if (file_dest.query_exists ()) {
                    file_dest.delete ();
                } else {
                    file_src.copy (file_dest, FileCopyFlags.NONE);
                }

            } catch (GLib.FileError e){
                warning (e.message);
            }

	}

    void desktop_switch () {
            try {
                
                var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/show-desktop.dockitem");
                var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/show-desktop.dockitem");

                if (file_dest.query_exists ()) {
                    file_dest.delete ();
                } else {
                    file_src.copy (file_dest, FileCopyFlags.NONE);
                }

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

public static void translations () {
    string desktop_name = ("Tweaks");
}
