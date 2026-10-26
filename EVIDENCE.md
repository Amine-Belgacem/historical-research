# Evidence and editorial method

## Three kinds of statements

**Historical observation:** something recorded in a surviving notebook, or a mechanism visible in surviving source. This establishes what was written or implemented, without independently reproducing its runtime behavior.

**Retrospective explanation:** a new explanation or diagram written in 2026 to make the old material understandable. These diagrams are reconstructions, not contemporary screenshots.

**Unresolved:** a date, attribution, technical method, or runtime result that cannot be established from the available material. Such gaps remain explicit rather than being filled with a plausible story.

## Source material

The presentation was derived by read-only inspection of a separate private archive at commit `4c238550057c64590882bc3e62c4ca7c5aa4f3ab`. Readers can inspect [attached evidence](evidence/README.md), including four notebooks, five complete source-text files, procedure and credit excerpts, and four field-redacted database samples.

The [source manifest](evidence/source-manifest.json) distinguishes original file hashes from the hashes of the published copies. It records source encodings, original line counts, redaction locations, and excerpt ranges. The complete notebooks retain their original line order and count. Text is converted to UTF-8 with LF line endings; original implementations and credits are not corrected or rewritten. Hashes identify the files but do not establish historical dates or authorship.

The original archive is not a submodule, copied history, or build dependency of this repository. These pages can be read independently. The original files and repository history have been preserved in place.

## Treatment of sensitive material

The research pages retain experimental questions, observations, reasoning, and corrections. The MSN notebook has explicit redactions for account details, captured URLs, endpoint addresses, and authentication strings. The RAR notebook removes local profile names and long test-password strings; its hypotheses and arithmetic remain visible as originally written.

The database excerpts come from the first five nonempty lines of each of four real archival files. Every nonempty field, including any header-like value, is replaced with `[REDACTED]`. Only pipe delimiters and empty-field positions survive. These are redacted source excerpts, not invented records; the accompanying aggregate summary is newly computed. No actual person or account value, individual credential hash, captured log, or raw account list is published.

No surviving database file has been treated as proof of a particular vulnerability, access scope, extraction technique, or number of affected people. Line counts would not establish those conclusions.

## Source-file scope

The executable-configuration example includes the complete builder and template form/project text. Referenced `.frx` resources, OCXs, and executable templates are not included, so this is source evidence rather than a complete build package. The MSN and FTP examples contain selected original procedures with source-range comments; the surrounding application and account-related operations are omitted. The batch generator retains its original author banner. Separate credit excerpts preserve existing component attribution.

## Verification limits

Original executables and batch files were not run. Historical services were not contacted. No successful VB6 build or runtime demonstration is claimed. Legacy IDE logs help identify dependencies and incomplete imports, but do not establish whether the projects worked in their original environment.

Application walkthroughs describe mechanisms visible in source. The WinRAR study compares some observations with documentation for the historical format; it does not substitute a current archive format for the one being investigated.

## How to extend the collection

Add a recollection as a recollection, a recovered contemporary note as historical evidence, and a new reproduction as a new experiment with its own date and environment. Keep original findings and later corrections distinguishable.

[Return to the collection](README.md)
