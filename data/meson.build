# FIXME: We need more size variants (48px, 64px, and 128px) if we want to publish to AppCenter:
# https://docs.elementary.io/develop/appcenter/publishing-requirements#icons
install_data(
    'preferences-desktop-tweaks.svg',
    rename: 'com.github.pantheon_tweaks.pantheon-tweaks.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / '32x32' / 'apps'
)

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
