# Selected observations from the network notebook

These summaries are retrospective paraphrases. Original addresses, account identifiers, password values, and authentication strings have not been copied.

For inspectable evidence, read the [redacted original notebook](../../evidence/notes/msn/network-research.redacted.txt) and the [original VB6 framing excerpts](../../evidence/source/msn-application/message-framing.excerpt.vb). This page remains a separate interpretation of those artifacts.

1. **Connections have lifetimes.** The notebook records destinations appearing in different connection states and asks which stages open or close them. The useful evidence is the sequence of events, rather than a list of old addresses.
2. **Different endpoints may serve different roles.** Some destinations are described as sign-in related and others as messaging related. These are historical hypotheses, not a complete independently verified topology.
3. **Interventions can test a hypothesis.** Notes describe changing connectivity and observing whether sign-in or another behavior continues. The exact original environment is unavailable, so the record is preserved as an observation report.
4. **Authentication crosses component boundaries.** The related application coordinates a socket conversation with an asynchronous HTTP request and redirect handling. This is visible in the source, independently of whether each request in the notebook was successful.
5. **Protocol messages need framing.** The source checks for a line terminator and, for some message types, enough payload data before dispatch. This offers a concrete example of translating protocol observations into application structure.

The original material also contains incomplete experiments and repeated request variations. Those have not been rewritten as successful results. The exact relationship between each notebook entry and each code revision remains unresolved.

[Back to the case study](README.md)
