# RapidShare account cracker

**2000s · Visual Basic 6**

A Visual Basic 6 application forming the password-guessing stage of the [RapidShare account brute-force research](../rapidshare-account-finder/README.md). The companion finder identifies existing accounts; this application tries supplied password candidates against supplied accounts. The research succeeded in obtaining working RapidShare accounts.

## Role in the research

| Component | Purpose |
|---|---|
| Account input | Loads the account list used for password testing. |
| Password input | Loads candidate passwords from a separate file. |
| Request loop | Iterates through the password list for each account. |
| Response classification | Marks the known wrong-password response as `Found`; other responses are marked `Working`. |
| Result display | Shows account status and the candidate password associated with a `Working` result. |

The [main handler](originals/Main.frm#L134) uses nested loops, synchronous requests through the Internet Transfer Control, and list-view updates. It continues through the supplied passwords after marking a result as working, so later attempts can change the displayed status. The handler does not save successful pairs to an output file.

## Difference from the finder

The finder varies account identifiers while keeping one password value fixed, using distinct failure messages to detect account existence. This project varies passwords as well: it performs dictionary-based online password guessing. The [comparison](../rapidshare-account-finder/README.md#difference-between-the-applications) presents both stages together.

The `Working` label is assigned when the known wrong-password message is absent. It is not an explicit successful-login check, so unexpected responses could also be classified as working. This describes the archived implementation's result handling; the historical research outcome was successful account access.

## Original project

- [Complete original files](originals/)
- [VB6 project](originals/RapidShare.vbp)
- [Main form](originals/Main.frm)
- [Original account input](originals/found_accounts.txt)
- [Original password input](originals/passwords.txt)

All source, input, log, and project files are preserved without changes. The project sits alongside the related [account finder](../rapidshare-account-finder/README.md) as the second component of the same research.

[Back to the collection](../README.md)
