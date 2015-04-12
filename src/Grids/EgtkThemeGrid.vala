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

    public class EgtkThemeGrid : Gtk.Grid
    {
        private TweakWidget width_button  ;
        private TweakWidget etgk_switch ;         
        private TweakWidget rounded_switch ;
        private LockButtonTweakWidget unlock_button ; 
        private ColorComboboxTweakWidget tab_combox ;
        //private Gtk.InfoBar infobar ; 
        //private Gtk.Label info_label ;
        private bool is_unlocked = false ;
        private Permission permission ; 
        private bool old_enabled_value = false ; 
        
/*
ON TERMINAL 

ENV : SUDO_GID=1000
ENV : MAIL=/var/mail/root
ENV : LANGUAGE=en_CA:en
ENV : LC_TIME=fr_FR.UTF-8
ENV : USER=root
ENV : HOME=/home/cran
ENV : LC_MONETARY=fr_FR.UTF-8
ENV : SUDO_UID=1000
ENV : LOGNAME=root
ENV : TERM=xterm
ENV : USERNAME=root
ENV : PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV : LC_ADDRESS=fr_FR.UTF-8
ENV : DISPLAY=:0
ENV : LC_TELEPHONE=fr_FR.UTF-8
ENV : LANG=en_CA.UTF-8
ENV : LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:
ENV : XAUTHORITY=/home/cran/.Xauthority
ENV : SUDO_COMMAND=/usr/bin/apt-get install indicator-multiload
ENV : LC_NAME=fr_FR.UTF-8
ENV : SHELL=/bin/bash
ENV : SUDO_USER=cran
ENV : LC_MEASUREMENT=fr_FR.UTF-8
ENV : LC_IDENTIFICATION=fr_FR.UTF-8
ENV : PWD=/tmp
ENV : LC_NUMERIC=fr_FR.UTF-8
ENV : LC_PAPER=fr_FR.UTF-8
*/

        protected TweaksPlug plug ;
        public EgtkThemeGrid (TweaksPlug plug)
        {
            this.plug = plug ; 
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            //this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;
            
            permission = create_permission () ;
            unlock_button = new LockButtonTweakWidget(
                        _("Please, pretty please, Unlock me"),
                        _("Changing the default theme requires adminstrator rights"),
                        ((unlocked) => { 
                            is_unlocked = unlocked;
                            update_widget_state () ;
                            }), // set
                        permission 
                    );
            unlock_button.margin_bottom = 16 ;
            unlock_button.margin_top = 24;
            this.add (unlock_button);
            old_enabled_value = EgtkThemeSettings.get_default ().enable_egtk_patch ;
            etgk_switch = new TweakWidget.with_switch (
                        _("Enable theme modifications:"),
                        _("If the default theme is changed with values below. When a new version of egtk is intalled, those values are automatically applied"),
                        null,
                        (() => { 
                            return EgtkThemeSettings.get_default ().enable_egtk_patch; 
                        }), // get
                        ((val) => {
                            enable_changes (val) ;
                            width_button.sensitive = val;
                            rounded_switch.sensitive = val;
                            if (!val) 
                                hide_info_bar () ;
                            EgtkThemeSettings.get_default ().enable_egtk_patch = val;
                            update_widget_state () ;
                        }), // set
                        (() => { 
                            EgtkThemeSettings.get_default ().schema.reset ("enable_egtk_patch"); 
                        }) // reset
                    );
            this.add (etgk_switch);
            
            // separator to try to make it obvious that the toggle button controls the entire block beneath
            this.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            
            // Scrollbar width
            width_button = new TweakWidget.with_spin_button (
                        _("Scrollbar Width:"),
                        _("How wide the scrollbars are"),
                        null,
                        (() => { 
                            return EgtkThemeSettings.get_default ().scrollbar_width ; 
                        }), // get
                        ((val) => { 
                            EgtkThemeSettings.get_default ().scrollbar_width = val; 
                            apply_changes () ;
                            }), // set
                        (() => { 
                            EgtkThemeSettings.get_default ().schema.reset ("scrollbar-width"); 
                        }), // reset
                        0, 100, 1
                    );
            this.add (width_button);

            rounded_switch = new TweakWidget.with_spin_button (
                        _("Scrollbar Button Radius:"),
                        _("Radius of the edges of the scrollbar button. Set it to 0 to make it square"),
                        null,
                        (() => { 
                            return EgtkThemeSettings.get_default ().scrollbar_button_radius; }), // get
                        ((val) => {
                            EgtkThemeSettings.get_default ().scrollbar_button_radius = val;
                            apply_changes () ;
                            }), // set
                        (() => { 
                            EgtkThemeSettings.get_default ().schema.reset ("scrollbar-button-radius"); 
                            apply_changes () ;
                        }), // reset
                        0, 100, 1
                    );
            this.add (rounded_switch);

            var tab_combox_values = create_combox_values () ; 
            tab_combox = new ColorComboboxTweakWidget (
                        _("Active dark tab underline:"), // name
                        _("The color for the active tab in the dark egtk theme (used in the terminal for example)"), // tooltip
                        null, // warning
                        (() => { 
                                return EgtkThemeSettings.get_default ().active_tab_underline_color; 
                        }), // get
                        ((val) => {
                                if( val == "custom" ) 
                                {
                                    pick_color () ;
                                }
                                else
                                {
                                    EgtkThemeSettings.get_default ().active_tab_underline_color = val;
                                }
                                apply_changes () ;
                            }), // set
                        (() => {
                                var schema = EgtkThemeSettings.get_default ().schema ;
                                
                                schema.reset ("active-tab-underline-values");
                                tab_combox.init_combox_values (create_combox_values ()) ;
                                
                                schema.reset ("active-tab-underline-color");
                                
                            }), // reset
                            tab_combox_values
                    );     
            this.add (tab_combox);

            // Update the depending controls
            update_widget_state () ;
            hide_info_bar () ;
            
            if (InterfaceSettings.get_default ().gtk_theme != "elementary") {
                show_info_bar (_("You are using a custom Gtk theme. Only the elementary theme will be changed.")) ;
            }
        }
        
        private void update_widget_state () {
            
            var enable_egtk_patch =  EgtkThemeSettings.get_default ().enable_egtk_patch ;
            
            etgk_switch.sensitive = is_unlocked ;
            var enabled = is_unlocked && enable_egtk_patch ;
            width_button.sensitive = enabled;
            rounded_switch.sensitive = enabled;
            tab_combox.sensitive = enabled;
        }
        
        private Gee.HashMap<string, string> create_combox_values () {
            var tab_colors_map = new Gee.HashMap<string, string> ();
            tab_colors_map.set ("default", _("Default"));
            // Add variable colors
            var color_descs = EgtkThemeSettings.get_default ().active_tab_underline_values.split (";") ;
            foreach ( var desc in color_descs) 
            {
                var values= desc.split (":") ; 
                var color_code=values[0] ; 
                if( color_code != null )
                {
                    color_code=color_code.strip () ;
                    if( color_code != "" ) 
                    {
                        var color_name=color_code ; 
                        if (values.length >1) {
                            var text = values[1] ;
                            if( text != null)
                                text = _(text.strip ()) ; 
                            color_name= text;
                        }
                        tab_colors_map.set (color_code, color_name);
                    }
                }
            }
            tab_colors_map.set ("custom", _("Custom"));
            return tab_colors_map ;
        }
            
        private void pick_color () {
            string color = "" ;
            var dialog = new Gtk.ColorChooserDialog (_("Select a color"), null);
            if (dialog.run () == Gtk.ResponseType.OK) {
                
                color = to_hex(dialog.rgba);
            }
            dialog.close ();
            if (color != "" ) {
                var settings = EgtkThemeSettings.get_default () ;
                settings.active_tab_underline_color = color;
                tab_combox.text = color ;
                settings.active_tab_underline_values += " ; " + color ;
            }
        }
        
        private string to_hex (Gdk.RGBA color) {
            return "#%02X%02X%02X".printf( (uint8)(Math.floor (255*color.red)), 
                (uint8)(Math.floor (255*color.green)), (uint8)(Math.floor (255*color.blue))) ;
        }
        private void apply_changes () {
            if(  EgtkThemeSettings.get_default ().enable_egtk_patch )
                show_info_bar () ;
            else 
                hide_info_bar () ;
                
            execute_theme_patching_sync () ;
        }
        
        private Polkit.Permission? create_permission () {
            string filename = "org.pantheon.elementary-tweaks.egtk" ;
            try {
                var permission = new Polkit.Permission.sync (filename, Polkit.UnixProcess.new (Posix.getpid ()));
                return permission;
            } catch (Error e) {
                report_error ("error while getting permission from '%s'. Error: %s".printf (filename, e.message)) ;
                return null ;
            }
        }

        private void report_error (string message) {
            plug.display_error ("Elementary-tweaks (EgtkThemeGrid): %s".printf (message) ) ;
        }
        
        private void enable_changes ( bool enabled ) 
        {
            if (enabled != old_enabled_value) 
                show_info_bar () ;
        }   
        
        private void show_info_bar (string text=_("You need to log out and log in to see the changes")) {
            /*info_label.set_text (text) ;
            infobar.no_show_all = false;
            infobar.show_all ();*/
            plug.show_info_bar (text) ;
        }
        
        private void hide_info_bar () {
            /*infobar.no_show_all = true;
            infobar.hide ();*/
            plug.hide_info_bar () ;
        }
        
        private void execute_theme_patching_sync () {
            
            if (permission.allowed ) {
                var settings = EgtkThemeSettings.get_default () ;
                
                string output;
                string error;
                int status;
                var cli = "%s/theme-patcher".printf (Build.PKGDATADIR);
                try {
                    
                    Process.spawn_sync (null, 
                        {   "pkexec", cli, 
                            settings.enable_egtk_patch.to_string (),
                            settings.scrollbar_width.to_string (), 
                            settings.scrollbar_button_radius.to_string (), 
                            settings.active_tab_underline_color 
                        }, 
                        Environ.get (),
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out output,
                        out error,
                        out status);
                
                } catch (Error e) {
                    report_error ("error while executing '%s'. Message: '%s'. Output: '%s', Error: '%s'".printf (cli, e.message, output, error)) ;
                }
            }
        }
        private void execute_theme_patching_async () {
            
            if (permission.allowed ) {
                var settings = EgtkThemeSettings.get_default () ;
                
                Pid child_pid;
                var cli = "%s/theme-patcher".printf (Build.PKGDATADIR);
                try {
                                        
                    Process.spawn_async (null, 
                        {   "pkexec", cli, 
                            settings.enable_egtk_patch.to_string (),
                            settings.scrollbar_width.to_string (), 
                            settings.scrollbar_button_radius.to_string (), 
                            settings.active_tab_underline_color 
                        }, 
                        Environ.get (),
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out child_pid);
                    // FIXME doesn't execute ouput: Refusing to render service to dead parents.
                } catch (SpawnError e) {
                    report_error ("error while executing '%s'. Message: '%s'.".printf (cli, e.message)) ;
                }
            }
        }
    }
}
