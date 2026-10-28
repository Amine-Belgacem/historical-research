# Executable Configuration Builder

Two VB6 source projects demonstrate **FTP configuration embedded directly inside an EXE**. A builder produces a configured copy of a precompiled template; that copy reads the settings from its own executable when it starts.

## Working example

| Source project | Compiled program | Role |
| --- | --- | --- |
| [Builder.vbp](source/Builder.vbp) / [form](source/frmBuilder.frm) | `FtpBuilder.exe` | Collect an FTP host, username, and password, then embed them in a copy of the demo template. |
| [Template.vbp](source/Template.vbp) / [form](source/frmTemplate.frm) | `FtpTemplate.exe` | Supply the program being configured. The generated copy loads its embedded values at startup and displays them. |

Open [Example.vbg](source/Example.vbg) to edit both projects in VB6. Build and test from PowerShell in this folder:

```powershell
.\build.ps1
```

The script uses an installed, licensed VB6 compiler; supply `-Compiler` if it is elsewhere. It compiles the template before the builder, runs the [native tests](tests/ConfigTests.vbp), and executes a generated copy to verify that it reads its own settings.

1. Run `build/FtpBuilder.exe`, keeping `FtpTemplate.exe` beside it.
2. Enter example FTP settings and choose an output EXE filename.
3. Select **Build EXE**, then open the generated copy. Its fields come from inside that EXE; no `.cfg` file is needed.

The template displays the settings without connecting or uploading. Serialization does not encrypt passwords; the defaults are dummy credentials.

## File format

| Region, in order | Contents |
| --- | --- |
| Template | Every original byte of the compiled demo template, unchanged. |
| Embedded payload | Serialized VB6 `PropertyBag`: `FtpHost`, `FtpUserName`, and `FtpPassword`. |
| Final 16 bytes | Eight-byte marker `FTPDMO01`, four-byte payload offset, and four-byte payload length. The integers are little-endian; the offset is zero-based. |

The [shared module](source/Configuration.bas) appends the payload after the template's final byte. At startup the template reads the footer at the end of its own file, locates the payload, and restores the properties. Building starts from the unconfigured demo template each time. The builder completes a temporary file before replacing an existing output and rejects an attempt to overwrite its input template.

Native tests cover byte preservation, FTP-value round trips, Unicode, footer corruption, failed replacements, and form behavior. The process-level check copies a generated EXE into a separate folder without the builder or template, runs it, and confirms that its self-reader restores the expected test values.

## Historical implementation

[Original files](originals/) and the [original executable layout and findings](analysis.md) document the archived implementation. The editable example preserves the builder/template and EXE-embedded configuration concept, with a versioned footer and display-only template behavior.

[Back to the collection](../README.md)
