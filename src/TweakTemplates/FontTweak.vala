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
     * A Gtk.FontButton with a defaults button and a label wrapped in a container.
     */
    public class FontTweak {
        public delegate string GetValue ();
        public delegate void SetValue (string val);
        public delegate void ResetValue ();

        public Gtk.Label label { get; private set; }
        public Gtk.FontButton font_button { get; private set; }
        public Gtk.Grid container { get; private set; }
        public Gtk.ToolButton default_button { get; private set; }

        /**
         * Constructor for creating a new FontTweak.
         *
         * Send in a list containing all of the potential values as well as functions
         * and setting the particular thing that we are tweaking.
         */
        public FontTweak (string tweakName, string tooltip, GetValue getV, SetValue setV, ResetValue resetV) {
            // label that identifies the tweak
            label = new Gtk.Label (tweakName);

            // container that will hold both the combo box and the default button
            container = new Gtk.Grid ();
            container.set_orientation (Gtk.Orientation.HORIZONTAL);
            container.set_column_spacing (10);
            container.halign = Gtk.Align.END;

            // font button that will allow selection of font
            font_button = new Gtk.FontButton.with_font (getV ());
            font_button.halign = Gtk.Align.START;
            font_button.width_request = 160;
            font_button.set_tooltip_text (tooltip);
            font_button.use_font = true;

            // when font is changed, set the value to active entry
            font_button.font_set.connect (() => setV (font_button.get_font_name ()));

            // button to reset the combo box selection (and thus the setting) to default
            default_button = new Gtk.ToolButton (
                    new Gtk.Image.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR), // icon
                    null); // label

            default_button.halign = Gtk.Align.START;
            default_button.set_tooltip_text (_("Revert to default setting"));

            // when the default button is clicked, reset the value and then set the active entry
            default_button.clicked.connect (() => {
                        resetV ();
                        font_button.font_name = getV ();
                    });

            // attach children to container
            container.add (label);
            container.add (font_button);
            container.add (default_button);
        }
    }
}
