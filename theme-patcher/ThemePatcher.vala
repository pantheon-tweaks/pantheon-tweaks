/*
 * Copyright (C) PerfectCarl, 2015
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
    static bool logged_to_file = false ;
    static bool logged_to_console = false ;

    int main (string[] args)
    {
        log_string  = "" ;
        var past_message = "" ;
        
        var program_name = args[0] ;
        try{

            bool enable_egtk_patch = false;
            int scrollbar_width = 0 ;
            int scrollbar_button_radius = 0 ;
            string  active_tab_underline_color = "";
            bool reset = false;
            bool verbose = false;
            
            // This is regular update
            if( args.length == 1 )
            {
                //add_error ("The application expect 4 arguments: enable_egtk_patch scrollbar_width scrollbar_button_radius active_tab_underline_color") ;
                //save_log () ;
                //return 1 ;
                log_environment ()  ;
                past_message =  "Reading settings (argument count: %d)".printf (args.length) ;
                var settings = EgtkThemeSettings.load_from_file () ;
                if (settings == null )
                {
                    // Configuration file not present, nothing to patch 
                    return 0 ;
                }
                enable_egtk_patch = settings.enable_egtk_patch ;
                scrollbar_width = settings.scrollbar_width ;
                scrollbar_button_radius = settings.scrollbar_button_radius ;
                active_tab_underline_color = settings.active_tab_underline_color ;
                reset = settings.reset ;
                verbose = settings.verbose ;

            }
            else
            {
                enable_egtk_patch = args[1] == "true";
                scrollbar_width = int.parse (args[2]);
                scrollbar_button_radius = int.parse (args[3]);
                active_tab_underline_color = args[4];
                reset = args[5] == "true";
                verbose = args[6] == "true";
                // Always write that reset is false to avoid 
                // recursive call when called with reset (because the hook is called)
                EgtkThemeSettings.save_to_file (enable_egtk_patch, scrollbar_width, scrollbar_button_radius, 
                    active_tab_underline_color, false, verbose) ;
            }
            logged_to_file = logged_to_console = verbose ; 
            add_log ("Theme patcher") ;
            if (past_message != "" )
                add_log (past_message) ;

            var patcher = new EgtkThemePatcher () ;
            if(reset)
            {
                add_log ("Resetting the theme to default values") ;

                // patcher.patch_scrollbar () ;
                // patcher.patch_current_tab_underline_dark () ;
                reinstall_theme () ;
            }

            if( enable_egtk_patch)
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

    private void reinstall_theme () {
        string output;
        string error;
        int status;
        try {

            Process.spawn_sync (null,
                {   "sudo", "apt-get", "install",
                    "elementary-theme", "--reinstall"
                },
                Environ.get (),
                SpawnFlags.SEARCH_PATH,
                null,
                out output,
                out error,
                out status);
                add_log( "'elementary-theme' reinstalled.") ;
                if (status != 0 )
                    add_log ("Output: '%s. Error: '%s'".printf (output, error)) ;
        } catch (Error e) {
            add_error ("error while executing reinstalling the theme. Message: '%s'. Output: '%s', Error: '%s'".printf (e.message, output, error)) ;
        }
    
    }

    private void log_environment () {
        var strings = Environ.@get () ;
        foreach ( var str in strings )
        {
            add_log ("ENV : "+ str ) ;
        }
    }

    private static void add_log (string text) {
        if( logged_to_console )
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
