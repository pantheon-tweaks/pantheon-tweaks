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

    /**
     * A Gtk.Switch with a defaults button and a label wrapped in a container.
     */
    public class SwitchTweak {
        public delegate bool GetValue ();
        public delegate void SetValue (bool val);
        public delegate void ResetValue ();

        public Gtk.Label label { get; private set; }
        public Gtk.Switch switch_button { get; private set; }
        public Gtk.Grid container { get; private set; }
        public Gtk.ToolButton default_button { get; private set; }

        /**
         * Constructor for creating a new SwitchTweak.
         */
        public SwitchTweak (string tweakName, string tooltip, GetValue getV, SetValue setV, ResetValue resetV) {
            // label that identifies the tweak
            label = new Gtk.Label (tweakName);

            // container that will hold everything
            container = new Gtk.Grid ();
            container.set_orientation (Gtk.Orientation.HORIZONTAL);
            container.set_column_spacing (10);
            container.halign = Gtk.Align.END;

            // switch that will toggle between the tweak settings
            switch_button = new Gtk.Switch ();
            switch_button.halign = Gtk.Align.START;
            switch_button.set_tooltip_text (tooltip);

            // set the current value of switch to current value
            switch_button.set_active (getV ());

            // when the switch is toggled, change the setting
            switch_button.notify["active"].connect (() => setV (switch_button.get_active ()));

            // button to reset the the setting to default
            default_button = new Gtk.ToolButton (
                    new Gtk.Image.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR), // icon
                    null); // label

            default_button.halign = Gtk.Align.START;
            default_button.set_tooltip_text (_("Revert to default setting"));

            // when the default button is clicked, reset the value and then set the switch
            default_button.clicked.connect (() => {
                        resetV ();
                        switch_button.set_active (getV ());
                    });

            // attach children to container
            container.add (label);
            container.add (switch_button);
            container.add (default_button);
        }
    }
}
