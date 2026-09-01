project(
  'pantheon-tweaks',
  'vala', 'c',
  version: '2.5.2',
  meson_version: '>= 0.57.0',
)

valac = meson.get_compiler('vala')

# Gtk.StringList.find() is not in gtk4.vapi of valac < 0.56.19
valac_ver_min = '0.56.19'
valac_ver = valac.version()

if valac_ver.version_compare('< @0@'.format(valac_ver_min))
    error('Found valac @0@ but need: \'>= @1@\''.format(valac_ver_min, valac_ver))
endif

gettext_name = meson.project_name()
# Use this when reverse-DNS format is required
application_id = 'io.github.pantheon_tweaks.' + meson.project_name()

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments(
  '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
  language:'c',
)

subdir('data')
subdir('po')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
)
