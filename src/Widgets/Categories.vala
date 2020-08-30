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
        var appearance_pane = new Panes.AppearancePane ();
        var fonts_pane = new Panes.FontsPane ();
        var animations_pane = new Panes.AnimationsPane ();
        var misc_pane = new Panes.MiscPane ();
        var files_pane = new Panes.FilesPane ();
        var terminal_pane = new Panes.TerminalPane ();
        var audience_pane = new Panes.AudiencePane ();

        // Left: Add PaneListItems to PaneList
        var pane_list = new Gtk.ListBox ();
        pane_list.set_size_request (176, 10);
        pane_list.add (appearance_pane.pane_list_item);
        pane_list.add (fonts_pane.pane_list_item);
        pane_list.add (animations_pane.pane_list_item);
        pane_list.add (misc_pane.pane_list_item);
        pane_list.add (files_pane.pane_list_item);
        pane_list.add (terminal_pane.pane_list_item);
        pane_list.add (audience_pane.pane_list_item);

        // Right: Add Pane itself to Stack
        var stack = new Gtk.Stack ();
        stack.add (appearance_pane);
        stack.add (fonts_pane);
        stack.add (animations_pane);
        stack.add (misc_pane);
        stack.add (files_pane);
        stack.add (terminal_pane);
        stack.add (audience_pane);

        pack1 (pane_list, false, false);
        add2 (stack);

        pane_list.row_selected.connect ((row) => {
            var list_item = ((Categories.Pane.PaneListItem) row);
            stack.visible_child = list_item.pane;
        });

        pane_list.set_header_func ((row, before) => {
            var list_item = ((Categories.Pane.PaneListItem) row);

            if (list_item.pane == appearance_pane) {
                list_item.set_header (new Granite.HeaderLabel (_("General")));
            } else if (list_item.pane == files_pane) {
                list_item.set_header (new Granite.HeaderLabel (_("Applications")));
            }
        });
    }

    public abstract class Pane : Granite.SimpleSettingsPage {
        protected delegate void SetValue<T> (T val);
        protected delegate void Reset ();

        public PaneListItem pane_list_item { get; private set; }

        protected Pane (string title, string icon_name, string? description = null) {
            Object (
                title: title,
                icon_name: icon_name,
                description: description
            );
        }

        construct {
            pane_list_item = new PaneListItem (this);

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

        protected virtual void init_data () {}

        protected class PaneListItem : Gtk.ListBoxRow {
            public Pane pane { get; construct; }

            public PaneListItem (Pane pane) {
                Object (
                    pane: pane
                );
            }
    
            construct {
                var label = new Gtk.Label (pane.title);
                label.hexpand = true;
                label.halign = Gtk.Align.START;
    
                var image = new Gtk.Image.from_icon_name (pane.icon_name, Gtk.IconSize.DND);
    
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
