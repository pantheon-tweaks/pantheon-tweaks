//  
//  Copyright (C) 2013 Michael Langfermann, Tom Beckmann
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 


public class TweaksPlug : Pantheon.Switchboard.Plug
{
    public TweaksPlug ()
    {
        /* Notebook */
        var notebook = new Granite.Widgets.StaticNotebook (false);
        notebook.set_margin_top (12);

        /* Appearances Tab */
        notebook.append_page (new AppearanceGrid (), new Gtk.Label (_("Appearance")));

        /* Font Tab*/
        notebook.append_page (new FontsGrid (), new Gtk.Label (_("Fonts")));

        /* Animations Tab */
        notebook.append_page (new AnimationsGrid (), new Gtk.Label (_("Animations")));

        /* Shadows Tab*/
        notebook.append_page (new ShadowsGrid (), new Gtk.Label (_("Shadows")));

        /* Dock Tab*/
        notebook.append_page (new DockGrid (), new Gtk.Label (_("Dock")));

        /* Misc Tab*/
        notebook.append_page (new MiscGrid (), new Gtk.Label (_("Miscellaneous")));

        /* Add Tabs to Notebook*/
        add (notebook);
    }
}



public static int main (string[] args) {

    Gtk.init (ref args);

    var plug = new TweaksPlug ();
    plug.register ("Tweaks");
    plug.show_all ();

    Gtk.main ();
    return 0;
}

