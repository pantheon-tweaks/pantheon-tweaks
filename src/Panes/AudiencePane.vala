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
    private const string VIDEOS_SCHEMA = "io.elementary.videos";

    public AudiencePane () {
        base (_("Videos"), "multimedia-video-player");
    }

    construct {
        if (!if_show_pane ({ VIDEOS_SCHEMA })) {
            return;
        }

        var settings = new Settings (VIDEOS_SCHEMA);

        var stay_on_top_label = new SummaryLabel (_("Stay on top while playing:"));
        var stay_on_top_switch = new Switch ();

        var move_window_label = new SummaryLabel (_("Move window from video canvas:"));
        var move_window_switch = new Switch ();
        var move_window_info = new DimLabel (_("If enabled, the window can be dragged by clicking anywhere on it."));

        var playback_wait_label = new SummaryLabel (_("Don't instantly start video playback:"));
        var playback_wait_switch = new Switch ();
        var playback_wait_info = new DimLabel (_("If enabled, opening a video will not auto play it."));

        content_area.attach (stay_on_top_label, 0, 0, 1, 1);
        content_area.attach (stay_on_top_switch, 1, 0, 1, 1);
        content_area.attach (move_window_label, 0, 1, 1, 1);
        content_area.attach (move_window_switch, 1, 1, 1, 1);
        content_area.attach (move_window_info, 1, 2, 1, 1);
        content_area.attach (playback_wait_label, 0, 3, 1, 1);
        content_area.attach (playback_wait_switch, 1, 3, 1, 1);
        content_area.attach (playback_wait_info, 1, 4, 1, 1);

        show_all ();

        settings.bind ("stay-on-top", stay_on_top_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("move-window", move_window_switch, "active", SettingsBindFlags.DEFAULT);
        settings.bind ("playback-wait", playback_wait_switch, "active", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"stay-on-top", "move-window", "playback-wait"};

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
