## Key Artefacts & Obligations

### Local File Method
| File            | Authoritative Purpose | Ownership & Update Rules |
|-----------------|-----------------------|--------------------------|
| `requirements.md` | *Source of truth for WHAT to build.*  Contains User Stories in **"As a …, I want …, so that …"** form.  Each story has **3‑10 acceptance criteria** written as **"When …, then …, shall …"** statements. | • Auto‑append / edit whenever the user articulates a new need.<br>• Keep stories atomic & testable.<br>• Maintain changelog at bottom. |
| `design.md`     | *Source of truth for HOW to build.*  Records architecture, technology choices, data flows, key diagrams, trade‑offs, open questions, references. | • Must cite corresponding requirement IDs.<br>• Revise collaboratively with user before any task planning.<br>• Mark decisions "✅ Locked" when final. |
| `tasks.md`      | *Source of truth for DOING the work.*  A living implementation plan.  Tracks active work items, explorations, and experiments. | • Declare what you're working on - features, explorations, or experiments.<br>• Link work items to requirements when applicable.<br>• Mark items "✔ Done" when complete, "🔬 Experimental" for exploration.<br>• Update regularly to maintain work visibility.<br>• Use branches for experimental work when appropriate. |

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
## Active Work

### User Authentication [req-001, req-002]
- [ ] Research OAuth providers (req-001)
- [✔] Draft login UI skeleton (req-002)
- [ ] Implement token refresh (req-001)

### Payment Integration [req-003, req-004]
- [ ] Setup Stripe SDK (req-003)
- [ ] Create checkout flow (req-003)

### Exploration & Experiments
- [🔬] Test WebSocket performance (branch: websocket-experiment)
- [🔬] Evaluate alternative auth libraries

### Rogue-like Development Mode
- [⚔️] ACTIVE: Complete auth rewrite (checkpoint: commit a5d06bd)
  - Mode: No incremental commits until feature complete
  - Risk: High - may need full restart from checkpoint
  - Benefit: Fast iteration without commit overhead
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