# MSN network investigation

**2000s · Network and protocol research**

An investigation of MSN client connections and authentication, covering server roles, connection lifecycles, and the relationship between sign-in and messaging. The central finding was a Hotmail account-lockout behavior triggered by repeated failed sign-ins.

The research led to [MSN Hotmail Kira](msn-hotmail-kira/README.md), the Visual Basic 6 application included with this investigation.

## Discovery and outcome

Repeated failed sign-in attempts triggered a Hotmail account lockout, preventing the legitimate account owner from accessing their email.

Continuing the failed attempts maintained that denial of access. The account owner remained locked out for as long as MSN Hotmail Kira kept running and continuing the attempts. This was the finding that the application was built around.

## Research notebook

[MSN Messenger network research notebook](originals/MSN_Messenger_Network_Research_2006.txt)

The complete, unredacted working notebook is kept here in its original bytes.

## Research scope

- Connection states and the lifetime of individual connections.
- Different server roles during sign-in and messaging.
- Changes in behavior when a connection was blocked or closed.
- Requests, redirects, and authentication parameters.
- Translating observations into application behavior.

The notes mix French, Tunisian Arabic transliteration, and technical English, preserving the original working style.

## From research to application

### MSN Hotmail Kira

[MSN Hotmail Kira](msn-hotmail-kira/README.md) implements the failed-sign-in lockout finding. It combines MSN socket communication with an asynchronous HTTP sign-in flow and an interface built around freeze and defreeze actions. The interface's historical “freeze” action refers to the account-lockout behavior described above.

The implementation brings together socket message handling, command dispatch, connection transitions, and asynchronous sign-in requests. The [complete original project](msn-hotmail-kira/originals/) includes the VB6 source, forms, resources, helper modules, and compiled program.

## Folder layout

```text
msn-network-investigation/
    README.md                    Research, discovery, and resulting application
    originals/                   Original research notebook
    msn-hotmail-kira/
        README.md                Application details
        originals/               Complete original VB6 project
```

The notebook and application are successive stages of the same work, kept together here with their original files unchanged.

[Back to the collection](../README.md)
