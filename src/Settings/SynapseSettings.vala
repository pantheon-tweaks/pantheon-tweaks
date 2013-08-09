public class SynapseSettings : Granite.Services.Settings
{
    public string shortcut { get; set; }

    static SynapseSettings? instance = null;

    private SynapseSettings ()
    {
        base ("net.launchpad.synapse-project.indicator");
    }

    public static SynapseSettings get_default ()
    {
        if (instance == null)
            instance = new SynapseSettings ();

        return instance;
    }
}

