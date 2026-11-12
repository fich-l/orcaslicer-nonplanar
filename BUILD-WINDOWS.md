# Building OrcaSlicer Nonplanar on Windows

Windows x64 downloads are in [Releases](https://github.com/fich-l/orcaslicer-nonplanar/releases), built by
[`.github/workflows/build.yml`](.github/workflows/build.yml) exactly as described here. This document describes
the port, what it changes, and how to build it yourself with MSVC.

The base is the same as the macOS build: upstream OrcaSlicer **v2.4.2**
(commit `8500fcdccaa10b5099ac20d252af3a7c560046f1`) plus `orca-nonplanar.patch`,
then [`windows/orca-nonplanar-windows.patch`](orca-nonplanar-windows.patch) on top.

## What the Windows patch adds

Only the installer is touched; the nonplanar slicing itself is platform independent and unchanged.

| Change | File(s) |
|---|---|
| Windows installer: own package name, install directory and registry key (`OrcaSlicer Nonplanar`), so it can be installed next to a normal OrcaSlicer instead of replacing it | `CMakeLists.txt` (CPack block) |

## Requirements

- Windows 10/11 x64
- **Visual Studio 2022 Build Tools** with the "Desktop development with C++" workload
  (MSVC v143 + Windows 11 SDK). Full Visual Studio 2022 works as well.
- **CMake** 3.13 or newer (3.31 is what was tested)
- **Strawberry Perl** (used by `scripts/run_gettext.bat`)
- Git, and optionally **NSIS** for building the installer (`cpack -G NSIS`)
- ~60 GB free disk space, ~25 GB RAM recommended (20 GB works)

Use a short build path without spaces and outside OneDrive, for example `C:\src\orca-np`.
CMake in `C:\Program Files\CMake\bin` must come **before** Strawberry Perl's `c\bin`
on `PATH`, otherwise OrcaSlicer's `CMakeLists.txt` refuses to configure.

## Build

```bat
git clone https://github.com/OrcaSlicer/OrcaSlicer.git orca-np
cd orca-np
git checkout 8500fcdccaa10b5099ac20d252af3a7c560046f1

git apply ..\orca-nonplanar.patch
git apply ..\windows\orca-nonplanar-windows.patch
```

Open an **x64 Native Tools Command Prompt for VS 2022** (so `cl.exe` and `msbuild` are on
`PATH`) and run, from the repository root:

```bat
build_release_vs2022.bat deps     :: dependencies, first time only, 30-90 minutes
build_release_vs2022.bat slicer   :: OrcaSlicer itself, 15-40 minutes
```

Result:

- portable: `build\src\Release\orca-slicer.exe`
- installed layout: `build\OrcaSlicer\orca-slicer.exe`

Installer:

```bat
cd build
cpack -G NSIS -C Release
:: -> OrcaSlicer_Nonplanar_Windows_Installer_V2.4.2_x64.exe
```

## First start

The build is self-contained: no profiles or settings are shipped with it. On first start the app
creates its own settings folder, `%APPDATA%\OrcaSlicerNonplanar`, and leaves an installed OrcaSlicer
(`%APPDATA%\OrcaSlicer`) untouched. Nonplanar is on by default for every printer and process preset.
Copying an existing OrcaSlicer config over is optional and not required for testing.

## Testing without a 3D printer

Slice a model with a gently sloped top (up to 12 deg):

```bat
orca-slicer.exe --load-settings "machine.json;process.json" ^
  --load-filaments "filament.json" --outputdir out --slice 0 ramp-10deg.stl
```

The G-code should start with `; OrcaSlicer Nonplanar v0.1` and contain
`;PATH_TASK ... conformal=1` lines. With nonplanar enabled the 10 deg ramp of the test
fixture produces 135 conformal paths; with `use_nonplanar_layers=0` the same model produces 0.

## Known limitations

- The installer and the executable are not code signed, so Windows SmartScreen shows an
  "unknown publisher" warning on first start.
- `scripts/run_gettext.bat` needs `xgettext`/`msgfmt`; without them the translations shipped
  in `resources/i18n` are used unchanged (the UI still works in all languages).
- Only x64 was tested. ARM64 is untested.
- Slicing time: the print-order planning adds overhead on models with large sloped tops;
  the same settings as on macOS apply (`NONPLANAR_DEPOSITION_ORDER=0` disables the planning
  for experiments only, the G-code is then not collision checked).
