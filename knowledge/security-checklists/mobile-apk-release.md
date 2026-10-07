# Mobile APK Security Release Checklist
> **DEFENSIVE USE ONLY:** This checklist is for reviewing our own Android apps (e.g., FabricFocus) before release.
> **Date:** 28 Sept 2026
> **Source Attribution:** Distilled from elementalsouls/Claude-BugHunter (`apk-redteam-pipeline`) (MIT+CC-BY 4.0).

This checklist acts as a pre-release gate for Android APKs, ensuring attack surface is minimized and no secrets are shipped.

## 1. Exported Components Audit
Exported activities, services, receivers, and providers can be invoked by any other app on the device.
- [ ] **Look for:** `AndroidManifest.xml` tags with `android:exported="true"` or components with `<intent-filter>` declarations (which default to exported on older APIs).
- [ ] **Verify:** Are all exported components strictly necessary?
- [ ] **Verify:** Do the necessary exported components properly validate all incoming Intent data (to prevent intent injection or unauthorized actions)?
- [ ] **Severity:** HIGH.

## 2. Hardcoded Secrets Grep
Decompilers easily reveal strings embedded in the APK.
- [ ] **Look for:** API keys, AWS credentials, JWT tokens, Firebase database URLs, or staging endpoint URLs in `strings.xml`, `BuildConfig`, or raw code.
- [ ] **Verify:** Run a secret-scanning grep catalog (60-pattern list: e.g., `AKIA.*`, `eyJ.*`) against the decompiled APK (via `jadx` or source).
- [ ] **Verify:** Ensure no production credentials or sensitive keys are hardcoded.
- [ ] **Severity:** CRITICAL.

## 3. Debuggable & Cleartext Flags
Development flags left on in production builds.
- [ ] **Look for:** `AndroidManifest.xml` `<application>` tag.
- [ ] **Verify:** Is `android:debuggable="false"` explicitly set (or omitted for release builds)?
- [ ] **Verify:** Is `android:usesCleartextTraffic="false"` set to enforce HTTPS globally?
- [ ] **Severity:** HIGH.

## 4. WebView Hardening
WebViews executing untrusted content can lead to device compromise if misconfigured.
- [ ] **Look for:** Usage of `WebView` and `@JavascriptInterface`.
- [ ] **Verify:** If `setJavaScriptEnabled(true)` is used, is it absolutely required?
- [ ] **Verify:** Are Javascript bridges (`addJavascriptInterface`) restricted to trusted local content only?
- [ ] **Verify:** Are file access permissions (`setAllowFileAccess(false)`) disabled unless explicitly needed?
- [ ] **Severity:** HIGH.

## 5. Certificate Pinning Status
Protecting the app against Man-in-the-Middle (MitM) attacks on compromised networks.
- [ ] **Look for:** Network security configuration XML or OkHttp certificate pinner setup.
- [ ] **Verify:** Is certificate pinning implemented for critical backend API endpoints?
- [ ] **Severity:** MEDIUM (depending on threat model).
