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
 *  * Authors
 *   - PerfectCarl <name.is.carl@gmail.com>
 * 
 */

namespace ElementaryTweaks {

    public class EgtkThemeSettings : Granite.Services.Settings
    {

        private const string CONFIG_FILE_PATH = "/etc/theme-patcher.conf" ;
        public int scrollbar_width { get; set; }
        public int scrollbar_button_radius { get; set; }
        public string active_tab_underline_color { get; set; }
        public string active_tab_underline_values { get; set; }
        public bool enable_egtk_patch { get; set; }
        public bool reset { get; set; }
        public bool verbose { get; set; }

        static EgtkThemeSettings? instance = null;

        private EgtkThemeSettings ()
        {
            base ("org.pantheon.elementary-tweaks.egtk");
        }

        public static EgtkThemeSettings get_default ()
        {
            if (instance == null)
                instance = new EgtkThemeSettings ();

            return instance;
        }
        
        public static void save_to_file (bool enable_egtk_patch, int scrollbar_width, 
            int scrollbar_button_radius, string active_tab_underline_color, bool reset, bool verbose) {
            string data = ""; 
            try {
                
                data = "%s;%d;%d;%s;%s;%s".printf (enable_egtk_patch.to_string (), 
                    scrollbar_width, scrollbar_button_radius, 
                    active_tab_underline_color, reset.to_string (), verbose.to_string ());
                
                FileUtils.set_contents (CONFIG_FILE_PATH, data);
            } catch (Error e) {
                critical ("Can't write config file: %s", e.message) ;
            }
        }
        
        public static EgtkThemeSettings? load_from_file ()
        {
            
            var config_file_exists = File.new_for_path (CONFIG_FILE_PATH).query_exists () ;
            if ( !config_file_exists )
                return null ; 
                
            var result = new EgtkThemeSettings ();
            string data ; 
            try {
                
                FileUtils.get_contents (CONFIG_FILE_PATH, out data);
                var strings = data.split (";");
                
                if( strings.length >0 )
                {
                    result.enable_egtk_patch = strings[0] == "true" ;
                }
                if( strings.length >1 )
                {
                    result.scrollbar_width = int.parse( strings[1]) ;
                }
                if( strings.length >2 )
                {
                    result.scrollbar_button_radius = int.parse( strings[2]) ;
                }
                if( strings.length >3 )
                {
                    result.active_tab_underline_color = strings[3] ;
                }     
                if( strings.length >4 )
                {
                    result.reset = strings[4] == "true" ;
                } 
                if( strings.length >5 )
                {
                    result.verbose = strings[5] == "true" ;
                }                                            
            } catch (Error e) {
                critical ("Can't read config file: %s", e.message) ;
            }
            return result;
        }
    }
}
