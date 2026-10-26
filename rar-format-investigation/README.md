# RAR format investigation

**2008 · Binary format research**

I explored how a RAR archive changed when I varied its input, compression options, timestamps, filenames, and password settings. These notebooks record the experiments, byte comparisons, and ideas as they developed.

## Outcomes I recorded in 2008

The work produced a partial map of the archive format and a set of conclusions about password handling. This section preserves what I recorded at the time, including conclusions I would explain differently today.

| Area | My recorded outcome |
|---|---|
| Archive structure | I identified a recognizable opening signature and associated regions with the filename, file size, timestamps, CRC, and compression method. |
| CRC and contents | I observed the same CRC for the same contents and worked out how the displayed CRC bytes related to the value shown by the application. |
| Compression | I mapped changes in the archive bytes to storage and the different compression settings. |
| Timestamps | I associated changing bytes with the stored date and time, including the two-second relationship for seconds. Some of my general explanations of date layout were incomplete. |
| Protected archive size | I observed that protected samples were larger and recorded a 23-byte difference in one comparison. This was a result for those samples. |
| Password representation | I concluded that a particular region contained the password, describing it as “16 hex” and another region as “8 hex” of content. That was my interpretation of the samples, retained in the original notes. |
| Replacing archive regions | I recorded cases that I interpreted as transferring password behavior between samples with matching contents or CRCs. Other entries record unsuccessful replacements and incorrect-password errors. |
| Header changes and repair | I described an edited archive being corrected into a form I considered unprotected, and interpreted some modifications as accepting different passwords. These were my reported experimental outcomes and early explanations. |
| Password length | My notes report that only the first 127 characters of a long test password appeared to matter in the version I was testing. The exact version is not recorded here. |

The final notebook entry also says that “F1” worked after another replacement failed. Its exact meaning is not explained in the entry, so it is preserved in the [original wording](originals/WinRAR_Reverse_Engineering_Notes_2008.txt#L631).

The password-region and bypass explanations above are historical conclusions, not a newly demonstrated password-recovery method. [Later annotations](annotations.md) discuss their interpretation separately; the original results and working hypotheses remain part of the research story.

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
