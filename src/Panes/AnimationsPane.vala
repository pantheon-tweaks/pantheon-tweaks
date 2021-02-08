/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2020
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

public class PantheonTweaks.Panes.AnimationsPane : Categories.Pane {
    private const string ANIMATIONS_SCHEMA = "org.pantheon.desktop.gala.animations";

    public AnimationsPane () {
        base (
            _("Animations"), "go-jump",
            _("Adjust the animation length used for window management or multitasking.")
        );
    }

    construct {
        if (!if_show_pane ({ ANIMATIONS_SCHEMA })) {
            return;
        }

        var settings = new GLib.Settings (ANIMATIONS_SCHEMA);

        var open_duration_label = new SummaryLabel (_("Open:"));
        var open_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var open_duration_spinbutton = new SpinButton (open_adj);

        var close_duration_label = new SummaryLabel (_("Close:"));
        var close_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var close_duration_spinbutton = new SpinButton (close_adj);

        var snap_duration_label = new SummaryLabel (_("Snap:"));
        var snap_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var snap_duration_spinbutton = new SpinButton (snap_adj);

        var minimize_duration_label = new SummaryLabel (_("Minimize:"));
        var minimize_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var minimize_duration_spinbutton = new SpinButton (minimize_adj);

        var workspace_duration_label = new SummaryLabel (_("Workspace switch:"));
        var workspace_adj = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);
        var workspace_duration_spinbutton = new SpinButton (workspace_adj);

        content_area.attach (open_duration_label, 0, 0, 1, 1);
        content_area.attach (open_duration_spinbutton, 1, 0, 1, 1);
        content_area.attach (close_duration_label, 0, 1, 1, 1);
        content_area.attach (close_duration_spinbutton, 1, 1, 1, 1);
        content_area.attach (snap_duration_label, 0, 2, 1, 1);
        content_area.attach (snap_duration_spinbutton, 1, 2, 1, 1);
        content_area.attach (minimize_duration_label, 0, 3, 1, 1);
        content_area.attach (minimize_duration_spinbutton, 1, 3, 1, 1);
        content_area.attach (workspace_duration_label, 0, 4, 1, 1);
        content_area.attach (workspace_duration_spinbutton, 1, 4, 1, 1);

        show_all ();

        settings.bind ("open-duration", open_duration_spinbutton, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("close-duration", close_duration_spinbutton, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("snap-duration", snap_duration_spinbutton, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("minimize-duration", minimize_duration_spinbutton, "value", SettingsBindFlags.DEFAULT);
        settings.bind ("workspace-switch-duration", workspace_duration_spinbutton, "value", SettingsBindFlags.DEFAULT);

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
