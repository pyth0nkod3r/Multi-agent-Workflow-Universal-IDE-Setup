# API Security Review Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own products and codebases.
> **Date:** 28 Sept 2026
> **Source Attribution:** Distilled from OWASP API Security Top 10 and elementalsouls/Claude-BugHunter (MIT+CC-BY 4.0).

This checklist covers common API misconfigurations, focusing on authorization, data exposure, and input validation.

## 1. Object-Level Authorization (BOLA / IDOR)
Every endpoint that takes an ID (e.g., `/api/users/{id}/profile`, `/api/invoices/{id}`) must verify that the currently authenticated user owns or has rights to that specific ID.
- [ ] **Look for:** Endpoints retrieving or modifying database records by ID.
- [ ] **Verify:** Is there a check ensuring `record.owner_id == current_user.id`?
- [ ] **Code Smell (Python/FastAPI):**
  ```python
  # BAD: Fetches based only on the requested ID
  @app.get("/invoices/{invoice_id}")
  def get_invoice(invoice_id: int, db: Session = Depends(get_db)):
      return db.query(Invoice).filter(Invoice.id == invoice_id).first()
  ```
- [ ] **Severity:** CRITICAL.

## 2. Mass Assignment
Accepting unvalidated fields in request bodies and blindly binding them to internal data models.
- [ ] **Look for:** Object updates using spread operators (`...req.body`) or full dict updates (`model.update(req.json())`).
- [ ] **Verify:** Is the input sanitized against a strict allowlist (e.g., Pydantic schema, Zod schema) that explicitly excludes internal flags like `is_admin`, `role`, or `plan_type`?
- [ ] **Code Smell (Node/Express):**
  ```javascript
  // BAD: Blindly merging user input into the database object
  app.put('/users/:id', async (req, res) => {
      await User.update(req.body, { where: { id: req.params.id } });
  });
  ```
- [ ] **Severity:** HIGH.

## 3. Function-Level Authorization
Admin or privileged endpoints that fail to verify the user's role, assuming UI hiding is sufficient.
- [ ] **Look for:** Routes prefixed with `/api/admin`, `/api/internal`, or performing destructive actions.
- [ ] **Verify:** Are RBAC/ABAC guards explicitly applied at the router or controller level?
- [ ] **Severity:** HIGH to CRITICAL.

## 4. Excessive Data Exposure
Returning more fields than the client application needs, relying on the frontend to filter out sensitive data.
- [ ] **Look for:** ORM calls directly returned as JSON (e.g., `return user_record`).
- [ ] **Verify:** Do response models filter out `password_hash`, `reset_token`, `internal_notes`, etc.?
- [ ] **Severity:** MEDIUM to HIGH.

## 5. Security Misconfiguration & CORS
Improperly configured security headers, wide-open CORS, or exposed Swagger/OpenAPI specs in production.
- [ ] **Look for:** CORS configurations allowing `*` origins while `credentials=true` is set.
- [ ] **Verify:** Are Swagger/Redoc endpoints `/docs`, `/openapi.json` disabled or authenticated in production?
- [ ] **Severity:** MEDIUM.

## 6. Rate Limiting & Resource Exhaustion
Lack of limits on how often an API can be called or how much data it can request.
- [ ] **Look for:** Login, password reset, or data-export endpoints without rate limit decorators.
- [ ] **Verify:** Is there a strict rate limit applied? Are pagination limits enforced (e.g., max 100 items per page) to prevent DoS via GraphQL or OData `$expand`/`$filter`?
- [ ] **Severity:** MEDIUM.
