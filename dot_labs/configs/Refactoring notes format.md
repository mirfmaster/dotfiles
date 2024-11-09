# Obsidian Note Type Templates

## 1. Permanent Note (Zettels)
```md
---
type: zettel
created: {{date}}
tags: concept/
---

# {{Title}}

## Core Idea
[Single, atomic concept explained in your own words]

## Context
[Brief explanation of why this note exists and its relevance]

## Connections
- [[Related Note 1]] - [Explicit explanation of relationship]
- [[Related Note 2]] - [Explicit explanation of relationship]

## References
- Source: [[Literature Note Title]]
```

## 2. Reference Note
```md
---
type: reference
created: {{date}}
source: [Book/Article/Video title]
author: [Author name]
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

## 3. MOC (Map of Content)
```md
---
type: moc
created: {{date}}
tags: moc/
---

# {{Topic}} MOC

## Overview
[Brief description of this area of knowledge]

## Main Concepts
### Concept Category 1
- [[Permanent Note 1]] - Brief description
- [[Permanent Note 2]] - Brief description

### Concept Category 2
- [[Permanent Note 3]] - Brief description
- [[Permanent Note 4]] - Brief description

## Related MOCs
- [[Related MOC 1]]
- [[Related MOC 2]]
```

## 4. Reference Note
```md
---
type: reference
created: {{date}}
tags: reference/
---

# {{Reference Title}}

## Overview
[Quick summary of what this reference contains]

## Details
[Specific details, could be structured based on type of reference]

## Usage
[Contexts where this reference is useful]

## Related References
- [[Other Reference 1]]
- [[Other Reference 2]]
```

## 5. Daily Note
```md
---
type: daily
created: {{date}}
tags: daily/
---

# {{date:YYYY-MM-DD}}

## Tasks
- [ ] Task 1
- [ ] Task 2

## Notes Created
- [[New Note 1]] - Brief context
- [[New Note 2]] - Brief context

## Insights & Ideas
- [Capture fleeting notes here]

## Journal
[Personal reflections or important events]
```

## 6. Project Note
```md
---
type: project
created: {{date}}
status: active/completed/on-hold
tags: project/
---

# {{Project Name}}

## Objective
[Clear project goal]

## Key Resources
- [[Resource 1]]
- [[Resource 2]]

## Notes
- [[Project-Related Note 1]]
- [[Project-Related Note 2]]

## Action Items
- [ ] Next step 1
- [ ] Next step 2

## Outcomes
[Project results or learnings]
```

## Usage Guidelines

1. **Permanent Notes (Zettels)**
   - Keep them atomic (one idea per note)
   - Always explain connections explicitly
   - Use your own words
   - Make them self-contained

2. **Literature Notes**
   - Create while consuming content
   - Focus on what's relevant to your interests
   - Use as source material for permanent notes
   - Keep original context

3. **MOCs (Maps of Content)**
   - Create when you have 10+ notes in an area
   - Update regularly as your notes grow
   - Use as navigation hubs
   - Keep categories flexible

4. **Reference Notes**
   - Use for factual information
   - Include source attribution
   - Update as needed
   - Link to relevant permanent notes

5. **Daily Notes**
   - Use as capture tool
   - Process into other note types regularly
   - Keep action items visible
   - Review periodically

6. **Project Notes**
   - Group project-specific information
   - Link to relevant permanent notes
   - Track progress
   - Document outcomes
