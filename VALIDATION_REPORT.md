# SecurePass v2.0 — Audit & Validation Report

## Audit result

The v1 workflow was re-audited after manual testing showed confusion around Check In versus Active Visitors.

### Corrected UX interpretation

- **Active Visitors** contains visitors already checked in; therefore **Check Out** is the correct action there.
- v2 now makes this visually explicit with a green **INSIDE** badge and an explanatory live-roster banner.
- **Gate Operations** is the arrival queue. A green **Check In** button appears only for `ready_for_checkin` records.
- After Security Verify, the visit action modal refreshes immediately, so the user can see the transition to **Ready for Entry** and the green Check In button without hunting through another page.

## Security / logic findings fixed

1. **Host ownership loophole fixed:** crafted API calls can no longer let a host pre-register on behalf of another host.
2. **Department mismatch fixed:** a host must belong to the selected visit department.
3. **Host discovery minimized:** host users receive only their own host record from the host-list API.
4. **Host phone masking extended to visit-list API responses.**
5. **Past scheduled visits rejected.**
6. **Recurring pass replacement/revocation added.**
7. **Visit cancellation lifecycle added.**
8. **Emergency roster print/export added and permission-protected.**
9. **Login throttling added.**
10. **Hard-coded signing secret removed; a random local demo secret is generated/persisted.**
11. **Security headers added and public `/docs`/OpenAPI disabled.**
12. **SQLite WAL/busy timeout added plus DB-level prevention of duplicate simultaneous inside visits.**
13. **Whitespace-only names/purposes/pass types are rejected/normalized.**
14. **Organization search added.**
15. **Frontend host quick-action bug fixed:** host top button now routes to Pre-Register Visitor rather than the guard check-in workflow.

## Automated validation

- Python application compilation: **PASS**
- Frontend JavaScript syntax check (`node --check`): **PASS**
- Pytest API/security suite: **12/12 PASS**
- Live Uvicorn health endpoint: **PASS**
- Security headers on live server: **PASS**
- Guard login: **PASS**
- Ready-for-check-in seeded visitor available: **PASS**
- Active visitor list: **PASS**
- Emergency roster CSV: **PASS**
- Host emergency-roster access: correctly **BLOCKED (403)**
- Host-list ownership scope: **PASS**

## Test coverage includes

- login success/failure and failure throttling;
- disabled public API docs and security headers;
- phone-number duplicate-safe search;
- organization search;
- exact duplicate visitor prevention;
- mandatory security verification;
- mandatory required host approval;
- ready-for-check-in transition;
- check-in/check-out state transition;
- host ownership and department restrictions;
- cross-host approval denial;
- past schedule denial;
- visit cancellation and terminal-state protection;
- QR pass non-sequential tokens;
- pass replacement and revocation;
- host data masking and history scope;
- seeded ready-for-entry state;
- emergency roster export permissions and audit event.

## Browser automation note

A headless Chromium E2E run was attempted again. The execution environment blocks browser navigation by administrator policy (`ERR_BLOCKED_BY_ADMINISTRATOR`) even though the Uvicorn application is reachable through normal HTTP requests. This is an environment restriction, not an application HTTP failure.

Because of that policy, v2 validation combines:

- automated backend/security tests;
- frontend JavaScript syntax validation;
- live Uvicorn/HTTP endpoint validation;
- the user’s own browser-based manual verification on Windows.

A final manual browser rehearsal on the presentation laptop is still recommended after extracting the v2 ZIP.

## Production boundary

This remains a functional internship prototype. Direct production use in a bank/high-security organization still requires formal InfoSec, privacy, identity, infrastructure, network, retention, BCP/DR, penetration-test and operational approvals.
