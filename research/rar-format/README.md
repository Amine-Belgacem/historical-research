# Understanding the RAR format

**Period:** 2008, based on notebook labels and dated examples.  
**Form:** annotated research retrospective.  
**Evidence:** three surviving text notebooks; the original test archives and exact WinRAR version have not been recovered in this collection.

I investigated how changing a file, an archive option, or a password affected the bytes of a RAR archive. The surviving notes show an experimental approach: create small inputs, compare their representations, change selected bytes, and record how the application responded.

Read the actual notebooks: [main research notes](../../evidence/notes/rar/01-reverse-engineering-notes.redacted.txt), [empty-header comparison](../../evidence/notes/rar/02-empty-header-comparison.txt), and [password/content hex analysis](../../evidence/notes/rar/03-password-content-hex-analysis.txt). The first has limited redactions; the other two have no content edits. All three are text-encoding and line-ending normalized copies, with the original reasoning preserved.

## Questions I explored

- Which parts of an archive describe the file, and which represent its contents?
- What changes when the filename, timestamp, compression setting, or password changes?
- What can different error messages reveal about the role of a byte range?

## The experimental process

```mermaid
flowchart LR
    A[Create a small input] --> B[Change one archive condition]
    B --> C[Compare hexadecimal views]
    C --> D[Form a field hypothesis]
    D --> E[Modify a copy and observe behavior]
    E --> F[Record the result and revise the hypothesis]
```

*Retrospective diagram reconstructed from the notebooks.*

The notes describe generating files of known sizes, comparing password-protected and unprotected archives, varying compression options, and editing byte regions. They also distinguish some header-corruption errors from password-related errors. Those records preserve the experiments; the exact tests have not been rerun.

## Observations that remain useful

The notebook identifies the archive signature, relates a CRC field to file contents, maps compression settings to changing method bytes, and observes timestamp-dependent changes. It also notices the two-second relationship in part of the stored time representation.

The documented RAR 3.30 format has a file CRC, DOS-format timestamp, extraction-version field, and compression-method field. Its method values run from `0x30` for storage to `0x35` for best compression, supporting the notebook's compression mapping. [RAR 3.30 technical information](https://sources.debian.org/src/rar/3.30-2/technote.txt/).

## What I would explain differently today

Some notes label a fixed region as the stored password. That was a hypothesis, rather than a demonstrated format description. The period format documents a conditional salt and encrypted data; the original test archives would be needed to identify the notebook's exact regions confidently. [RAR 3.30 technical information](https://sources.debian.org/src/rar/3.30-2/technote.txt/).

Some calculations also confuse numeric representations with storage length. Sixteen byte values occupy sixteen bytes regardless of whether their values are written in decimal, hexadecimal, or octal. Adding their displayed values does not measure that length.

The timestamp observations were a useful start, but a complete explanation needs the packed DOS date/time fields. Seconds use two-second increments, while other bits encode minutes, hours, day, month, and year. [Microsoft's DOS date/time documentation](https://learn.microsoft.com/en-us/windows/win32/sysinfo/ms-dos-date-and-time).

## What this work demonstrates

The strongest evidence is the investigation process: controlled samples, binary comparison, behavioral probes, and recorded uncertainty. The notebooks do not establish a successful password-recovery technique or a complete RAR parser.

Continue with the [annotated observations](annotated-observations.md) for concrete examples of separating an observation from an explanation.

[Return to the collection](../../README.md)
