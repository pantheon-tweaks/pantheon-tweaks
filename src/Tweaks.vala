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

public class PantheonTweaks.TweaksPlug : Switchboard.Plug {
    private Gtk.Paned paned;

    public TweaksPlug () {
        // init plugin stuff
        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("Tweaks", null);
        Object (category: Category.PERSONAL,
                code_name: "pantheon-tweaks",
                display_name: _("Tweaks"),
                description: _("Tweak elementary OS settings"),
                icon: "preferences-desktop-tweaks",
                supported_settings: settings);
    }

    /**
     * Returns the main Gtk.Widget that contains all of our UI for Switchboard.
     */
    public override Gtk.Widget get_widget () {
        if (paned == null) {
            paned = new Categories ();
            paned.show_all ();
        }

        return paned;
    }

    public override void shown () { }
    public override void hidden () { }
    public override void search_callback (string location) { }

    public override async Gee.TreeMap<string, string> search (string search) {
        return new Gee.TreeMap<string, string> (null, null);
    }
}

public Switchboard.Plug get_plug (Module module) {
    info ("Activating tweaks plug");
    var plug = new PantheonTweaks.TweaksPlug ();
    return plug;
}
