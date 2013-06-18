

public class PlankSettings : Object
{
	
	static PlankSettings? instance;
	
	static File configs_path;
	static KeyFile configs;
	
	public int icon_size {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "IconSize");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "IconSize", value);
			save ();
		}
	}

   /* versable changes */

	public int dock_position {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "Position");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "Position", value);
			save ();
		}
	}

	public int dock_alignment {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "Alignment");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "Alignment", value);
			save ();
		}
	}

	public int dock_items {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "ItemsAlignment");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "ItemsAlignment", value);
			save ();
		}
	}

    /* end */
	
	public int hide_mode {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "HideMode");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "HideMode", value);
			save ();
		}
	}
	
	private string _theme;
	public string theme {
		get {
			try {
				_theme = configs.get_value ("PlankDockPreferences", "Theme");
				return _theme;
			} catch (Error e) { warning (e.message); }
			return "";
		}
		set {
			configs.set_string ("PlankDockPreferences", "Theme", value);
			save ();
		}
	}
	
	public int monitor {
		get {
			try {
				return configs.get_integer ("PlankDockPreferences", "Monitor");
			} catch (Error e) { warning (e.message); }
			return 0;
		}
		set {
			configs.set_integer ("PlankDockPreferences", "Monitor", value);
			save ();
		}
	}
	
	PlankSettings ()
	{
		configs_path = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/settings");
		if (!configs_path.query_exists ())
			error ("Plank config file could not be found!");
		
		configs = new KeyFile ();
		try {
			configs.load_from_file (configs_path.get_path (), 
				KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS);
		} catch (Error e) { error (e.message); }
		
		
	}
	
	void save ()
	{
		try {
			FileUtils.set_contents (configs_path.get_path (), configs.to_data ());
		} catch (Error e) { warning (e.message); }
	}
	
	public static PlankSettings get_default ()
	{
		if (instance == null)
			instance = new PlankSettings ();
		
		return instance;
	}
	
}

