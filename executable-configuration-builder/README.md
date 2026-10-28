# Executable Configuration Builder

Two VB6 projects demonstrate FTP settings embedded directly inside an executable.

- [Builder.vbp](source/Builder.vbp) collects an FTP host, username, and password, then embeds them into a copy of the template EXE.
- [Template.vbp](source/Template.vbp) supplies the executable. The configured copy reads its settings from its own file at startup and displays them.

Open [Example.vbg](source/Example.vbg) to edit both projects in VB6. Build from PowerShell in this folder:

```powershell
.\build.ps1
```

The script uses an installed VB6 compiler; supply `-Compiler` for a different location. Run `build/FtpBuilder.exe` with `FtpTemplate.exe` beside it, enter example settings, and select **Build EXE**. The generated EXE runs independently, without an external configuration file.

The [shared module](source/Configuration.bas) preserves the template bytes, appends a serialized `PropertyBag`, and writes a 16-byte footer containing `FTPDMO01`, the payload offset, and its length. The template uses that footer to locate its settings.

The template displays the values without connecting or uploading. Serialization does not encrypt passwords; use dummy credentials for the example.

[Back to the collection](../README.md)
