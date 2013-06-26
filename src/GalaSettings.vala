//  
//  Copyright (C) 2012 GardenGnome, Rico Tzschichholz, Tom Beckmann
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 

/*
taken from gala code
*/

const string SCHEMA = "org.pantheon.desktop.gala";

public class BehaviorSettings : Granite.Services.Settings
{
	public bool edge_tiling { get; set; }
	public string panel_main_menu_action { get; set; }
	public string toggle_recording_action { get; set; }
	
	public int hotcorner_topleft { get; set; }
	public int hotcorner_topright { get; set; }
	public int hotcorner_bottomleft { get; set; }
	public int hotcorner_bottomright { get; set; }
	
	public string hotcorner_custom_command { get; set; }
	
	static BehaviorSettings? instance = null;
	
	private BehaviorSettings ()
	{
		base (SCHEMA+".behavior");
	}
	
	public static BehaviorSettings get_default ()
	{
		if (instance == null)
			instance = new BehaviorSettings ();
		
		return instance;
	}
}

public class CerbereSettings : Granite.Services.Settings
{
	public int crash_time_interval { get; set; }
	public int max_crashes { get; set; }
	public string[] monitored_processes { get; set; }
	
	static CerbereSettings? instance = null;
	
	private CerbereSettings ()
	{
		base ("org.pantheon.cerbere");
	}
	
	public static CerbereSettings get_default ()
	{
		if (instance == null)
			instance = new CerbereSettings ();
		
		return instance;
	}
}

public class WindowSettings : Granite.Services.Settings
{
	public bool audible_bell { get; set; }
	public string button_layout { get; set; }
	public string theme { get; set; }
	public string titlebar_font { get; set; }
	
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
	public bool ubuntu_overlay_scrollbars { get; set; }
	
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

public class SynapseSettings : Granite.Services.Settings
{
	public string shortcut { get; set; }
	
	static SynapseSettings? instance = null;
	
	private SynapseSettings ()
	{
		base ("net.launchpad.synapse-project.indicator");
	}
	
	public static SynapseSettings get_default ()
	{
		if (instance == null)
			instance = new SynapseSettings ();
		
		return instance;
	}
}


public class AppearanceSettings : Granite.Services.Settings
{
	public string button_layout { get; set; }
	public bool attach_modal_dialogs { get; set; }
	public bool dim_parents { get; set; }
	
	static AppearanceSettings? instance = null;
	
	private AppearanceSettings ()
	{
		base (SCHEMA+".appearance");
	}
	
	public static AppearanceSettings get_default ()
	{
		if (instance == null)
			instance = new AppearanceSettings ();
		
		return instance;
	}
}

public class ShadowSettings : Granite.Services.Settings
{
	public string[] menu { get; set; }
	public string[] normal_focused { get; set; }
	public string[] normal_unfocused { get; set; }
	public string[] dialog_focused { get; set; }
	public string[] dialog_unfocused { get; set; }
	
	static ShadowSettings? instance = null;
	
	private ShadowSettings ()
	{
		base (SCHEMA+".shadows");
	}
	
	public static ShadowSettings get_default ()
	{
		if (instance == null)
			instance = new ShadowSettings ();
		
		return instance;
	}
}

public class AnimationSettings : Granite.Services.Settings
{
	public bool enable_animations { get; set; }
	public int open_duration { get; set; }
	public int snap_duration { get; set; }
	public int minimize_duration { get; set; }
	public int close_duration { get; set; }
	public int workspace_switch_duration { get; set; }
	
	static AnimationSettings? instance = null;
	
	private AnimationSettings ()
	{
		base (SCHEMA+".animations");
	}
	
	public static AnimationSettings get_default ()
	{
		if (instance == null)
			instance = new AnimationSettings ();
		
		return instance;
	}
}
