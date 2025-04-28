# Release Flow
## Work in Project Repository
- Repository URL: https://github.com/pantheon-tweaks/pantheon-tweaks
- Decide the version number of the release
    - Versioning should follow [Semantic Versioning](https://semver.org/)
- Create a new branch named `release-X.Y.Z` from latest `origin/main` (`X.Y.Z` is the version number)
- See changes since the previous release  
    ```
    $ git diff $(git describe --tags --abbrev=0)..release-X.Y.Z
    ```
- Update screenshots if there are visual changes between releases
- Create a pull request with the following changes and merge it once the build succeeds
    - Write a release note in `data/pantheon-tweaks.metainfo.xml.in.in`
        - Refer to [the Metainfo guidelines by Flathub](https://docs.flathub.org/docs/for-app-authors/metainfo-guidelines)
        - Credits contributors with their GitHub username
    - Bump `version` in `meson.build`  
    ```meson
    project(
        'pantheon-tweaks',
        'vala', 'c',
        version: '2.2.0',
        meson_version: '>= 0.57.0'
    )
    ```
- [Create a new release on GitHub](https://github.com/pantheon-tweaks/pantheon-tweaks/releases/new)
    - Create a new tag named `X.Y.Z`
    - Release title: `<Project Name> X.Y.Z Released`
    - Publish it when completed

## Work in Flathub Repository
- Repository URL: https://github.com/flathub/io.github.pantheon_tweaks.pantheon-tweaks
- Create a new branch named `release-X.Y.Z` from latest `origin/master`
- Create a pull request with the following changes and merge it once the build succeeds
    - Sync the content of the manifest file with the upstream except for the project module
    - Change `tag` and `commit` of the project module in the manifest file
        - These two parameters should point to the tag/revision that we published on the project repository
- The new release should be available on Flathub after some time
