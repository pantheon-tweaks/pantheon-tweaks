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

    public class AnimationsGrid : Gtk.Grid
    {
        private Gtk.Grid animation_durations; // this can't be local to set sensitive from closure, not sure why

        public AnimationsGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // this will hold all of the animation durations so that we can set_sensitive all at once
            animation_durations = new Gtk.Grid ();
            animation_durations.set_orientation (Gtk.Orientation.VERTICAL);
            animation_durations.row_spacing = 6;
            animation_durations.halign = Gtk.Align.CENTER;

            // make sure that we are consistant about greying out if not enabled
            animation_durations.sensitive = AnimationSettings.get_default ().enable_animations;

            // Animation toggle
            SwitchTweak animations = new SwitchTweak (
                        _("Animations:"),
                        _("If the animations play at all"),
                        (() => { return AnimationSettings.get_default ().enable_animations; }), // get
                        ((val) => {
                                animation_durations.sensitive = val;
                                AnimationSettings.get_default ().enable_animations = val;
                            }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("enable-animations"); }) // reset
                    );
            this.add (animations.container);

            // separator to try to make it obvious that the toggle button controls the entire block beneath
            this.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

            // Open duration tweak
            SpinButtonTweak open_duration = new SpinButtonTweak (
                        _("Open Duration:"),
                        _("Plays when an application is opened"),
                        0, 10000, 1,
                        (() => { return AnimationSettings.get_default ().open_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().open_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("open-duration"); }) // reset
                    );
            animation_durations.add (open_duration.container);

            // Close duration tweak
            SpinButtonTweak close_duration = new SpinButtonTweak (
                        _("Close Duration:"),
                        _("Plays when an application is closed"),
                        0, 10000, 1,
                        (() => { return AnimationSettings.get_default ().close_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().close_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("close-duration"); }) // reset
                    );
            animation_durations.add (close_duration.container);

            // Snap duration tweak
            SpinButtonTweak snap_duration = new SpinButtonTweak (
                        _("Snap Duration:"),
                        _("Plays when an application is snapped to the side"),
                        0, 10000, 1,
                        (() => { return AnimationSettings.get_default ().snap_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().snap_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("snap-duration"); }) // reset
                    );
            animation_durations.add (snap_duration.container);

            // Minimize duration tweak
            SpinButtonTweak minimize_duration = new SpinButtonTweak (
                        _("Minimize Duration:"),
                        _("Plays when an application is minimized"),
                        0, 10000, 1,
                        (() => { return AnimationSettings.get_default ().minimize_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().minimize_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("minimize-duration"); }) // reset
                    );
            animation_durations.add (minimize_duration.container);

            // Minimize duration tweak
            SpinButtonTweak workspace_switch_duration = new SpinButtonTweak (
                        _("Workspace Switch Duration:"),
                        _("Plays when an application is minimized"),
                        0, 10000, 1,
                        (() => { return AnimationSettings.get_default ().workspace_switch_duration; }), // get
                        ((val) => { AnimationSettings.get_default ().workspace_switch_duration = val; }), // set
                        (() => { AnimationSettings.get_default ().schema.reset ("workspace-switch-duration"); }) // reset
                    );
            animation_durations.add (workspace_switch_duration.container);

            // add the grid with all of the animation durations in it
            this.add (animation_durations);

            this.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        }
    }
}
