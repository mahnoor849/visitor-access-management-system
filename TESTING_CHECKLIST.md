# SecurePass v2.0 — Final Manual Testing Checklist

Use a fresh demo reset before rehearsal:

```powershell
.\reset-demo.ps1
.\DEMO_START.ps1
```

## Gate workflow

| Test | Action | Expected Result |
|---|---|---|
| Ready entry visible | Guard → Gate Operations | Sara Raza shows `ready for checkin` + green **Check In** |
| Check in | Click Sara’s Check In | Visitor moves to Active Visitors |
| Active state | Open Active Visitors | Green **INSIDE** badge appears; no Check In button |
| Check out | Click Check Out | Visitor leaves Active Visitors and becomes checked out |
| Returning visitor | Search Areeba | Existing profile appears |
| Verification gate | Create visit | Security Verify appears first |
| Ready transition | Click Security Verify | Same modal changes to green **Check In Visitor** |
| Approval gate | Create approval-required IT visit | Check-in is blocked until host approval |

## Data / privacy

| Test | Expected Result |
|---|---|
| Same phone, different person | Both records can exist; no automatic merge |
| Same name + same phone | Exact duplicate is blocked |
| Host search | Phone number is masked |
| Host history | Full visitor profile/history endpoint is denied |
| Host ownership | Host cannot pre-register for another host |
| Department scope | IT host cannot pre-register for AI & Data Science |

## Operational controls

| Test | Expected Result |
|---|---|
| Cancel expected/pending visit | Visit becomes cancelled and cannot be verified/checked in |
| Issue new recurring pass | Previous active recurring pass becomes inactive |
| Revoke pass | Pass resolves as invalid afterwards |
| Emergency roster CSV | Guard/supervisor/admin can export |
| Host roster export | Access denied |
| Audit Trail | Check-in/out, cancellation, pass actions and export are recorded |

## Automated test

```powershell
python -m pytest -q
```

Expected:

```text
12 passed
```
