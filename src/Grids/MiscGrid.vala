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
        scroll.notify["active"].connect (() => scroll_switch());
        scroll.halign = Gtk.Align.START;

        /* Double Click Titlebar Action */
        var dbl_click_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var dbl_click = new Gtk.ComboBoxText ();
        dbl_click.append ("menu", _("Menu"));
        dbl_click.append ("toggle-maximize", _("Maximize"));
        dbl_click.append ("toggle-maximize-horizontally", _("Maximize Horizontally"));
        dbl_click.append ("toggle-maximize-vertically", _("Maximize Vertically"));
        dbl_click.append ("minimize", _("Minimize"));
        dbl_click.append ("toggle-shade", _("Shade"));
        dbl_click.append ("lower", _("Lower Window"));

        dbl_click.active_id = WindowSettings.get_default ().action_double_click_titlebar;
        dbl_click.changed.connect (() => WindowSettings.get_default ().action_double_click_titlebar = dbl_click.active_id );
        dbl_click.halign = Gtk.Align.START;
        dbl_click.width_request = 160;

        var dbl_click_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        dbl_click_default.clicked.connect (() => {
            WindowSettings.get_default ().schema.reset ("action-double-click-titlebar");
            dbl_click.active_id = WindowSettings.get_default ().action_double_click_titlebar;
        });
        dbl_click_default.halign = Gtk.Align.START;

        dbl_click_box.pack_start (dbl_click, false);
        dbl_click_box.pack_start (dbl_click_default, false);

        /* Middle Click Titlebar Action */
        var mdl_click_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var mdl_click = new Gtk.ComboBoxText ();
        mdl_click.append ("menu", _("Menu"));
        mdl_click.append ("toggle-maximize", _("Maximize"));
        mdl_click.append ("toggle-maximize-horizontally", _("Maximize Horizontally"));
        mdl_click.append ("toggle-maximize-vertically", _("Maximize Vertically"));
        mdl_click.append ("minimize", _("Minimize"));
        mdl_click.append ("toggle-shade", _("Shade"));
        mdl_click.append ("lower", _("Lower Window"));

        mdl_click.active_id = WindowSettings.get_default ().action_middle_click_titlebar;
        mdl_click.changed.connect (() => WindowSettings.get_default ().action_middle_click_titlebar = mdl_click.active_id );
        mdl_click.halign = Gtk.Align.START;
        mdl_click.width_request = 160;

        var mdl_click_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        mdl_click_default.clicked.connect (() => {
            WindowSettings.get_default ().schema.reset ("action-middle-click-titlebar");
            mdl_click.active_id = WindowSettings.get_default ().action_middle_click_titlebar;
        });
        mdl_click_default.halign = Gtk.Align.START;

        mdl_click_box.pack_start (mdl_click, false);
        mdl_click_box.pack_start (mdl_click_default, false);

        /* Right Click Titlebar Action */
        var rgt_click_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var rgt_click = new Gtk.ComboBoxText ();
        rgt_click.append ("menu", _("Menu"));
        rgt_click.append ("toggle-maximize", _("Maximize"));
        rgt_click.append ("toggle-maximize-horizontally", _("Maximize Horizontally"));
        rgt_click.append ("toggle-maximize-vertically", _("Maximize Vertically"));
        rgt_click.append ("minimize", _("Minimize"));
        rgt_click.append ("toggle-shade", _("Shade"));
        rgt_click.append ("lower", _("Lower Window"));

        rgt_click.active_id = WindowSettings.get_default ().action_right_click_titlebar;
        rgt_click.changed.connect (() => WindowSettings.get_default ().action_right_click_titlebar = rgt_click.active_id );
        rgt_click.halign = Gtk.Align.START;
        rgt_click.width_request = 160;

        var rgt_click_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        rgt_click_default.clicked.connect (() => {
            WindowSettings.get_default ().schema.reset ("action-right-click-titlebar");
            rgt_click.active_id = WindowSettings.get_default ().action_right_click_titlebar;
        });
        rgt_click_default.halign = Gtk.Align.START;

        rgt_click_box.pack_start (rgt_click, false);
        rgt_click_box.pack_start (rgt_click_default, false);

        this.attach (new LLabel.right (_("Double Click Titlebar Action:")), 0, 0, 1, 1);
        this.attach (dbl_click_box, 1, 0, 1, 1);

        this.attach (new LLabel.right (_("Middle Click Titlebar Action:")), 0, 1, 1, 1);
        this.attach (mdl_click_box, 1, 1, 1, 1);

        this.attach (new LLabel.right (_("Right Click Titlebar Action:")), 0, 2, 1, 1);
        this.attach (rgt_click_box, 1, 2, 1, 1);

        this.attach (new LLabel.right (_("Audible Bell:")), 0, 3, 1, 1);
        this.attach (audible_bell, 1, 3, 1, 1);

        this.attach (new LLabel.right (_("Overlay Scrollbars:")), 0, 4, 1, 1);
        this.attach (overlay_scrollbar, 1, 4, 1, 1);

        this.attach (new LLabel.right (_("Natural Scrolling:")), 0, 5, 1, 1);
        this.attach (scroll, 1, 5, 1, 1);

    }
}

public void scroll_switch () {
        try {
            var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/autostart/natural-scrolling.desktop");
            var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/natural-scrolling.desktop");
            if ( scroll_exists() ) {
                Process.spawn_command_line_async ("/usr/lib/plugs/pantheon/tweaks/natural_scrolling.sh false");
                if (file_dest.query_exists ())
                    file_dest.delete ();
            } else {
                Process.spawn_command_line_async ("/usr/lib/plugs/pantheon/tweaks/natural_scrolling.sh true");
                if (!file_dest.query_exists ())
                    file_src.copy (file_dest, FileCopyFlags.NONE);
            }
        } catch (Error e){
            warning (e.message);
        }
}

public bool scroll_exists () {
    try {
        string scrolling_state;
        Process.spawn_command_line_sync ("/usr/lib/plugs/pantheon/tweaks/natural_scrolling.sh", out scrolling_state);
        return scrolling_state.contains("true");
    } catch (Error e) {
        warning (e.message);
    }
    return false;
}
