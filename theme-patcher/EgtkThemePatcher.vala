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
 *   - Tom B*ckmann
 *   - PerfectCarl <name.is.carl@gmail.com>
 * 
 */

namespace ElementaryTweaks {

    public errordomain ThemeError {
            NOT_FOUND,
            FILE_ERROR
    }
   
    // stores a shortcut, converts to gsettings format and readable format
    // and checks for validity
    public class EgtkThemePatcher : GLib.Object {

        const string SLIDER_WIDTH_PROP = "-GtkRange-slider-width: ";
        const string SLIDER_WIDTH_BACKDROP_PROP = "-GtkRange-trough-border: ";

        const string GTK_WIDGETS_PATH = "/usr/share/themes/elementary/gtk-3.0/gtk-widgets.css";
        const string GTK_DARK_WIDGETS_PATH = "/usr/share/themes/elementary/gtk-3.0/gtk-widgets-dark.css";
        const string GTK2_THEME = "/usr/share/themes/elementary/gtk-2.0/gtkrc" ;

        public int get_width () {
            int  result = 0 ; // int.parse(data.splice(slider_width_start, slider_width_end)) ;
            return result ;
        }

        private void report_error_not_found (string filename, string text) throws ThemeError {
            string message = "Can't find '%s' in the file '%s'".printf( text, filename) ; 
            throw new ThemeError.NOT_FOUND( message) ;
        }
    
        private void report_file_error (Error e) throws ThemeError {
            string message = "Error '%s' while processing '%s'".printf (e.message, GTK_WIDGETS_PATH) ; 
            throw new ThemeError.FILE_ERROR( message) ;
        }

        private string dark_widgets_data;
        
        private void patch_tab_underline (string css_line, string color ) throws ThemeError {
            
            /* Trying to process that kind of data : 
             *       .dynamic-notebook .notebook tab:active {
             *            box-shadow: inset 0 0 0 1px alpha (#fff, 0.05),
             *                0 0 1px 1px alpha (#000, 0.15);
             *             background-color: #0f0;                
             *        }
             */
            const string BACKGROUND_COLOR = "    background-color" ;
            var line = "%s: %s;\n".printf (BACKGROUND_COLOR, color) ;
            var css_block_start = dark_widgets_data.index_of (css_line);
            if (css_block_start < 0)
            { 
                report_error_not_found (GTK_DARK_WIDGETS_PATH, css_line) ; 
            }
            var css_block_stop = dark_widgets_data.index_of ("}", css_block_start);
            if (css_block_stop < 0)
            { 
                report_error_not_found (GTK_DARK_WIDGETS_PATH, "}") ; 
            }
            var backgound_color_start = dark_widgets_data.index_of (BACKGROUND_COLOR, css_block_start);
            if (backgound_color_start < 0 || backgound_color_start > css_block_stop )
            { 
                // No background-color exists, let's add the line if the color 
                // is not default 
                if( color != "default" )
                {
                    dark_widgets_data = dark_widgets_data.slice (0, css_block_stop) + 
                        line + 
                        dark_widgets_data.slice (css_block_stop, dark_widgets_data.length);
                }
            }
            else
            {
                var backgound_color_stop = dark_widgets_data.index_of (";\n", backgound_color_start);
                if (backgound_color_stop < 0)
                { 
                    report_error_not_found (GTK_DARK_WIDGETS_PATH, ";\\n") ; 
                }
                if( color == "default" )
                {
                   // We need to remove the background-color property
                    dark_widgets_data = dark_widgets_data.slice (0, backgound_color_start) + 
                        dark_widgets_data.slice (backgound_color_stop+2, dark_widgets_data.length);
                }
                else
                {
                    // A background-color exists, let's update the value 
                    dark_widgets_data = dark_widgets_data.slice (0, backgound_color_start) + 
                        line + 
                        dark_widgets_data.slice (backgound_color_stop+2, dark_widgets_data.length);
                }
            }
        }
        
        public void patch_current_tab_underline_dark (string color="default") throws ThemeError
        {
            // Test sudo gedit /usr/share/themes/elementary/gtk-3.0/gtk-widgets-dark.css
            
            try {
                FileUtils.get_contents (GTK_DARK_WIDGETS_PATH, out dark_widgets_data);
                
                patch_tab_underline (".dynamic-notebook .notebook tab:active {", color) ;
                patch_tab_underline (".dynamic-notebook .notebook tab:active:backdrop {", color) ;
                
                FileUtils.set_contents (GTK_DARK_WIDGETS_PATH, dark_widgets_data);
            } catch (Error e) {
                    report_file_error (e) ;
            }
        }
        
        public void patch_scrollbar (int slider_width=6, int radius=10) throws ThemeError
        {
            patch_scrollbar_gtk2 (slider_width) ;
            patch_scrollbar_gtk3 (slider_width, radius) ;
        }        
        
