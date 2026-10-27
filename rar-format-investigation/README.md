# RAR format investigation

**2008 · Binary format research**

I explored how a RAR archive changed when I varied its input, compression options, timestamps, filenames, and password settings. These notebooks record the experiments, byte comparisons, and ideas as they developed.

## Findings and conclusions from 2008

The following summarizes my findings and conclusions in the 2008 notebooks. [Later technical notes](annotations.md) are kept separately.

| Area | Conclusion in my 2008 notes |
|---|---|
| Archive structure | I identified a recognizable opening signature and associated regions with the filename, file size, timestamps, CRC, and compression method. |
| CRC and contents | I observed the same CRC for the same contents and worked out how the displayed CRC bytes related to the value shown by the application. |
| Compression | I mapped changes in the archive bytes to storage and the different compression settings. |
| Timestamps | I associated changing bytes with the stored date and time, including the two-second relationship for seconds. |
| Protected archive size | I measured a 23-byte size difference between protected and unprotected samples in one comparison. |
| Password representation | I concluded that the password occupied a region described as “16 hex,” with another “8 hex” region representing content. |
| Replacing archive regions | I concluded that replacing regions between samples with matching contents or CRCs changed which password was accepted. The notebooks also record failed replacements and incorrect-password errors. |
| Header changes and repair | I concluded that header changes and repair removed password protection in an edited sample, and that some modifications allowed different passwords to be accepted. |
| Password length | I recorded that only the first 127 characters of a long test password affected the result in the version I tested. |

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
