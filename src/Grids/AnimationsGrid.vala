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

namespace ElementaryTweaks {

    public class AnimationsGrid : Categories.Pane {
        private Gtk.Grid animation_durations; // this can't be local to set sensitive from closure, not sure why

        public AnimationsGrid () {
            base (_("Animations"), "preferences-desktop-sound");


            // Animation toggle
            var animations = new TweakWidget.with_switch (
                        _("Animations:"),
                        _("If the animations play at all"),
                        null,
                        (() => { return AnimationSettings.get_default ().enable_animations; }), // get
                        ((val) => {
                                animation_durations.sensitive = val;
                                AnimationSettings.get_default ().enable_animations = val;
                            }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("enable-animations"); }) // reset
                    );
            grid.add (animations);

            // separator to try to make it obvious that the toggle button controls the entire block beneath
            grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

            // Open duration tweak
            var open_duration = new TweakWidget.with_spin_button (
                        _("Open Duration:"),
                        _("Plays when an application is opened"),
                        null,
                        (() => { return AnimationSettings.get_default ().open_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().open_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("open-duration"); }), // reset
                        0, 10000, 1
                    );
            grid.add (open_duration);

            // Close duration tweak
            var close_duration = new TweakWidget.with_spin_button (
                        _("Close Duration:"),
                        _("Plays when an application is closed"),
                        null,
                        (() => { return AnimationSettings.get_default ().close_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().close_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("close-duration"); }), // reset
                        0, 10000, 1
                    );
            grid.add (close_duration);

            // Snap duration tweak
            var snap_duration = new TweakWidget.with_spin_button (
                        _("Snap Duration:"),
                        _("Plays when an application is snapped to the side"),
                        null,
                        (() => { return AnimationSettings.get_default ().snap_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().snap_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("snap-duration"); }), // reset
                        0, 10000, 1
                    );
            grid.add (snap_duration);

            // Minimize duration tweak
            var minimize_duration = new TweakWidget.with_spin_button (
                        _("Minimize Duration:"),
                        _("Plays when an application is minimized"),
                        null,
                        (() => { return AnimationSettings.get_default ().minimize_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().minimize_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("minimize-duration"); }), // reset
                        0, 10000, 1
                    );
            grid.add (minimize_duration);

            // Minimize duration tweak
            var workspace_switch_duration = new TweakWidget.with_spin_button (
                        _("Workspace Switch Duration:"),
                        _("Plays when a workspace switch is initiated"),
                        null,
                        (() => { return AnimationSettings.get_default ().workspace_switch_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().workspace_switch_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("workspace-switch-duration"); }), // reset
                        0, 10000, 1
                    );
            grid.add (workspace_switch_duration);
        }
    }
}
