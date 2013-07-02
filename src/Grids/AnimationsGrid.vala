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

public class AnimationsGrid : Gtk.Grid
{
    public AnimationsGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;


        var open_dur_label = new LLabel.right (_("Open Duration:"));
        var close_dur_label = new LLabel.right (_("Close Duration:"));
        var snap_dur_label = new LLabel.right (_("Snap Duration:"));
        var mini_dur_label = new LLabel.right (_("Minimize Duration:"));
        var work_dur_label = new LLabel.right (_("Workspace Switch Duration:"));

        var open_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var open_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        open_dur_spin.width_request = 160;
        open_dur_spin.set_value (AnimationSettings.get_default ().open_duration);
        open_dur_spin.value_changed.connect (() => AnimationSettings.get_default ().open_duration = (int)open_dur_spin.get_value ());

        var open_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        open_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("open-duration");
            open_dur_spin.set_value (AnimationSettings.get_default ().open_duration);
        });

        open_dur_box.pack_start (open_dur_spin, false);
        open_dur_box.pack_start (open_dur_default, false);


        var close_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var close_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        close_dur_spin.width_request = 160;
        close_dur_spin.set_value (AnimationSettings.get_default ().close_duration);
        close_dur_spin.value_changed.connect (() => AnimationSettings.get_default ().close_duration = (int)close_dur_spin.get_value ());

        var close_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        close_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("close-duration");
            close_dur_spin.set_value (AnimationSettings.get_default ().close_duration);
        });

        close_dur_box.pack_start (close_dur_spin, false);
        close_dur_box.pack_start (close_dur_default, false);


        var snap_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var snap_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        snap_dur_spin.width_request = 160;
        snap_dur_spin.set_value (AnimationSettings.get_default ().snap_duration);
        snap_dur_spin.value_changed.connect (() => AnimationSettings.get_default ().snap_duration = (int)snap_dur_spin.get_value ());

        var snap_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        snap_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("snap-duration");
            snap_dur_spin.set_value (AnimationSettings.get_default ().snap_duration);
        });

        snap_dur_box.pack_start (snap_dur_spin, false);
        snap_dur_box.pack_start (snap_dur_default, false);


        var mini_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var mini_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        mini_dur_spin.width_request = 160;
        mini_dur_spin.set_value (AnimationSettings.get_default ().minimize_duration);
        mini_dur_spin.value_changed.connect (() => AnimationSettings.get_default ().minimize_duration = (int)mini_dur_spin.get_value ());
        var mini_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        mini_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("minimize-duration");
            mini_dur_spin.set_value (AnimationSettings.get_default ().minimize_duration);
        });

        mini_dur_box.pack_start (mini_dur_spin, false);
        mini_dur_box.pack_start (mini_dur_default, false);


        var work_dur_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var work_dur_spin = new Gtk.SpinButton.with_range (1, 2000, 1);

        work_dur_spin.width_request = 160;
        work_dur_spin.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        work_dur_spin.value_changed.connect (() => AnimationSettings.get_default ().workspace_switch_duration = (int)work_dur_spin.get_value ());
        var work_dur_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);
        work_dur_default.clicked.connect (() => {
            AnimationSettings.get_default ().schema.reset ("workspace-switch-duration");
            work_dur_spin.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        });

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
        this.attach (new LLabel.right_with_markup (("<span weight=\"bold\">"+_("Animations:")+"</span>")), 0, 0, 1, 1);
        this.attach (enable_anim, 1, 0, 1, 1);
        this.attach (open_dur_label, 0, 1, 1, 1);
        this.attach (open_dur_box, 1, 1, 1, 1);
        this.attach (close_dur_label, 0, 2, 1, 1);
        this.attach (close_dur_box, 1, 2, 1, 1);
        this.attach (snap_dur_label, 0, 3, 1, 1);
        this.attach (snap_dur_box, 1, 3, 1, 1);
        this.attach (mini_dur_label, 0, 4, 1, 1);
        this.attach (mini_dur_box, 1, 4, 1, 1);
        this.attach (work_dur_label, 0, 5, 1, 1);
        this.attach (work_dur_box, 1, 5, 1, 1);
    }
}
