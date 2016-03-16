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
 * Authors
 *   - PerfectCarl <name.is.carl@gmail.com>
 *
 */
namespace ElementaryTweaks {

    public class ColorComboboxTweakWidget: TweakWidget {
        
        private  Gtk.EventBox color_box ;
        private Gtk.ComboBoxText combo_box ;
        
        public ColorComboboxTweakWidget (string name, string tooltip, string? warning_text, GetValue<string> get_value, SetValue<string> set_value, ResetValue reset_value, Gee.Map<string, string> values)
        {
            base (name, tooltip, warning_text, reset_value);

            // combo box that will select which of the options to set
            combo_box = new Gtk.ComboBoxText ();
            combo_box.halign = Gtk.Align.FILL;
            combo_box.hexpand = true;

            color_box = new Gtk.EventBox ();
            color_box.margin_left = 8 ; 
            color_box.width_request = 24 ; 
            color_box.margin_top = 1 ;
            color_box.margin_bottom = 1 ;
            // add all of the passed in values into the combo box
            // id is the thing that we set while value is the display
            init_combox_values (values) ;

            // set current value to displayed entry
            combo_box.active_id = get_value ();

            // when combo box is changed, set the value to active entry
            combo_box.changed.connect (() => {
                var val = combo_box.active_id ; 
                // val is null when the combox values are reset via combo_box.active_id
                if( val != null )
                {
                    set_value (val);
                    set_color (color_box, val) ;
                }
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
                //set_color (color_box, text) ;
            });
             
            widget_grid.add (combo_box);
            widget_grid.add (color_box);
            set_color (color_box, combo_box.active_id) ;
        }
        
        private void set_color (Gtk.EventBox color_box, string? color) {
            
            var rgba = Gdk.RGBA() ; 

            if( color != null && color.has_prefix ("#")) {
                rgba = to_rgba (color) ;
            }
            color_box.override_background_color (Gtk.StateFlags.NORMAL,rgba) ;
            
        }

        public void init_combox_values (Gee.Map<string, string> values) {
            //var temp_id = combo_box.active_id ;
            combo_box.remove_all () ;
            foreach (var val in values.entries)
                combo_box.append (val.key, val.value); // id = val; value = val;
            //combo_box.active_id = temp_id ;
        }
        
        private Gdk.RGBA to_rgba (string text ) 
        {
            var red_str = text.slice (1, 3) ;
            var green_str = text.slice (3, 5) ;
            var blue_str = text.slice (5, 7) ;
            int red = 0 ; 
            int green = 0 ; 
            int blue = 0 ; 
            red_str.scanf ("%x", &red) ;
            green_str.scanf ("%x", &green) ;
            blue_str.scanf ("%x", &blue) ;
            
            var result = Gdk.RGBA() ; 
            result.red = (double)red/255; 
            result.green = (double)green/255;
            result.blue = (double)blue/255  ; 
            result.alpha = 1 ; 
            return result ;
            
        }
    }
}
