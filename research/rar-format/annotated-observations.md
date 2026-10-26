# Selected observations, annotated

These are English paraphrases of surviving notes, selected and annotated in 2026. They are not a transcription of the entire notebook.

| Historical record | Interpretation | Reference value |
|---|---|---|
| Compare small archives containing the same input with and without password protection. | Controlling the input helps isolate differences caused by archive options. A single comparison still cannot establish the purpose of every changed byte. | Preserve the method; expand the explanation. |
| The beginning of the archive contains a recognizable RAR marker. | A signature provides a starting point for structural analysis. | Useful observation, consistent with the period specification. |
| Changing a filename does not necessarily remove password protection. | Filename metadata and protected file contents have distinct roles. | Useful experimental separation. |
| Different compression settings change the apparent method byte. | The notebook's progression agrees with documented storage and compression-method values. | One of the stronger field identifications. |
| Timestamp changes alter some metadata, and the seconds relationship appears doubled. | DOS time stores seconds in two-second units. The full timestamp requires interpretation of packed fields. | Useful partial discovery with a later correction. |
| Editing different regions produces header or password-related errors. | Error categories can guide a hypothesis about a field's role. They do not, on their own, prove that the field stores a password. | Preserve observations; qualify the inference. |
| Add numeric byte values and compare the sum with file size. | A sum of byte values is not a byte count. Writing a value in another base does not change storage length. | Preserve as an abandoned hypothesis rather than a reference formula. |

## Surviving notebook set

- Main reverse-engineering notebook: experiments and evolving interpretations.
- Empty-archive header comparison: supporting side-by-side observations.
- Password/content hexadecimal analysis: numeric tables and hypotheses, partly repeated in the main notebook.

The archive's exact file identifiers and hashes are recorded in the [source inventory](../../evidence/source-manifest.json). The diagrams and explanations here were prepared later.

Technical cross-check: [RAR 3.30 format documentation](https://sources.debian.org/src/rar/3.30-2/technote.txt/) and [Microsoft DOS date/time documentation](https://learn.microsoft.com/en-us/windows/win32/sysinfo/ms-dos-date-and-time).

[Back to the case study](README.md)
