# Doc Precision & Postmortem Standards
Adopted 26 Oct 2026 from the interview-study corpus (user-directed full adoption). Applies to ALL operational docs and incident reports workspace-wide. The critic applies this on doc-heavy diffs; the postmortem template is mandatory for any incident report in any project.

## Operational docs
- Every documented behavior names four things: **trigger → timing → actor → observable consequence**.
- Banned in operational prose: "refresh", "sometimes", "usually", "periodically" — name the concrete mechanism instead.
- Explicitly kill phantom mechanisms where a wrong mental model is likely ("no background refresh job exists").
- A doc disagreeing with code is itself an incident risk: flag it and ask the owner to confirm the actual implementation.
- Docs about runtime behavior get the same review discipline as code PRs — the person who debugs with them reviews them.

## Postmortem template (all seven sections required)
1. **Exact failure mode** — which component, which keys/pattern, what behavior, when it started. ("Cache issue" is a category, not a cause; stale reads / stampede / eviction storm / missed invalidation have different fixes.)
2. **Scope as numbers** — users, requests, duration. Numbers behave as nouns; never adjectives.
3. **Timestamped timeline (UTC)** — first bad data → detection → mitigation → resolution.
4. **Evidence with names** — log lines, metric names + values, dashboards; include ONE fully worked example traced key-by-key (e.g. cache-write time vs DB-write time for one record).
5. **Causal chain** — the condition that allowed it, not just the component that failed.
6. **Fix** — exact code/config change, owner, deadline.
7. **Verification + prevention** — the test/metric/alert that proves it is fixed and would catch recurrence; prevention action items each with an owner.

- **The bar:** a new engineer could verify the fix from the document alone. Every sentence survives the "says who?" challenge — a timestamp, a metric, a log line, or a key name; otherwise it is storytelling.
- **Missing data is a finding:** record the gap as an instrumented action item ("no consumer-lag data for this window — task, owner, due date"), never smooth prose over a hole.
- **Reference shape:** the invalidation-events-per-write 0.0-vs-1.0 root-cause pattern from the study corpus — scope, mechanism, evidence, detection, fix, proof, each carrying a number or named signal.
