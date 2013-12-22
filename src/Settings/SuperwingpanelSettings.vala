public class SuperwingpanelSettings : Granite.Services.Settings
{
    public string hide_mode { get; set; }
    public bool   show_window_controls { get; set; }

    public bool   show_launcher { get; set; }   
    public string launcher_text_override { get; set; }
    public string default_launcher { get; set; }

    public bool   enable_slim_mode { get; set; }
    public bool   slim_panel_separate_launcher { get; set; }
    public string slim_panel_edge { get; set; }
    public string slim_panel_position { get; set; }
    public int    slim_panel_margin { get; set; }


    public string[] blacklist { get; set; }
    public string[] indicator_order { get; set; }


    static SuperwingpanelSettings? instance = null;

    private SuperwingpanelSettings ()
    {
        base ("org.pantheon.desktop.super-wingpanel");
    }

    public static SuperwingpanelSettings get_default ()
    {
        if (instance == null)
            instance = new SuperwingpanelSettings ();

        return instance;
    }
}
