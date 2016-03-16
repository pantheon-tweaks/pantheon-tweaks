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

namespace ElementaryTweaks {

    public class AppearanceGrid : Gtk.Grid
    {
        private TweakWidget custom_layout; // stupid closure won't 'see' the widget unless it's non-local

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

            this.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

            // Custom layout
            custom_layout = new TweakWidget.with_entry (
                        _("Custom Layout:"), // name
                        _("Custom window control layout"), // tooltip
                        null, // warning
                        (() => { return AppearanceSettings.get_default ().button_layout; }), // get
                        ((val) => {
                                AppearanceSettings.get_default ().button_layout = val;
                                XSettings.get_default ().decoration_layout = val;
                            }), // set
                        (() => {
                                AppearanceSettings.get_default ().schema.reset ("button-layout");
                                XSettings.get_default ().reset ();
                            }) // reset
                    );

            // Window Controls
            var window_controls_map = AppearanceSettings.get_preset_button_layouts ();
            var window_controls = new TweakWidget.with_combo_box (
                        _("Window Controls:"), // name
                        _("Controls located at the top of the window for close, minimize, and maximize"), // tooltip
                        _("May break window controls! May stop working with updates to system!"), // warning
                        (() => {
                                if (!AppearanceSettings.get_preset_button_layouts ().has_key (AppearanceSettings.get_default ().button_layout)) {
                                    custom_layout.sensitive = true;
                                    return "custom";
                                }
                                custom_layout.sensitive = false;
                                return AppearanceSettings.get_default ().button_layout;
                            }), // get
                        ((val) => {
                                if (val == "custom") {
                                    // activate entry box
                                    custom_layout.sensitive = true;
                                }
                                else {
                                    // deactivate entry box
                                    custom_layout.sensitive = false;
                                    AppearanceSettings.get_default ().button_layout = val;
                                    XSettings.get_default ().decoration_layout = val;
                                    custom_layout.text = val ;
                                }
                            }), // set
                        (() => {
                                AppearanceSettings.get_default ().schema.reset ("button-layout");
                                XSettings.get_default ().reset ();
                            }), // reset
                        window_controls_map
                    );
            this.add (window_controls);
            this.add (custom_layout);
        }
    }
}
