# Building OrcaSlicer Nonplanar on Linux

Tested on Zorin OS (Ubuntu 24.04 based), x86_64, Wayland. Same base as the other platforms:
upstream OrcaSlicer **v2.4.2** (commit `8500fcdccaa10b5099ac20d252af3a7c560046f1`) plus
`orca-nonplanar.patch`. The Linux x86_64 AppImage in
[Releases](https://github.com/fich-l/orcaslicer-nonplanar/releases) is built the same way by
[`.github/workflows/build.yml`](.github/workflows/build.yml) on Ubuntu 24.04.

```bash
git clone https://github.com/OrcaSlicer/OrcaSlicer.git orca-np && cd orca-np \
 && git checkout 8500fcdccaa10b5099ac20d252af3a7c560046f1 \
 && git apply --whitespace=nowarn /path/to/orca-nonplanar.patch \
 && ./build_linux.sh -u && ./build_linux.sh -dsi
```

The AppImage is written to `build/OrcaSlicer_Linux_V2.4.2.AppImage`.

If the 3D view misbehaves on Wayland: `GDK_BACKEND=x11 ./OrcaSlicer_Linux_V2.4.2.AppImage`

Status: test build. Check the G-code preview before printing, as described in the README.
