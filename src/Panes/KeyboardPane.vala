/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: Pantheon Tweaks Developers, 2023
 */

public class PantheonTweaks.Panes.KeyboardPane : Categories.Pane {
    private const string INPUT_SOURCES_SCHEMA = "org.gnome.desktop.input-sources";

    public KeyboardPane () {
        base (
            "keyboard", _("Keyboard"), "input-keyboard",
            _("Configure keybindings.")
        );
    }

    construct {
        if (!if_show_pane ({ INPUT_SOURCES_SCHEMA })) {
            return;
        }

        var input_sources_settings = new GLib.Settings (INPUT_SOURCES_SCHEMA);
        var altwin_items = new Gee.HashMap<string, string> ();
        altwin_items["default"] = _("Default");
        altwin_items["altwin:menu"] = _("Add the standard behavior to Menu key");
        altwin_items["altwin:menu_win"] = _("Menu is mapped to Win");
        altwin_items["altwin:meta_alt"] = _("Alt and Meta are on Alt");
        altwin_items["altwin:alt_win"] = _("Alt is mapped to Win and the usual Alt");
        altwin_items["altwin:ctrl_win"] = _("Ctrl is mapped to Win and the usual Ctrl");
        altwin_items["altwin:ctrl_rwin"] = _("Ctrl is mapped to Right Win and the usual Ctrl");
        altwin_items["altwin:ctrl_alt_win"] = _("Ctrl is mapped to Alt, Alt to Win");
        altwin_items["altwin:meta_win"] = _("Meta is mapped to Win");
        altwin_items["altwin:left_meta_win"] = _("Meta is mapped to Left Win");
        altwin_items["altwin:hyper_win"] = _("Hyper is mapped to Win");
        altwin_items["altwin:alt_super_win"] = _("Alt is mapped to Right Win, Super to Menu");
        altwin_items["altwin:swap_lalt_lwin"] = _("Left Alt is swapped with Left Win");
        altwin_items["altwin:swap_alt_win"] = _("Alt is swapped with Win");
        altwin_items["altwin:prtsc_rwin"] = _("Win is mapped to PrtSc and the usual Win");

        var altwin_label = new SummaryLabel (_("Alt and Win behavior:"));
        var altwin_combo = new ComboBoxText (altwin_items);

        var change_screenshot_key_label = new SummaryLabel (_("Alternative screenshot shortcut keys:"));
        var change_screenshot_key_switch = new Switch ();
        var change_screenshot_key_info = new DimLabel (
            _("Useful if your keyboard has no PrtSc key. If enabled, the following shortcut keys are assigned:")
        );

        var screenshot_accel = new Granite.AccelLabel (gettext_kbd("Grab the whole screen"), "<Super><Shift>3") {
            halign = Gtk.Align.START
        };
        var area_screenshot_accel = new Granite.AccelLabel (gettext_kbd("Select an area to grab"), "<Super><Shift>4") {
            halign = Gtk.Align.START
        };
        var window_screenshot_accel = new Granite.AccelLabel (gettext_kbd("Grab the current window"), "<Super><Shift>6") {
            halign = Gtk.Align.START
        };

        content_area.attach (altwin_label, 0, 0, 1, 1);
        content_area.attach (altwin_combo, 1, 0, 1, 1);
        content_area.attach (change_screenshot_key_label, 0, 2, 1, 1);
        content_area.attach (change_screenshot_key_switch, 1, 2, 1, 1);
        content_area.attach (change_screenshot_key_info, 1, 3, 1, 1);
        content_area.attach (screenshot_accel, 1, 4, 1, 1);
        content_area.attach (area_screenshot_accel, 1, 5, 1, 1);
        content_area.attach (window_screenshot_accel, 1, 6, 1, 1);

        show_all ();

        on_click_reset (() => {});
    }

    private string gettext_kbd (string msgid) {
        return dgettext ("keyboard-plug", msgid);
    }
}
