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

    public class ShadowsGrid : Gtk.Grid
    {
        public ShadowsGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Focused Windows
            var focused_windows = new TweakWidget.with_spin_button (
                        _("Focused Windows:"),
                        _("Shadow beneath windows that you have currently selected"),
                        _("This may not actually do anything"),
                        (() => { return int.parse (ShadowSettings.get_default ().normal_focused[0]); }), // get
                        ((val) => {
                                ShadowSettings.get_default ().normal_focused[0] = val.to_string ();
                                ShadowSettings.get_default ().normal_focused[3] = Math.round (val * 0.75).to_string ();
                            }), // set
                        (() => { ShadowSettings.get_default ().schema.reset ("normal-focused"); }), // reset
                        0, 200, 1
                    );
            this.add (focused_windows);

            // Unfocused Windows
            var unfocused_windows = new TweakWidget.with_spin_button (
                        _("Unfocused Windows:"),
                        _("Shadow beneath windows that you do not have selected"),
                        _("This may not actually do anything"),
                        (() => { return int.parse (ShadowSettings.get_default ().normal_unfocused[0]); }), // get
                        ((val) => {
                                ShadowSettings.get_default ().normal_unfocused[0] = val.to_string ();
                                ShadowSettings.get_default ().normal_unfocused[3] = Math.round (val * 0.75).to_string ();
                            }), // set
                        (() => { ShadowSettings.get_default ().schema.reset ("normal-unfocused"); }), // reset
                        0, 200, 1
                    );
            this.add (unfocused_windows);
        }
    }
}
