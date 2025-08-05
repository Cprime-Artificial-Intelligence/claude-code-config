# Methodology Design Rationale

This document explains the design principles behind the disciplined software engineering methodology for human maintainers. **Claude Code does not read this file** - it's for understanding why the methodology is structured as it is.

## Core Philosophy: Behavioral Controls vs Best Practices

The methodology is designed as **AI behavioral controls**, not traditional engineering wisdom. The harsh specificity serves as a ratchet mechanism against Claude's natural tendencies.

### Claude's Natural Tendencies (Without Controls)
- Creates comprehensive, monolithic solutions when given flexibility
- Files grow to 1000+ lines in the name of "cohesion"  
- Functions expand to 100+ lines to be "thorough"
- Classes accumulate methods to be "helpful"
- Writes elaborate error handling chains
- Rationalizes complexity as "comprehensive"

### Control Mechanisms

#### Hard Limits (Not Suggestions)
- **500-line file limit**: Without this, files grow to 1000+ lines
- **3-level nesting limit**: Prevents "comprehensive" error handling chains  
- **7-method class limit**: Prevents god objects that "helpfully" do everything
- **30-50 line function limit**: Claude writes 100+ line functions when unconstrained

#### Mechanical Enforcement
- Count lines/methods/nesting mechanically
- No exceptions for "cohesive" modules or "logically grouped" code
- Framework conflicts get documented but rules still apply
- Working code still needs refactoring if over limits

#### Language Patterns
**Weak (current)**: "Watch for", "suggest", "consider"
**Strong (needed)**: "Flag", "Force", "No negotiation", "Mandatory"

### Drift Prevention

Rules dilute over conversation length:
- Fresh session: Rules enforced → 400-line files
- Mid-session: Rules diluted → 600-line files  
- Post-compaction: Drift normalized → 750-line files

The methodology must provide **hard reset points** through non-negotiable enforcement.

### Framework Integration vs Control Maintenance

When methodology conflicts with framework conventions:
1. Document the conflict (don't ignore it)
2. Apply the rule anyway (unless user explicitly overrides)
3. Suggest framework-compatible alternatives that respect limits

This prevents the gradual erosion of controls in the name of "best practices."

## Implementation Strategy

### Current State
- Right structure (modular files, clear organization)
- Right topics (SOLID, limits, workflow)  
- Wrong language (diplomatic suggestions vs hard requirements)

### Needed Changes
- Shift from suggestion language to requirement language
- Add mechanical counting instructions
- Make limits absolute rather than guidelines
- Specify exact refactoring actions, not general advice

### Success Metrics
- Claude consistently enforces 500-line limits without negotiation
- Functions stay under 50 lines across sessions
- No "comprehensive" rationalizations accepted
- Complexity resets to controlled levels after compaction

## Human vs AI Documentation Split

**For Humans (this file):**
- Rationale and behavioral psychology
- Why limits seem arbitrary but aren't
- Design philosophy and drift prevention

**For Claude (methodology files):**
- Hard rules without explanation
- Mechanical enforcement procedures  
- Specific refactoring actions
- Non-negotiable thresholds

This separation prevents context waste while maintaining human understanding of the system's design.