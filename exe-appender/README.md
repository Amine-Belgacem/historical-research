# EXE appender

**2000s · Visual Basic 6**

A Visual Basic 6 builder that embeds FTP connection settings into a precompiled executable. The generated program reads its embedded configuration and uses it for outbound FTP access.

The focus is the mechanism used to configure Trojan server executables with new FTP settings. The unfinished VB6 project contains a closely related server-template builder. The [detailed analysis](analysis.md) explains the source, the relationship between the projects, and a read-only comparison of the archived binaries.

## Original project

- [Complete original files](originals/)
- [Builder project](originals/Compiler.vbp) and [form](originals/frmMain.frm)
- [Template project](originals/rdfce%20source/prjRdfce.vbp) and [form](originals/rdfce%20source/frmMain.frm)
- [Project group](originals/ExeDemo.vbg)

The original resources, template, generated executable, workspace files, comments, and metadata are kept together. No source has been rewritten.

## Design

```mermaid
flowchart LR
    A[FTP connection settings] --> B[PropertyBag configuration]
    T[Precompiled executable template] --> C[Configured output]
    B --> C
    C --> D[Template reads its configuration]
    D --> E[Outbound FTP connection and upload]
```

*Diagram prepared in 2026 from the source.*

The builder stores the FTP host, username, and password as configuration. The template loads those values from its own executable file, connects to the configured FTP destination, and contains an upload of a fixed local image file. The compiled output is therefore intended to carry its own connection settings.

The generated agent acts as an FTP client: it connects to the configured destination and uploads the local image. The [analysis](analysis.md) covers the project structure and its dependencies.

The original project metadata names Softrix; those names and the existing comments are retained unchanged.

[Read the source and binary-layout analysis](analysis.md)

[Back to the collection](../README.md)
