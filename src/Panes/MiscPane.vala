/*
 * Copyright (C) Elementary Tweaks Developers, 2016-2020
 *               Pantheon Tweaks Developers, 2020 - 2022
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
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

        var max_volume_label = summary_label_new (_("Max volume:"));
        var max_volume_adj = new Gtk.Adjustment (0, 10, 160, 5, 10, 10);
        var max_volume_spinbutton = spin_button_new (max_volume_adj);

        content_area.attach (indicator_sound_label, 0, 0, 1, 1);
        content_area.attach (max_volume_label, 0, 1, 1, 1);
        content_area.attach (max_volume_spinbutton, 1, 1, 1, 1);

        sound_settings.bind ("max-volume", max_volume_spinbutton, "value", SettingsBindFlags.DEFAULT);

        on_click_reset (() => {sound_settings.reset ("max-volume");});
    }
}
