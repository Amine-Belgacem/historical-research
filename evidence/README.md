# Inspect the evidence

These files contain historical notebook text and source, with the treatment of each item stated below. They accompany the retrospective articles; they are not newly written demonstrations pretending to be old work.

## Original research notes

| Attached file | Treatment |
|---|---|
| [RAR: main reverse-engineering notebook](notes/rar/01-reverse-engineering-notes.redacted.txt) | Complete text with local profile names and long test-password strings redacted. Original line order, mistakes, and hypotheses retained. |
| [RAR: empty-header comparison](notes/rar/02-empty-header-comparison.txt) | Complete text, no content edits. |
| [RAR: password/content hex analysis](notes/rar/03-password-content-hex-analysis.txt) | Complete text, no content edits. |
| [MSN: network notebook](notes/msn/network-research.redacted.txt) | Complete text with substantial redaction of account values, captured URLs, endpoint addresses, and authentication strings. Original line order retained. |

The explanatory articles are separate: [RAR study](../research/rar-format/README.md) and [MSN study](../research/msn-network/README.md). Errors in the historical notes have not been silently corrected.

## Original source text

| Attached file | Scope |
|---|---|
| [Configuration builder form](source/executable-configuration/builder/frmMain.frm) | Complete original form text. |
| [Configuration builder project](source/executable-configuration/builder/Compiler.vbp) | Complete original project text, including existing company metadata. |
| [Configuration reader/template form](source/executable-configuration/template/frmMain.frm) | Complete original form text. |
| [Configuration reader/template project](source/executable-configuration/template/prjRdfce.vbp) | Complete original project text. |
| [MSN message-framing excerpt](source/msn-application/message-framing.excerpt.vb) | Original `TransactionID`, `sckMain_DataArrival`, and `GetData` procedures, with source-range headings. |
| [FTP file-navigation excerpt](source/vb6-prototype/file-navigation.excerpt.vb) | Original directory/drive handlers and `EnumFiles`, with source-range headings. |
| [Batch password generator](source/smaller-experiments/password-gen.bat) | Complete original script, including its “SwYaraB” credit. Attribution remains unresolved. |
| [MUI component credit](source/credits/mui-original-credit.excerpt.txt) | Three original credit lines; component implementation omitted. |
| [Helper-routine credit](source/credits/routine-original-credit.excerpt.txt) | Original credited declaration; implementation omitted. |

Text is normalized to UTF-8/LF. No implementation fixes are applied. Some legacy bytes are interpreted as Windows-1252; this may not reproduce the intended box-drawing artwork in the batch banner. The byte-level originals remain in the private archive, with their hashes recorded here.

The form/project files still reference `.frx` resources and legacy components that are not supplied. Procedure excerpts depend on surrounding declarations and UI controls. These attachments document source rather than supply a complete build or runnable demonstration. The original scripts and executables were not run during preparation.

## Redacted database evidence

- [Dataset A](web-security/dataset-a.redacted.txt)
- [Dataset B](web-security/dataset-b.redacted.txt)
- [Dataset C](web-security/dataset-c.redacted.txt)
- [Dataset D](web-security/dataset-d.redacted.txt)
- [Computed structural summary](web-security/structure-summary.json)

Each sample uses the first five nonempty source lines. Every nonempty field is replaced with `[REDACTED]`, preserving only pipe delimiters and empty-field positions. There are no actual account values, names, email addresses, passwords, or individual credential hashes. These are redacted source excerpts, not invented example records.

Dataset identifiers hide the original target names. The aggregate summary records whole-file hashes and physical line structure. Delimiter counts are not a verified schema; line counts are not a count of unique people or evidence of a specific vulnerability. Read the [web security account](../research/web-security/README.md) for what is known and what still needs reconstruction.

## Provenance

The [manifest](source-manifest.json) provides original hashes and published-copy hashes, source encodings, line counts, edit locations, and excerpt ranges. Exact originals are retained separately at archive commit `4c238550057c64590882bc3e62c4ca7c5aa4f3ab`. A hash identifies an artifact; the attached content allows the reader to inspect the selected evidence. Neither independently establishes its historical date or every component's authorship.

[Return to the collection](../README.md)
