# Frontend Security Review Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own products and codebases.
> **Date:** 26 Oct 2026
> **Source Attribution:** Distilled from the interview-study corpus frontend tracks (React/JS security items) plus OWASP practice; complements api-security.md and auth-security.md.

Used by the critic on substantive frontend diffs (Gate 9 scope) and by builders pre-submit.

## 1. Token & Session Storage
- [ ] **Rule:** Session tokens in httpOnly + Secure + SameSite cookies by default, or in-memory with refresh-token rotation. NEVER long-lived tokens in localStorage/sessionStorage — any XSS payload can exfiltrate them.
- [ ] **Look for:** `localStorage.setItem('token', ...)`, JWTs in localStorage, tokens persisted from Redux/Context.
- [ ] **Verify:** Cookie-authenticated flows have a CSRF defense; one storage policy across web surfaces.
- [ ] **Severity:** CRITICAL.

## 2. Dangerous HTML / XSS
- [ ] **Rule:** Every `innerHTML` / `dangerouslySetInnerHTML` site sanitizes with DOMPurify (or equivalent) in the same file, with a comment naming the sanitizer. eslint `react/no-danger` (warn) marks every site for review.
- [ ] **Look for:** Rich-text/markdown rendering, user-supplied URLs in `href`/`src` (javascript: scheme), `iframe.src`, `postMessage` handlers without origin checks.
- [ ] **Severity:** HIGH.

## 3. Content-Security-Policy
- [ ] **Verify:** Strict CSP with nonce shipped from the server; no reliance on inline scripts; violations reported in staging.
- [ ] **Severity:** MEDIUM-HIGH.

## 4. Client-Exposed Secrets
- [ ] **Look for:** Secrets under client-exposed env prefixes (VITE_*, NEXT_PUBLIC_*, REACT_APP_*), API keys in the bundle, private endpoints referenced by client code.
- [ ] **Verify:** Anything shipped to the bundle is public by definition — gitleaks will NOT catch intentional exposure; this line does.
- [ ] **Severity:** HIGH.

## 5. Event & Effect Hygiene (leak + race)
- [ ] **Look for:** `addEventListener` / `setInterval` / WebSocket / polling added in components without matching cleanup on unmount (detached-node memory leak); async effects without race guards on param change (AbortController.abort() or ignore flag).
- [ ] **Verify:** Every subscription has a teardown; every fetch keyed by an id aborts or ignores stale responses.
- [ ] **Severity:** MEDIUM (memory + correctness).

## 6. Authorization Surface
- [ ] **Verify:** User/tenant isolation enforced at the DATABASE layer (RLS or equivalent) — never by developer-discipline WHERE clauses. Standing probe: authenticated user A cannot render or read user B's rows via any route.
- [ ] **Severity:** CRITICAL.

## 7. Performance-as-Safety (soft rules)
- [ ] Server-side cursor pagination (WHERE id > last LIMIT) for large lists — never deep OFFSET scans; virtualize past a size threshold (react-window).
- [ ] Memoization (useMemo/useCallback/React.memo) only after a measured re-render cost — memoizing without measuring is overhead with zero benefit.
- [ ] Context reserved for low-frequency state (theme, auth user); rapidly-changing data in Context re-renders every consumer; server data lives in a query/cache layer, not hand-rolled in Redux.
- [ ] State placement (decision matrix): local UI state stays in useState/useReducer — lift only when siblings need it; Zustand/Redux only for genuinely client-owned complex state (wizards, editors, players) — never as a hand-rolled mirror of backend API responses.
