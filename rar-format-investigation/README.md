# RAR format investigation

**2008 · Binary format research**

I explored how a RAR archive changed when I varied its input, compression options, timestamps, filenames, and password settings. These notebooks record the experiments, byte comparisons, and ideas as they developed.

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
