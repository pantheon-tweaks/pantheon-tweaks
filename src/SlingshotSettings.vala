

public class SlingshotSettings : Granite.Services.Settings
{
	public bool show_category_filter { get; set; }
	public int icon_size { get; set; }
	public int rows { get; set; }
	public int columns { get; set; }
//	public bool open_on_mouse { get; set; }
	
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
