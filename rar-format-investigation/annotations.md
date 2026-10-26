# Later annotations

These comments were prepared in 2026. The [original notebooks](README.md) retain their original wording, calculations, and hypotheses.

The [recorded outcomes](README.md#outcomes-i-recorded-in-2008) belong in the account of the work even where an explanation was incomplete or incorrect. These later comments accompany those outcomes rather than replace them.

| Topic | Comment |
|---|---|
| Controlled comparisons | Keeping the input fixed while changing an archive option helps isolate the resulting differences. |
| Archive signature | The recognizable opening marker provides a starting point for understanding the file structure. |
| Compression methods | The notebook's method progression agrees with the historical values from `0x30` for storage through `0x35` for best compression. |
| Timestamps | The observed two-second relationship is part of DOS time encoding. The complete date/time uses packed fields. |
| Error responses | Different error categories help explore the role of a byte range, alongside structural comparisons. |
| Password-region hypotheses | Some notes describe a region as the stored password. A fuller explanation needs to distinguish headers, salt, and encrypted data. |
| Numeric calculations | Decimal, octal, and hexadecimal describe the same byte values. Adding their displayed values does not measure the number of bytes occupied. |

The notes' reports of password changes, apparent acceptance of different passwords, and repair behavior describe the experiments as I understood them then. They do not establish a general password bypass. The final “F1” entry and the reported 127-character observation remain recorded outcomes whose exact conditions would need the original environment and test archives to reconstruct.

References: [RAR 3.30 technical information](https://sources.debian.org/src/rar/3.30-2/technote.txt/) and [Microsoft DOS date/time documentation](https://learn.microsoft.com/en-us/windows/win32/sysinfo/ms-dos-date-and-time).

[Back to the work](README.md)
