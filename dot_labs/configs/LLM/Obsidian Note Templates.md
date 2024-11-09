# Obsidian Note Type Templates

## 1. Permanent Note (Zettels)
```md
---
type: zettel
created: {{date}}
aliases: [alternative names]
tags:
  - Tag1
  - Tag2
references: "[[Reference link name]]"
---

# {{Title}}

## Core Idea
[Single, atomic concept explained in your own words]

## Context
[Brief explanation of why this note exists and its relevance]

## Keypoints
- [[Short linked atomic concept 1]]
- [[Short linked atomic concept 2]]
- [[Each keypoint should be a linked concept]]
```

## 2. Reference Note
```md
---
type: reference
created: {{date}}
aliases: [alternative names]
author:
  - [Author name]
tags:
  - "#Type/Reference"
  - [Additional Tags]
References:
  - [Source URLs or citations]
---

# {{Source Title}}

## Key Points
- Main point 1
- Main point 2
- Main point 3

## Quotes
> Important quote with page number (p. XX)

## Personal Thoughts
[Initial reactions and ideas for permanent notes]

## Action Items
- [ ] Create permanent note about [concept]
- [ ] Link to existing note about [[Related Note]]
```

## Usage Guidelines

1. **Permanent Notes (Zettels)**
    - Keep them atomic (one idea per note)
    - Always explain connections explicitly
    - Use your own words
    - Make them self-contained
    - Use keypoints as links to create conceptual nodes in graph view
    - Each keypoint should be a linked atomic concept
    - Links help build a stronger knowledge graph
    - Must include block references (^unique-id)
    - Each Zettel requires its own artifact when created

2. **Reference Notes**
   - Create while consuming content
   - Focus on what's relevant to your interests
   - Use as source material for permanent notes
   - Keep original context
   - Break down into multiple atomic Zettels

3. Output Format
    - All notes should be in proper markdown format
    - No XML tags or other wrapping
    - Ready to copy-paste into Obsidian
    - Include proper YAML frontmatter
    - Use hierarchical tagging system
