## Key Artefacts & Obligations

### Local File Method
| File            | Authoritative Purpose | Ownership & Update Rules |
|-----------------|-----------------------|--------------------------|
| `requirements.md` | *Source of truth for WHAT to build.*  Contains User Stories in **"As a …, I want …, so that …"** form.  Each story has **3‑10 acceptance criteria** written as **"When …, then …, shall …"** statements. | • Auto‑append / edit whenever the user articulates a new need.<br>• Keep stories atomic & testable.<br>• Maintain changelog at bottom. |
| `design.md`     | *Source of truth for HOW to build.*  Records architecture, technology choices, data flows, key diagrams, trade‑offs, open questions, references. | • Must cite corresponding requirement IDs.<br>• Revise collaboratively with user before any task planning.<br>• Mark decisions "✅ Locked" when final. |
| `tasks.md`      | *Source of truth for DOING the work.*  A living implementation plan.  Structured as **Tasks → Sub‑tasks**. | • One **Task** at a time may be decomposed and worked on.<br>• Each **Sub‑task** must list the `requirement‑ids` it satisfies.<br>• On completion, mark sub‑task "✔ Done" and, if the Task's last sub‑task closes, mark Task "✅ Complete".<br>• Claude (or its sub‑agents) MUST update this file after every change. |

## File Conventions

### Project Structure
```
project-root/
  requirements/
    requirements.md          # Index of all requirements with links
    auth/
      req-001-user-login.md
      req-002-oauth-integration.md
    payments/
      req-003-stripe-checkout.md
      req-004-subscription-mgmt.md
    changelog.md
  
  design.md                  # Architecture & technical decisions
  
  tasks.md                   # Current implementation plan
  
  src/                       # Implementation follows tasks.md
  tests/                     # Tests validate requirements.md
```

### tasks.md Structure
```markdown
## Task 01 – User Authentication [req-001, req-002]
- [ ] sub-01-a Research OAuth providers (req-001)
- [✔] sub-01-b Draft login UI skeleton (req-002)
- [ ] sub-01-c Implement token refresh (req-001)

## Task 02 – Payment Integration [req-003, req-004]
- [ ] sub-02-a Setup Stripe SDK (req-003)
- [ ] sub-02-b Create checkout flow (req-003)
```

### Story Format (e.g., `req-001-user-login.md`)
```markdown
# Story req-001: User Login

**As a** registered user  
**I want** to log in with email and password  
**So that** I can access my personal dashboard

## Acceptance Criteria
- When user enters valid credentials, then system shall authenticate and redirect to dashboard
- When user enters invalid credentials, then system shall display error message
- When user fails 3 attempts, then system shall lock account for 15 minutes

## Related Tasks
- Task 01 / sub-01-a
- Task 01 / sub-01-c
```