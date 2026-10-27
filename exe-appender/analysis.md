# EXE appender: historical analysis

**Static inspection prepared in October 2026. Original files unchanged; executables not run.**

## Purpose

The core mechanism configures a precompiled executable with FTP connection settings. A builder collects the values, attaches serialized configuration to a template, and produces a configured file. The corresponding template source reads that configuration and uses it for outbound FTP access.

The focus is the configuration mechanism used in Trojan server builders. Its relationship to the unfinished VB6 project shows how the same approach was used with a server template.

## Builder and template

The [project group](originals/ExeDemo.vbg) contains both the builder and template projects. The [template project](originals/rdfce%20source/prjRdfce.vbp) names `rdfce.ext` as its compiled output. The builder's “Compile” action operates on that precompiled file.

| Part | What appears in the original source |
|---|---|
| [Builder form](originals/frmMain.frm#L77) | Collects three text values, places them in a `PropertyBag`, and writes configuration into a copy of the template. |
| Configuration fields | The property names are `Text`, `Text2`, and `Text3`. Their use in the template identifies them as FTP host, username, and password. |
| [Template form](originals/rdfce%20source/frmMain.frm#L142) | Opens its own executable file, loads the serialized properties, and places the values into the corresponding controls. |
| FTP behavior | Uses the loaded connection settings with WinINet, checks the remote directory response, and contains an upload operation for a fixed local image path. |

The visible transfer refers to `c:\1.jpg` and the remote filename `1.jpg`. The inspected template does not contain an image-capture routine. The broader purpose of an image produced elsewhere cannot be reconstructed from this template alone.

The calls are consistent with an outbound FTP client: Microsoft's [InternetConnect documentation](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetconnecta) describes opening a session to a destination, and [FtpPutFile documentation](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-ftpputfilea) describes transferring a local file to the FTP server. The historical term “server” refers here to the generated program's role, not to hosting an FTP service.

## Relationship to the unfinished VB6 project

The [unfinished project's configuration handler](../keylogger-unfinished/originals/Form1.frm#L489) follows the same pattern: it stores FTP-related settings, copies a server template, and writes serialized configuration into the output. Its properties use the more descriptive names `ftp`, `nom`, and `pass`.

That handler expects `Files/servedit.exe`, a template absent from the surviving snapshot. The same form includes a separate FTP connection test and remote-file browsing. This ties the builder to a larger interface concerned with configuring and accessing the FTP destination.

The [nested server project](../keylogger-unfinished/originals/seveur/Projet1.vbp) also references external source folders whose names describe MSN password-stealing components. Those referenced source files are absent, leaving that part of the server implementation incomplete in this snapshot.

The shared serialization and template pattern suggests reuse or development of a common approach across the projects. Their exact development order is not established by the surviving snapshot.

## Archived executable layout

A read-only byte comparison of the two archived files found:

| File or comparison | Result |
|---|---:|
| `rdfce.ext` template | 32,768 bytes |
| `test.exe` output | 32,915 bytes |
| Size difference | 147 bytes |
| Identical initial bytes | 32,767 bytes |
| Final four bytes of the output, interpreted as a little-endian integer | 32,768 |

The shared initial region and small additional tail agree with the source's template-and-configuration design. The initial match stops one byte before the template's end, consistent with where the writer begins writing its data. This is a structural comparison, not a runtime test; configuration values were not decoded or printed.

## Historical interpretation

This is a **server-configuration builder experiment using embedded FTP settings**. The source shows how the settings were carried into the generated executable, and the related unfinished project contains the matching server-template pattern. The preserved files document the configuration mechanism; parts of the broader server implementation are missing.

[Back to the work](README.md)
