# Changelog

## added/modified:

* feature/project-template: C and C++ projects with debug.h, a main that prints --help and the --version from VERSION, a Makefile with build, format, test and zig release targets, a dev container with the toolchain, the shared CI, and code laid out to the NASA SEL C Style Guide.
* fix/devcontainer-timezone: the dev container, and CI with it, starts on hosts that have no /etc/timezone.
* fix/bash-history-mount: shell history in the dev container persists between sessions.
* fix/dockerfile-workdir: copier update no longer conflicts on the Dockerfile; existing projects resolve it once on their next update.
* feature/root-answers-file: generated projects keep their Copier answers in `.copier-cxx-answers.yml` at the root rather than in `.copier-generic-project/`; existing projects move the file once before their next update.
* feature/plain-version: VERSION holds a plain X.Y.Z here and in generated projects, with CI adding the v for tags; existing projects remove the v from VERSION once.
