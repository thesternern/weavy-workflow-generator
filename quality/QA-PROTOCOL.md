# Quality Assurance Protocol for Weavy Workflow Generator

---

## Section 1: Structural Checklist (run by primary agent, automated)

These are mechanical checks run on every generated workflow JSON.

### Node Integrity
- [ ] All node IDs are unique UUID v4
- [ ] `version: 3` is present on all nodes
- [ ] No root-level `kind` field on any node (must be `data.kind` and only on model nodes)
- [ ] Node names are UPPERCASE for main nodes

### Edge Integrity
- [ ] All edge source IDs reference existing nodes
- [ ] All edge target IDs reference existing nodes
- [ ] All edge `sourceHandle` values follow the pattern `{nodeId}-output-{handleName}`
- [ ] All edge `targetHandle` values follow the pattern `{nodeId}-input-{handleName}`

### Handle Name Validation
Handle names must match the expected handles for each node type:

| Node Type | Handles |
|-----------|---------|
| File | `file` |
| Text | `text` |
| Prompt | `prompt` |
| Concat | `prompt` |
| Router | `out` / `in` |
| LLM | `text` / `prompt` / `system_prompt` / `image` |
| NB / Flux | `result` / `prompt` / `image_1` |
| Kling | `video` / `prompt` / `image` / `end_image_url` / `negative_prompt` / `element_N` |
| Array | `array` / `text` |
| Selector | `option` / `options` |

### Edge Color/Type Combos
- [ ] Edge color and type combos are correct (e.g., File to Router uses `Yambo_Blue` to `Yambo_Orange`, any to any)

### Routing
- [ ] Router node placed after every File Upload that feeds multiple downstream nodes

### Layout
- [ ] Node spacing follows conventions (~600px X between columns, ~400px Y between rows)

### Feedback Loops
- [ ] Every image model output node has a Pattern N (Image Feedback Loop) connected
- [ ] Every video model output node (Kling, Wan, Veo, LTX, Higgsfield) has a Pattern Q (Video Feedback Loop) connected — audio-driven avatars (Omnihuman, Kling Avatar Pro) are exempt
- [ ] Feedback loops include: original brief Text, user feedback Text, Concat, Refiner LLM with system prompt, and the output model

### Prompt Content
- [ ] System prompts are in English, detailed, and structured
- [ ] Image prompts are plain text only (no markdown formatting)
- [ ] Separator `//` used correctly between prompt variants

---

## Section 2: Creative Quality Review (run by CRITIC sub-agent)

These require judgment and are run by the CRITIC sub-agent after generation.

### System Prompt Quality
- Are system prompts specific enough?
- Does each system prompt give the LLM a clear role, clear instructions, and clear output format?

### Model Selection
- Is each model the right choice for its task?
- Consult MODEL-CATALOG.md "Reality" fields, not descriptions, when evaluating selection

### Pattern Efficiency
- Could this workflow be simpler?
- Are there unnecessary nodes?

### Prompt Structure
- Do image model prompts follow best practices?
- For realism: prompts should use FRAME / SUBJECT / ENVIRONMENT / LIGHTING / CAMERA / MATERIALS / QUALITY structure

### Connection Logic
- Does data flow make sense?
- Are all necessary inputs connected?

### Role Specificity
- Do LLM personas have distinct, non-overlapping responsibilities?

### Realism Techniques
- If photorealism is the goal, are anchoring, camera specs, lighting, and anti-artifact techniques applied?
- Does the final image prompt include 2-3 optical imperfections? (grain, chromatic aberration, vignetting, motion blur, DOF specificity, halation)
- Is a film stock or sensor color science reference named?
- Is the prompt written in natural prose? (no keyword lists, no comma-separated tags)
- Are banned words absent? (perfect, flawless, beautiful, hyper-realistic, 8K, masterpiece, smooth skin, clear complexion)
- For human subjects: does skin description include zone-specific pore detail, subsurface scattering, T-zone sheen, color variation, and at least one named imperfection?
- When reference images are available: are DOP and PHOTOGRAPHER roles present in the workflow? (Pattern F)

### CRITIC Output Format

The CRITIC should output a structured report:

```
VERDICT: PASS / NEEDS FIXES
STRUCTURAL: [any structural issues found]
PROMPTS: [prompt quality assessment]
MODELS: [model selection assessment]
FLOW: [data flow assessment]
FIXES NEEDED: [numbered list of specific fixes, if any]
```

---

## Section 3: Iteration Protocol

Two iteration modes: **in-workflow feedback loops** (user iterates inside Weavy) and **external fixes** (user reports issues, agent modifies workflow JSON).

### In-Workflow Iteration (Patterns N and Q)

The preferred approach. The workflow itself contains feedback nodes the user edits directly in Weavy:

**Pattern N (Image Feedback Loop):**
- User types feedback into the USER FEEDBACK text node
- IMAGE REFINER LLM rewrites the image prompt incorporating feedback
- User re-runs the workflow — no JSON editing required
- See `patterns/PATTERNS.md` → Pattern N

**Pattern Q (Video Feedback Loop):**
- User types feedback into the VIDEO FEEDBACK text node
- MOTION REFINER LLM rewrites the motion prompt incorporating feedback
- User edits the NEGATIVE PROMPT text node directly to block artifacts
- User re-runs — no JSON editing required
- See `patterns/PATTERNS.md` → Pattern Q

**MANDATORY:** Every `/workflow` generation MUST include feedback loops on all image and video output nodes. Use Pattern N (Image Feedback Loop) for every image model output and Pattern Q (Video Feedback Loop) for every prompt-driven video model output (Kling, Wan, Veo, LTX, Higgsfield Video). Audio-driven avatar models (Omnihuman, Kling Avatar Pro) are exempt since they lack prompt inputs to refine. Do not ask — include them by default. If the user explicitly requests no feedback loops, they can be omitted, but the default is always to include them.

### External Fixes (agent-assisted)

When the user reports issues that can't be solved by in-workflow feedback (structural problems, wrong model, broken connections):

#### 1. Issue Categorization

When user shares output, categorize the issue:

- **PROMPT issue**: wrong style, wrong composition, artifacts, unrealistic
- **STRUCTURAL issue**: missing connections, wrong data flow, nodes not firing
- **MODEL issue**: wrong model for the task, model limitations hit

#### 2. Fix Strategy by Category

| Category | Strategy |
|----------|----------|
| Prompt issues | Rewrite specific node prompts using REALISM-GUIDE.md techniques |
| Structural issues | Modify connections, add/remove nodes, fix edge handles |
| Model issues | Consult MODEL-CATALOG.md, swap to better model, adjust parameters |

#### 3. Scope of Fix

- Only regenerate the affected portion of the Python script
- Never rebuild the entire workflow for a localized issue
- When fixing, preserve all node IDs to maintain Weavy's internal state

#### 4. Post-Fix Validation

- Run structural checklist (Section 1) on modified workflow
- Run CRITIC sub-agent (Section 2) on modified workflow
- Deliver with clear description of what changed and why

### Feedback Capture

- If iteration reveals a model performance insight, update MODEL-CATALOG.md
- Example: "The Try On model didn't work for clothing composites, but NB Pro with good prompting did" -- update both model entries
