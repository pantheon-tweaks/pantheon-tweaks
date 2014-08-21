/*
 * Copyright (C) Elementary Tweaks Developers, 2014
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

namespace ElementaryTweaks {

    public class SynapseSettings : Granite.Services.Settings
    {
        public string shortcut { get; set; }

        static SynapseSettings? instance = null;

        private SynapseSettings ()
        {
            base ("net.launchpad.synapse-project.indicator");
        }

        public static SynapseSettings get_default ()
        {
            if (instance == null)
                instance = new SynapseSettings ();

            return instance;
        }
    }
}
