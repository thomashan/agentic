macos-latest has no support for nested virtualisation, so we can't run Docker in the runners since docker-desktop, colima, podman all require VM to run containers there is no definitive answer on this in github but these
are good starting points:

* https://github.com/orgs/community/discussions/160591
* https://github.com/actions/runner-images/blob/main/images/macos/macos-15-arm64-Readme.md
* https://github.com/actions/runner-images/issues/12933
