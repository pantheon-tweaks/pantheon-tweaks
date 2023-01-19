install_data(
    'preferences-desktop-tweaks.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / '32x32' / 'categories'
)

i18n.merge_file(
    input: meson.project_name() + '.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: meson.source_root () / 'po',
    install_dir: get_option('prefix') / get_option('datadir') / 'metainfo',
    install: true
)
