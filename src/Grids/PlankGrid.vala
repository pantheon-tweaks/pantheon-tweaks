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

public class PlankGrid : Gtk.Grid
{
    public PlankGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        /* Icon Size */
        var icon_size_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var icon_size = new Gtk.SpinButton.with_range (32, 96, 1);
        icon_size.set_value (PlankSettings.get_default ().icon_size);
        icon_size.value_changed.connect (() => {
            PlankSettings.get_default ().icon_size = (int)icon_size.get_value ();
        });
        icon_size.halign = Gtk.Align.START;
        icon_size.width_request = 160;

        var icon_size_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        icon_size_default.clicked.connect (() => {
            PlankSettings.get_default ().icon_size = int.parse ("48");
            icon_size.set_value (PlankSettings.get_default ().icon_size);
        });
        
        icon_size_box.pack_start (icon_size, false);
        icon_size_box.pack_start (icon_size_default, false); 

        /* Position */
        var label_top = _("Top");
        var label_bottom = _("Bottom");
        var label_left = _("Left");
        var label_right = _("Right");
        var label_center = _("Center");
        var label_panel = _("Panel");

        //FIXME: Needs a look over
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
        //FIXME: Needs a look over
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
        //FIXME: Needs a look over
        if ( PlankSettings.get_default ().dock_position != 0 && PlankSettings.get_default ().dock_position != 1) {
             dock_items.model = dock_items_h.model;
             dock_alignment.model = dock_alignment_h.model;
        } else {
             dock_items.model = dock_items_v.model;
             dock_alignment.model = dock_alignment_v.model;
        }

        var label_items = new LLabel.right (_("Item Alignment:"));

        var alignment = PlankSettings.get_default ().dock_alignment;
     
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
        theme = combo_box_themes ( "plank/themes", "dock.theme");

        theme.active_id = PlankSettings.get_default ().theme;
        theme.changed.connect (() => PlankSettings.get_default ().theme = theme.active_id );
        theme.halign = Gtk.Align.START;
        theme.width_request = 160;

        var theme_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        theme_default.clicked.connect (() => {
            PlankSettings.get_default ().theme = "Pantheon";
            theme.active_id = PlankSettings.get_default ().theme;
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
        this.attach (new LLabel.right (_("Icon Size:")), 0, 0, 1, 1);
        this.attach (icon_size_box, 1, 0, 1, 1);


        this.attach (new LLabel.right (_("Hide Mode:")), 0, 1, 1, 1);
        this.attach (hide_mode_box, 1, 1, 1, 1);


        this.attach (new LLabel.right (_("Theme:")), 0, 2, 1, 1);
        this.attach (theme_box, 1, 2, 1, 1);


        if (i > 1) {
            this.attach (new LLabel.right (_("Monitor:")), 0, 3, 1, 1);
            this.attach (monitor_box, 1, 3, 1, 1);
        }

        this.attach (new LLabel.right (_("Position:")), 0, 4, 1, 1);
        this.attach (dock_position_box, 1, 4, 1, 1);

        this.attach (new LLabel.right (_("Alignment:")), 0, 5, 1, 1);
        this.attach (dock_alignment_box, 1, 5, 1, 1); 

        this.attach (label_items, 0, 6, 1, 1);
        this.attach (dock_items_box, 1, 6, 1, 1);

        this.attach (new LLabel.right (_("Workspace Overview Icon:")), 0, 7, 1, 1);
        this.attach (overview_icon, 1, 7, 1, 1);

        this.attach (new LLabel.right (_("Show Desktop Icon:")), 0, 8, 1, 1);
        this.attach (desktop_icon, 1, 8, 1, 1);
    }
}
