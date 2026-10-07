# Source Code Security Review Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own products and codebases.
> **Date:** 28 Sept 2026
> **Source Attribution:** Distilled from Lostsec's Bug Bounty Article (source-code security review shortcuts).

This checklist provides a structured approach for manual code reviews, focusing on practical exploitability.

**Review Discipline:** Do not assume a vulnerability exists. Separate confirmed issues from hypotheses. Rank findings by practical exploitability (Severity = Impact × Likelihood).

## 1. Authentication & Access Control
- [ ] **Look for:** Custom authentication middleware, role checks, and JWT parsing logic.
- [ ] **Verify:** Are access controls applied consistently by a central framework, or are they manually added to each route (risk of omission)?
- [ ] **Verify:** Are ID-based lookups checking ownership (BOLA/IDOR protection)?
- [ ] **Severity:** HIGH to CRITICAL.

## 2. Input Validation & Injection Risks
- [ ] **Look for:** Concatenated SQL strings, raw template rendering, or shell execution (`subprocess.run(..., shell=True)`, `eval()`, `exec()`).
- [ ] **Verify:** Is parameterized/prepared SQL used universally?
  - *Note our rule:* Parameterized SQL flagged by SAST linters is a **verified false positive**. Only raw string interpolation into SQL is an injection risk.
- [ ] **Verify:** Are template engines configured to auto-escape HTML to prevent XSS?
- [ ] **Severity:** CRITICAL.

## 3. Sensitive Information Exposure
- [ ] **Look for:** `.env` parsing, logging statements, and hardcoded values.
- [ ] **Verify:** Are there any hardcoded secrets, API keys, or passwords in the source?
- [ ] **Verify:** Are logs stripped of sensitive PII, session tokens, and passwords before writing?
- [ ] **Severity:** HIGH.

## 4. Insecure File Handling
- [ ] **Look for:** File upload endpoints, file reading utilities (`fs.readFile`, `open()`).
- [ ] **Verify:** Are uploaded files strictly validated by content type and extension?
- [ ] **Verify:** Are filenames sanitized to prevent directory traversal (`../`) attacks before being used in file system operations?
- [ ] **Severity:** HIGH.

## 5. Session Management
- [ ] **Look for:** Cookie configuration, session generation, and token expiration logic.
- [ ] **Verify:** Are cookies scoped tightly (domain/path) and secured (`HttpOnly`, `Secure`, `SameSite=Lax/Strict`)?
- [ ] **Verify:** Do sessions have an absolute timeout as well as an idle timeout?
- [ ] **Severity:** MEDIUM to HIGH.
