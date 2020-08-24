/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
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

namespace PantheonTweaks {
    public class Panes.AnimationsPane : Categories.Pane {
        private Gtk.Switch master_switch;
        private Gtk.SpinButton open_duration;
        private Gtk.SpinButton close_duration;
        private Gtk.SpinButton snap_duration;
        private Gtk.SpinButton minimize_duration;
        private Gtk.SpinButton workspace_duration;

        private Gtk.Adjustment open_adj = new Gtk.Adjustment (0,0,1000,10,10,10);
        private Gtk.Adjustment close_adj = new Gtk.Adjustment (0,0,1000,10,10,10);
        private Gtk.Adjustment snap_adj = new Gtk.Adjustment (0,0,1000,10,10,10);
        private Gtk.Adjustment minimize_adj = new Gtk.Adjustment (0,0,1000,10,10,10);
        private Gtk.Adjustment workspace_adj = new Gtk.Adjustment (0,0,1000,10,10,10);

        public AnimationsPane () {
            base (_("Animations"), "go-jump");
        }

        construct {
            if (Util.schema_exists ("org.pantheon.desktop.gala.animations")) {
                build_ui ();
                init_data ();
                connect_signals ();
            }
        }

        private void build_ui () {
            var master_box = new Widgets.SettingsBox ();
            var animations_box = new Widgets.SettingsBox ();

            master_switch = master_box.add_switch (_("Enable animations"));
            master_switch.bind_property ("active", animations_box, "sensitive", BindingFlags.SYNC_CREATE);

            var duration_label = new Widgets.Label (_("Duration"));

            open_duration = animations_box.add_spin_button (_("Open"), open_adj);
            close_duration = animations_box.add_spin_button (_("Close"), close_adj);
            snap_duration = animations_box.add_spin_button (_("Snap"), snap_adj);
            minimize_duration = animations_box.add_spin_button (_("Minimize"), minimize_adj);
            workspace_duration = animations_box.add_spin_button (_("Workspace switch"), workspace_adj);

            grid.add (master_box);
            grid.add (duration_label);
            grid.add (animations_box);

            grid.show_all ();
        }

        protected override void init_data () {
            master_switch.set_state (AnimationSettings.get_default ().enable_animations);

            open_duration.set_value (AnimationSettings.get_default ().open_duration);
            close_duration.set_value (AnimationSettings.get_default ().close_duration);
            snap_duration.set_value (AnimationSettings.get_default ().snap_duration);
            minimize_duration.set_value (AnimationSettings.get_default ().minimize_duration);
            workspace_duration.set_value (AnimationSettings.get_default ().workspace_switch_duration);
        }

        private void connect_signals () {
            master_switch.notify["active"].connect (() => {
                AnimationSettings.get_default ().enable_animations = master_switch.state;
            });

            connect_spin_button (open_duration, (val) => { AnimationSettings.get_default ().open_duration = val; });
            connect_spin_button (close_duration, (val) => { AnimationSettings.get_default ().close_duration = val; });
            connect_spin_button (snap_duration, (val) => { AnimationSettings.get_default ().snap_duration = val; });
            connect_spin_button (minimize_duration, (val) => { AnimationSettings.get_default ().minimize_duration = val; });
            connect_spin_button (workspace_duration, (val) => { AnimationSettings.get_default ().workspace_switch_duration = val; });

            connect_reset_button (() => {AnimationSettings.get_default().reset ();});
        }
    }
}
