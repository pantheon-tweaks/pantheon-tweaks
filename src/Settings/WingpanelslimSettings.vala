/*
 * Copyright (C) Elementary Tweak Developers, 2014
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

namespace ElementaryTweak {

    public class WingpanelslimSettings : Granite.Services.Settings
    {
        public bool auto_hide { get; set; }
        public bool show_launcher { get; set; }
        public string default_launcher { get; set; }
        public string panel_position { get; set; }
        public string panel_edge { get; set; }

        static WingpanelslimSettings? instance = null;

        private WingpanelslimSettings ()
        {
            base ("org.pantheon.desktop.wingpanel-slim");
        }

        public static WingpanelslimSettings get_default ()
        {
            if (instance == null)
                instance = new WingpanelslimSettings ();

            return instance;
        }
    }
}
