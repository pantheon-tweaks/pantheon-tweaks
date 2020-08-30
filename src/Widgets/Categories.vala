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
 */

public class PantheonTweaks.Categories : Gtk.Paned {

    construct {
        // Left: Add PaneListItems to PaneList
        var appearance_item = new PaneListItem (PaneName.APPEARANCE);
        var fonts_item = new PaneListItem (PaneName.FONTS);
        var animations_item = new PaneListItem (PaneName.ANIMATIONS);
        var misc_item = new PaneListItem (PaneName.MISC);
        var files_item = new PaneListItem (PaneName.FILES);
        var terminal_item = new PaneListItem (PaneName.TERMINAL);
        var audience_item = new PaneListItem (PaneName.AUDIENCE);

        var pane_list = new Gtk.ListBox ();
        pane_list.set_size_request (176, 10);
        pane_list.add (appearance_item);
        pane_list.add (fonts_item);
        pane_list.add (animations_item);
        pane_list.add (misc_item);
        pane_list.add (files_item);
        pane_list.add (terminal_item);
        pane_list.add (audience_item);

        // Right: Add Pane itself to Stack
        var appearance_pane = new Panes.AppearancePane (PaneName.APPEARANCE);
        var fonts_pane = new Panes.FontsPane (PaneName.FONTS);
        var animations_pane = new Panes.AnimationsPane (PaneName.ANIMATIONS);
        var misc_pane = new Panes.MiscPane (PaneName.MISC);
        var files_pane = new Panes.FilesPane (PaneName.FILES);
        var terminal_pane = new Panes.TerminalPane (PaneName.TERMINAL);
        var audience_pane = new Panes.AudiencePane (PaneName.AUDIENCE);

        var stack = new Gtk.Stack ();
        stack.add_named (appearance_pane, PaneName.APPEARANCE.get_id ());
        stack.add_named (fonts_pane, PaneName.FONTS.get_id ());
        stack.add_named (animations_pane, PaneName.ANIMATIONS.get_id ());
        stack.add_named (misc_pane, PaneName.MISC.get_id ());
        stack.add_named (files_pane, PaneName.FILES.get_id ());
        stack.add_named (terminal_pane, PaneName.TERMINAL.get_id ());
        stack.add_named (audience_pane, PaneName.AUDIENCE.get_id ());

        pack1 (pane_list, false, false);
        add2 (stack);

        pane_list.row_selected.connect ((row) => {
            var item_id = ((Categories.PaneListItem) row).pane_name.get_id ();
            stack.visible_child_name = item_id;
        });

        pane_list.set_header_func ((row, before) => {
            if (row == appearance_item) {
                row.set_header (new Granite.HeaderLabel (_("General")));
            } else if (row == files_item) {
                row.set_header (new Granite.HeaderLabel (_("Applications")));
            }
        });
    }

    public class PaneListItem : Gtk.ListBoxRow {
        public PaneName pane_name { get; construct; }

        public PaneListItem (PaneName pane_name) {
            Object (
                pane_name: pane_name
            );
        }

        construct {
            var label = new Gtk.Label (pane_name.get_display_name ());
            label.hexpand = true;
            label.halign = Gtk.Align.START;

            var image = new Gtk.Image.from_icon_name (pane_name.get_icon_name (), Gtk.IconSize.DND);

            var rowgrid = new Gtk.Grid ();
            rowgrid.orientation = Gtk.Orientation.HORIZONTAL;
            rowgrid.column_spacing = 6;
            rowgrid.margin = 3;
            rowgrid.margin_start = 12;
            rowgrid.add (image);
            rowgrid.add (label);

            add (rowgrid);
        }
    }

    public abstract class Pane : Granite.SimpleSettingsPage {
        protected delegate void SetValue<T> (T val);
        protected delegate void Reset ();

        protected Pane (PaneName pane_name) {
            Object (
                icon_name: pane_name.get_icon_name (),
                title: pane_name.get_display_name (),
                description: pane_name.get_description ()
            );
        }

        construct {
            content_area.expand = true;
            content_area.margin_start = 60;
        }

        protected void connect_combobox (Gtk.ComboBox box, Gtk.ListStore store, SetValue<string> set_func) {
            box.changed.connect (() => {
                Value val;
                Gtk.TreeIter iter;

                box.get_active_iter (out iter);
                store.get_value (iter, 1, out val);
                set_func ((string) val);
            });
        }

        protected void connect_font_button (Gtk.FontButton button, SetValue<string> set_func) {
            button.font_set.connect (() => {
                set_func (button.font);
            });
        }

        protected void connect_spin_button (Gtk.SpinButton button, SetValue<int> set_func) {
            button.value_changed.connect (() => {
                set_func (button.get_value_as_int ());
            });
        }

        protected void connect_reset_button (Reset reset_func, bool expand = true) {
            var reset = new Gtk.LinkButton (_("Reset to default"));
            reset.can_focus = false;

            reset.activate_link.connect (() => {
                reset_func ();
                init_data ();
                return true;
            });

            action_area.add (reset);
            show_all ();
        }

        protected class SpinButton : Gtk.SpinButton {
            public SpinButton (Gtk.Adjustment adjustment) {
                Object (adjustment: adjustment);
            }

            construct {
                climb_rate = 1;
                digits = 0;
                set_size_request (150, 0);
            }
        }

        protected class Switch : Gtk.Switch {
            construct {
                halign = Gtk.Align.START;
            }
        }

        protected class ComboBox : Gtk.ComboBox {
            construct {
                set_size_request (180, 0);
                halign = Gtk.Align.START;

                var renderer = new Gtk.CellRendererText ();
                pack_start (renderer, true);
                add_attribute (renderer, "text", 0);
            }
        }

        protected class ComboBoxText : Gtk.ComboBoxText {
            construct {
                set_size_request (180, 0);
                halign = Gtk.Align.START;
            }
        }

        protected class SummaryLabel : Gtk.Label {
            public SummaryLabel (string label) {
                Object (label: label);
            }

            construct {
                halign = Gtk.Align.END;
            }
        }

        protected class DimLabel : Gtk.Label {
            public DimLabel (string label) {
                Object (label: label);
            }

            construct {
                max_width_chars = 60;
                margin_bottom = 18;
                wrap = true;
                xalign = 0;
                get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            }
        }
    }
}
