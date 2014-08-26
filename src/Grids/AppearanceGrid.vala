/*
 * Copyright (C) Elementary Tweaks Developers, 2014
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

namespace ElementaryTweaks {

    public class AppearanceGrid : Gtk.Grid
    {
        public AppearanceGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Dark theme tweak
            var prefer_dark_theme = new TweakWidget.with_switch (
                        _("Prefer Dark Theme:"), // name
                        _("GTK+ windows will now prefer the dark GTK+ theme"), // tooltip
                        _("Some applications will not react well with this enabled and can look terrible"), // warning
                        (() => { return GtkSettings.get_default ().prefer_dark_theme; }), // get
                        ((val) => { GtkSettings.get_default ().prefer_dark_theme = val; }), // set
                        (() => { GtkSettings.get_default ().prefer_dark_theme = false; }) // reset
                    );
            this.add (prefer_dark_theme);

            // Metacity theme
            var metacity_theme = new TweakWidget.with_combo_box (
                        _("Metacity Theme:"), // name
                        _("Used to render windows that do not use GTK+"), // tooltip
                        null, // warning
                        (() => { return WindowSettings.get_default ().theme; }), // get
                        ((val) => { WindowSettings.get_default ().theme = val; }), // set
                        (() => { WindowSettings.get_default ().schema.reset ("theme"); }), // reset
                        Util.get_themes_map ("themes", "metacity-1") // map
                    );
            this.add (metacity_theme);

            // Gtk+ theme
            var gtk_theme = new TweakWidget.with_combo_box (
                        _("GTK+ Theme:"), // name
                        _("Used to render GTK+ windows like Switchboard"), // tooltip
                        null, // warning
                        (() => { return InterfaceSettings.get_default ().gtk_theme; }), // get
                        ((val) => { InterfaceSettings.get_default ().gtk_theme = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("gtk-theme"); }), // reset
                        Util.get_themes_map ("themes", "gtk-3.0") // map
                    );
            this.add (gtk_theme);

            // Icon theme
            var icon_theme = new TweakWidget.with_combo_box (
                        _("Icon Theme:"), // name
                        _("Used to theme the icon set, including application icons"), // tooltip
                        null, // warning
                        (() => { return InterfaceSettings.get_default ().icon_theme; }), // get
                        ((val) => { InterfaceSettings.get_default ().icon_theme = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("icon-theme"); }), // reset
                        Util.get_themes_map ("icons", "index.theme") // map
                    );
            this.add (icon_theme);

            // Cursor theme
            var cursor_theme = new TweakWidget.with_combo_box (
                        _("Cursor Theme:"), // name
                        _("Used to theme the cursor"), // tooltip
                        null, // warning
                        (() => { return InterfaceSettings.get_default ().cursor_theme; }), // get
                        ((val) => { InterfaceSettings.get_default ().cursor_theme = val; }), // set
                        (() => { InterfaceSettings.get_default ().schema.reset ("cursor-theme"); }), // reset
                        Util.get_themes_map ("icons", "cursors") // map
                    );
            this.add (cursor_theme);

            // TODO: redo this so that it works and isn't.. like this.
            /*
            var button_layout_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var button_layout = new Gtk.ComboBoxText ();
            var custom_layout_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var custom_layout = new Gtk.Entry();
            var custom_text = new LLabel.right (_("Custom Layout:"));

            button_layout.append ("close:maximize", ("elementary"));
            button_layout.append (":close", _("Close Only"));
            button_layout.append ("close,minimize:maximize", _("Minimize Left"));
            button_layout.append ("close:minimize,maximize", _("Minimize Right"));
            button_layout.append (":minimize,maximize,close", _("Windows"));
            button_layout.append ("close,minimize,maximize:", _("OS X"));
            button_layout.append ("custom", _("Custom"));

            if ( AppearanceSettings.get_default ().button_layout == "close:maximize" ||
                    AppearanceSettings.get_default ().button_layout == ":close" ||
                    AppearanceSettings.get_default ().button_layout == "close,minimize:maximize" ||
                    AppearanceSettings.get_default ().button_layout == "close:minimize,maximize" ||
                    AppearanceSettings.get_default ().button_layout == ":minimize,maximize,close" ||
                    AppearanceSettings.get_default ().button_layout == "close,minimize,maximize:")
                button_layout.active_id = AppearanceSettings.get_default ().button_layout;
            else
                button_layout.active_id = "custom";

            custom_layout.text = AppearanceSettings.get_default ().button_layout;

            if ( button_layout.active_id == "custom" ) {
                custom_layout_box.set_sensitive(true);
                custom_text.set_sensitive(true);
            } else {
                custom_layout_box.set_sensitive(false);
                custom_text.set_sensitive(false);
            }

            button_layout.changed.connect (() => {
                    if ( button_layout.active_id == "custom" ) {
                    custom_layout_box.set_sensitive(true);
                    custom_text.set_sensitive(true);
                    } else {
                    custom_layout_box.set_sensitive(false);
                    custom_text.set_sensitive(false);
                    AppearanceSettings.get_default ().button_layout = button_layout.active_id;
                    custom_layout.text = AppearanceSettings.get_default ().button_layout;
                    }
                    });
            button_layout.halign = Gtk.Align.START;
            button_layout.width_request = 160;

            custom_layout.activate.connect (() => AppearanceSettings.get_default ().button_layout = custom_layout.text);
            custom_layout.halign = Gtk.Align.START;
            custom_layout.width_request = 160;

            var button_layout_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            button_layout_default.clicked.connect (() => {
                    AppearanceSettings.get_default ().schema.reset ("button-layout");
                    button_layout.active_id = AppearanceSettings.get_default ().button_layout;
                    });
            button_layout_default.halign = Gtk.Align.START;

            button_layout_box.pack_start (button_layout, false);
            button_layout_box.pack_start (button_layout_default, false);

            var custom_layout_apply = new Gtk.ToolButton.from_stock (Gtk.Stock.APPLY);
            custom_layout_apply.clicked.connect (() => AppearanceSettings.get_default ().button_layout = custom_layout.text);

            custom_layout_box.pack_start (custom_layout, false);
            custom_layout_box.pack_start (custom_layout_apply, false);


            this.attach (new LLabel.right (_("Button Layout:")), 0, 5, 2, 1);
            this.attach (button_layout_box, 2, 5, 2, 1);

            this.attach (custom_text, 0, 6, 2, 1);
            this.attach (custom_layout_box, 2, 6, 2, 1);
            */
        }
    }
}
