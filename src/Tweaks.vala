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
    private PantheonTweaks.Categories categories;

    public TweaksPlug () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("tweaks", null);
        settings.set ("tweaks/appearance", "appearance");
        settings.set ("tweaks/fonts", "fonts");
        settings.set ("tweaks/animations", "animations");
        settings.set ("tweaks/misc", "misc");
        settings.set ("tweaks/files", "files");
        settings.set ("tweaks/terminal", "terminal");

        Object (
            category: Category.PERSONAL,
            code_name: "pantheon-tweaks",
            display_name: _("Tweaks"),
            description: _("Tweak Pantheon settings"),
            icon: "preferences-desktop-tweaks",
            supported_settings: settings
        );
    }

    /**
     * Returns the main Gtk.Widget that contains all of our UI for Switchboard.
     */
    public override Gtk.Widget get_widget () {
        if (categories == null) {
            categories = new Categories ();
            categories.show_all ();
        }

        return categories;
    }

    public override void shown () { }

    public override void hidden () { }

    public override void search_callback (string location) {
        categories.set_visible_view (location);
    }

    public override async Gee.TreeMap<string, string> search (string search) {
        return new Gee.TreeMap<string, string> (null, null);
    }
}

public Switchboard.Plug get_plug (Module module) {
    info ("Activating tweaks plug");
    var plug = new PantheonTweaks.TweaksPlug ();
    return plug;
}
