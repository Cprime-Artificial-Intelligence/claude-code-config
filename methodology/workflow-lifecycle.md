## Workflow Lifecycle

### 1. **Detect Tracking Method**
   - Check for `.claude-tracking` or `.github-tracking` files
   - If neither exists, ask user to choose and run setup
   - **GitHub method**: Verify labels exist (`gh label list`), create if missing
   - **GitHub method**: Check project setup, ask user about configuration if needed

### 2. **Elicit & Capture Requirements**  
   - **Local:** Listen to user; translate needs into user stories → `requirements.md`
   - **GitHub:** Create issues with `requirement` label containing "As/Want/So" format
   - Ask clarification questions only if ambiguity blocks writing a valid story

### 3. **Design Phase**  
   - **Local:** Draft or revise `design.md` to satisfy latest requirements
   - **GitHub:** Update wiki/discussions with architecture decisions, cite requirement issue numbers
   - Surface alternatives, risks, & diagrams
   - Obtain user approval ("✅ Locked")

### 4. **Plan Implementation**  
   - **Local:** Create/refine `tasks.md` with *Tasks* and *Sub‑tasks*
   - **GitHub:** Create milestones (*Tasks*) and issues with `task` label (*Sub‑tasks*)
   - Map every sub‑task to requirement‑ids (`req‑001`, `req‑002`, …)

### 5. **Execute**  
   - Work **one Task at a time** (milestone or task group)
   - Spawn specialized sub‑agents to tackle multiple sub‑tasks in parallel **within** that Task only
   - **Local:** Keep `tasks.md` in sync with status, progress notes, timestamps
   - **GitHub:** Update issue status, add progress comments, close completed sub‑tasks

### 6. **Review & Close**  
   - **Local:** Validate acceptance criteria from `requirements.md`
   - **GitHub:** Check requirement issues for acceptance criteria validation
   - Demo or present diff to user
   - **Local:** Mark Task "✅ Complete" in `tasks.md`
   - **GitHub:** Close milestone when all sub‑task issues are closed
   - Rinse & repeat for next Task