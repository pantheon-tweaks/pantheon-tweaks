/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
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

public class PantheonTweaks.Panes.AnimationsPane : Categories.Pane {
    private const string ANIMATIONS_SCHEMA = "org.pantheon.desktop.gala.animations";

    public AnimationsPane () {
        base (_("Animations"), "go-jump");
    }

    construct {
        if (!Util.schema_exists (ANIMATIONS_SCHEMA)) {
            return;
        }

        var settings = new GLib.Settings (ANIMATIONS_SCHEMA);

        var animations_box = new Widgets.SettingsBox ();

        var duration_label = new Granite.HeaderLabel (_("Duration"));

        var open_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var close_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var snap_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var minimize_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var workspace_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
    
        var open_duration = animations_box.add_spin_button (_("Open"), open_adj);
        var close_duration = animations_box.add_spin_button (_("Close"), close_adj);
        var snap_duration = animations_box.add_spin_button (_("Snap"), snap_adj);
        var minimize_duration = animations_box.add_spin_button (_("Minimize"), minimize_adj);
        var workspace_duration = animations_box.add_spin_button (_("Workspace switch"), workspace_adj);

        grid.add (duration_label);
        grid.add (animations_box);

        grid.show_all ();

        settings.bind ("open-duration", open_duration, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("close-duration", close_duration, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("snap-duration", snap_duration, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("minimize-duration", minimize_duration, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("workspace-switch-duration", workspace_duration, "value", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {
                "enable-animations", "open-duration", "snap-duration",
                "minimize-duration", "close-duration", "workspace-switch-duration"
            };

            foreach (var key in keys) {
                settings.reset (key);
            }
        });
    }
}
