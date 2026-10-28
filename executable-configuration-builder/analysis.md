# How the Executable Configuration Builder Worked

The [editable offline example](README.md#working-example) demonstrates property-bag storage and restoration using local display settings. The analysis below concerns the archived executable-writing implementation in `originals/`; its defects and byte layout do not describe the new example.

## From settings to a configured program

The project separates a **builder** from an **executable template**. The template contains the program logic; the builder supplies configuration. The button labelled “Compile” copies and configures an existing binary rather than compiling new program code.

| Stage | What happens in the source |
| --- | --- |
| Input | The builder collects an FTP host, username, password, and output filename. |
| Serialization | A VB6 `PropertyBag` stores the settings under `Text`, `Text2`, and `Text3`. Its binary contents are assigned to a `Variant`. |
| Template copy | The builder copies `rdfce.ext` to the selected output filename, normally `test.exe`. The template's `.ext` suffix does not change its underlying Windows executable format. |
| Configuration write | The builder opens the copy in binary mode and writes the serialized configuration, followed by a `Long` carrying its starting position. |
| Startup | The template source opens its own `.exe`, attempts to locate the configuration through the footer, and loads the property bag into its controls. |
| Connection | Those control values supply WinINet's FTP host, account name, and password. |

The field mapping is established by matching the builder's `WriteProperty` calls to the template's `ReadProperty` calls and its `InternetConnect` arguments. Serialization is storage, not encryption: the source contains no encryption step protecting these credentials.

The [builder form](originals/frmMain.frm#L77), [template form](originals/rdfce%20source/frmMain.frm#L142), and [project group](originals/ExeDemo.vbg) preserve this arrangement. The [template project](originals/rdfce%20source/prjRdfce.vbp) identifies `rdfce.ext` as its output.

## What is inside the saved output

The archived template is **32,768 bytes**; the saved output is **32,915 bytes**. Their first **32,767 bytes** are identical. The final output bytes are `00 80 00 00`, representing **32,768** as a signed, little-endian, four-byte integer.

The following offsets are **zero-based and inclusive**:

| Output offsets | Length | Contents |
| --- | ---: | --- |
| 0–32,766 | 32,767 bytes | Unchanged prefix of the executable template. |
| 32,767–32,910 | 144 bytes | Configuration region, including VB's serialized-data representation. Its first byte replaces the template's last byte. |
| 32,911–32,914 | 4 bytes | Stored configuration-position footer: 32,768 in VB's one-based position convention. |

The net growth is **147 bytes**, even though the written region plus footer occupies 148 bytes, because one existing byte is overwritten.

The PE section headers are unchanged:

| Section | Raw file offsets, zero-based and inclusive |
| --- | --- |
| `.text` | 4,096–20,479 |
| `.data` | 20,480–24,575 |
| `.rsrc` | 24,576–32,767 |

Consequently, 147 bytes lie beyond the section raw data, while the first configuration byte falls inside the last byte allocated to `.rsrc`. The file is not a byte-for-byte template followed only by an appended block. This observation alone does not establish whether that changed resource byte affects execution.

Microsoft documents [binary Get/Put positions](https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/get-statement) as one-based, [LOF](https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/lof-function) as the file size in bytes, and [Long](https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/long-data-type) as four bytes. These classic Visual Basic language rules explain the measured positions. The section boundaries follow Microsoft's [PE format specification](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format).

## What the generated program was intended to do

Startup proceeds directly into the connection code after configuration loading. It opens a WinINet session, requests a passive FTP connection on port 21, and asks for the current remote directory. The code tests for the response prefix `257` before continuing its directory-handling branch.

The upload source is fixed at `c:\1.jpg`, and the remote filename is `1.jpg`. Both branches of the local-path condition select the same file. The supplied template contains no image-capture operation and does not create that image; it must already exist for an upload to succeed.

The upload call occurs after the directory-response branches, including the branch that closes the connection handles. Its return value is ignored. The error helper retrieves server-response text, but its message box is commented out. Connection or transfer success therefore cannot be established from the program's visible completion messages.

These are outbound client operations. [InternetConnect](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetconnecta) opens a session to a destination, and [FtpPutFile](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-ftpputfilea) transfers a local file to that destination. The historical use of “server” for a generated Trojan component does not mean this program hosts an FTP service.

## Verification findings

| Check | Result and consequence |
| --- | --- |
| Saved template/output comparison | The matching prefix, serialized-data region, and four-byte footer confirm the configuration-storage mechanism. |
| Builder write position | `Seek #1, LOF(1)` selects the last existing byte. The measured output confirms that this byte is overwritten. |
| Reader footer position | `Get #1, LOF(1), BeginPos` starts on the final byte, although `BeginPos` requires four bytes. For the saved output it starts at zero-based offset 32,914, three bytes after the footer begins; only one stored byte remains. It cannot read the stored footer as written. |
| File and FTP failure handling | The builder has no file-error recovery. The template lacks a guard that prevents the upload call after failed connection setup and does not check the upload result. |
| Build/runtime inputs | The builder project references `COMDLG32.OCX` and an environment-specific OLE Automation path. The image input is external. The archived `rdfce source/prjRdfce.exe` is empty; `rdfce.ext` is the actual nonempty template. |
| Preservation | All 14 original files match their archived byte lengths and SHA-256 hashes. |

**Conclusion:** the configuration layout is verified, and the supplied reader has a definite position mismatch. The archived files are not certified as a working executable chain. The compiled template was not established to be identical to the supplied source revision; the binaries were not launched and no FTP transfer was performed.

## Relationship to the unfinished VB6 project

The [related configuration handler](../keylogger-unfinished/originals/Form1.frm#L489) uses the same pattern with properties named `ftp`, `nom`, and `pass`. It references a separate server template, `Files/servedit.exe`. Its [nested server project](../keylogger-unfinished/originals/seveur/Projet1.vbp) references external MSN password-stealing components. Those external source files and the referenced server template are absent from the collection.

The shared mechanism explains how an existing program could receive different connection settings without changing its underlying logic. This study documents that mechanism and its archived implementation. The original comments and Softrix project metadata remain intact.

[Back to the work](README.md)
