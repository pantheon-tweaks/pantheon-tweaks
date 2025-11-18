/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public abstract class PantheonTweaks.BasePane : Switchboard.SettingsPage {
    public signal void restored ();

    public abstract bool load ();
    protected abstract void do_reset ();

    protected bool is_load_success { get; protected set; }
    protected Gtk.Box content_area;

    protected BasePane () {
    }

    construct {
        show_end_title_buttons = true;

        is_load_success = false;

        content_area = new Gtk.Box (Gtk.Orientation.VERTICAL, 18) {
            vexpand = true,
            hexpand = true
        };
        child = content_area;

        var reset = add_button (_("Reset to Default"));

        reset.clicked.connect (on_click_reset);

        // Can't bind to this's sensitive property because the end title buttons is also included
        bind_property ("is_load_success", content_area, "sensitive", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);
        bind_property ("is_load_success", reset, "sensitive", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);
    }

    private void on_click_reset () {
        var reset_confirm_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Reset to Default?"),
            _("All settings in this pane will be restored to the factory defaults. This action can't be undone."),
            "dialog-warning", Gtk.ButtonsType.CANCEL
        ) {
            modal = true,
            transient_for = (Gtk.Window) get_root ()
        };
        var reset_button = reset_confirm_dialog.add_button (_("Reset"), Gtk.ResponseType.ACCEPT);
        reset_button.add_css_class (Granite.CssClass.DESTRUCTIVE);
        reset_confirm_dialog.response.connect ((response_id) => {
            if (response_id != Gtk.ResponseType.ACCEPT) {
                reset_confirm_dialog.destroy ();
                return;
            }

            do_reset ();
            reset_confirm_dialog.destroy ();
            restored ();
        });
        reset_confirm_dialog.present ();
    }
}
