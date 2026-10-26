# Early software and systems research

**Amine Belgacem · Personal work from the 2000s · Retrospective assembled in 2026**

This collection presents my early experiments with Windows applications, binary formats, network protocols, and web security. It explains the questions I explored, the software I assembled, and what the surviving evidence supports.

The original material remains in a separate private archive. These pages are a curated retrospective, with selected observations, reconstructed diagrams, and present-day annotations. Dates are approximate where the surviving records do not establish them.

## Research case studies

| Investigation | What to explore | Evidence |
|---|---|---|
| [Understanding the RAR format](research/rar-format/README.md) | Comparing controlled samples to understand metadata, compression options, and password-protected archives | Three surviving experiment notebooks labeled 2008 |
| [Investigating MSN connections](research/msn-network/README.md) | Following connection changes, separating server roles, and examining an authentication flow | A network notebook and related VB6 source; exact date uncertain |
| [Web security investigation, circa 2007–2008](research/web-security/README.md) | An early investigation whose retained results include database records | Surviving data artifacts and my recollection; the technical method still needs reconstruction |

## Software experiments

| Project | Engineering topic | Presentation |
|---|---|---|
| [Executable configuration builder](projects/executable-configuration/README.md) | Builder/template separation and serialized configuration | Architecture walkthrough |
| [FTP interface and unfinished tool](projects/vb6-prototype/README.md) | Event-driven desktop UI, file navigation, and component integration | Prototype retrospective |
| [MSN protocol application](projects/msn-application/README.md) | Receive buffering, command dispatch, and asynchronous callbacks | Source walkthrough |
| [Smaller experiments](projects/smaller-experiments.md) | List processing, request automation, and batch scripting | Short historical catalog |

Start with the RAR investigation for the clearest surviving record of my experimental process. The software walkthroughs explain the mechanisms visible in source without claiming that the old applications have been rebuilt or run today.

## Reading the collection

- [Timeline](TIMELINE.md): dates and how they were established.
- [Evidence and editorial method](EVIDENCE.md): original observations, retrospective explanations, and open questions.
- [Credits](CREDITS.md): bundled components and unresolved attribution.
- [Attached evidence](evidence/README.md): original notebook text, selected source files, credited excerpts, and field-redacted database samples.
- [Source inventory](evidence/source-manifest.json): original and published hashes, redaction locations, and excerpt line ranges.

The web security page is an evidence summary pending reconstruction of the method. The remaining pages contain completed initial write-ups based on the available notes and source. Attached evidence includes notes, selected source, and fully field-redacted database excerpts. No raw database values, account credentials, authentication strings, captured logs, executables, or operational account-checking tools are included.
