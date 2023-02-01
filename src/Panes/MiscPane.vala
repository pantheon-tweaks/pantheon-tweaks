/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2023
 */

public class PantheonTweaks.Panes.MiscPane : Categories.Pane {
    private const string SOUND_SCHEMA = "io.elementary.desktop.wingpanel.sound";

    public MiscPane () {
        base (
            _("Miscellaneous"), "applications-utilities",
            _("Configure some other hidden settings.")
        );
    }

    construct {
        if (!if_show_pane ({ SOUND_SCHEMA })) {
            return;
        }

        var sound_settings = new GLib.Settings (SOUND_SCHEMA);

        var indicator_sound_label = new Granite.HeaderLabel (_("Sound Indicator"));

        var max_volume_label = new SummaryLabel (_("Max volume:"));
        var max_volume_adj = new Gtk.Adjustment (0, 10, 160, 5, 10, 10);
        var max_volume_spinbutton = new SpinButton (max_volume_adj);

        content_area.attach (indicator_sound_label, 0, 0, 1, 1);
        content_area.attach (max_volume_label, 0, 1, 1, 1);
        content_area.attach (max_volume_spinbutton, 1, 1, 1, 1);

        show_all ();

        sound_settings.bind ("max-volume", max_volume_spinbutton, "value", SettingsBindFlags.DEFAULT);

        on_click_reset (() => {sound_settings.reset ("max-volume");});
    }
}