        private void patch_scrollbar_gtk2 (int slider_width=6) throws ThemeError
        {
            // See how to patch : 
            //  - egtk2 : http://www.reddit.com/r/elementaryos/comments/2ydmib/changing_the_scrollbar_width_so_as_to_be_useful/
            string data ; 
            const string ENTRY = "GtkScrollbar		::slider-width                      = " ;
            try {
                FileUtils.get_contents (GTK2_THEME, out data);
                
                var scrollbar_block_start = data.index_of (ENTRY);
                if (scrollbar_block_start < 0)
                { 
                    report_error_not_found (GTK2_THEME, ENTRY) ; 
                }
                var scrollbar_block_end = data.index_of ("\n", scrollbar_block_start);
                if (scrollbar_block_end < 0)
                { 
                    report_error_not_found (GTK2_THEME, ";\\n");
                }
                
                data = data.slice (0, scrollbar_block_start + ENTRY.length) + slider_width.to_string ()
                    + data.slice (scrollbar_block_end, data.length);
                    
                FileUtils.set_contents (GTK2_THEME, data);
            } catch (Error e) {
                    report_file_error (e) ;
            }
            

        }        
        
        private void patch_scrollbar_gtk3 (int slider_width=6, int radius=10) throws ThemeError
        {
            // See how to patch : 
            //  - egtk3 : http://www.reddit.com/r/elementaryos/comments/2x4au1/can_we_please_have_some_scrollbars_in_eos/coy3f8s

            string data;

            try {
                FileUtils.get_contents (GTK_WIDGETS_PATH, out data);

                // * 
                // * Scrollbar width 
                // * 
                var scrollbar_block_start = data.index_of (".scrollbar {");
                if (scrollbar_block_start < 0)
                { 
                    report_error_not_found (GTK_WIDGETS_PATH, ".scrollbar {") ; 
                }
                var slider_width_start = data.index_of (SLIDER_WIDTH_PROP, scrollbar_block_start)
                    + SLIDER_WIDTH_PROP.length;
                var slider_width_end = data.index_of (";\n", slider_width_start);
                if (slider_width_start < 0 || slider_width_end < 0)
                { 
                    report_error_not_found (GTK_WIDGETS_PATH, ";\\n");
                }

                data = data.slice (0, slider_width_start) + slider_width.to_string ()
                    + data.slice (slider_width_end, data.length);

                var scrollbar_backdrop_block_start = data.index_of (".scrollbar:backdrop {");
                if (scrollbar_backdrop_block_start < 0)
                { 
                    report_error_not_found (GTK_WIDGETS_PATH, ".scrollbar:backdrop {");
                }

                var slider_backdrop_width_start = data.index_of (SLIDER_WIDTH_BACKDROP_PROP, scrollbar_backdrop_block_start)
                    + SLIDER_WIDTH_BACKDROP_PROP.length;
                var slider_backdrop_width_end = data.index_of (";\n", slider_backdrop_width_start);
                if (slider_backdrop_width_start < 0 || slider_backdrop_width_end < 0)
                { 
                    report_error_not_found (GTK_WIDGETS_PATH, ";\\n");
                }

                data = data.slice (0, slider_backdrop_width_start) + (slider_width + 2).to_string ()
                    + data.slice (slider_backdrop_width_end, data.length);

                // * 
                // * Scrollbar button radius 
                // * 
                
                /* Updating the code: 
                 *    .scrollbar.button {
                 *         border-width: 0;
                 *         background-color: alpha (#000, 0.4);
                 *         border-radius: 10px;   
                 *   }
                 * */
                var button_block_start = data.index_of (".scrollbar.button {");
                if (button_block_start < 0)
                { 
                     report_error_not_found (GTK_WIDGETS_PATH, ".scrollbar.button {");
                }
                var button_block_end = data.index_of ("}", button_block_start);
                if (button_block_end < 0)
                { 
                     report_error_not_found (GTK_WIDGETS_PATH, "}");
                }
                
                const string BORDER_RADIUS = "border-radius:" ;
                var radius_start = data.index_of (BORDER_RADIUS, button_block_start);
                if (button_block_end < 0 || radius_start > button_block_end)
                { 
                     report_error_not_found (GTK_WIDGETS_PATH, BORDER_RADIUS);
                }
                var radius_end = data.index_of (";", radius_start);
                if (radius_end < 0)
                { 
                     report_error_not_found (GTK_WIDGETS_PATH, ";");
                }
                
                data = data.slice (0, radius_start + BORDER_RADIUS.length) +
                    " %dpx".printf (radius) +
                    data.slice (radius_end, data.length);
                
                // Save the file 
                FileUtils.set_contents (GTK_WIDGETS_PATH, data);
            } catch (Error e) {
                report_file_error (e) ;
            }

        }

    }
}
