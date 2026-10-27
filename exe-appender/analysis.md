# EXE appender: historical analysis

**Static source and binary analysis · October 2026**

## Purpose

The core mechanism configures a precompiled executable with FTP connection settings. A builder collects the values, attaches serialized configuration to a template, and produces a configured file. The corresponding template source reads that configuration and uses it for outbound FTP access.

The focus is the configuration mechanism used in Trojan server builders. Its relationship to the unfinished VB6 project shows how the same approach was used with a server template.

## Builder and template

The [project group](originals/ExeDemo.vbg) contains both the builder and template projects. The [template project](originals/rdfce%20source/prjRdfce.vbp) names `rdfce.ext` as its compiled output. The builder's “Compile” action operates on that precompiled file.

| Part | Implementation |
|---|---|
| [Builder form](originals/frmMain.frm#L77) | Collects three text values, places them in a `PropertyBag`, and writes configuration into a copy of the template. |
| Configuration fields | The property names are `Text`, `Text2`, and `Text3`. Their use in the template identifies them as FTP host, username, and password. |
| [Template form](originals/rdfce%20source/frmMain.frm#L142) | Opens its own executable file, loads the serialized properties, and places the values into the corresponding controls. |
| FTP behavior | Uses the loaded connection settings with WinINet, checks the remote directory response, and contains an upload operation for a fixed local image path. |

The transfer uses `c:\1.jpg` as its local input and `1.jpg` as the remote filename. Image creation is outside the template's code.

The calls are consistent with an outbound FTP client: Microsoft's [InternetConnect documentation](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetconnecta) describes opening a session to a destination, and [FtpPutFile documentation](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-ftpputfilea) describes transferring a local file to the FTP server. The historical term “server” refers here to the generated program's role, not to hosting an FTP service.

## Relationship to the unfinished VB6 project

The [unfinished project's configuration handler](../keylogger-unfinished/originals/Form1.frm#L489) follows the same pattern: it stores FTP-related settings, copies a server template, and writes serialized configuration into the output. Its properties use the more descriptive names `ftp`, `nom`, and `pass`.

That handler references `Files/servedit.exe`. The same form includes a separate FTP connection test and remote-file browsing, connecting the builder to the interface used to configure and access the FTP destination.

The [nested server project](../keylogger-unfinished/originals/seveur/Projet1.vbp) references external source folders for MSN password-stealing components.

Both projects use the same serialization and executable-template pattern.

### Project dependencies

The archived project references `Files/servedit.exe` and external server-source files that are not included in the collection. The template's image input is also produced outside its code.

## Archived executable layout

A read-only byte comparison of the two archived files found:

| File or comparison | Result |
|---|---:|
| `rdfce.ext` template | 32,768 bytes |
| `test.exe` output | 32,915 bytes |
| Size difference | 147 bytes |
| Identical initial bytes | 32,767 bytes |
| Final four bytes of the output, interpreted as a little-endian integer | 32,768 |

The shared initial region and small additional tail match the template-and-configuration layout. The initial match stops one byte before the template's end, where the source writer begins writing its data.

## Design summary

This is a **server-configuration builder experiment using embedded FTP settings**. The builder carries the settings into the generated executable, and the related unfinished project uses the same server-template pattern.

[Back to the work](README.md)
