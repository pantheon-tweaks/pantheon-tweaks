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

public void icon_switch (string dockitem) {
    try {
        var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/" + dockitem + ".dockitem");
        var file_src = File.new_for_path ("/usr/lib/plugs/pantheon/tweaks/" + dockitem + ".dockitem");

        file_dest.query_exists ()?file_dest.delete ():file_src.copy (file_dest, FileCopyFlags.NONE);
    } catch (Error e){
        warning (e.message);
    }
}

public bool icon_exists (string dockitem) {
    try {
        var file_dest = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/launchers/" + dockitem + ".dockitem");
        return file_dest.query_exists ();
    } catch (Error e){
        warning (e.message);
    }
}
