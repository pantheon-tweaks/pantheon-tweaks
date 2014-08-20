/*
 * Copyright (C) Elementary Tweak Developers, 2014
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *
 */

public class SuperwingpanelGrid : Gtk.Grid
{
    bool disable_switch_active_event = false;

    public SuperwingpanelGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        /* Enable Super Wingpanel */
        var wingpanel = new Gtk.Switch ();
        var wingpanel_label = new LLabel.right (_("Super Wingpanel:"));
        
        map.connect (() => {
            var monitored_processes = CerbereSettings.get_default ().monitored_processes;

            var enable = false;
            for (int i = 0; i < monitored_processes.length ; i++) {
                if (monitored_processes[i] == "super-wingpanel")
                    enable = true;
            }

            disable_switch_active_event = true;
            wingpanel.set_active (enable);
            disable_switch_active_event = false;
        });


        /* Hide Mode */
        var hide_mode_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var hide_mode = new Gtk.ComboBoxText ();
        var hide_mode_label = new LLabel.right (_("Hide Mode:"));
        hide_mode.append ("Never Hide", _("Never Hide"));
        hide_mode.append ("Intellihide", _("Intellihide"));
        hide_mode.append ("Intellislim", _("Intellislim"));
        hide_mode.append ("Auto Hide", _("Auto Hide"));

        hide_mode.active_id = SuperwingpanelSettings.get_default ().hide_mode;
        hide_mode.changed.connect (() => SuperwingpanelSettings.get_default ().hide_mode = hide_mode.active_id );
        hide_mode.halign = Gtk.Align.START;
        hide_mode.width_request = 160;

