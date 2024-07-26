icon_sizes = ['32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        'icons' / i / meson.project_name() + '.svg',
        rename: application_id + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps'
    )
endforeach

i18n.merge_file(
    input: meson.project_name() + '.desktop.in',
    output: application_id + '.desktop',
    po_dir: meson.project_source_root () / 'po',
    type: 'desktop',
    install_dir: get_option('prefix') / get_option('datadir') / 'applications',
    install: true
)

i18n.merge_file(
    input: meson.project_name() + '.metainfo.xml.in',
    output: application_id + '.metainfo.xml',
    po_dir: meson.project_source_root () / 'po',
    install_dir: get_option('prefix') / get_option('datadir') / 'metainfo',
    install: true
)

install_data(
    'pantheon-tweaks.gschema.xml',
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas'
)

subdir('styles')
