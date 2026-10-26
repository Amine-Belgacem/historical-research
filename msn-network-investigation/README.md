# MSN network investigation

**2000s · Network and protocol research**

I investigated the connections used by an MSN client: which destinations it contacted, when connections opened and closed, how sign-in interacted with the messaging conversation, and what changed when connectivity changed.

This investigation led to [MSN Hotmail Kira](../msn-hotmail-kira/README.md), the application in which I put the network and sign-in work into practice.

## Discovery and outcome

What I discovered at the time was an account-lockout behavior: repeated failed sign-in attempts could cause Hotmail to block access to the account. The legitimate owner of the email address would then be unable to sign in to their email.

In my observations, continuing the failed attempts maintained that denial of access. The account owner remained locked out for as long as MSN Hotmail Kira kept running and continuing the attempts. This was the practical finding that the application was built around.

This describes the historical behavior I observed during the investigation, as recalled for this retrospective.

## Original file

[MSN Messenger network research notebook](originals/MSN_Messenger_Network_Research_2006.txt)

The complete, unredacted notebook is kept here in its original bytes. Its filename labels it 2006; the exact sequence and dates of the experiments are approximate.

## Topics explored

- Connection states and the lifetime of individual connections.
- Different server roles during sign-in and messaging.
- Changes in behavior when a connection was blocked or closed.
- Requests, redirects, and authentication parameters.
- Translating observations into application behavior.

The notes mix French, Tunisian Arabic transliteration, and technical English, preserving the original working style.

## From research to application

The notebook preserves the investigation. [MSN Hotmail Kira](../msn-hotmail-kira/README.md) is its resulting application, built around the failed-sign-in lockout behavior, with the original VB6 protocol code, forms, resources, and compiled program. Its implementation brings together socket message handling, command dispatch, connection transitions, and asynchronous sign-in requests.

[Back to the collection](../README.md)
