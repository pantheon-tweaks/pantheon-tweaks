

public class FilesSettings : Granite.Services.Settings
{
	public string date_format { get; set; }
    public string sidebar_zoom_level { get; set; }
	public bool single_click { get; set; }
	
	static FilesSettings? instance = null;
	
	private FilesSettings ()
	{
		base ("org.pantheon.files.preferences");
	}
	
	public static FilesSettings get_default ()
	{
		if (instance == null)
			instance = new FilesSettings ();
		
		return instance;
	}
}