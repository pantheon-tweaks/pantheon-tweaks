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
    static string log_string  ;
    static const bool logged_to_file = true ;  
    
    int main (string[] args)
    {
        log_string  = "" ;
        add_log ("Theme patcher") ; 
        

        var program_name = args[0] ;
        try{
                            
            bool enable_egtk_patch = false;
            int scrollbar_width = 0 ;
            int scrollbar_button_radius = 0 ;
            string  active_tab_underline_color = "";
            
            // This is regular update 
            if( args.length == 1 )
            {
                //add_error ("The application expect 4 arguments: enable_egtk_patch scrollbar_width scrollbar_button_radius active_tab_underline_color") ;
                //save_log () ;
                //return 1 ;
                log_environment ()  ;
                add_log ( "Reading settings (argument count: %d)".printf (args.length)) ;
                var settings = EgtkThemeSettings.load_from_file () ;
                
                enable_egtk_patch = settings.enable_egtk_patch ;
                scrollbar_width = settings.scrollbar_width ;
                scrollbar_button_radius = settings.scrollbar_button_radius ;
                active_tab_underline_color = settings.active_tab_underline_color ;
            }
            else
            {
                enable_egtk_patch = args[1] == "true";
                scrollbar_width = int.parse (args[2]);
                scrollbar_button_radius = int.parse (args[3]);
                active_tab_underline_color = args[4];
                EgtkThemeSettings.save_to_file (enable_egtk_patch, scrollbar_width, scrollbar_button_radius, active_tab_underline_color) ;
            }

            var patcher = new EgtkThemePatcher () ;
            if( !enable_egtk_patch) 
            {
                add_log ("Resetting the theme to default values") ;
                
                patcher.patch_scrollbar () ;
                patcher.patch_current_tab_underline_dark () ;
            }
            else
            {
                var message = "  . width: %d, radius: %d, tab color: %s".printf (
                    scrollbar_width, 
                    scrollbar_button_radius,
                    active_tab_underline_color) ;
                    
                add_log (message) ;
                
                patcher.patch_scrollbar (scrollbar_width, scrollbar_button_radius) ;
                patcher.patch_current_tab_underline_dark (active_tab_underline_color) ;
            }
            
            add_log ("Patching done.");
            save_log () ;
        } catch (ThemeError error ) 
        {
            add_error ("[%s] Error while trying to patch Egtk theme: '%s'\n".printf (program_name, error.message)) ;
            save_log () ;
            return 1 ;
        }

        return 0 ;
    }
    
    private void log_environment () {
        var strings = Environ.@get () ;
        foreach ( var str in strings ) 
        {
            add_log ("ENV : "+ str ) ;
        }
    }
    
    private static void add_log (string text) {
        stdout.printf ("%s\n", text) ;
        if( logged_to_file ) {
            var now = new DateTime.now_local ();
            log_string += "(%s) %s\n".printf (now.to_string (), text) ;
        }
    }

    private static void add_error (string text) {
        stdout.printf ("ERROR %s\n", text) ;
        if( logged_to_file ) {
            var now = new DateTime.now_local ();
            log_string += "(%s) ERROR %s\n".printf (now.to_string (), text) ;
        }
    }

    private static void save_log () {
        if( !logged_to_file ) 
            return ; 
            
        var filename = "/tmp/theme-patcher-%lld.log".printf( new DateTime.now_local ().to_unix() ) ; 
        try {
            var file = File.new_for_path (filename ) ;
            if (file.query_exists () ) 
            {
                string content = "" ; 
                FileUtils.get_contents (filename, out content);
                log_string +=  "--------------------\n" + content ; 
            }
            FileUtils.set_contents (filename, log_string);
        }
        catch (Error e ) 
        {
            critical ("Can't write to file '%s'. Error: %s", filename, e.message ) ;
        }
    }
    
}
