#!/usr/bin/env python3
"""
ADR Indexer - Extracts and indexes Architecture Decision Records
Used by workspace-curator agent to build decision indexes
"""

import json
import re
import sys
from pathlib import Path
from datetime import datetime

def find_adrs(project_root):
    """Find all ADR files in the project"""
    project_path = Path(project_root)

    # Common ADR locations
    patterns = [
        "docs/adr/*.md",
        "docs/architecture/*.md",
        "ADR-*.md",
        "design.md",
        ".claude/adrs/*.md"
    ]

    adr_files = set()  # Use set to avoid duplicates
    for pattern in patterns:
        adr_files.update(project_path.glob(f"**/{pattern}"))

    return adr_files

def extract_adr_metadata(file_path):
    """Extract structured data from an ADR file"""
    content = file_path.read_text()

    # Try to extract YAML block if present
    yaml_match = re.search(
        r'<!-- LLM-STRUCTURED-DATA -->(.+?)<!-- END-LLM-STRUCTURED-DATA -->',
        content,
        re.DOTALL
    )

    # Basic metadata extraction
    metadata = {
        "file": str(file_path),
        "indexed": datetime.now().isoformat()
    }

    # Extract title from first # heading
    title_match = re.search(r'^# (.+)$', content, re.MULTILINE)
    if title_match:
        metadata["title"] = title_match.group(1)

    # Extract ADR number if present
    adr_num_match = re.search(r'ADR-(\d+)', file_path.name)
    if adr_num_match:
        metadata["id"] = f"ADR-{adr_num_match.group(1)}"

    # Extract status if present
    status_match = re.search(r'Status:\s*(.+)$', content, re.MULTILINE | re.IGNORECASE)
    if status_match:
        metadata["status"] = status_match.group(1).strip()

    # Extract date if present
    date_match = re.search(r'Date:\s*(\d{4}-\d{2}-\d{2})', content)
    if date_match:
        metadata["date"] = date_match.group(1)

    # Extract decision if present
    decision_match = re.search(r'## Decision\s+(.+?)(?=##|\Z)', content, re.DOTALL)
    if decision_match:
        # Get first sentence or line as summary
        decision_text = decision_match.group(1).strip()
        first_line = decision_text.split('\n')[0]
        metadata["decision_summary"] = first_line[:200]  # Limit length

    return metadata

def create_index(project_root):
    """Create or update the ADR index"""
    project_path = Path(project_root)
    index_dir = project_path / ".claude" / "index"
    index_dir.mkdir(parents=True, exist_ok=True)

    index_file = index_dir / "decisions.json"

    # Find and index all ADRs
    adrs = []
    adr_files = find_adrs(project_root)

    for adr_file in adr_files:
        try:
            metadata = extract_adr_metadata(adr_file)
            adrs.append(metadata)
            print(f"Indexed: {adr_file.name}")
        except Exception as e:
            print(f"Error indexing {adr_file}: {e}", file=sys.stderr)

    # Write index
    index_data = {
        "adrs": adrs,
        "count": len(adrs),
        "last_updated": datetime.now().isoformat(),
        "version": "1.0"
    }

    index_file.write_text(json.dumps(index_data, indent=2))

    return index_data

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else "."

    print(f"Indexing ADRs in {project_root}...")
    index = create_index(project_root)

    print(f"\nIndexed {index['count']} ADRs")
    print(f"Index saved to {project_root}/.claude/index/decisions.json")