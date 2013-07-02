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

public class ShadowsGrid : Gtk.Grid
{
    public ShadowsGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        var shadow_scheme = new Settings ("org.pantheon.desktop.gala.shadows");
        var shadow_focused_label = new LLabel.right (_("Focused Windows:"));
        var shadow_unfocused_label = new LLabel.right (_("Unfocused Windows:"));
        var shadow_dfocused_label = new LLabel.right (_("Focused Dialogs:"));
        var shadow_undfocused_label = new LLabel.right (_("Unfocused Dialogs:"));
        var shadow_menu_label = new LLabel.right (_("Menu:"));

        /* Focused Windows */
        var shadow_focused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_focused_spin = new Gtk.SpinButton.with_range (0, 200, 1);        
        var shadows_focused = ShadowSettings.get_default ().normal_focused;
        radius_focused_spin.width_request = 160;

        radius_focused_spin.value = int.parse (shadows_focused[0]);        
        radius_focused_spin.value_changed.connect (() => {
            shadows_focused[0] = ((int)radius_focused_spin.value).to_string ();
            shadows_focused[3] = Math.round( double.parse(shadows_focused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_focused = shadows_focused;
        });

        var focused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        focused_default.clicked.connect (() => {
            shadow_scheme.reset ("normal-focused");
            shadows_focused = ShadowSettings.get_default ().normal_focused;
            radius_focused_spin.set_value(int.parse (shadows_focused[0]));
        });
        focused_default.halign = Gtk.Align.START;

        shadow_focused_box.pack_start (radius_focused_spin, false);
        shadow_focused_box.pack_start (focused_default, false);

        /* Unfocused Windows */
        var shadow_unfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_unfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_unfocused = ShadowSettings.get_default ().normal_unfocused;
        radius_unfocused_spin.width_request = 160;

        radius_unfocused_spin.value = int.parse (shadows_unfocused[0]);
        radius_unfocused_spin.value_changed.connect (() => {
            shadows_unfocused[0] = ((int)radius_unfocused_spin.value).to_string ();
            shadows_unfocused[3] = Math.round( double.parse(shadows_unfocused[0]) * 0.75).to_string();
            ShadowSettings.get_default ().normal_unfocused = shadows_unfocused;
        });

        var unfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        unfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("normal-unfocused");
            shadows_unfocused = ShadowSettings.get_default ().normal_unfocused;
            radius_unfocused_spin.set_value(int.parse (shadows_unfocused[0]));
        });
        unfocused_default.halign = Gtk.Align.START;

        shadow_unfocused_box.pack_start (radius_unfocused_spin, false);
        shadow_unfocused_box.pack_start (unfocused_default, false);

        /* Focused Dialoges */
        var shadow_dfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

        var radius_dfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_dfocused = ShadowSettings.get_default ().dialog_focused;
        radius_dfocused_spin.width_request = 160;

        radius_dfocused_spin.value = int.parse (shadows_dfocused[0]);
        radius_dfocused_spin.value_changed.connect (() => {
            shadows_dfocused[0] = ((int)radius_dfocused_spin.value).to_string ();
            shadows_dfocused[3] = Math.round( double.parse(shadows_dfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_focused = shadows_dfocused;
        });

        var dfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        dfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("dialog-focused");
            shadows_dfocused = ShadowSettings.get_default ().dialog_focused;
              radius_dfocused_spin.set_value(int.parse (shadows_dfocused[0]));
        });
        dfocused_default.halign = Gtk.Align.START;

        shadow_dfocused_box.pack_start (radius_dfocused_spin, false);
        shadow_dfocused_box.pack_start (dfocused_default, false);

        /* Unfocused Dialoges */
        var shadow_undfocused_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_undfocused_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_undfocused = ShadowSettings.get_default ().dialog_unfocused;
        radius_undfocused_spin.width_request = 160;

        radius_undfocused_spin.value = int.parse (shadows_undfocused[0]);
        radius_undfocused_spin.value_changed.connect (() => {
            shadows_undfocused[0] = ((int)radius_undfocused_spin.value).to_string ();
            shadows_undfocused[3] = Math.round( double.parse(shadows_undfocused[0]) * 0.6).to_string();
            ShadowSettings.get_default ().dialog_unfocused = shadows_undfocused;
        });

        var undfocused_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        undfocused_default.clicked.connect (() => {
            shadow_scheme.reset ("dialog-unfocused");
            shadows_undfocused = ShadowSettings.get_default ().dialog_unfocused;
            radius_undfocused_spin.set_value(int.parse (shadows_undfocused[0]));
        });
        undfocused_default.halign = Gtk.Align.START;

        shadow_undfocused_box.pack_start (radius_undfocused_spin, false);
        shadow_undfocused_box.pack_start (undfocused_default, false);

        /* Menu */
        var shadow_menu_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var radius_menu_spin = new Gtk.SpinButton.with_range (0, 200, 1);
        var shadows_menu = ShadowSettings.get_default ().menu;
        radius_menu_spin.width_request = 160;

        radius_menu_spin.value = int.parse (shadows_menu[0]);
        radius_menu_spin.value_changed.connect (() => {
            shadows_menu[0] = ((int)radius_menu_spin.value).to_string ();
            shadows_menu[3] = Math.round( double.parse(shadows_menu[0]) * 0.7).to_string();
            ShadowSettings.get_default ().menu = shadows_menu;
        });

        var menu_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        menu_default.clicked.connect (() => {
            shadow_scheme.reset ("menu");
            shadows_menu = ShadowSettings.get_default ().menu;
            radius_menu_spin.set_value(int.parse (shadows_menu[0]));
        });
        menu_default.halign = Gtk.Align.START;

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
        //FIXME: Check all shadows!
        if ( shadows_focused[4] != "0" )
        enable_shadows.active = true;

        /* Attach to grid */
        this.attach (new LLabel.right_with_markup (("<span weight=\"bold\">"+_("Shadows:")+"</span>")), 0, 0, 1, 1);
        this.attach (enable_shadows, 1, 0, 1, 1);

        this.attach (shadow_focused_label, 0, 1, 1, 1);
        this.attach (shadow_focused_box, 1, 1, 1, 1);

        this.attach (shadow_unfocused_label, 0, 2, 1, 1);
        this.attach (shadow_unfocused_box, 1, 2, 1, 1);

        this.attach (shadow_dfocused_label, 0, 3, 1, 1);
        this.attach (shadow_dfocused_box, 1, 3, 1, 1);

        this.attach (shadow_undfocused_label, 0, 4, 1, 1);
        this.attach (shadow_undfocused_box, 1, 4, 1, 1);

        this.attach (shadow_menu_label, 0, 5, 1, 1);
        this.attach (shadow_menu_box, 1, 5, 1, 1);
    }
}
