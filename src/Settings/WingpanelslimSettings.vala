public class WingpanelslimSettings : Granite.Services.Settings
{
	public string panel_position { get; set; }
	
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