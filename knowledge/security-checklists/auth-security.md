# Authentication & Session Security Review Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own products and codebases.
> **Date:** 28 Sept 2026
> **Source Attribution:** Distilled from elementalsouls/Claude-BugHunter (`hunt-auth-bypass`, `hunt-ato`) (MIT+CC-BY 4.0).

This checklist targets authentication bypass vectors, session management vulnerabilities, and account takeover (ATO) risks.

## 1. Authentication Bypass & Identity Claims
Trusting client-supplied data to determine identity rather than relying on secure server-side session state.
- [ ] **Look for:** Endpoints that determine identity via request parameters, body fields, or headers (e.g., `{"user_id": 123}` or `X-User-ID: 123`).
- [ ] **Verify:** Is the user identity derived *exclusively* from a cryptographically verified token or secure server-side session?
- [ ] **Severity:** CRITICAL.

## 2. Legacy Protocol & Endpoint Matrix
Older or alternative authentication paths often lack the security controls of the primary branded UI.
- [ ] **Look for:** Mobile API endpoints, XMLRPC, older versioned APIs (`/api/v1/login`), or alternative SSO entry points.
- [ ] **Verify:** Do all legacy or alternative endpoints enforce the exact same MFA, lockout, and password complexity rules as the main web login?
- [ ] **Severity:** HIGH.

## 3. JWT Validation Gaps
Misconfigurations in JSON Web Token handling that allow attackers to forge tokens.
- [ ] **Look for:** JWT library usage, especially custom validation wrappers.
- [ ] **Verify:**
  - Is the `alg: none` attack explicitly rejected by the library?
  - Is the signature validated on *every* request using a securely stored, hardcoded/env secret?
  - Is token expiry (`exp`) actively checked?
  - Is the audience (`aud`) and issuer (`iss`) verified to prevent token-audience confusion (e.g., accepting a token meant for a different service)?
- [ ] **Severity:** CRITICAL.

## 4. Session Management & Token Lifecycle
Failure to properly invalidate sessions or handle session transitions.
- [ ] **Look for:** Password reset flows, logout functions, and privilege changes.
- [ ] **Verify:**
  - Are all existing sessions/tokens revoked immediately after a password reset?
  - Does logging out invalidate the token on the server-side, or does it merely delete the cookie locally?
  - Are session cookies marked with `HttpOnly`, `Secure`, and `SameSite`?
- [ ] **Severity:** HIGH.

## 5. Account Takeover (ATO): Enumeration & Lockout
Vectors that allow attackers to guess credentials or map out valid users.
- [ ] **Look for:** Login, password reset, and registration endpoints.
- [ ] **Verify:**
  - Is user enumeration prevented? (e.g., "If this email exists, a reset link has been sent" vs "Email not found" differential responses).
  - Is there a strict account lockout or throttling mechanism (e.g., IP-based and account-based rate limiting) after 5-10 failed login attempts?
- [ ] **Severity:** MEDIUM to HIGH.
