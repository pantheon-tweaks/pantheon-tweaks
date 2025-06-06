/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Panes.FontsPane : BasePane {
    private Gtk.FontDialogButton default_font_button;
    private Gtk.FontDialogButton document_font_button;
    private Gtk.FontDialogButton mono_font_button;
    private Gtk.FontDialogButton titlebar_font_button;

    private Settings interface_settings;
    private Settings gnome_wm_settings;

    public FontsPane () {
        Object (
            name: "fonts",
            title: _("Fonts"),
            icon: new ThemedIcon ("preferences-desktop-font"),
            description: _("Change the fonts used in your system and documents by default.")
        );
    }

    construct {
        /*************************************************/
        /* Default Font                                  */
        /*************************************************/
        var default_font_label = new Granite.HeaderLabel (_("Default Font")) {
            hexpand = true
        };

        default_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
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

        document_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
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

        mono_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
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

        titlebar_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
            valign = Gtk.Align.CENTER,
            use_font = true
        };

        var titlebar_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        titlebar_font_box.append (titlebar_font_label);
        titlebar_font_box.append (titlebar_font_button);

        content_area.append (default_font_box);
        content_area.append (document_font_box);
        content_area.append (mono_font_box);
        content_area.append (titlebar_font_box);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.INTERFACE_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.INTERFACE_SCHEMA);
            return false;
        }
        interface_settings = new Settings (SettingsUtil.INTERFACE_SCHEMA);

        if (!SettingsUtil.schema_exists (SettingsUtil.GNOME_WM_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.GNOME_WM_SCHEMA);
            return false;
        }
        gnome_wm_settings = new Settings (SettingsUtil.GNOME_WM_SCHEMA);

        interface_settings.bind_with_mapping ("font-name",
            default_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_fontbutton_fontdesc,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_fontbutton_fontdesc,
            null, null);

        interface_settings.bind_with_mapping ("document-font-name",
            document_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_fontbutton_fontdesc,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_fontbutton_fontdesc,
            null, null);

        interface_settings.bind_with_mapping ("monospace-font-name",
            mono_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_fontbutton_fontdesc,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_fontbutton_fontdesc,
            null, null);

        gnome_wm_settings.bind_with_mapping ("titlebar-font",
            titlebar_font_button, "font-desc",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_fontbutton_fontdesc,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_fontbutton_fontdesc,
            null, null);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        string[] keys = {"font-name", "document-font-name", "monospace-font-name"};

        foreach (unowned var key in keys) {
            interface_settings.reset (key);
        }

        gnome_wm_settings.reset ("titlebar-font");
    }
}
