public class WindowSettings : Granite.Services.Settings
{
    public bool audible_bell { get; set; }
    public string button_layout { get; set; }
    public string theme { get; set; }
    public string titlebar_font { get; set; }
    public string action_double_click_titlebar { get; set; }
    public string action_middle_click_titlebar { get; set; }
    public string action_right_click_titlebar { get; set; }

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

public Gtk.ComboBoxText combo_box_themes ( string path, string condition ) {
    var return_box = new Gtk.ComboBoxText ();
    var themes = new Gee.ArrayList<string> ();

    string[] dirs = { 
        "/usr/share/" + path + "/",
        Environment.get_home_dir () + "/." + path + "/" };

    foreach (string dir in dirs) {
        try {
            var enumerator = File.new_for_path (dir).enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file ()) != null) {
                var name = file_info.get_name ();
                var checktheme = File.new_for_path (dir + name + "/" + condition);
                var checkicons = File.new_for_path (dir + name + "/48x48/" + condition);
                if ( ( checktheme.query_exists() || checkicons.query_exists() ) &&
                        name != "Emacs" && name != "Default" && !themes.contains(name))
                    themes.add(name);
            }
        } catch (Error e) { warning (e.message); }
    }

    themes.sort((GLib.CompareDataFunc<string>)GLib.strcmp);

    foreach (string theme in themes) 
            return_box.append (theme, theme);

    return return_box;
}

