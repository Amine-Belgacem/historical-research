# Trojan Builder Configuration

This VB6 project illustrates how historical Trojan builders packaged FTP configuration inside a generated executable, and what that configuration served.

## Historical purpose

In this builder/template design, the program already contained its core logic. The builder supplied the destination and account settings for a particular generated copy. This allowed the same program to carry different FTP configurations without recompiling its logic or relying on an external configuration file.

For Trojans and keyloggers that reported through FTP, these settings told the program where to upload collected information and how to authenticate. Embedded FTP credentials used for this purpose are documented in [Zscaler's iSpy analysis](https://www.zscaler.com/blogs/security-research/ispy-keylogger).

| Embedded setting | Historical role |
| --- | --- |
| FTP host | The destination receiving uploaded data. |
| FTP username | The account used to access that destination. |
| FTP password | Authentication for the upload account, separate from any passwords the malware collected. |

The historical term **Trojan server executable** referred to the generated payload running on the affected computer. In this FTP workflow, that program acted as a client of a separate FTP server. The builder configured the payload; it did not create the remote FTP service.

## The two projects

- [Builder.vbp](source/Builder.vbp) collects an FTP host, username, and password, then embeds them into a copy of the template EXE.
- [Template.vbp](source/Template.vbp) supplies the executable. The configured copy reads its settings from its own file at startup and displays them.

Together they demonstrate the configuration stage. The template displays the recovered values without collecting information, connecting, or uploading.

## Build

Open [TrojanBuilderConfiguration.vbg](source/TrojanBuilderConfiguration.vbg) to edit both projects in VB6. Build from PowerShell in this folder:

```powershell
.\build.ps1
```

The script uses an installed VB6 compiler; supply `-Compiler` for a different location. Run `build/TrojanConfigBuilder.exe` with `TrojanConfigTemplate.exe` beside it, enter example settings, and select **Build EXE**. The generated EXE runs independently, without an external configuration file.

The [shared module](source/Configuration.bas) preserves the template bytes, appends a serialized `PropertyBag`, and writes a 16-byte footer containing `FTPDMO01`, the payload offset, and its length. The template uses that footer to locate its settings.

Serialization does not encrypt passwords; use dummy credentials for the example. The property-bag and footer format above belongs to this demonstration, rather than representing every historical Trojan's storage format.

[Back to the collection](../README.md)
