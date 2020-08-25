/*
 * Copyright (C) Elementary Tweaks Developers, 2016 - 2020
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

public class PantheonTweaks.Panes.AudiencePane : Categories.Pane {
    private const string VIDEOS_OLD_SCHEMA = "org.pantheon.audience";
    private const string VIDEOS_NEW_SCHEMA = "io.elementary.videos";

    public AudiencePane () {
        base (_("Videos"), "multimedia-video-player");
    }

    construct {
        if (!(Util.schema_exists (VIDEOS_OLD_SCHEMA) || Util.schema_exists (VIDEOS_NEW_SCHEMA))) {
            return;
        }

        var settings = new Settings ((Util.schema_exists (VIDEOS_NEW_SCHEMA)) ? VIDEOS_NEW_SCHEMA : VIDEOS_OLD_SCHEMA);

        var behaviour = new Widgets.SettingsBox ();

        var stay_on_top = behaviour.add_switch (_("Stay on top while playing"));
        var move_window = behaviour.add_switch (_("Move window from video canvas"));
        var playback_wait = behaviour.add_switch (_("Don't instantly start video playback"));

        grid.add (behaviour);
        grid.show_all ();

        settings.bind ("stay-on-top", stay_on_top, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("move-window", move_window, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("playback-wait", playback_wait, "active", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"stay-on-top", "move-window", "playback-wait"};

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
