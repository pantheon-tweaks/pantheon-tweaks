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
     * A Gtk.SpinButton with a defaults button and a label wrapped in a container.
     */
    public class SpinButtonTweak {
        public delegate int GetValue ();
        public delegate void SetValue (int val);
        public delegate void ResetValue ();

        public Gtk.Label label { get; private set; }
        public Gtk.SpinButton spin_button { get; private set; }
        public Gtk.Grid container { get; private set; }
        public Gtk.ToolButton default_button { get; private set; }

        /**
         * Constructor for creating a new SpinButtonTweak.
         */
        public SpinButtonTweak (string tweakName, string tooltip, int start, int end, int step, GetValue getV, SetValue setV, ResetValue resetV) {
            // label that identifies the tweak
            label = new Gtk.Label (tweakName);

            // container that will hold everything
            container = new Gtk.Grid ();
            container.set_orientation (Gtk.Orientation.HORIZONTAL);
            container.set_column_spacing (10);
            container.halign = Gtk.Align.END;

            // spinbutton
            spin_button = new Gtk.SpinButton.with_range (start, end, step);
            spin_button.halign = Gtk.Align.START;
            spin_button.width_request = 160;
            spin_button.set_tooltip_text (tooltip);

            // set the current value of spinner to current value
            spin_button.set_value ((double) getV ());

            // when combo box is changed, set the value to active entry
            spin_button.value_changed.connect (() => setV (spin_button.get_value_as_int ()));

            // button to reset the combo box selection (and thus the setting) to default
            default_button = new Gtk.ToolButton (
                    new Gtk.Image.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR), // icon
                    null); // label

            default_button.halign = Gtk.Align.START;
            default_button.set_tooltip_text (_("Revert to default setting"));

            // when the default button is clicked, reset the value and then set the active entry
            default_button.clicked.connect (() => {
                        resetV ();
                        spin_button.set_value (getV ());
                    });

            // attach children to container
            container.add (label);
            container.add (spin_button);
            container.add (default_button);
        }
    }
}
