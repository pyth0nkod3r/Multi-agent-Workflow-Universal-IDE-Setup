# Paystack Integration Knowledge & Contracts

Canonical reference for EaseApply payment integration via Paystack API (paystack.com/docs, verified 11 Oct 2026).

## Key Contracts & Specifications

- **Base URL & Auth:** `https://api.paystack.co` (both test & live). `Authorization: Bearer SECRET_KEY`. Keys: `sk_test_...` vs `sk_live_...`.
- **Currency Subunits:** NGN amount in kobo (base * 100). Minimum ₦50 (`5000` kobo). E.g. ₦10,000 Pro plan = `1000000` kobo.
- **Initialize Transaction (`POST /transaction/initialize`):**
  - Body: `email`, `amount`, `plan` (optional `PLN_...` plan code overrides `amount`), `callback_url`, `metadata: {"user_id": ..., "plan": "pro"}`.
  - Returns: `data.authorization_url` (`https://checkout.paystack.com/{access_code}`), `data.access_code`, `data.reference`.
- **Verify Transaction (`GET /transaction/verify/{reference}`):**
  - Status semantics: `data.status` (`"success"`, `"failed"`, `"abandoned"`). Verified on `data.status == "success"`, `amount`, `paid_at`.
- **Webhooks & Security:**
  - Header: `x-paystack-signature`.
  - Signature: HMAC-SHA512 hex of RAW body bytes with secret key (`hmac.compare_digest`).
  - Whitelist IPs: `52.31.139.75`, `52.49.173.169`, `52.214.14.220`.
  - Must return `200 OK` immediately (live retries up to 72 hours).
- **Events -> Role Mapping:**
  - Pro Grant: `charge.success` (with plan), `subscription.create`.
  - Pro Demote: `subscription.disable`, `invoice.payment_failed`.
  - Non-Renewing: `subscription.not_renew` (maintain Pro until period ends).
- **Plans & Subscriptions:**
  - Create Plan (`POST /plan`): `name`, `amount` (kobo), `interval: "monthly"`, `currency: "NGN"`.
  - Monthly billing rule: created <=28th bills same day monthly; 29th-31st bills on 28th.
  - Customer Portal Link: `GET /subscription/{code}/manage/link` returns hosted card/cancel update link.
  - Disable: `POST /subscription/disable` requires `code` and `token` (`email_token`).
- **Operational Invariants:**
  - Customer emails cannot be modified in Paystack (`PUT /customer/{code}` excludes email). Always embed immutable `user_id` in `metadata` and resolve webhooks via `metadata.user_id` first.
  - Reference generation: use prefix `ea_pstk_{user_id}_{hex}` for idempotency.

Pointers: Detailed research doc and full Python adapter implementation in `/workspace/platform/docs/RESEARCH-paystack.md`.
