install_data(
    'preferences-desktop-tweaks.svg',
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', '32x32', 'categories')
)

i18n.merge_file(
    input: meson.project_name() + '.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root (), 'po'),
    install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'metainfo'),
    install: true
)
