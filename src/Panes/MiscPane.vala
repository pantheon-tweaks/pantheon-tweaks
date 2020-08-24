/*
 * Copyright (C) Elementary Tweaks Developers, 2016-2020
 *               Pantheon Tweaks Developers, 2020
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
    public MiscPane () {
        base (_("Miscellaneous"), "applications-utilities");
    }

    construct {
        if (!Util.schema_exists ("io.elementary.desktop.wingpanel.sound")) {
            return;
        }

        var indicator_sound_box = new Widgets.SettingsBox ();

        var indicator_sound_label = new Granite.HeaderLabel (_("Sound Indicator"));

        var max_volume_adj = new Gtk.Adjustment (0, 10, 160, 5, 10, 10);
        var max_volume = indicator_sound_box.add_spin_button (_("Max volume"), max_volume_adj);

        grid.add (indicator_sound_label);
        grid.add (indicator_sound_box);
        grid.show_all ();

        max_volume.set_value (IndicatorSoundSettings.get_default ().max_volume);

        connect_spin_button (max_volume, (val) => {IndicatorSoundSettings.get_default ().max_volume = val;});
        connect_reset_button (() => {IndicatorSoundSettings.get_default().reset ();});
    }
}
