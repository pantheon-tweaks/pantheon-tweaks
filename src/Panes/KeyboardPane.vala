/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: Pantheon Tweaks Developers, 2025
 */

public class PantheonTweaks.Panes.KeyboardPane : BasePane {
    private const string SCREENSHOT_ACCEL = "<Super><Shift>3";
    private const string AREA_SCREENSHOT_ACCEL = "<Super><Shift>4";
    private const string WINDOW_SCREENSHOT_ACCEL = "<Super><Shift>6";

    private GLib.Settings keybindings_settings;
    private ListStore altwin_items;
    private Gtk.Switch altscr_switch;

    public KeyboardPane () {
        Object (
            name: "keyboard",
            title: _("Keyboard"),
            icon: new ThemedIcon ("input-keyboard"),
            description: _("Configure keybindings.")
        );
    }

    construct {
        /*************************************************/
        /* Alt and Win Behavior                          */
        /*************************************************/
        altwin_items = new ListStore (typeof (StringIdObject));
        altwin_items.append (new StringIdObject ("default", _("Default")));
        altwin_items.append (new StringIdObject ("altwin:menu", _("Add the standard behavior to Menu key")));
        altwin_items.append (new StringIdObject ("altwin:menu_win", _("Menu is mapped to Win")));
        altwin_items.append (new StringIdObject ("altwin:meta_alt", _("Alt and Meta are on Alt")));
        altwin_items.append (new StringIdObject ("altwin:alt_win", _("Alt is mapped to Win and the usual Alt")));
        altwin_items.append (new StringIdObject ("altwin:ctrl_win", _("Ctrl is mapped to Win and the usual Ctrl")));
        altwin_items.append (new StringIdObject ("altwin:ctrl_rwin", _("Ctrl is mapped to Right Win and the usual Ctrl")));
        altwin_items.append (new StringIdObject ("altwin:ctrl_alt_win", _("Ctrl is mapped to Alt, Alt to Win")));
        altwin_items.append (new StringIdObject ("altwin:meta_win", _("Meta is mapped to Win")));
        altwin_items.append (new StringIdObject ("altwin:left_meta_win", _("Meta is mapped to Left Win")));
        altwin_items.append (new StringIdObject ("altwin:hyper_win", _("Hyper is mapped to Win")));
        altwin_items.append (new StringIdObject ("altwin:alt_super_win", _("Alt is mapped to Right Win, Super to Menu")));
        altwin_items.append (new StringIdObject ("altwin:swap_lalt_lwin", _("Left Alt is swapped with Left Win")));
        altwin_items.append (new StringIdObject ("altwin:swap_alt_win", _("Alt is swapped with Win")));
        altwin_items.append (new StringIdObject ("altwin:prtsc_rwin", _("Win is mapped to PrtSc and the usual Win")));

        var altwin_label = new Granite.HeaderLabel (_("Alt and Win Behavior")) {
            hexpand = true
        };

        var altwin_dropdown = DropDownId.new (altwin_items);

        var altwin_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        altwin_box.append (altwin_label);
        altwin_box.append (altwin_dropdown);

        /*************************************************/
        /* Alternative Screenshot Shortcut Keys          */
        /*************************************************/
        var altscr_label = new Granite.HeaderLabel (_("Alternative Screenshot Shortcut Keys")) {
            hexpand = true,
            secondary_text = _("Useful if your keyboard has no PrtSc key. If enabled, the following shortcut keys are assigned.")
        };

        altscr_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };

        var scr_accel = new Granite.AccelLabel (
            _("Grab the whole screen"), SCREENSHOT_ACCEL
        ) {
            halign = Gtk.Align.START
        };

        var area_scr_accel = new Granite.AccelLabel (
            _("Select an area to grab"), AREA_SCREENSHOT_ACCEL
        ) {
            halign = Gtk.Align.START
        };

        var window_scr_accel = new Granite.AccelLabel (
            _("Grab the current window"), WINDOW_SCREENSHOT_ACCEL
        ) {
            halign = Gtk.Align.START
        };

        var altscr_grid = new Gtk.Grid () {
            column_spacing = 12,
            row_spacing = 12
        };
        altscr_grid.attach (altscr_label, 0, 0, 1, 1);
        altscr_grid.attach (altscr_switch, 1, 0, 1, 1);
        altscr_grid.attach (scr_accel, 0, 1, 2, 1);
        altscr_grid.attach (area_scr_accel, 0, 2, 2, 1);
        altscr_grid.attach (window_scr_accel, 0, 3, 2, 1);

        content_area.append (altwin_box);
        content_area.append (altscr_grid);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.INPUT_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.INPUT_SCHEMA);
            return false;
        }
        var input_sources_settings = new GLib.Settings (SettingsUtil.INPUT_SCHEMA);

        if (!SettingsUtil.schema_exists (SettingsUtil.KEYBINDING_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.KEYBINDING_SCHEMA);
            return false;
        }
        keybindings_settings = new GLib.Settings (SettingsUtil.KEYBINDING_SCHEMA);

        // TODO bind to xkb-options settings

        altscr_switch.notify["active"].connect ((obj, pspec) => {
            var switch = (Gtk.Switch) obj;
            if (switch.active) {
                keybindings_settings.set_strv ("screenshot", { SCREENSHOT_ACCEL });
                keybindings_settings.set_strv ("area-screenshot", { AREA_SCREENSHOT_ACCEL });
                keybindings_settings.set_strv ("window-screenshot", { WINDOW_SCREENSHOT_ACCEL });
            } else {
                reset_keybindings_settings ();
            }
        });

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        reset_keybindings_settings ();
    }

    private void reset_keybindings_settings () {
        string[] keys = {"screenshot", "area-screenshot", "window-screenshot"};

        foreach (unowned var key in keys) {
            keybindings_settings.reset (key);
        }

        altscr_switch.active = false;
    }
}
