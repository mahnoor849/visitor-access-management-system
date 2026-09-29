# SecurePass v2.0 — Audited Enterprise Demo

**Visitor & Temporary Access Management — Internship Prototype**

SecurePass digitizes the manual visitor register while keeping security staff in control. It supports guard-assisted visitor registration, returning-visitor lookup, recurring QR passes, employee pre-registration, host approval, security verification, explicit gate check-in/check-out, live visitor accountability, emergency roster export, visitor analytics, exception alerts, pass revocation, visit cancellation and audit logging.

> **Prototype boundary:** This is an internship/demo prototype and is **not an official the host organization product or production deployment**. Use synthetic/demo data only unless the organization has formally approved the data-handling and deployment design.

## What changed in v2.0

- **Clear Gate Operations workflow:** Expected → Approval → Security Verification → Ready for Entry → Check In.
- **Green Check In action appears only when a visit is truly ready.**
- **Active Visitors now clearly shows a green INSIDE badge.** Active visitors are already checked in, so the valid gate action there is Check Out.
- Added a seeded **Sara Raza** record in `ready_for_checkin` state so the Check In action is visible immediately after a fresh demo reset.
- After Security Verify, the visit modal refreshes in place and shows the green Check In button if all controls are complete.
- Added **Emergency Roster** print and CSV export.
- Added **Visit cancellation** with audit logging.
- Added **Recurring pass revoke/replace** behavior.
- Hosts are now enforced server-side to pre-register **only for themselves and their own department**.
- Guards cannot assign a host from a different department.
- Host API results now preserve phone masking and ownership boundaries.
- Past scheduled visits are rejected.
- Search now also supports organization/company name.
- Added login-failure throttling, stronger PBKDF2 settings, random local signing secret, security headers and disabled public API documentation.
- SQLite now uses WAL, busy timeout and a database-level unique rule preventing two simultaneous `inside` visits for the same visitor.

## Run on Windows

### Easiest method

1. Extract the ZIP.
2. Double-click **`DEMO_START.bat`**.
3. The app opens at **http://127.0.0.1:8120**.
4. When finished, double-click **`DEMO_STOP.bat`**.

The starter checks Python, required packages, port 8120 and the application health endpoint before opening the browser.

### PowerShell method

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\DEMO_START.ps1
```

### Fresh demo reset

To restore the clean seeded demo state:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\reset-demo.ps1
```

Do this **before rehearsal**, not in the middle of a live presentation.

## Demo accounts

| Role | Username | Password |
|---|---|---|
| Security Officer | `guard1` | `Guard@123` |
| IT Employee / Host | `host.it` | `Host@123` |
| AI & Data Science Host | `host.ai` | `Host@123` |
| Security Supervisor | `supervisor` | `Supervisor@123` |
| Administrator | `admin` | `Admin@123` |

Additional seeded hosts exist for HR and Facilities so department-scoped host selection can be demonstrated.

## Correct gate workflow

### New / returning visitor

`Search or QR → Select/Create Profile → Create Visit → Host Approval (if required) → Security Verify → Ready for Entry → Check In → Inside → Check Out`

### Important UI rule

- **Gate Operations** = visitors not yet inside. This is where **Verify** and **Check In** appear.
- **Active Visitors** = visitors already inside. This page deliberately shows **INSIDE** and **Check Out**, not Check In.

## Recommended first demo

1. Login as `guard1`.
2. Open **Gate Operations**.
3. Find **Sara Raza** — she is seeded as **Ready for Entry**.
4. Show the green **Check In** button.
5. Check her in and open **Active Visitors**.
6. Show the green **INSIDE** badge and live duration.
7. Show **Print Roster / Export CSV**.
8. Check the visitor out.
9. Open **Visitor Check-In**, search `Areeba`, create an internship visit, press **Security Verify**, and show that the same modal changes to **Ready for Entry** with a green **Check In Visitor** button.
10. Login as `host.it` and demonstrate pre-registration/approval scope.
11. Login as `supervisor` to show Visitor Intelligence and Audit Trail.

## Current technology stack

- **Frontend:** HTML5, CSS3, vanilla JavaScript
- **Backend:** Python + FastAPI
- **Application server:** Uvicorn
- **Database:** SQLite (presentation prototype)
- **QR:** `qrcode` / PNG generation
- **Authentication:** signed expiring bearer sessions
- **Password storage:** PBKDF2-SHA256
- **Testing:** Pytest + FastAPI TestClient, JavaScript syntax validation
- **Time zone:** Asia/Karachi

The single-process architecture is intentional for presentation reliability: no Docker, Node runtime, PostgreSQL server or internet connection is required after Python dependencies are installed.

## Security / workflow rules enforced by the backend

- Search result, phone number, Visitor ID or QR **does not prove identity**.
- Security verification is mandatory before check-in.
- Required host approval is mandatory before check-in.
- A host can approve/reject/cancel only visits assigned to that host.
- A host can pre-register only for their own identity and department.
- A selected host must belong to the selected department.
- A visitor cannot have two simultaneous active visits.
- A checked-out, cancelled or rejected visit cannot be reused as a new entry.
- Hosts receive masked phone values and cannot browse full visitor histories.
- Recurring pass tokens are non-sequential/high-entropy.
- Issuing a new recurring pass replaces previous active passes for that visitor.
- Authorized supervisors/admins can revoke recurring passes.
- Past pre-registration dates are blocked.
- Important actions are written to the audit trail.
- No CNIC scans, biometrics or facial-recognition data are collected by this prototype.

## Automated validation

Run:

```powershell
.\RUN_TESTS.ps1
```

or:

```powershell
python -m pytest -q
```

Expected result for this release:

```text
12 passed
```

The suite validates authentication, throttling, security headers, duplicate-safe lookup, host ownership/department scope, scheduling validation, approval and verification gates, state transitions, cancellation, QR pass replacement/revocation, privacy boundaries, emergency roster export and role authorization.

## Production deployment boundary

A real bank/high-security deployment should still add or integrate:

- organization-approved SSO + MFA;
- centrally managed enterprise database (e.g. PostgreSQL/approved DB platform);
- TLS, internal reverse proxy/WAF and managed certificates;
- secrets vault/key rotation;
- official employee directory and host lookup;
- approved visitor identity-verification SOP;
- host notification channel (email/SMS/Teams/internal app as approved);
- formal data-retention/deletion policy;
- backup, disaster recovery and high availability;
- SIEM/security monitoring;
- formal penetration test and secure-code review;
- approved kiosk/tablet, badge printer and physical access integration;
- branch/site/gate model for multi-location deployment;
- approved offline/business-continuity process.

Passing prototype tests does not remove those production requirements.
