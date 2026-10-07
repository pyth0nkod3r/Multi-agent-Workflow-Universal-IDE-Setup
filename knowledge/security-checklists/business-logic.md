# Business Logic Security Review Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own products and codebases.
> **Date:** 28 Sept 2026
> **Source Attribution:** Distilled from elementalsouls/Claude-BugHunter (`hunt-business-logic`) (MIT+CC-BY 4.0).

This checklist focuses on business logic flaws, which are often unique to the application's domain and difficult for automated scanners to catch.

## 1. Trusting Client-Side State
Relying on the client to provide critical business data that should be securely managed on the server.
- [ ] **Look for:** Prices, discount amounts, item quantities, or user tiers submitted in POST/PUT request bodies or hidden HTML fields.
- [ ] **Verify:** Does the server recalculate and verify all prices, totals, and permissions against the database, regardless of what the client submits?
- [ ] **Test Case Requirement:** Reviewer must demand tests showing the server rejects tampered client-side totals.
- [ ] **Severity:** CRITICAL.

## 2. Missing Server-Side Validation of Sequences
Allowing users to skip mandatory steps in a multi-step business process (e.g., skipping payment).
- [ ] **Look for:** Multi-step wizards, checkout flows, or onboarding sequences.
- [ ] **Verify:** Does the final endpoint independently verify that all prerequisite steps (e.g., successful payment, KYC verification) have been completed successfully?
- [ ] **Severity:** HIGH.

## 3. Negative & Zero Quantities (Tampered Prices)
Failing to restrict numeric inputs to valid positive ranges, leading to logic inversion.
- [ ] **Look for:** Shopping carts, wallet top-ups, refund logic, or point transfers.
- [ ] **Verify:**
  - Are quantities strictly validated to be > 0?
  - Is it impossible to add negative quantities of an item to reduce the total cart price?
  - Are decimal overflows or rounding errors accounted for in financial calculations?
- [ ] **Severity:** HIGH.

## 4. Coupon & Referral Replay
Failing to enforce single-use properties on promotional codes or actions.
- [ ] **Look for:** Coupon code application, referral link clicks, one-time rewards, or voting.
- [ ] **Verify:** Is the state updated transactionally to prevent the same code from being applied multiple times to a single order or by a single user?
- [ ] **Severity:** MEDIUM.

## 5. Race Conditions on State Transitions
Concurrent requests exploiting a Time-of-Check to Time-of-Use (TOCTOU) window.
- [ ] **Look for:** Balance withdrawals, coupon applications, or inventory reservations.
- [ ] **Verify:**
  - Are database transactions, row-level locks (`SELECT ... FOR UPDATE`), or optimistic concurrency controls used to prevent double-spending?
  - If a user sends 10 simultaneous requests to redeem a $10 credit, will they only receive $10?
- [ ] **Test Case Requirement:** Reviewer must verify that state changes are wrapped in atomic transactions.
- [ ] **Severity:** HIGH.
