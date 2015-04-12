/*
 * Copyright (C) Elementary Tweaks Developers, 2014
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

namespace ElementaryTweaks {

    public class PlankGrid : Gtk.Grid
    {
        public PlankGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // current workspace only
            var current_workspace_only = new TweakWidget.with_switch (
                        _("Current Workspace Only"),
                        _("Show only windows on the current workspace"),
                        _("Will still show pinned items on different workspaces"),
                        (() => { return PlankSettings.get_default ().current_workspace_only; }), // get
                        ((val) => { PlankSettings.get_default ().current_workspace_only = val; }), // set
                        (() => { PlankSettings.get_default ().current_workspace_only = false; }) // reset
                    );
            this.add (current_workspace_only);

            // lock items
            var lock_items = new TweakWidget.with_switch (
                        _("Lock Items:"),
                        _("Whether to prevent drag'n'drop actions and lock items on the dock"),
                        null,
                        (() => { return PlankSettings.get_default ().lock_items; }), // get
                        ((val) => { PlankSettings.get_default ().lock_items = val; }), // set
                        (() => { PlankSettings.get_default ().lock_items = false; }) // reset
                    );
            this.add (lock_items);

            // Icon Size
            var icon_size = new TweakWidget.with_spin_button (
                        _("Icon Size:"),
                        _("The size of each icon in the plank"),
                        null,
                        (() => { return PlankSettings.get_default ().icon_size; }), // get
                        ((val) => { PlankSettings.get_default ().icon_size = val; }), // set
                        (() => { PlankSettings.get_default ().icon_size = 48; }), // reset
                        32, 96, 1
                    );
            this.add (icon_size);

            // Hide Bar mode
            var hide_mode_map = new Gee.HashMap<string, string> ();
            hide_mode_map["0"] = _("Don't hide");
            hide_mode_map["1"] = _("Intelligent hide");
            hide_mode_map["2"] = _("Auto hide");
            hide_mode_map["3"] = _("Hide on maximize");

            var hide_mode = new TweakWidget.with_combo_box (
                        _("Hide Mode:"), // name
                        _("Plank's hide mode"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().hide_mode.to_string (); }), // get
                        ((val) => { PlankSettings.get_default ().hide_mode = int.parse (val); }), // set
                        (() => { PlankSettings.get_default ().hide_mode = 3; }), // reset
                        hide_mode_map
                    );
            this.add (hide_mode);

            // Hide delay
            var hide_delay = new TweakWidget.with_spin_button (
                        _("Hide Delay (ms):"),
                        _("Time to wait before unhiding the dock"),
                        null,
                        (() => { return PlankSettings.get_default ().dock_delay; }), // get
                        ((val) => { PlankSettings.get_default ().dock_delay = val; }), // set
                        (() => { PlankSettings.get_default ().dock_delay = 0; }), // reset
                        0, 10000, 500
                    );
            this.add (hide_delay);

            // Theme
            var theme = new TweakWidget.with_combo_box (
                        _("Theme:"), // name
                        _("Plank's theme for the dock"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().theme; }), // get
                        ((val) => { PlankSettings.get_default ().theme = val; }), // set
                        (() => { PlankSettings.get_default ().theme = "Pantheon"; }), // reset
                        Util.get_themes_map ("plank/themes", "dock.theme") // map
                    );
            this.add (theme);

            // monitor to display on
            var monitor_map = new Gee.HashMap<string, string> ();
            monitor_map["-1"] = _("Primary Monitor");

            for (int i = 0; i < Gdk.Screen.get_default ().get_n_monitors (); i++) {
                monitor_map[i.to_string ()] = _("Monitor %d").printf (i+1);
            }

            var monitor = new TweakWidget.with_combo_box (
                        _("Monitor:"), // name
                        _("The monitor that Plank is displayed on"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().monitor.to_string (); }), // get
                        ((val) => { PlankSettings.get_default ().monitor = int.parse (val); }), // set
                        (() => { PlankSettings.get_default ().monitor = -1; }), // reset
                        monitor_map
                    );
            this.add (monitor);

            // Screen position
            var screen_position_map = new Gee.HashMap<string, string> ();
            screen_position_map["0"] = _("Left");
            screen_position_map["1"] = _("Right");
            screen_position_map["2"] = _("Top");
            screen_position_map["3"] = _("Bottom");

            var screen_position = new TweakWidget.with_combo_box (
                        _("Screen Position:"), // name
                        _("Where on the screen Plank is displayed"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().dock_position.to_string (); }), // get
                        ((val) => { PlankSettings.get_default ().dock_position = int.parse (val); }), // set
                        (() => { PlankSettings.get_default ().dock_position = 3; }), // reset
                        screen_position_map
                    );
            this.add (screen_position);

            // Alignment
            var alignment_map = new Gee.HashMap<string, string> ();
            alignment_map["0"] = _("Panel");
            alignment_map["1"] = _("Right");
            alignment_map["2"] = _("Left");
            alignment_map["3"] = _("Centered");

            var alignment = new TweakWidget.with_combo_box (
                        _("Alignment:"), // name
                        _("The alignment for the dock on the monitor's edge"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().dock_alignment.to_string (); }), // get
                        ((val) => { PlankSettings.get_default ().dock_alignment = int.parse (val); }), // set
                        (() => { PlankSettings.get_default ().dock_alignment = 3; }), // reset
                        alignment_map
                    );
            this.add (alignment);

            // Item alignment
            var item_alignment_map = new Gee.HashMap<string, string> ();
            item_alignment_map["1"] = _("Right");
            item_alignment_map["2"] = _("Left");
            item_alignment_map["3"] = _("Centered");

            var item_alignment = new TweakWidget.with_combo_box (
                        _("Item Alignment:"), // name
                        _("The alignment of the items in this dock if panel-mode is used"), // tooltip
                        null, // warning
                        (() => { return PlankSettings.get_default ().dock_items.to_string (); }), // get
                        ((val) => { PlankSettings.get_default ().dock_items = int.parse (val); }), // set
                        (() => { PlankSettings.get_default ().dock_items = 3; }), // reset
                        item_alignment_map
                    );
            this.add (item_alignment);

            // Offset
            var offset = new TweakWidget.with_spin_button (
                        _("Offset:"),
                        _("The offset (in percent) from the alignment point to shift Plank"),
                        null,
                        (() => { return PlankSettings.get_default ().dock_offset; }), // get
                        ((val) => { PlankSettings.get_default ().dock_offset = val; }), // set
                        (() => { PlankSettings.get_default ().dock_offset = 0; }), // reset
                        -100, 100, 1
                    );
            this.add (offset);

            var pressure_reveal = new TweakWidget.with_switch (
                        _("Pressure Reveal:"),
                        _("Whether to use pressure-based revealing of the dock if the support is available"),
                        null,
                        (() => { return PlankSettings.get_default ().pressure_reveal; }), // get
                        ((val) => { PlankSettings.get_default ().pressure_reveal = val; }), // set
                        (() => { PlankSettings.get_default ().pressure_reveal = false; }) // reset
                    );
            this.add (pressure_reveal);

            var pinned_only = new TweakWidget.with_switch (
                        _("Pinned Only:"),
                        _("Whether to show only pinned applications. Useful for running more then one dock"),
                        null,
                        (() => { return PlankSettings.get_default ().pinned_only; }), // get
                        ((val) => { PlankSettings.get_default ().pinned_only = val; }), // set
                        (() => { PlankSettings.get_default ().pinned_only = false; }) // reset
                    );
            this.add (pinned_only);
            
            var auto_pinning = new TweakWidget.with_switch (
                        _("Auto Pinning:"),
                        _("Whether to automatically pin an application if it seems useful to do"),
                        null,
                        (() => { return PlankSettings.get_default ().auto_pinning; }), // get
                        ((val) => { PlankSettings.get_default ().auto_pinning = val; }), // set
                        (() => { PlankSettings.get_default ().auto_pinning = true; }) // reset
                    );
            this.add (auto_pinning);
            /*
            var label_items = new LLabel.right (_("Item Alignment:"));
            var alignment = PlankSettings.get_default ().dock_alignment;

            dock_alignment.active_id = alignment.to_string ();
            dock_offset.set_sensitive(PlankSettings.get_default ().dock_alignment == 3);
            dock_alignment.changed.connect (() => {
                    PlankSettings.get_default ().dock_alignment = int.parse (dock_alignment.active_id);
                    bool flip = (PlankSettings.get_default ().dock_alignment == 0);
                    dock_items_box.set_sensitive (flip);
                    label_items.set_sensitive (flip);
                    dock_offset.set_sensitive (PlankSettings.get_default ().dock_alignment == 3);
                    });
            dock_alignment.halign = Gtk.Align.START;
            dock_alignment.width_request = 160;

            var dock_alignment_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            dock_alignment_default.clicked.connect (() => {
                    PlankSettings.get_default ().dock_alignment = int.parse ("3");
                    dock_alignment.active_id = PlankSettings.get_default ().dock_alignment.to_string ();
                    dock_offset.set_sensitive (PlankSettings.get_default ().dock_alignment == 3);
                    });
            dock_position_default.halign = Gtk.Align.START;

            dock_alignment_box.pack_start (dock_alignment, false);
            dock_alignment_box.pack_start (dock_alignment_default, false);

            var lock_items = new Gtk.Switch ();
            lock_items.set_active(PlankSettings.get_default ().lock_items);
            lock_items.notify["active"].connect (() => PlankSettings.get_default ().lock_items = lock_items.get_active());
            lock_items.halign = Gtk.Align.START;

            this.attach (new LLabel.right (_("Icon Size:")), 0, 0, 1, 1);
            this.attach (icon_size_box, 1, 0, 1, 1);

            this.attach (new LLabel.right (_("Hide Mode:")), 0, 1, 1, 1);
            this.attach (hide_mode_box, 1, 1, 1, 1);

            this.attach (new LLabel.right (_("Delay (in ms):")), 0, 2, 1, 1);
            this.attach (dock_delay_box, 1, 2, 1, 1);

            this.attach (new LLabel.right (_("Theme:")), 0, 3, 1, 1);
            this.attach (theme_box, 1, 3, 1, 1);

            if (i > 1) {
                this.attach (new LLabel.right (_("Monitor:")), 0, 4, 1, 1);
                this.attach (monitor_box, 1, 4, 1, 1);
            }

            this.attach (new LLabel.right (_("Position:")), 0, 5, 1, 1);
            this.attach (dock_position_box, 1, 5, 1, 1);

            this.attach (new LLabel.right (_("Alignment:")), 0, 6, 1, 1);
            this.attach (dock_alignment_box, 1, 6, 1, 1);

            this.attach (new LLabel.right (_("Offset:")), 0, 7, 1, 1);
            this.attach (dock_offset_box, 1, 7, 1, 1);

            this.attach (label_items, 0, 8, 1, 1);
            this.attach (dock_items_box, 1, 8, 1, 1);

            this.attach (new LLabel.right (_("Lock Items:")), 0, 9, 1, 1);
            this.attach (lock_items, 1, 9, 1, 1);
            */
        }
    }
}
