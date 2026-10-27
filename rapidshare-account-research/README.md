# RapidShare account brute-force research

Historical research into RapidShare account enumeration and online password guessing, implemented in Visual Basic 6 during the 2000s. The research succeeded in obtaining working RapidShare accounts. This study brings the investigation and both original applications together.

## Research objective

Investigate whether login responses exposed account existence and whether supplied password candidates could identify working credentials for existing accounts.

## Finding and outcome

RapidShare returned different responses for a nonexistent account and an existing account with an incorrect password. This distinction exposed account existence independently of knowing the correct password.

The research applied that finding in two stages: account discovery, followed by password guessing. The account finder identified existing accounts; the account cracker tested password candidates against a supplied account list.

## The two applications

| Aspect | Account finder | Account cracker |
|---|---|---|
| Research role | Identify existing accounts through login responses. | Find working passwords for supplied accounts. |
| Inputs | An account list. | An account list and a password list. |
| Request pattern | Vary the account while keeping one password value fixed. | Iterate over password candidates for each account. |
| Response classification | Distinguish the account-not-found message from the existing-account/wrong-password message. | Recognize the wrong-password message; classify other responses as `Working`. |
| Display | `Found` or `Not Found`. | Account status and the candidate password associated with a `Working` result. |
| Connection between stages | Identify accounts for further testing. | Load a separately supplied account file. The finder has no automatic export into this stage. |

The search uses a supplied password list, making it dictionary-based online password guessing rather than exhaustive generation of character combinations.

## Source analysis

The finder's [check handler](originals/account-finder/Main.frm#L92) loops over loaded account identifiers, makes synchronous requests through the Internet Transfer Control, and classifies the response text. Its [load handler](originals/account-finder/Main.frm#L108) reads the account file into a list view.

The cracker's [main handler](originals/account-cracker/Main.frm#L134) adds a second loop over loaded password candidates and updates account status and password columns. It continues through the supplied candidates after a `Working` result, so subsequent attempts can change the displayed status. The handler does not save successful pairs to an output file.

In the archived implementation, `Working` means that the known wrong-password message was absent. The code does not check for an explicit successful-login response, so an unexpected response can receive the same label. The historical outcome was successful account access.

## Original projects

| Application | Project | Main source | Input files |
|---|---|---|---|
| Account finder | [RapidShare.vbp](originals/account-finder/RapidShare.vbp) | [Main.frm](originals/account-finder/Main.frm) | [Account list](originals/account-finder/accounts.txt) |
| Account cracker | [RapidShare.vbp](originals/account-cracker/RapidShare.vbp) | [Main.frm](originals/account-cracker/Main.frm) | [Account list](originals/account-cracker/found_accounts.txt), [password list](originals/account-cracker/passwords.txt) |

All source, input, log, and project files retain their original contents and filenames. The two project directories preserve their respective VB6 layouts inside this research folder.

```text
rapidshare-account-research/
    README.md
    originals/
        account-finder/       Complete original finder project
        account-cracker/      Complete original cracker project
```

[Back to the historical research collection](../README.md)