        var hide_mode_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        hide_mode_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("hide-mode");
            hide_mode.active_id = SuperwingpanelSettings.get_default ().hide_mode;
        });
        hide_mode_default.halign = Gtk.Align.START;

        hide_mode_box.pack_start (hide_mode, false);
        hide_mode_box.pack_start (hide_mode_default, false);


        /* Show Window Controls */
        var show_controls = new Gtk.Switch ();
        var show_controls_label = new LLabel.right (_("Show Window Controls:"));

        show_controls.set_active(SuperwingpanelSettings.get_default ().show_window_controls);
        show_controls.notify["active"].connect (() => SuperwingpanelSettings.get_default ().show_window_controls = show_controls.active );
        show_controls.halign = Gtk.Align.START;


        /* Show Launcher */
        var show_launcher = new Gtk.Switch ();
        var show_launcher_label = new LLabel.right (_("Show Launcher:"));

        show_launcher.set_active(SuperwingpanelSettings.get_default ().show_launcher);
        show_launcher.notify["active"].connect (() => SuperwingpanelSettings.get_default ().show_launcher = show_launcher.active );
        show_launcher.halign = Gtk.Align.START;

        /* Launcher Text Override */
        var launcher_text_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var launcher_text = new Gtk.Entry();
        var launcher_text_label = new LLabel.right (_("Launcher Text Override:"));
        launcher_text.text = SuperwingpanelSettings.get_default ().launcher_text_override;
        launcher_text.changed.connect (() => SuperwingpanelSettings.get_default ().launcher_text_override = launcher_text.text);
        launcher_text.width_request = 160;
        launcher_text.halign = Gtk.Align.START;

        var launcher_text_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        launcher_text_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("launcher-text-override");
            launcher_text.text = SuperwingpanelSettings.get_default ().launcher_text_override;
        });
        launcher_text_default.halign = Gtk.Align.START;

        launcher_text_box.pack_start (launcher_text, false);
        launcher_text_box.pack_start (launcher_text_default, false);

        /* Default Launcher */
        var default_launcher_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var default_launcher = new Gtk.Entry();
        var launcher_label = new LLabel.right (_("Launcher:"));
        default_launcher.text = SuperwingpanelSettings.get_default ().default_launcher;
        default_launcher.changed.connect (() => SuperwingpanelSettings.get_default ().default_launcher = default_launcher.text);
        default_launcher.width_request = 160;
        default_launcher.halign = Gtk.Align.START;

        var default_launcher_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        default_launcher_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("default-launcher");
            default_launcher.text = SuperwingpanelSettings.get_default ().default_launcher;
        });
        default_launcher_default.halign = Gtk.Align.START;

        default_launcher_box.pack_start (default_launcher, false);
        default_launcher_box.pack_start (default_launcher_default, false);


        /* Slim Mode */
        var enable_slim = new Gtk.Switch ();
        var slim_label = new LLabel.right (_("Slim Mode:"));

        enable_slim.set_active(SuperwingpanelSettings.get_default ().enable_slim_mode);
        enable_slim.notify["active"].connect (() => SuperwingpanelSettings.get_default ().enable_slim_mode = enable_slim.active );
        enable_slim.halign = Gtk.Align.START;

        /* Slim Mode - Separate Launcher */
        var separate_launcher = new Gtk.Switch ();
        var separate_launcher_label = new LLabel.right (_("Separate Launcher:"));

        separate_launcher.set_active(SuperwingpanelSettings.get_default ().slim_panel_separate_launcher);
        separate_launcher.notify["active"].connect (() => SuperwingpanelSettings.get_default ().slim_panel_separate_launcher = separate_launcher.active );
        separate_launcher.halign = Gtk.Align.START;

        
        /* Wingpanel Edge */
        var slim_edge_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slim_edge = new Gtk.ComboBoxText ();
        var slim_edge_label = new LLabel.right (_("Edge:"));
        slim_edge.append ("Slanted", _("Slanted"));
        slim_edge.append ("Squared", _("Squared"));
        slim_edge.append ("Curved 1", _("Curved 1"));
        slim_edge.append ("Curved 2", _("Curved 2"));
        slim_edge.append ("Curved 3", _("Curved 3"));

        slim_edge.active_id = SuperwingpanelSettings.get_default ().slim_panel_edge;
        slim_edge.changed.connect (() => SuperwingpanelSettings.get_default ().slim_panel_edge = slim_edge.active_id );
        slim_edge.halign = Gtk.Align.START;
        slim_edge.width_request = 160;

        var slim_edge_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slim_edge_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("slim-panel-edge");
            slim_edge.active_id = SuperwingpanelSettings.get_default ().slim_panel_edge;
        });
        slim_edge_default.halign = Gtk.Align.START;

        slim_edge_box.pack_start (slim_edge, false);
        slim_edge_box.pack_start (slim_edge_default, false);


        /* Wingpanel Position */
        var slim_pos_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slim_pos = new Gtk.ComboBoxText ();
        var slim_pos_label = new LLabel.right (_("Position:"));
        slim_pos.append ("Elementary Right", _("Right"));
        slim_pos.append ("Middle", _("Middle"));
        slim_pos.append ("Elementary Left", _("Left"));
        slim_pos.append ("Flush Left", _("Flush Left"));
        slim_pos.append ("Flush Right", _("Flush Right"));

        slim_pos.active_id = SuperwingpanelSettings.get_default ().slim_panel_position;
        slim_pos.changed.connect (() => SuperwingpanelSettings.get_default ().slim_panel_position = slim_pos.active_id );
        slim_pos.halign = Gtk.Align.START;
        slim_pos.width_request = 160;

        var slim_pos_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slim_pos_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("slim-panel-position");
            slim_pos.active_id = SuperwingpanelSettings.get_default ().slim_panel_position;
        });
        slim_pos_default.halign = Gtk.Align.START;

        slim_pos_box.pack_start (slim_pos, false);
        slim_pos_box.pack_start (slim_pos_default, false);


        /* Default Launcher */
        var slim_margin_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var slim_margin = new Gtk.Entry();
        var slim_margin_label = new LLabel.right (_("Margin:"));
        slim_margin.text = SuperwingpanelSettings.get_default ().slim_panel_margin.to_string ();
        slim_margin.changed.connect (() => {
            if (int64.try_parse (slim_margin.text)) {
                SuperwingpanelSettings.get_default ().slim_panel_margin = (int)int64.parse (slim_margin.text);
            } else {
                SuperwingpanelSettings.get_default ().schema.reset ("slim-panel-margin");
                slim_margin.text = SuperwingpanelSettings.get_default ().slim_panel_margin.to_string ();
            }
        });
        slim_margin.width_request = 160;
        slim_margin.halign = Gtk.Align.START;

        var slim_margin_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        slim_margin_default.clicked.connect (() => {
            SuperwingpanelSettings.get_default ().schema.reset ("slim-panel-margin");
            slim_margin.text = SuperwingpanelSettings.get_default ().slim_panel_margin.to_string ();
        });
        slim_margin_default.halign = Gtk.Align.START;

        slim_margin_box.pack_start (slim_margin, false);
        slim_margin_box.pack_start (slim_margin_default, false);




        // Watch for changes
        wingpanel.notify["active"].connect (() => {
            if (disable_switch_active_event) 
                return;

            var processes = CerbereSettings.get_default ().monitored_processes;
            string[] new_processes = {};

            // Killall wingpanel processes and copy the rest to a new list
            for (int i = 0; i < processes.length ; i++) {
                if (processes[i] == "wingpanel" || processes[i] == "wingpanel-slim" || processes[i] == "super-wingpanel") {
                    processes[i] = "killall " + processes[i];
                } else {
                    new_processes += processes[i];
                }
            }
            CerbereSettings.get_default ().monitored_processes = processes;

            // Add the appropriate wingpanel to the new processes list and save it
            var active = wingpanel.active;
            new_processes += (active) ? "super-wingpanel" : "wingpanel";
            CerbereSettings.get_default ().monitored_processes = new_processes;

            hide_mode_label.set_sensitive (active);
            hide_mode_box.set_sensitive (active);
            show_controls_label.set_sensitive (active);
            show_controls.set_sensitive (active);
            show_launcher_label.set_sensitive (active);
            show_launcher.set_sensitive (active);
            launcher_text_label.set_sensitive (active);
            launcher_text_box.set_sensitive (active);
            separate_launcher_label.set_sensitive (active);
            separate_launcher.set_sensitive (active);
            slim_label.set_sensitive (active);
            enable_slim.set_sensitive (active);
            slim_pos_label.set_sensitive (active);
            slim_pos_box.set_sensitive (active);
            slim_edge_label.set_sensitive (active);
            slim_edge_box.set_sensitive (active);
            slim_margin_label.set_sensitive (active);
            slim_margin_box.set_sensitive (active);

        });
        wingpanel.halign = Gtk.Align.START;

        this.attach (wingpanel_label, 0, 0, 1, 1);
        this.attach (wingpanel, 1, 0, 1, 1);

        this.attach (hide_mode_label, 0, 1, 1, 1);
        this.attach (hide_mode_box, 1, 1, 1, 1);

        this.attach (show_controls_label, 0, 2, 1, 1);
        this.attach (show_controls, 1, 2, 1, 1);

        this.attach (show_launcher_label, 0, 4, 1, 1);
        this.attach (show_launcher, 1, 4, 1, 1);

        this.attach (launcher_text_label, 0, 5, 1, 1);
        this.attach (launcher_text_box, 1, 5, 1, 1);

        this.attach (launcher_label, 0, 6, 1, 1);
        this.attach (default_launcher_box, 1, 6, 1, 1);

        this.attach (slim_label, 0, 7, 1, 1);
        this.attach (enable_slim, 1, 7, 1, 1);

        this.attach (separate_launcher_label, 0, 8, 1, 1);
        this.attach (separate_launcher, 1, 8, 1, 1);

        this.attach (slim_edge_label, 0, 9, 1, 1);
        this.attach (slim_edge_box, 1, 9, 1, 1);

        this.attach (slim_pos_label, 0, 10, 1, 1);
        this.attach (slim_pos_box, 1, 10, 1, 1);

        this.attach (slim_margin_label, 0, 11, 1, 1);
        this.attach (slim_margin_box, 1, 11, 1, 1);
    }
}
