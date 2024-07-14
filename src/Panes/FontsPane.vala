/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Panes.FontsPane : Categories.Pane {
    private GLib.Settings interface_settings;
    private GLib.Settings window_settings;

    public FontsPane () {
        base (
            "fonts", _("Fonts"), "preferences-desktop-font",
            _("Change the fonts used in your system and documents by default.")
        );
    }

    construct {
        interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        window_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        /*************************************************/
        /* Default Font                                  */
        /*************************************************/
        var default_font_label = new Granite.HeaderLabel (_("Default Font")) {
            hexpand = true
        };
        var default_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true
        };
        var default_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        default_font_box.append (default_font_label);
        default_font_box.append (default_font_button);

        /*************************************************/
        /* Docuemnt Font                                 */
        /*************************************************/
        var document_font_label = new Granite.HeaderLabel (_("Document Font")) {
            hexpand = true
        };
        var document_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true
        };
        var document_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        document_font_box.append (document_font_label);
        document_font_box.append (document_font_button);

        /*************************************************/
        /* Monospace Font                                */
        /*************************************************/
        var mono_font_label = new Granite.HeaderLabel (_("Monospace Font")) {
            hexpand = true
        };
        var mono_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true,
        };
        var mono_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        mono_font_box.append (mono_font_label);
        mono_font_box.append (mono_font_button);

        /*************************************************/
        /* Titlebar Font                                 */
        /*************************************************/
        var titlebar_font_label = new Granite.HeaderLabel (_("Titlebar Font")) {
            hexpand = true
        };
        var titlebar_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true
        };
        var titlebar_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        titlebar_font_box.append (titlebar_font_label);
        titlebar_font_box.append (titlebar_font_button);

        content_area.attach (default_font_box, 0, 0, 1, 1);
        content_area.attach (document_font_box, 0, 1, 1, 1);
        content_area.attach (mono_font_box, 0, 2, 1, 1);
        content_area.attach (titlebar_font_box, 0, 3, 1, 1);

        interface_settings.bind_with_mapping ("font-name", default_font_button, "font-desc", SettingsBindFlags.DEFAULT,
                font_button_bind_get, font_button_bind_set, null, null);
        interface_settings.bind_with_mapping ("document-font-name", document_font_button, "font-desc", SettingsBindFlags.DEFAULT,
                font_button_bind_get, font_button_bind_set, null, null);
        interface_settings.bind_with_mapping ("monospace-font-name", mono_font_button, "font-desc", SettingsBindFlags.DEFAULT,
                font_button_bind_get, font_button_bind_set, null, null);
        window_settings.bind_with_mapping ("titlebar-font", titlebar_font_button, "font-desc", SettingsBindFlags.DEFAULT,
                font_button_bind_get, font_button_bind_set, null, null);
    }

    protected override void do_reset () {
        string[] keys = {"font-name", "document-font-name", "monospace-font-name"};

        foreach (var key in keys) {
            interface_settings.reset (key);
        }

        window_settings.reset ("titlebar-font");
    }
}
