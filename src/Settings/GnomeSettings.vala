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
 */

namespace ElementaryTweaks {

    public class WindowSettings : Granite.Services.Settings
    {
        public bool audible_bell { get; set; }
        public string button_layout { get; set; }
        public string theme { get; set; }
        public string titlebar_font { get; set; }
        public string action_double_click_titlebar { get; set; }
        public string action_middle_click_titlebar { get; set; }
        public string action_right_click_titlebar { get; set; }

        static WindowSettings? instance = null;

        private WindowSettings ()
        {
            base ("org.gnome.desktop.wm.preferences");
        }

        public static WindowSettings get_default ()
        {
            if (instance == null)
                instance = new WindowSettings ();

            return instance;
        }
    }

    public class InterfaceSettings : Granite.Services.Settings
    {
        public string cursor_theme { get; set; }
        public string document_font_name { get; set; }
        public string font_name { get; set; }
        public string gtk_theme { get; set; }
        public string icon_theme { get; set; }
        public string monospace_font_name { get; set; }

        static InterfaceSettings? instance = null;

        private InterfaceSettings ()
        {
            base ("org.gnome.desktop.interface");
        }

        public static InterfaceSettings get_default ()
        {
            if (instance == null)
                instance = new InterfaceSettings ();

            return instance;
        }
    }

    public Gtk.ComboBoxText combo_box_themes ( string path, string condition ) {
        var return_box = new Gtk.ComboBoxText ();
        var themes = Util.get_themes (path, condition);

        foreach (string theme in themes)
            return_box.append (theme, theme);

        return return_box;
    }
}
