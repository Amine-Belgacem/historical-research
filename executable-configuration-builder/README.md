# Executable Configuration Builder

A Visual Basic 6 project demonstrating how connection settings were embedded into a precompiled program. The builder copies an executable template, stores FTP settings in the copy, and produces a program intended to load those settings at startup.

This explains the configuration stage used in historical Trojan builders: the program already existed, while its destination and account settings changed between generated copies. The template here is an outbound FTP client with a fixed image-upload operation.

| Component | Role |
| --- | --- |
| [Builder](originals/frmMain.frm) | Collects settings and writes them into a copy of the template. |
| [Template source](originals/rdfce%20source/frmMain.frm) | Reads configuration from its own file and passes it to WinINet. |
| [Saved template and output](originals/) | `rdfce.ext` and `test.exe` preserve the resulting file layout. |

**Verification:** the saved configuration layout is confirmed by byte comparison. The supplied source has a footer-reading error and a one-byte overwrite, so it cannot be presented as a fully working build. The binaries were inspected without execution. All original files remain unchanged.

[How it works, byte layout, and verification findings](analysis.md)

[Back to the collection](../README.md)
