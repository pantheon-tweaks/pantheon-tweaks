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

    public class SlingshotSettings : Granite.Services.Settings
    {
        public bool show_category_filter { get; set; }
        public int icon_size { get; set; }
        public int rows { get; set; }
        public int columns { get; set; }

        static SlingshotSettings? instance = null;

        private SlingshotSettings ()
        {
            base ("org.pantheon.desktop.slingshot");
        }

        public static SlingshotSettings get_default ()
        {
            if (instance == null)
                instance = new SlingshotSettings ();

            return instance;
        }
    }
}
