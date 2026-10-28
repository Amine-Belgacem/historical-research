# Early software and systems research

**Amine Belgacem · Personal work from the 2000s**

A collection of software projects and research covering Windows applications, binary formats, network protocols, and web security. Each project brings its technical description, outcomes, and original files together in one folder.

## Research

| Work | Period | Focus |
|---|---|---|
| [RAR format investigation](rar-format-investigation/README.md) | 2008 | Manual hex analysis, visual archive maps, compression and timestamp findings, and original password-handling conclusions. |
| [MSN network investigation](msn-network-investigation/README.md) | 2000s | Protocol research, failed-sign-in account-lockout discovery, and the resulting Hotmail Kira application, kept together. |
| [Web security research: SQL injection](web-security-investigation/README.md) | Circa 2007–2008 | Independent SQL injection research, websites studied, and original database results. |
| [RapidShare account brute-force research](rapidshare-account-research/README.md) | 2000s | Account enumeration and password guessing, with the research and both original applications together. |

## Applications and prototypes

| Work | Focus |
|---|---|
| [Trojan Builder Configuration](trojan-builder-configuration/README.md) | How historical Trojan builders embedded FTP reporting settings into generated executables, demonstrated by two VB6 projects. |
| [Early VB6 Security Prototypes](vb6-security-prototypes/README.md) | Unfinished keylogger and MSN credential-stealer interfaces, their shared architecture, and known limitations. |

## Folder layout

```text
work-name/
    README.md          Introduction and explanation
    originals/         Original files, unchanged
```

Original filenames, directory structure, encodings, resources, binaries, and existing credits remain unchanged for the files retained in each `originals/` folder. The introductions and summary tables were prepared in 2026. The original `digital-archive-2000s` repository remains untouched.

The MSN investigation also contains a `hotmail-kira/` subfolder for its resulting application, with the complete original project inside it.

The Trojan Builder Configuration contains its two editable VB6 projects under `source/`, with a build script. The Early VB6 Security Prototypes study groups two unfinished projects in separate source folders, with their application logic unchanged.

This repository is private because the complete originals include personal and account-related material.

[Timeline](TIMELINE.md) · [Credits](CREDITS.md) · [To-do](TODO.md)
