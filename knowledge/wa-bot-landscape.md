# WhatsApp bot landscape (as of 27 Sept 2026)

Full research: `runs/wa-bot-research/out-wa-bot.md`.

## Library state
- **Baileys (WhiskeySockets)**: active, npm `latest` 7.0.0-rc14 + `legacy` 6.7.24 (both 2026-07-29), Node ≥20, repo pushed daily, docs now baileys.wiki. MD-protocol (no browser). QR OR pairing-code link; `useMultiFileAuthState` for sessions.
- **whatsapp-web.js (wwebjs org)**: 1.34.7 (2026-04-24), Node ≥18, puppeteer-based — heavier, slower cadence.
- **CVE-2026-48063 (GHSA-qvv5-jq5g-4cgg, CVSS 9.3)**: malicious protocolMessage → fake `messages.upsert` / history spoofing. Fixed 6.7.22 / 7.0.0-rc12. **EaseApply must run patched versions and treat WA-ingested content as untrusted (spoofable feed).**

## Official API verdict
- Meta **Groups API** (open to all OBA) = invite-only groups, **max 8 participants**, 1 business/group, own-created groups only. **Cannot monitor public/community job groups** → unofficial libs are the only path.
- 2026 policy tightening: AI-providers ToS ban (15 Jan 2026), new WhatsApp account model rollout (Sep 23 → mid-Oct 2026).

## Ban posture (documented)
- 2025-10 wave (issue #1869, 5 bots in a week); 2026 steady stream: Jan temp bans (#2260/#2309), Jul degraded-restore (#2699), Sep **OBA instant ban on datacenter handshake** (#2805, open).
- Triggers: unofficial-client detection, OBA accounts, large-group joins, status uploads, volume, login churn. Official temp-ban text explicitly names **scraping**.
- Safest config: disposable SIM consumer number (no VoIP, no personal, no OBA), 1 number/VPS, strictly read-only (no sendMessage, `markOnlineOnConnect:false`), jittered cadence, persist auth state, never re-scan QR in loops.

## Architecture for EaseApply
- Node 22 service on HidenCloud (Baileys) → filter job-signal msgs (regex + URL) → dedupe by WA msg id → **batch POST to FastAPI `/v1/ingress/wa`** (scoped `wa` API key, same raw_ingress ETL as cron scrapers — no direct DB writes, platform-swappable). Python/uv stack untouched.
- ToS is violated (scraping + unofficial automation both named) but enforcement is per-number → budget SIM churn + re-provisioning; Pro-gated source with per-market kill-switch.

## Pointers
- Registry: registry.npmjs.org/{baileys,whatsapp-web.js}; advisories: api.github.com/advisories/GHSA-qvv5-jq5g-4cgg
- Meta docs: developers.facebook.com/documentation/business-messaging/whatsapp/{groups,groups/groups-messaging/,changelog}
- Ban log: github.com/WhiskeySockets/Baileys/issues (search "banned")
