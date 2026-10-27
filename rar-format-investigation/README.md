# RAR format investigation

**2008 · Binary format research**

A byte-level investigation of RAR archive structure, metadata, compression, and password handling. Controlled comparisons of file contents and archive settings produced field mappings and conclusions documented in three research notebooks.

## Findings and conclusions from 2008

The table summarizes the findings and conclusions documented in the 2008 notebooks. [Later technical notes](annotations.md) are kept separately.

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

```mermaid
flowchart LR
    A[Create a small input] --> B[Change one archive option]
    B --> C[Compare the bytes]
    C --> D[Form an explanation]
    D --> E[Modify a copy and observe behavior]
    E --> F[Record and refine]
```

*Diagram prepared in 2026 from the original notes.*

The experiments include creating files of known sizes, comparing protected and unprotected archives, varying compression, and changing individual byte regions. The notebooks also record how different changes affected errors and archive behavior.

[Later annotations](annotations.md) explain some findings using the historical format documentation while leaving the original notebooks unchanged.

[Back to the collection](../README.md)
