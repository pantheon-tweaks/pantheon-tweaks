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

    public class TerminalSettings : Granite.Services.Settings
    {
        public string background { get; set; }
        public string cursor_color { get; set; }
        public string font { get; set; }
        public string foreground { get; set; }
        public int opacity { get; set; }
        public string palette { get; set; }
        public int scrollback_lines { get; set; }

        static TerminalSettings? instance = null;

        private TerminalSettings ()
        {
            base ("org.pantheon.terminal.settings");
        }

        public static TerminalSettings get_default ()
        {
            if (instance == null)
                instance = new TerminalSettings ();

            return instance;
        }
    }
}
