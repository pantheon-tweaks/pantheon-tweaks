public class TerminalSettings : Granite.Services.Settings
{
    public string background { get; set; }
    public string cursor_color { get; set; }
    public string font { get; set; }
    public string foreground { get; set; }
    public int opacity { get; set; }
    public string palette { get; set; }
    public int scrollback_lines { get; set; }

    static TerminalSettings? instance = null;

    private TerminalSettings ()
    {
        base ("org.pantheon.terminal.settings");
    }

    public static TerminalSettings get_default ()
    {
        if (instance == null)
            instance = new TerminalSettings ();

        return instance;
    }
}
