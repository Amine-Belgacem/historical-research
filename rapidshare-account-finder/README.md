# RapidShare account brute-force research

**2000s · Visual Basic 6**

Research into RapidShare account enumeration and online password guessing, implemented as two Visual Basic 6 applications: the account finder and the [account cracker](../rapidshare-account-bruteforcer/README.md). The research succeeded in obtaining working RapidShare accounts.

## Finding and outcome

RapidShare returned different login messages for an account that did not exist and an existing account with an incorrect password. That distinction exposed account existence independently of knowing the correct password.

The finder used this distinction to identify existing accounts. The cracker tested candidate passwords against a supplied account list. Together, the projects cover account discovery followed by password guessing.

## Difference between the applications

| Aspect | Account finder | Account cracker |
|---|---|---|
| Research role | Identify existing accounts from login responses. | Find working passwords for supplied accounts. |
| Inputs | One account list. | An account list and a password list. |
| Request pattern | One fixed password value while varying the account. | Nested account and password loops. |
| Response handling | Distinguishes the existing-account/wrong-password message from the account-not-found message. | Recognizes the wrong-password message; otherwise marks the pair as working. |
| Displayed result | `Found` or `Not Found`. | Account status and the candidate password associated with a `Working` result. |
| Connection between stages | Identifies candidates for the password-guessing stage. | Loads a separate account file; the finder does not automatically export it. |

## Source analysis

The finder's [check handler](originals/Main.frm#L92) iterates through loaded accounts, makes synchronous requests with the Internet Transfer Control, and classifies the returned text. Its [load handler](originals/Main.frm#L108) reads the account file into a list view. There is no password-list loop in this project.

The cracker's [request loop](../rapidshare-account-bruteforcer/originals/Main.frm#L134) adds a second iteration over loaded passwords. Its inputs are supplied lists, so its password search is dictionary-based online guessing rather than exhaustive generation of character combinations.

The source records how the applications classified responses. The cracker's `Working` label is based on the absence of one error message, rather than an explicit successful-login check; an unexpected response could receive the same label. The historical success of the research and this classification limitation are separate facts.

## Original project

- [Complete original files](originals/)
- [VB6 project](originals/RapidShare.vbp)
- [Main form](originals/Main.frm)
- [Original input file](originals/accounts.txt)

The source, inputs, and project files remain unchanged. The original finder project is retained here; the companion [cracker project](../rapidshare-account-bruteforcer/README.md) documents the second stage of the same research.

[Back to the collection](../README.md)
