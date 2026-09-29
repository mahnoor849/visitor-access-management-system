# SecurePass v2.0 — Architecture

## Current validated presentation architecture

```text
┌──────────────────────────────────────────────────────────────┐
│                         USERS                                │
│  Security Guard | Employee/Host | Supervisor | Administrator │
└─────────────────────────────┬────────────────────────────────┘
                              │ Browser / localhost
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                 PRESENTATION / UI LAYER                      │
│                  HTML + CSS + JavaScript                     │
│                                                              │
│ Dashboard | Visitor Search | Gate Operations | Active Roster │
│ Pre-Registration | Intelligence | Audit | Administration     │
└─────────────────────────────┬────────────────────────────────┘
                              │ Same-origin REST API
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                    FASTAPI APPLICATION                       │
│                                                              │
│ Authentication / RBAC                                        │
│ Visitor Profiles                                             │
│ Visit Lifecycle / State Machine                              │
│ Host Ownership + Department Scope                            │
│ Approval / Security Verification                             │
│ Check-In / Check-Out / Cancellation                          │
│ QR Pass Generation / Resolve / Revoke                        │
│ Emergency Roster Export                                      │
│ Analytics / Exception Rules                                  │
│ Audit Logging                                                 │
│ Security Headers / Login Throttling                          │
└─────────────────────────────┬────────────────────────────────┘
                              │ SQL
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                      SQLITE DATABASE                         │
│ Departments | Users | Visitors | Passes | Visits | Audit Logs│
│ WAL + busy timeout + DB constraints                          │
└──────────────────────────────────────────────────────────────┘
```

## Visit state model

```text
Expected / Pending Verification / Pending Approval
                       │
          required controls completed
                       ▼
               READY FOR CHECK-IN
                       │
                    Check In
                       ▼
                     INSIDE
                       │
                    Check Out
                       ▼
                 CHECKED OUT

Alternative terminal states: REJECTED / CANCELLED
```

### Critical rule

**Active Visitors is not a queue for entry.** A record appears there only after successful check-in. The green **Check In** action belongs to **Gate Operations** when the visit state is `ready_for_checkin`.

## Why the current stack is intentionally simple

The internship version is designed to run reliably from one Windows laptop. FastAPI serves the API and static frontend, and SQLite stores demo data locally. This avoids presentation dependencies such as Docker, PostgreSQL service availability and Node/Vite processes.

## Production evolution

For an approved enterprise deployment, the UI/API concepts can remain while infrastructure changes to SSO/MFA, enterprise DB, TLS/WAF, managed secrets, HA, SIEM, formal retention, employee-directory integration and physical access-control integration.
