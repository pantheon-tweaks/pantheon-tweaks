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
        
        var notebook = new Granite.Widgets.StaticNotebook (false);
        notebook.set_margin_top (12);        

        /* Appearances Tab */
        var app_grid = new AppearanceGrid ();
        notebook.append_page (app_grid, new Gtk.Label (_("Appearance")));

        /* Font Tab*/
        var font_grid = new FontsGrid ();
        notebook.append_page (font_grid, new Gtk.Label (_("Fonts")));

        /* Animations Tab */
        var anim_grid = new AnimationsGrid ();
        notebook.append_page (anim_grid, new Gtk.Label (_("Animations")));


        /* Shadows*/
        var sha_grid = new ShadowsGrid ();
        notebook.append_page (sha_grid, new Gtk.Label (_("Shadows")));

        
        /* Dock Tab*/
        var dock_grid = new DockGrid ();
        notebook.append_page (dock_grid, new Gtk.Label (_("Dock")));



        /* Misc Tab*/
        var misc_grid = new MiscGrid ();
        notebook.append_page (misc_grid, new Gtk.Label (_("Miscellaneous")));


        /* Add Tabs */
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

