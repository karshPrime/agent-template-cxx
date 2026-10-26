# Changelog

## Added

* 2.0.2
   * the changelog lists changes under the version they were released in, newest first
* 2.0.1
   * a shorter README with the right copy command, gh:karshosphere/template-cxx
   * the first commit of a new project links to this template
* 2.0.0
   * VERSION holds a plain X.Y.Z here and in generated projects, with CI adding the v for tags
   * existing projects remove the v from VERSION once
* 1.1.1
   * copier update no longer conflicts on the Dockerfile
   * existing projects resolve it once on their next update
* 1.1.0
   * generated projects keep their Copier answers in `.copier-cxx-answers.yml` at the root rather than in `.copier-generic-project/`
   * existing projects move the file once before their next update
* 1.0.2
   * shell history in the dev container persists between sessions
* 1.0.1
   * the dev container, and CI with it, starts on hosts that have no /etc/timezone
* 1.0.0
   * C and C++ projects with debug.h and code laid out to the NASA SEL C Style Guide
   * a main that prints --help and the --version from VERSION
   * a Makefile with build, format, test and zig release targets
   * a dev container with the toolchain
   * the shared CI
