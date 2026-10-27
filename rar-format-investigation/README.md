# RAR hex analysis

**2008 · Binary format research**

A byte-level investigation of RAR archive structure, metadata, compression, and password handling. Controlled sample creation, hexadecimal comparisons, and manual byte editing connected changes in the archive to changes in application behavior. Three notebooks document the experiments and conclusions.

## Structure and hex findings

A RAR 3.x archive starts with a seven-byte signature and an archive header, followed by file headers and packed data. The table connects the investigated regions to their positions in the format. Offsets beginning with `+` are hexadecimal offsets relative to a file header, whose fixed part occupies 32 bytes. Format reference: [RAR 3.30 technical information](https://sources.debian.org/src/rar/3.30-2/technote.txt/).

| Region | Location / size | Mapping and hex findings |
|---|---|---|
| Archive signature | Start of archive · 7 bytes | `52 61 72 21 1A 07 00`; the first four bytes encode `Rar!`. |
| Header flags | `+03–04` · 2 bytes | Flags determine protection settings and the presence of optional metadata. |
| Packed file size | `+07–0A` · 4 bytes | Size of the stored data; compared while varying compression and protection. |
| Unpacked file size | `+0B–0E` · 4 bytes | Original file size; related to the known-size input samples. |
| File CRC | `+10–13` · 4 bytes | Recorded bytes `B7 EF DC 83` correspond to displayed CRC32 `83DCEFB7` in little-endian order. Identical contents produced matching CRC values. |
| DOS date and time | `+14–17` · 4 bytes | Date and time fields were identified through sample changes, including the two-second units used for seconds. |
| Compression method | `+19` · 1 byte | `30` Store; `31` Fastest; `32` Fast; `33` Normal; `34` Good; `35` Best. |
| Filename length | `+1A–1B` · 2 bytes | Determines the filename field's length. |
| Filename | Variable field after the fixed header and any large-size fields | Filename changes were compared against changes in the archive bytes. |
| Optional metadata | Position depends on flags and filename length | Large-size fields, salt, and extended timestamps affect the header layout. |
| Packed file data | After the complete file header · variable length | Data regions were compared and edited between protected and unprotected samples. |

The password/content notebook records these two 16-byte data regions:

| Sample | Recorded bytes |
|---|---|
| A | `D1 1C BD 73 24 99 18 31`<br>`69 2A E9 E7 AC C2 A8 88` |
| B | `1B 0F 34 67 89 9C 00 21`<br>`F4 4F 3B 52 C5 23 8B 1F` |

These are compared data regions from the protected samples; they do not establish a stored-password field.

## Findings and conclusions from 2008

The table summarizes the findings and conclusions documented in the 2008 notebooks.

| Area | Conclusion in the 2008 notebooks |
|---|---|
| Archive structure | The opening signature and metadata regions were mapped to the filename, file size, timestamps, CRC, and compression method. |
| CRC and contents | Identical contents produced identical CRC values. The byte ordering was related to the CRC displayed by the application. |
| Compression | Changes in the method bytes were mapped to storage and the different compression settings. |
| Timestamps | Date and time regions were identified, including the two-second relationship for seconds. |
| Protected archive size | One comparison measured a 23-byte size difference between protected and unprotected samples. |
| Password representation | The early format model assigned a “16 hex” region to the password and an “8 hex” region to content. |
| Replacing archive regions | Region replacements between samples with matching contents or CRCs were recorded as changing the accepted password. The notebooks also document failed replacements and incorrect-password errors. |
| Header changes and repair | Header changes and repair were recorded as removing protection from an edited sample, with some modifications accepting different passwords. |
| Password length | The recorded result was that only the first 127 characters of a long test password affected the outcome in the tested version. |

The [final notebook entry](originals/WinRAR_Reverse_Engineering_Notes_2008.txt#L631) records “F1” working after a failed replacement. The original wording remains unchanged.

## Original files

- [Main reverse-engineering notebook](originals/WinRAR_Reverse_Engineering_Notes_2008.txt)
- [Empty-archive header comparison](originals/WinRAR_Empty_RAR_Header_Comparison_2008.txt)
- [Password and content hex analysis](originals/WinRAR_Password_Content_HEX_Analysis_2008.txt)

All three files are complete, unredacted copies of the archived originals, including their original encoding and line endings.

## Approach

| Step | Method |
|---|---|
| Create samples | Use files with known contents and sizes. |
| Vary one condition | Change compression, protection, filename, or timestamp. |
| Compare hexadecimal bytes | Identify changed regions and map them to archive fields. |
| Edit a copy | Replace selected bytes or regions between samples. |
| Record the result | Document archive behavior, accepted passwords, repair results, and errors. |

[Back to the collection](../README.md)
