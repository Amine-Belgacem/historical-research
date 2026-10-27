# Hotmail Kira

**2000s · Visual Basic 6 · MSN protocol application**

A Visual Basic 6 application developed from the [MSN network investigation](../README.md). It combines MSN socket communication with an asynchronous HTTP sign-in flow and an interface built around freeze and defreeze actions.

## Outcome

The application implemented the account-lockout finding. Repeated failed sign-ins caused Hotmail to block account access, including access by the legitimate owner. Continued attempts while Hotmail Kira was running maintained the lockout.

That is the historical meaning of the interface's “freeze” action. The research outcome was denial of account access through failed-sign-in lockout, and this application was the resulting implementation.

## Original project

- [Complete original files](originals/)
- [VB6 project](originals/hotmail%20kira.vbp)
- [Main form and protocol code](originals/hotmail%20kira.frm)
- [MD5 helper](originals/mdlMD5.bas)
- [Encryption helper](originals/modEncryption.bas)
- [About form](originals/about.frm)

Form resources, the compiled application, and the remaining original project files are preserved in the same folder.

## Application structure

```mermaid
flowchart LR
    A[Socket event] --> B[Receive buffer]
    B --> C[Message and payload handling]
    C --> D[Command dispatcher]
    D --> E[Connection transitions]
    D --> F[HTTP request]
    F --> G[Response callback]
    G --> D
```

*Diagram prepared in 2026 from the source.*

The source includes message framing, a transaction counter, command dispatch, redirect handling, and coordination between socket events, HTTP callbacks, timers, and UI actions.

The [parent investigation](../README.md) brings together the working notes, the lockout discovery, and this resulting application.

[Back to the investigation](../README.md) · [Back to the collection](../../README.md)
