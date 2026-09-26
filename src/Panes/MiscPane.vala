/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

public class PantheonTweaks.Panes.MiscPane : BasePane {
    private const int SPIN_BUTTON_STEP_INCREMENT = 1;
    private const int SPIN_BUTTON_PAGE_INCREMENT = 10;
    private const int SPIN_BUTTON_PAGE_SIZE = 10;

    private const string SCHEMA_ID_MUTTER = "org.gnome.mutter";
    private const string SCHEMA_KEY_CHECK_ALIVE_TIMEOUT = "check-alive-timeout";

    private const uint CHECK_ALIVE_TIMEOUT_DEFAULT = 5000;
    private const uint CHECK_ALIVE_TIMEOUT_MIN = uint.MIN;
    private const uint CHECK_ALIVE_TIMEOUT_MAX = uint.MAX;

    private Gtk.SpinButton max_volume_spinbutton;
    private Gtk.SpinButton check_alive_timeout_spinbutton;

    private Settings sound_settings;
    private Settings mutter_settings;

    public MiscPane () {
        Object (
            name: "misc",
            title: _("Miscellaneous"),
            icon: new ThemedIcon ("application-x-addon"),
            description: _("Configure some other hidden settings.")
        );
    }

    construct {
        /*************************************************/
        /* Max Volume                                    */
        /*************************************************/
        var indicator_sound_label = new Granite.HeaderLabel (_("Max Volume"));

        var max_volume_adj = new Gtk.Adjustment (0, 10, 160, 5, 10, 10);

        var max_volume_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, max_volume_adj) {
            hexpand = true,
            valign = Gtk.Align.CENTER
        };
        max_volume_scale.add_mark (100, Gtk.PositionType.BOTTOM, null);

        max_volume_spinbutton = new Gtk.SpinButton (max_volume_adj, 1, 0) {
            valign = Gtk.Align.CENTER
        };

        var max_volume_box = new Granite.Box (Gtk.Orientation.HORIZONTAL);
        max_volume_box.append (max_volume_scale);
        max_volume_box.append (max_volume_spinbutton);

        /*************************************************/
        /* Check Alive Timeout                           */
        /*************************************************/
        var check_alive_timeout_label = new Granite.HeaderLabel (_("Check Alive Timeout")) {
            secondary_text = _("Number of milliseconds an app has to respond to a ping request from Mutter. If it doesn't, “Application is not responding” dialog appears. Setting to 0 disables this feature."),
        };

        var check_alive_timeout_adj = new Gtk.Adjustment (CHECK_ALIVE_TIMEOUT_DEFAULT,
                                                          CHECK_ALIVE_TIMEOUT_MIN,
                                                          CHECK_ALIVE_TIMEOUT_MAX,
                                                          SPIN_BUTTON_STEP_INCREMENT,
                                                          SPIN_BUTTON_PAGE_INCREMENT,
                                                          SPIN_BUTTON_PAGE_SIZE);

        var check_alive_timeout_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, check_alive_timeout_adj) {
            hexpand = true,
            valign = Gtk.Align.CENTER
        };
        check_alive_timeout_scale.add_mark (CHECK_ALIVE_TIMEOUT_MIN, Gtk.PositionType.BOTTOM, _("Disabled"));
        check_alive_timeout_scale.add_mark (CHECK_ALIVE_TIMEOUT_MAX, Gtk.PositionType.BOTTOM, _("Max"));

        check_alive_timeout_spinbutton = new Gtk.SpinButton (check_alive_timeout_adj, SPIN_BUTTON_STEP_INCREMENT, 0) {
            valign = Gtk.Align.CENTER
        };

        var check_alive_timeout_box = new Granite.Box (Gtk.Orientation.HORIZONTAL);
        check_alive_timeout_box.append (check_alive_timeout_scale);
        check_alive_timeout_box.append (check_alive_timeout_spinbutton);

        content_area.append (indicator_sound_label);
        content_area.append (max_volume_box);
        content_area.append (check_alive_timeout_label);
        content_area.append (check_alive_timeout_box);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.PANEL_SOUND_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.PANEL_SOUND_SCHEMA);
            return false;
        }
        sound_settings = new Settings (SettingsUtil.PANEL_SOUND_SCHEMA);

        sound_settings.bind ("max-volume", max_volume_spinbutton, "value", SettingsBindFlags.DEFAULT);

        if (!SettingsUtil.schema_exists (SCHEMA_ID_MUTTER)) {
            warning ("Could not find settings schema %s", SCHEMA_ID_MUTTER);
            return false;
        }
        mutter_settings = new Settings (SCHEMA_ID_MUTTER);

        mutter_settings.bind (SCHEMA_KEY_CHECK_ALIVE_TIMEOUT, check_alive_timeout_spinbutton, "value", SettingsBindFlags.DEFAULT);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        sound_settings.reset ("max-volume");

        mutter_settings.reset (SCHEMA_KEY_CHECK_ALIVE_TIMEOUT);
    }
}
