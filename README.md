# Weavy Workflow Generator v2

Describe a creative workflow in plain language. Get a complete JSON template you paste directly into [Weavy](https://yambo.ai). Now with built-in quality review, photorealism optimization, and an experience-driven model catalog.

---

## What it does

You talk to Claude Code, which understands every node type in Weavy — file uploads, prompts, LLMs, image generators, video models, routers, arrays, iterators. You describe a workflow like you'd explain it to a colleague, and it generates the full JSON structure: nodes, connections, system prompts, parameters, everything.

**v2 adds:**
- **Automatic quality review** — a Critic sub-agent reviews every generated workflow before delivery
- **Photorealism stack** — specialized creative roles (DOP, Photographer, Colorist, Retoucher, Critic, Refiner) with detailed system prompts tuned for photorealistic output
- **Experience-driven model catalog** — recommends models based on what actually works, not marketing descriptions
- **In-Weavy review patterns** — Critic-Refine chains that run inside your workflows, automatically improving generation quality
- **Iteration support** — share results/screenshots and get targeted fixes, not full rebuilds

---

## Setup (Claude Code)

This system runs locally via Claude Code. The project is organized into modular files that Claude Code loads as needed.

### Directory structure

```
weavy-system/
  CLAUDE.md              # Orchestration instructions (loaded automatically)
  README.md              # This file

  core/
    SKILL-CORE.md        # Slash commands, rules, edge builder, references
    NODE-BUILDERS.md     # All Python builder functions

  models/
    MODEL-CATALOG.md     # Experience-driven model recommendations

  patterns/
    PATTERNS.md          # Workflow architecture patterns (Basic, Realism, Review)

  prompts/
    CREATIVE-ROLES.md    # LLM persona system prompts
    REALISM-GUIDE.md     # Photorealism prompt engineering

  quality/
    QA-PROTOCOL.md       # Structural QA + creative review criteria
```

### Getting started

1. Open this project directory in Claude Code
2. CLAUDE.md is loaded automatically and tells Claude how to use the system
3. Start with `/workflow "your description"` or just describe what you want

---

## Commands

### `/workflow "description"`

The main command. Describe what you want and Claude builds it.

```
/workflow "take a product photo, analyze it with an Art Director LLM,
generate 5 creative variants, render each with Nano Banana Pro"
```

Claude will:
1. Select the right models from the catalog (based on practical performance, not descriptions)
2. Show you an ASCII diagram of the architecture
3. Ask clarifying questions if needed
4. Generate the JSON
5. Run quality review (structural + creative)
6. Deliver a file to paste into Weavy (Ctrl+V / Cmd+V on canvas)

For photorealistic workflows, Claude automatically activates the Realism Advisor — recommending specialized creative roles, prompt structures, and camera/lighting specifications.

### `/add`

Teach the system a new model:

1. In Weavy, drop the model node on your canvas
2. Select it, Ctrl+C
3. In Claude, type `/add` and paste

Claude registers the model and asks: "What is this model best at in practice? Any gotchas?" Your answer gets stored in the model catalog for future recommendations.

### `/update`

Fix a node that doesn't paste correctly:

1. In Weavy, copy a working node of that type
2. In Claude, type `/update` and paste

### `/info`

Quick reference table of all known node types.

### `/patterns`

Shows all workflow architecture patterns:
- **Basic (A-E):** LLM Chain, Split-Iterate-Generate, Parameter Selectors, Multi-Stage Roles, Router Hub
- **Realism (F-H):** Photorealistic Single Image, Photorealistic Batch, Retouch Pipeline
- **Review (K-M):** Critic-Refine (single), Critic-Refine (batch), Quality Gate

### `/help`

Shows the command list.

---

## Giving feedback

The system learns from your experience. When you notice something:

- **"NB Pro worked way better than X for this task"** — Claude updates the model catalog
- **Share a screenshot of bad output** — Claude diagnoses the issue (prompt, model, or structure) and fixes only what's broken
- **"This model has a quirk where..."** — Claude stores the gotcha for future workflows

The model catalog is experience-driven. Every insight you share makes future recommendations better.

---

## Tips for good results

**Name your creative roles.** "Add an Art Director that writes the visual brief" produces better system prompts than "use an LLM to write prompts."

**Be specific about quantities.** "Generate 12 variants" is better than "generate some variants."

**Mention quality level.** "Photorealistic portrait" triggers the full realism stack. "Quick concept sketch" keeps it simple.

**Ask for review patterns.** "With Critic-Refine loop" or "production-ready" triggers the in-Weavy review chain where generated outputs get automatically critiqued and improved.

**Start with a mood reference.** Upload a mood board or reference image as the first File Upload node. It anchors the creative direction.

---

## Example

```
/workflow "Photorealistic casting sheet with 12 persons and Critic-Refine.
A DOP handles the lighting setup from a mood reference, a Casting Director
generates 12 diverse profiles from the user brief, and an Art Director
synthesizes everything into 12 portrait prompts for Nano Banana Pro.
Each portrait goes through a Critic-Refine loop for quality improvement."
```

This generates a workflow with:
- File Upload (mood reference) with Router
- Text node (casting brief)
- DOP LLM analyzing lighting from the reference
- Casting Director LLM generating 12 character profiles
- Art Director LLM writing 12 NB Pro prompts (separated by //)
- Array splitter into Iterator (12x)
- NB Pro (Pass 1) per portrait
- LLM Critic evaluating each portrait against the reference
- LLM Refiner improving the prompt based on critique
- NB Pro (Pass 2) for the refined generation

One paste into Weavy. Fill in your mood image and brief. Hit run. 12 refined portraits.

---

## What's inside

You don't need to read the system files — Claude does. But if you're curious:

- **SKILL-CORE.md** — Structural rules, edge builder, handle/color reference, node reference format, boilerplate
- **NODE-BUILDERS.md** — 14 verified Python builder functions organized by category
- **MODEL-CATALOG.md** — Experience-driven model reference with Claims/Reality/Best For/Avoid For/Gotchas per model
- **PATTERNS.md** — 13 workflow patterns across Basic, Realism, and Review categories
- **CREATIVE-ROLES.md** — 8 LLM personas with full system prompts (Art Director, DOP, Casting Director, Photographer, Colorist, Retoucher, Critic, Refiner)
- **REALISM-GUIDE.md** — Prompt engineering for photorealism: camera specs, lighting setups, material descriptions, anti-artifact techniques
- **QA-PROTOCOL.md** — Structural checklist, creative quality review criteria, iteration protocol

All node structures verified by copying real nodes from Weavy and comparing field by field. Updated March 2026.

---

## Troubleshooting

**The JSON doesn't paste into Weavy**
Copy the raw JSON content (the `{"nodes":[...],"edges":[...]}` object), not the Python script. Click somewhere on the canvas first, then Ctrl+V.

**A node shows an error after pasting**
The model structure may have changed on Weavy's side. Copy a working node from Weavy, then use `/update` to sync.

**The AI doesn't know a specific model**
Use `/add` with a real Weavy node. The AI can't guess proprietary model structures — but once added, it learns and recommends intelligently.

**I get a Python script instead of a JSON file**
Run `python workflow.py` — it outputs the JSON file. You'll need Python 3, nothing else.

**The Critic says everything is fine but the output looks bad**
Share the output with Claude. The iteration protocol will diagnose whether it's a prompt, model, or structural issue and make targeted fixes. Your feedback also improves the model catalog for next time.
