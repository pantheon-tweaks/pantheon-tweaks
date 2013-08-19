public class WingpanelslimSettings : Granite.Services.Settings
{
    public bool auto_hide { get; set; }
    public bool show_launcher { get; set; }
    public string default_launcher { get; set; }
    public string panel_position { get; set; }
    public string panel_edge { get; set; }

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
