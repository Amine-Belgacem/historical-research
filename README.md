# Historical Research

Independent investigations from the 2000s into binary formats, network protocols, authentication behavior, and web application security. The collection brings together working notebooks, recorded results, and original applications developed alongside the research.

## Investigations

| Study | Period | Focus and results |
|---|---|---|
| [RAR Format Investigation](rar-format-investigation/README.md) | 2008 | Controlled samples, hex comparisons, and manual byte editing to investigate archive structure, compression, timestamps, CRCs, and password handling. Includes three original notebooks and tables mapping the findings. |
| [MSN Network Investigation](msn-network-investigation/README.md) | 2000s | Connection and authentication research, including the discovery that continued failed sign-ins maintained a Hotmail account lockout. Includes the research notebook and the resulting Hotmail Kira application. |
| [Web Security Research: SQL Injection](web-security-investigation/README.md) | Circa 2007–2008 | SQL injection investigations across multiple web applications, with the websites studied and four original database result files. |
| [RapidShare Account Research](rapidshare-account-research/README.md) | 2000s | Login-response analysis for account enumeration, followed by password-list testing. Includes the original account finder and account cracker projects. |

## Configuration example

[Trojan Builder Configuration](trojan-builder-configuration/README.md) provides an explanatory VB6 implementation of a historical builder/template pattern. The builder embeds example FTP settings into a template executable; the generated program reads and displays those settings from its own file.

The example includes two editable VB6 projects and a build script. It demonstrates configuration packaging with a display-only template.

## Reading the collection

Each investigation's README explains its methods, findings, and associated files. Retained notebooks, project files, and recorded results are kept under `originals/`, with their original contents, encodings, resources, and existing credits preserved.

Hotmail Kira is included within the MSN investigation under `hotmail-kira/`. The RapidShare study keeps its finder and cracker together under `originals/`. The configuration example contains its editable implementation under `source/`.

The collection remains private because some retained originals contain personal and account-related material.

[Timeline](TIMELINE.md) · [Credits](CREDITS.md)
