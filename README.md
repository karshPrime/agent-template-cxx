# C/C++ Template

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)

A [Copier](https://copier.readthedocs.io/en/stable) template for C and C++ projects.


## Create a Project

```bash
$ uv tool install copier
$ copier copy --trust gh:karshosphere/template-cxx path/to/project
```

Copier asks for:
* **Project Name** and an optional **Project Description**.
* **Language:** C (`src/main.c`, gnu11) or C++ (`src/main.cpp`, gnu++20).
* **Release Targets:** platforms `make release` builds for, or none. The same targets as the Go template, cross-compiled with zig.

`--trust` lets the template run `git` to create the repository and its first commit.

Your name, email and GitHub user come from `~/.config/copier/settings.yml`, and are left empty without it:

```yaml
defaults:
  user_name: "karsh"
  user_email: "karshmail@icloud.com"
  github_user: "karnull"
```


## Update a Project

From the project root:

```bash
$ copier update --defaults --answers-file .copier-cxx-answers.yml
```

Projects generated before 2.0.0 need two one-off steps first: move the answers file to the root with `git mv .copier-generic-project/.copier-cxx-answers.yml .copier-cxx-answers.yml`, and drop the `v` from `VERSION` with `sed -i 's/^v//' VERSION`.


## What a Project Gets

* `src/debug.h`, a fork of Zed Shaw's debug macros (`debug`, `log_error`, `log_warn`, `log_info`, `check` and friends).
* A `main` that takes arguments and prints `--help` and `--version`. The version comes from `VERSION`, compiled in by the Makefile, so the binary reports the version CI releases.
* Code laid out to the [NASA SEL C Style Guide](https://ntrs.nasa.gov/citations/19950022400) (SEL-94-003), with the layout rules in `.clang-format`. `debug.h` keeps its own layout.
* A `Makefile`:
  * `make build` builds a debug binary into `build/`.
  * `make format` formats the sources with clang-format; `make format-dry-run` fails if any need it.
  * `make test` runs cppcheck, then checks `--help` and `--version` with `tests/cli.sh`.
  * `make release` cross-compiles a stripped binary per release target into `dist/` with zig. Linux builds link musl statically, and `NODEBUG` drops the `debug()` output.
* A dev container with gcc or g++, make, clang-format, cppcheck and zig.
* The shared CI from [template-github-ci](https://github.com/karshosphere/template-github-ci): it runs the four make targets in the dev container, requires a `VERSION` bump on every pull request, and publishes a GitHub release on each merge to main.
* `VERSION`, starting at `0.1.0`, and a `renovate.json` using the shared Renovate settings. The project owns both; updates never overwrite them.


## Maintaining the Template

* Bump `VERSION`, a plain `X.Y.Z`, on every branch: `Z` for fixes, `Y` for features and chores, `X` for changes that break `copier update` in existing projects. CI checks it and tags each merge to main `vX.Y.Z`.
* Renovate keeps the pinned actions and images current, grouping minor updates into one weekly pull request. It never touches `VERSION`.
* Bring in a newer release of the shared CI from the repository root with `copier update -a .github/.copier-ci-answers.yml template`.
