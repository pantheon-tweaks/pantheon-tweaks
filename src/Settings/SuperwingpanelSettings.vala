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

public class SuperwingpanelSettings : Granite.Services.Settings
{
    public string hide_mode { get; set; }
    public bool   show_window_controls { get; set; }

    public bool   show_launcher { get; set; }
    public string launcher_text_override { get; set; }
    public string default_launcher { get; set; }

    public bool   enable_slim_mode { get; set; }
    public bool   slim_panel_separate_launcher { get; set; }
    public string slim_panel_edge { get; set; }
    public string slim_panel_position { get; set; }
    public int    slim_panel_margin { get; set; }


    public string[] blacklist { get; set; }
    public string[] indicator_order { get; set; }


    static SuperwingpanelSettings? instance = null;

    private SuperwingpanelSettings ()
    {
        base ("org.pantheon.desktop.super-wingpanel");
    }

    public static SuperwingpanelSettings get_default ()
    {
        if (instance == null)
            instance = new SuperwingpanelSettings ();

        return instance;
    }
}
