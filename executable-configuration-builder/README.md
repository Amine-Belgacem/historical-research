# Executable Configuration Builder

A study of executable configuration, with an editable **offline VB6 example** demonstrating how settings are serialized, saved, and restored in a separate viewer.

## Working example

| Project | Role |
| --- | --- |
| [Builder](source/Builder.vbp) / [form](source/frmBuilder.frm) | Edit a title, message, theme, and timestamp option; save a `.cfg` file. |
| [Viewer](source/Viewer.vbp) / [form](source/frmViewer.frm) | Load the file and display those settings, with a scrollable message preview. |
| [Shared file handling](source/Configuration.bas) | Validate settings, serialize the property bag, and handle file errors. |
| [Native tests](tests/ConfigTests.vbp) | Exercise the format, error cases, and form behavior. |

Open [Example.vbg](source/Example.vbg) in VB6, or build and test from PowerShell in this folder:

```powershell
.\build.ps1
```

The script uses an installed, licensed VB6 compiler; supply `-Compiler` if it is elsewhere. It produces `build/ConfigBuilder.exe` and `build/ConfigViewer.exe`. Save with the builder, then choose **View saved file**, or open the same `.cfg` in the standalone viewer.

The example writes a data file rather than modifying an executable. It has no FTP operations or credential fields.

## File format

| Bytes, zero-based | Contents |
| --- | --- |
| 0–7 | ASCII signature `VBCFG001`. |
| 8–11 | Four-byte payload length. |
| 12 onward | Serialized VB6 `PropertyBag` containing the display settings. |

Saving validates inputs and completes a temporary file before replacing the destination. Loading checks the signature, payload length, property types, and settings before updating the viewer. Both forms show errors in their status area.

Compiled with VB6 and checked by the native self-tests, including round trips, Unicode, malformed files, failed replacements, and form behavior.

## Historical implementation

[Original files](originals/) and the [original executable layout and findings](analysis.md) explain the archived builder/template mechanism and its defects. The offline example uses a separate data-file format; it is not a repaired version of the original FTP uploader.

[Back to the collection](../README.md)
