First public test release of OrcaSlicer Nonplanar (OrcaSlicer 2.4.2, macOS, Apple Silicon).

**Highlights**
- Nonplanar top surfaces up to 12° and 5 mm height span; the visible top shell is printed in one piece.
- Collision check against a simplified hotend model (tip, 12° cone, heater block), with planned print order.
- No move steeper than 12° in the G-code; clear messages when a model can't be sliced collision-free.
- Slope compensation, top line direction and top flow ratio options.
- Own settings folder: a normal OrcaSlicer on the same Mac stays untouched.

**Compared with the original PrusaSlicer nonplanar build (2.6.0+teachingtechYT)**, tested on 8 models with the
same A1 mini settings (12°, 5 mm):

| | Original | v0.1 |
|---|---|---|
| Moves steeper than 12° | 1–86 per model | 0 on every model |
| Hotend collisions (simplified A1 mini hotend) | on 8 of 8 models (up to 0.034 mm) | none on 6 models, 2 tiny contacts (0.004 / 0.013 mm), 1 model refused with a clear message |
| Slicing time | 0–22 s | 0–66 s (print-order planning) |

**Install:** open the DMG and drag the app to Applications. The app is unsigned: on macOS 15 and newer, start it
once, then click "Open Anyway" in System Settings > Privacy & Security (older macOS: right-click > Open). See
README.

**Known limits:** one hotend model for all printers, Apple Silicon only, unsigned, test status.
