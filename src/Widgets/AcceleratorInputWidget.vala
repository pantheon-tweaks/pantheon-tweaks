/*
 * Copyright (C) Elementary Tweak Developers, 2014
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

namespace ElementaryTweak {

    public class AcceleratorInput : Gtk.ToggleButton
    {
        bool waiting = false;
        string old_label = "";
        uint key_val;
        Gdk.ModifierType mod_type;

        public signal void accelerator_set (uint keyval, Gdk.ModifierType mods);

        public AcceleratorInput ()
        {
            set_accelerator (0, 0, 0);
            width_request = 120;
        }

        public string get_accelerator_from_string()
        {
            return Gtk.accelerator_name (key_val, mod_type).replace("<Hyper>", "");
        }

        public override void toggled ()
        {
            if (active) {
                Gtk.grab_add (this);
                old_label = label;
                label = "Enter Shortcut...";
            } else if (waiting) {
                Gtk.grab_remove (this);
            }
            waiting = active;
        }

        public override bool key_press_event (Gdk.EventKey event)
        {
            if (!waiting || event.is_modifier == 1)
                return false;

            if (event.keyval == Gdk.Key.Escape ) {
                active = false;
                label = old_label;
                return false;
            } else if (event.keyval == Gdk.Key.BackSpace) {
                active = false;
                set_accelerator (0, 0);
                return false;
            }

            key_val = Gdk.keyval_to_lower (event.keyval);
            mod_type = event.state & Gtk.accelerator_get_default_mod_mask ();

            if (!Gtk.accelerator_valid (key_val, mod_type)) {
                error_bell ();
                return false;
            }

            set_accelerator (key_val, mod_type, event.hardware_keycode);
            active = false;

            return false;
        }

        public void set_accelerator (uint key, Gdk.ModifierType mods, uint hardware_keycode = 0)
        {
            accelerator_set (key, mods);

            if (!valid()) {
                label = _("Disabled");
                return;
            }

            label = to_readable();
        }

        public void set_accelerator_from_string (string accelerator)
        {
            key_val = 0;
            mod_type = 0;
            Gtk.accelerator_parse (accelerator, out key_val, out mod_type);
            set_accelerator (key_val, mod_type);
        }

        public string to_readable  ()
        {
            if (!valid())
                return _("Disabled");

            string tmp = "";
            string SEPARATOR = " · ";

            if ((mod_type & Gdk.ModifierType.SHIFT_MASK) > 0)
                tmp += "⇧" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.SUPER_MASK) > 0)
                tmp += "⌘" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.CONTROL_MASK) > 0)
                tmp += "Ctrl" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.MOD1_MASK) > 0)
                tmp += "⎇" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.MOD2_MASK) > 0)
                tmp += "Mod2" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.MOD3_MASK) > 0)
                tmp += "Mod3" + SEPARATOR;
            if ((mod_type & Gdk.ModifierType.MOD4_MASK) > 0)
                tmp += "Mod4" + SEPARATOR;

            switch (key_val) {

                case Gdk.Key.Tab:   tmp += "↹"; break;
                case Gdk.Key.Up:    tmp += "↑"; break;
                case Gdk.Key.Down:  tmp += "↓"; break;
                case Gdk.Key.Left:  tmp += "←"; break;
                case Gdk.Key.Right: tmp += "→"; break;
                default:
                                    tmp += Gtk.accelerator_get_label (key_val, 0);
                                    break;
            }

            return tmp;
        }

        public bool valid()
        {
            if (key_val == 0)
                return false;

            if (mod_type == 0 || mod_type == Gdk.ModifierType.SHIFT_MASK)
            {
                if ((key_val >= Gdk.Key.a                    && key_val <= Gdk.Key.z)
                        || (key_val >= Gdk.Key.A                    && key_val <= Gdk.Key.Z)
                        || (key_val >= Gdk.Key.@0                   && key_val <= Gdk.Key.@9)
                        || (key_val >= Gdk.Key.kana_fullstop        && key_val <= Gdk.Key.semivoicedsound)
                        || (key_val >= Gdk.Key.Arabic_comma         && key_val <= Gdk.Key.Arabic_sukun)
                        || (key_val >= Gdk.Key.Serbian_dje          && key_val <= Gdk.Key.Cyrillic_HARDSIGN)
                        || (key_val >= Gdk.Key.Greek_ALPHAaccent    && key_val <= Gdk.Key.Greek_omega)
                        || (key_val >= Gdk.Key.hebrew_doublelowline && key_val <= Gdk.Key.hebrew_taf)
                        || (key_val >= Gdk.Key.Thai_kokai           && key_val <= Gdk.Key.Thai_lekkao)
                        || (key_val >= Gdk.Key.Hangul               && key_val <= Gdk.Key.Hangul_Special)
                        || (key_val >= Gdk.Key.Hangul_Kiyeog        && key_val <= Gdk.Key.Hangul_J_YeorinHieuh))
                {
                    return false;
                }
            }
            return true;
        }

    }
}
