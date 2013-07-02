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