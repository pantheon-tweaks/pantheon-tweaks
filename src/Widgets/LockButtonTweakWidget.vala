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
 * Authors
 *   - PerfectCarl <name.is.carl@gmail.com>
 *
 */
namespace ElementaryTweaks {

    public class LockButtonTweakWidget: TweakWidget {
        
        private Gtk.LockButton unlock_button ;
        
        /**
         * Constructs a tweak widget that has a unlock button
         */
        public LockButtonTweakWidget (string name, string tooltip, SetValue<bool> set_value, Permission permission)
        {
            base.empty () ;

            label = new Gtk.Label (name);
            
            // set up information and warning widgets
            //information = new Gtk.Image.from_icon_name ("help-contents", Gtk.IconSize.BUTTON);
            //information.set_tooltip_text (tooltip);

            unlock_button = new Gtk.LockButton (permission) ;
            unlock_button.width_request =128 ;
            unlock_button.halign = Gtk.Align.FILL;
            unlock_button.hexpand = true;
            unlock_button.margin_end = 100  ; 
            unlock_button.get_permission ().notify["allowed"].connect (() => {
                set_value (unlock_button.get_permission ().allowed );
            });
            widget_grid.add (unlock_button);
            
            this.add (label);
            this.add (widget_grid);
            // add all of the widgets to the grid
            //this.add (information);
            
            // make sure that everything is showing
            this.show_all ();

        }
    }
}
