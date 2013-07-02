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
