
# C/C++ Template

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)

This repository provides a template for creating C and C++ project skeletons. It got a consistent and reproducible starting point which makes it easier to apply improvements when the template is updated.


### Prerequisites

Install the Copier command:
* **Quick option:** `uv tool install copier`
* **Documentation:** https://copier.readthedocs.io/en/stable


### Create New Project

Run the following command:

```bash
$ copier copy --trust gh:karshosphere/template-cxx path/to/project
```
* **Project Description:** Answer the Copier prompt with an optional plain‑text description of your project.
* **Language:** C (`src/main.c`, gnu11) or C++ (`src/main.cpp`, gnu++20).
* **Release Targets:** Platforms `make release` builds for, or none. The same targets as the Go template, cross-compiled with zig.
* The `--trust` option is required because the template runs `git` to create the repository and its first commit.


### Default Config

User-specific values are loaded from the global configuration file - `~/.config/copier/settings.yml`. If the file is not present or not saved, empty strings are used as defaults.
```
defaults:
  user_name  : "karsh"
  user_email : "karshmail@icloud.com"
  github_user: "karnull"

```



### Updating a Project

Generated projects keep their Copier answers in `.copier-cxx-answers.yml` at the project root. From there:

```bash
$ copier update --defaults --answers-file .copier-cxx-answers.yml
```

Projects generated before the answers file moved keep it in `.copier-generic-project/`. Move it once before updating:

```bash
$ git mv .copier-generic-project/.copier-cxx-answers.yml .copier-cxx-answers.yml
```

Projects generated before 2.0.0 hold `vX.Y.Z` in `VERSION`. Remove the leading `v` once when updating, or the shared CI's version check fails:

```bash
$ sed -i 's/^v//' VERSION
```


### Generated Code

Every generated project ships `src/debug.h`, a fork of Zed Shaw's debug macros (`debug`, `log_error`, `log_warn`, `log_info`, `check` and friends), and a `main` that accepts arguments and prints `--help` and `--version`. The version is the one in the project's `VERSION` file, which the Makefile compiles in, so the binary always reports the version CI releases.

Code follows the [NASA SEL C Style Guide](https://ntrs.nasa.gov/citations/19950022400) (SEL-94-003): file and function prologs, Braces-Stand-Alone layout with four-space indents, `lower_case` variables, `CapitalisedWords` functions, `UPPER_CASE` constants, one return per function and a `default` in every `switch`. The layout rules are in `.clang-format`; `debug.h` keeps its own layout and is left out of formatting.


### Versioning and CI

The template's release version lives in `VERSION` as a plain `X.Y.Z`, without a leading `v`. Bump it in every change that should be released:
* `Z` for minor fixes.
* `Y` for minor features and chores.
* `X` for breaking changes, such as renamed questions or moved files that affect `copier update` in existing projects.

GitHub Actions (`.github/workflows/ci.yml`) runs two jobs:
* **version:** on every pull request and push to `main`, checks that `VERSION` holds a single `X.Y.Z` line.
* **tag:** on push to `main`, tags the merged commit `v` plus the version in `VERSION`, such as `v1.2.3`, so existing projects can move to it with `copier update`. If the tag already exists, nothing is tagged.

The workflow is read-only apart from the tag job, which needs write access to create the tag. It runs on `pull_request`, never `pull_request_target`, so code from a fork never runs with this repository's credentials. Actions are pinned to commit SHAs, and Renovate (`renovate.json`, extending the shared settings in template-github-ci) proposes updates to them weekly. Minor, patch and digest updates come as one grouped pull request and majors on their own; Renovate never touches `VERSION`, so bump it on the pull request before merging.


### Project Tasks

Every generated project has a `Makefile` at its root:
* `make build` builds a debug binary into `build/`.
* `make format` formats the sources with clang-format; `make format-dry-run` lists unformatted files and fails if there are any.
* `make test` runs cppcheck over `src/`, then checks the binary's `--help` and `--version` with `tests/cli.sh`.
* `make release` cross-compiles one optimised, stripped binary per release target into `dist/` with zig, using `scripts/release.sh`. Linux builds link musl statically, and `NODEBUG` is set, so `debug()` output is dropped.

The project's dev container (`Dockerfile`) installs gcc or g++, make, clang-format, cppcheck and zig.


### GitHub CI

Generated projects ship with the shared workflow from [template-github-ci](https://github.com/karshosphere/template-github-ci), vendored into `template/.github/`. It expects the project's `Makefile` and `.devcontainer/`, requires a `VERSION` bump on every pull request, and publishes a GitHub release on each merge to main. They also ship a `renovate.json` that extends the same shared Renovate settings; the project owns it once created, so it can add its own rules.

To bring in a newer release of the workflow, from this repository's root:

```bash
$ copier update -a .github/.copier-ci-answers.yml template
```
