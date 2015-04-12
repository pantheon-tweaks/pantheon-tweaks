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

    public delegate T GetValue<T> ();
    public delegate void SetValue<T> (T val);
    public delegate void ResetValue ();

    public class TweakWidget: Gtk.Grid {

        protected const int WIDTH = 180 ;
        protected const int TEXT_WIDTH = 180 ;
        protected const int COLUMN_SPACING = 10 ;

        protected SetValue<string> setter_text ;
        protected GetValue<string> getter_text ;
        protected string text_value ;

        public string text {
            get {
                if( getter_text!= null )
                    text_value = getter_text () ;
                else
                    text_value =  "" ;
                return text_value ;
            }
            set
            {
                if( setter_text != null ) {
                    setter_text (value) ;
                }
            }
        }

        /**
         * Label that holds the tweak name and displays it
         */
        public Gtk.Label label { get; protected set; }

        /**
         * Button that reverts the setting to it's default setting
         */
        public Gtk.ToolButton default_button { get; private set; }

        /**
         * Help image that holds tooltip on what the tweak does.
         */
        public Gtk.Image information { get; protected set; }

        /**
         * Warning image that holds information on the possible side effects of the tweak
         */
        public Gtk.Image warning { get; private set; }

        /**
         * Controlling widget that users will use to tweak the setting
         */
        public Gtk.Grid widget_grid { get; protected set; }


       protected TweakWidget.empty () {
            // set up base grid widget
            this.set_orientation (Gtk.Orientation.HORIZONTAL);
            this.set_column_spacing (COLUMN_SPACING);
            this.halign = Gtk.Align.END;

            // set up widget grid
            widget_grid = new Gtk.Grid ();
            widget_grid.width_request = WIDTH;
       }
        /**
         * Base Constructor for a TweakWidget.
         *
         * Sets up the default button, the label, the information image and tooltip,
         * the warning image and tooltip.
         */
        protected TweakWidget (string name, string tooltip, string? warning_text, ResetValue reset_value) {
            empty () ;

            // set up label
            label = new Gtk.Label (name);

            // set up information and warning widgets
            information = new Gtk.Image.from_icon_name ("help-contents", Gtk.IconSize.BUTTON);
            information.set_tooltip_text (tooltip);

            if (warning_text != null) {
                warning = new Gtk.Image.from_icon_name ("dialog-warning", Gtk.IconSize.BUTTON);
                warning.set_tooltip_text (warning_text);
            }

            // button to reset the tweak.
            default_button = new Gtk.ToolButton (
                    new Gtk.Image.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR), // icon
                    null); // label
            default_button.set_tooltip_text (_("Revert to default setting"));

            // when default button is pressed, reset the value.
            default_button.clicked.connect (() => reset_value ());

            // add all of the widgets to the grid
            this.add (label);
            this.add (widget_grid);
            this.add (default_button);
            this.add (information);

            if (warning != null)
                this.add (warning);
            else {
                var spacer = new Gtk.Grid();
                spacer.width_request = 16;
                this.add (spacer);
            }

            // make sure that everything is showing
            this.show_all ();
        }

        /**
         * Contructs a tweak widget that has a combo box that tweaks a string value.
         */
        public TweakWidget.with_combo_box (string name, string tooltip, string? warning_text, GetValue<string> get_value, SetValue<string> set_value, ResetValue reset_value, Gee.Map<string, string> values)
        {
            this (name, tooltip, warning_text, reset_value);

            // combo box that will select which of the options to set
            var combo_box = new Gtk.ComboBoxText ();
            combo_box.halign = Gtk.Align.FILL;
            combo_box.hexpand = true;
            combo_box.width_request = TEXT_WIDTH ;

            // add all of the passed in values into the combo box
            // id is the thing that we set while value is the display
            foreach (var val in values.entries)
                combo_box.append (val.key, val.value); // id = val; value = val;

            // set current value to displayed entry
            combo_box.active_id = get_value ();

            // when combo box is changed, set the value to active entry
            combo_box.changed.connect (() => {
                // val is null when the combox values are removed/reset
                if( combo_box.active_id != null )
                    set_value (combo_box.active_id);
            });

            setter_text = (val) => {
                if( val != null)
                {
                    combo_box.active_id = val ;
                    // If the value is not present, it is added
                    if( combo_box.active_id != val) {
                        combo_box.append (val, val);
                        combo_box.active_id = val ;
                    }
                }
            } ;
            getter_text = () => {
                return combo_box.active_id ;
            } ;

            // when the default button is pressed, reset the combo box to the new value
            default_button.clicked.connect_after (() => {
                var text =  get_value () ;
                combo_box.active_id = text ;
            });

            widget_grid.add (combo_box);
        }

        /**
         * Constructs a tweak widget that has a switch widget that tweaks a boolean value
         */
        public TweakWidget.with_switch (string name, string tooltip, string? warning_text, GetValue<bool> get_value, SetValue<bool> set_value, ResetValue reset_value)
        {
            this (name, tooltip, warning_text, reset_value);

            // switch that will toggle between the tweak settings
            var switch_button = new Gtk.Switch ();
            switch_button.halign = Gtk.Align.CENTER; //FIXME: WHY YOU NO CENTER

            // set the current value of switch to current value
            switch_button.set_active (get_value ());

            // when the switch is toggled, change the setting
            switch_button.notify["active"].connect (() => set_value (switch_button.get_active ()));

            // when the default button is pressed, reset the switch to the new value
            default_button.clicked.connect_after (() => switch_button.set_active(get_value ()));

            widget_grid.add (switch_button);
        }

        /**
         * Constructs a tweak widget that has a font widget that tweaks a string (containing a font name)  value
         */
        public TweakWidget.with_font_button (string name, string tooltip, string? warning_text, GetValue<string> get_value, SetValue<string> set_value, ResetValue reset_value)
        {
            this (name, tooltip, warning_text, reset_value);

            // font button that will allow selection of font
            var font_button = new Gtk.FontButton.with_font (get_value ());
            font_button.halign = Gtk.Align.FILL;
            font_button.hexpand = true;
            font_button.use_font = true;
            font_button.width_request = 250 ;

            // when font is changed, set the value to active entry
            font_button.font_set.connect (() => set_value (font_button.get_font_name ()));

            // when the default button is pressed, reset the font button to the new value
            default_button.clicked.connect_after (() => font_button.font_name = get_value ());

            widget_grid.add (font_button);
        }

        /**
         * Constructs a tweak widget that has a spin button that tweaks as int value
         */
        public TweakWidget.with_spin_button (string name, string tooltip, string? warning_text, GetValue<int> get_value, SetValue<int> set_value, ResetValue reset_value, int begin, int end, int step)
        {
            this (name, tooltip, warning_text, reset_value);

            // spinbutton
            var spin_button = new Gtk.SpinButton.with_range (begin, end, step);
            spin_button.halign = Gtk.Align.FILL;
            spin_button.hexpand = true;

            // set the current value of spinner to current value
            spin_button.set_value ((double) get_value ());

            // when combo box is changed, set the value to active entry
            spin_button.value_changed.connect (() => set_value (spin_button.get_value_as_int ()));

            // when the default button is pressed, reset the font button to the new value
            default_button.clicked.connect_after (() => spin_button.set_value ((double) get_value ()));

            widget_grid.add (spin_button);
        }

        /**
         * Constructs a tweak widget that has an entry that tweaks a string value
         */
        public TweakWidget.with_entry (string name, string tooltip, string? warning_text, GetValue<string> get_value, SetValue<string> set_value, ResetValue reset_value) {
            this (name, tooltip, warning_text, reset_value);

            // entry
            var entry = new Gtk.Entry ();
            entry.halign = Gtk.Align.FILL;
            entry.hexpand = true;
            entry.width_request = TEXT_WIDTH ;

            // set the current value of the entry widget
            entry.text = get_value ();

            setter_text = (val) => {
                entry.text = val ;
            } ;
            getter_text = () => {
                return entry.text ;
            } ;

            // when the entry is activated, set the value to the current value
            entry.activate.connect (() => set_value (entry.text));

            // when default button is pressed, reset the entry to new value
            default_button.clicked.connect_after (() => entry.text = get_value ());

            widget_grid.add (entry);
        }
    }
}
