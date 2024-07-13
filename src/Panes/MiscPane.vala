/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Panes.MiscPane : Categories.Pane {
    private const string SOUND_SCHEMA = "io.elementary.desktop.wingpanel.sound";

    private GLib.Settings sound_settings;

    public MiscPane () {
        base (
            "misc", _("Miscellaneous"), "application-x-addon",
            _("Configure some other hidden settings.")
        );
    }

    construct {
        if (!if_show_pane ({ SOUND_SCHEMA })) {
            return;
        }

        sound_settings = new GLib.Settings (SOUND_SCHEMA);

        var indicator_sound_label = new Granite.HeaderLabel (_("Max Volume"));

        var max_volume_adj = new Gtk.Adjustment (0, 10, 160, 5, 10, 10);

        var max_volume_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, max_volume_adj) {
            hexpand = true,
            valign = Gtk.Align.CENTER
        };
        max_volume_scale.add_mark (100, Gtk.PositionType.BOTTOM, null);

        var max_volume_spinbutton = new Gtk.SpinButton (max_volume_adj, 1, 0);

        var max_volume_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        max_volume_box.append (max_volume_scale);
        max_volume_box.append (max_volume_spinbutton);

        content_area.attach (indicator_sound_label, 0, 0, 1, 1);
        content_area.attach (max_volume_box, 0, 1, 1, 1);

        sound_settings.bind ("max-volume", max_volume_spinbutton, "value", SettingsBindFlags.DEFAULT);
    }

    protected override bool do_reset () {
        sound_settings.reset ("max-volume");

        return true;
    }
}
