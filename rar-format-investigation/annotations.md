# Later annotations

These technical notes were prepared in 2026. The [original notebooks](README.md) retain their original wording and calculations.

The [2008 conclusions](README.md#findings-and-conclusions-from-2008) are presented in the project introduction. The explanations below cover the file format and the calculations separately.

| Topic | Comment |
|---|---|
| Controlled comparisons | Keeping the input fixed while changing an archive option helps isolate the resulting differences. |
| Archive signature | The recognizable opening marker provides a starting point for understanding the file structure. |
| Compression methods | The notebook's method progression agrees with the historical values from `0x30` for storage through `0x35` for best compression. |
| Timestamps | The observed two-second relationship is part of DOS time encoding. The complete date/time uses packed fields. |
| Error responses | Different error categories help explore the role of a byte range, alongside structural comparisons. |
| Password-related regions | The format distinguishes headers, salt, and encrypted data. These have different roles from the password itself. |
| Numeric calculations | Decimal, octal, and hexadecimal describe the same byte values. Adding their displayed values does not measure the number of bytes occupied. |

References: [RAR 3.30 technical information](https://sources.debian.org/src/rar/3.30-2/technote.txt/) and [Microsoft DOS date/time documentation](https://learn.microsoft.com/en-us/windows/win32/sysinfo/ms-dos-date-and-time).

[Back to the work](README.md)
