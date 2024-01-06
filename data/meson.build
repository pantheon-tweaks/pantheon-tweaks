icon_sizes = ['32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        'icons' / i / meson.project_name() + '.svg',
        rename: 'com.github.pantheon_tweaks.pantheon-tweaks.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps'
    )
endforeach

i18n.merge_file(
    input: meson.project_name() + '.desktop.in',
    output: 'com.github.pantheon_tweaks.pantheon-tweaks.desktop',
    po_dir: meson.source_root () / 'po',
    type: 'desktop',
    install_dir: get_option('prefix') / get_option('datadir') / 'applications',
    install: true
)

i18n.merge_file(
    input: meson.project_name() + '.metainfo.xml.in',
    output: 'com.github.pantheon-tweaks.pantheon-tweaks.metainfo.xml',
    po_dir: meson.source_root () / 'po',
    install_dir: get_option('prefix') / get_option('datadir') / 'metainfo',
    install: true
)
