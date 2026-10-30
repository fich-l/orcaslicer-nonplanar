# Building OrcaSlicer Nonplanar v0.1

The source is upstream OrcaSlicer **v2.4.2** (commit `8500fcdccaa10b5099ac20d252af3a7c560046f1`) plus
`orca-nonplanar.patch` from this repository.

## macOS (Apple Silicon)

Requirements: Xcode (full app, not only the command line tools), CMake, Git. Use a build path **without spaces**.

```bash
git clone https://github.com/OrcaSlicer/OrcaSlicer.git orcaslicer-nonplanar
cd orcaslicer-nonplanar
git checkout 8500fcdccaa10b5099ac20d252af3a7c560046f1
git apply /path/to/orca-nonplanar.patch
```

Dependencies (once, takes a while):

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./build_release_macos.sh -d -a arm64
```

If the MPFR dependency stops because `makeinfo` is missing, touch its documentation files
(`doc/*.texi`, `doc/stamp-vti`, `doc/version.texi`, `doc/*.info` in the MPFR source folder) and run the command
again.

Generate the Xcode project, then build the app:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./build_release_macos.sh -s -a arm64 -T
cd build/arm64
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project OrcaSlicer.xcodeproj build \
  -configuration Release -parallelizeTargets -jobs 8 -target OrcaSlicer
```

The app is at `build/arm64/src/Release/OrcaSlicer.app`.

## Windows (x64 or ARM64)

The release ZIPs are built by [`.github/workflows/build-windows.yml`](.github/workflows/build-windows.yml) on
GitHub's Windows runners; it's the reference for all steps. By hand, with Visual Studio 2022 (C++ workload),
CMake, Git and Strawberry Perl, in a path without spaces:

```bat
git clone https://github.com/OrcaSlicer/OrcaSlicer.git orca
cd orca
git checkout 8500fcdccaa10b5099ac20d252af3a7c560046f1
git apply path\to\orca-nonplanar.patch
build_release_vs.bat deps
build_release_vs.bat slicer
```

For ARM64, add `arm64` to both commands. ARM64 also needs GMP/MPFR from MSYS2 (see the workflow). The portable
app is in `build\OrcaSlicer` (`build-arm64\OrcaSlicer` for ARM64).

## Tests

The nonplanar C++ tests are in `tests/fff_print/test_nonplanar.cpp` (tag `[Nonplanar]`). Build the
`fff_print_tests` target, ad-hoc sign the test bundle (`codesign --force -s - fff_print_tests.app`) and run it
with `NONPLANAR_FIXTURES_DIR` and `NONPLANAR_ORCA_PROFILES_DIR` pointing to the test fixtures and A1 mini
profiles.

## Diagnostics (environment variables)

- `NONPLANAR_PLAN_VERIFY=1`: checks the planner's cached dependencies against a fresh computation (slow).
- `NONPLANAR_DEPOSITION_ORDER=0`: disables the print-order planning (comparison only; the G-code is not
  collision-checked).
