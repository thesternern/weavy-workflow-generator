# Weavy Workflow Patterns

All workflow architecture patterns, organized by category. Use these as building blocks when designing workflows.

---

## BASIC PATTERNS

### A — LLM Chain (simplest)
```
STRING (direction) ──→ CONCAT ──→ LLM ──→ output text
PROMPT (system)    ──→ LLM (system_prompt)
FILE (image)       ──→ ROUTER ──→ LLM (image)
```
**Use for:** analysis, copywriting, brief generation.

### B — LLM → Split → Iterate → Generate
```
LLM ──→ ARRAY (split //) ──→ LIST SELECTOR (iterator) ──→ IMAGE MODEL
```
**Use for:** batch generation, variant exploration. The LLM writes N prompts separated by `//`, the Array splits them, and the Iterator fires the image model once per prompt.

### C — Parameter Selectors
```
STATIC ARRAY ["opt1","opt2"] ──→ LIST SELECTOR (manual) ──→ CONCAT
```
**Use for:** user picks style/format/options before generation. Multiple selectors can feed into one Concatenator.

### D — Multi-Stage Creative Roles
```
LLM (Art Director) ──→ CONCAT ──→ LLM (Copywriter)
```
**Use for:** complex creative briefs, film production. Chain LLMs with different personas to build up a creative brief through multiple perspectives.

### E — Router Hub
```
FILE ──→ ROUTER ──┬──→ LLM (analysis)
                  └──→ IMAGE MODEL (as reference)
```
**Use for:** one input feeds multiple consumers. Always use a Router when a File Upload needs to connect to 2+ downstream nodes.

---

## REALISM PATTERNS

### F — Photorealistic Single Image
```
FILE (ref) ──→ ROUTER ──┬──→ LLM (DOP: lighting setup)
                        └──→ LLM (Photographer: camera/composition)
TEXT (brief) ──→ CONCAT (brief + DOP + Photographer) ──→ LLM (Art Director) ──→ Image Model
PROMPT (system: Art Director realism) ──→ LLM (Art Director)
```
**Use for:** single hero image with photorealistic quality. The DOP analyzes the reference for lighting, the Photographer specifies camera/lens, and the Art Director synthesizes everything into a final image prompt following the realism prompt structure (FRAME / SUBJECT / ENVIRONMENT / LIGHTING / CAMERA / MATERIALS / QUALITY).

### G — Photorealistic Batch
```
FILE (ref) ──→ ROUTER ──→ LLM (DOP)
TEXT (brief) ──→ CONCAT (brief + DOP) ──→ LLM (Art Director: writes N prompts //-separated)
    ──→ ARRAY (split //) ──→ LIST SELECTOR (iterator) ──→ Image Model
```
**Use for:** batch photorealistic generation. Combines Pattern F's realism roles with Pattern B's iterate mechanism.

### H — Retouch Pipeline
```
Image Model (initial gen) ──→ ROUTER ──→ LLM (Retoucher: identifies zones needing work)
    ──→ CONCAT (retoucher notes + original brief) ──→ LLM (Art Director: writes edit prompt)
    ──→ NB Pro (edit mode with initial image as reference)
```
**Use for:** two-pass generation where the first pass creates the base and the second pass refines specific areas. Best with NB Pro which excels at editing existing images.

---

## REVIEW PATTERNS

### K — Single-Image Critic-Refine
```
FILE (ref) ──→ ROUTER ──→ LLM (Creator) ──→ Image Model (Pass 1) ──→ ROUTER (img)
                                                                        │
TEXT (brief) ──→ CONCAT                                                 ├──→ LLM (CRITIC)
                                                                        │        │
PROMPT (Critic sys) ──→ LLM (CRITIC)                                   │        ▼
                                                                        │   CONCAT (brief + critique)
PROMPT (Refiner sys) ──→ LLM (REFINER) ←───────────────────────────────│        │
                              │                                                  │
                              ▼                                         ←────────┘
                    Image Model (Pass 2, final)
```
**Use for:** single-image workflows where quality matters. The CRITIC LLM receives the Pass 1 image + reference image via image inputs, evaluates against the brief, and produces structured feedback:
```
KEEP: [what works in the generated image]
FIX: [what needs improvement — artifacts, composition, lighting, realism]
REVISED DIRECTION: [specific prompt modifications for Pass 2]
```
The REFINER LLM incorporates the critique into an improved prompt for Pass 2.

**Node count:** ~11 nodes (FILE, ROUTER, TEXT, 2x PROMPT sys, LLM Creator, Image Model Pass 1, ROUTER img, LLM Critic, CONCAT, LLM Refiner, Image Model Pass 2)

**CRITIC LLM setup:**
- Model: Claude Sonnet or GPT-4o (needs vision)
- Temperature: 0
- Image inputs: receives both generated image AND reference image
- System prompt: see `prompts/CREATIVE-ROLES.md` → Critic role

**REFINER LLM setup:**
- Model: Gemini 2.5 Flash or Claude (strong text gen)
- Temperature: 0.3
- Text inputs: original brief + Critic's KEEP/FIX/REVISED DIRECTION output
- System prompt: see `prompts/CREATIVE-ROLES.md` → Refiner role

### L — Batch Critic-Refine (with iteration)
```
LLM (writes N prompts //-separated) ──→ ARRAY (split //) ──→ LIST SELECTOR (iterator)
    ──→ Image Model (Pass 1) ──→ ROUTER ──→ LLM (Critic)
    ──→ CONCAT (prompt[i] + critique) ──→ LLM (Refiner) ──→ Image Model (Pass 2)
```
**Use for:** batch generation (12 portraits, product variants, etc.) where each item gets independently critiqued and refined. Because `isIterator: true` fires everything downstream once per element, the entire Critic-Refine chain executes for each item.

**Note:** This doubles the image model calls (N items x 2 passes = 2N generations). For large batches, consider Pattern M instead to triage which items need refinement.

### M — Quality Gate (no regeneration)
```
LLM (Creator) ──→ Kling 3 ──→ ROUTER ──→ LLM (Critic) ──→ text output: quality score + notes
```
**Use for:** expensive operations (Kling video, high-res batch) where automatic regeneration is too costly. The Critic evaluates the output and produces a structured quality assessment the user reviews inside Weavy before deciding to re-run manually.

**CRITIC output format for Quality Gate:**
```
SCORE: [1-10]
ASSESSMENT: [one-line summary]
STRENGTHS: [what works]
ISSUES: [what needs improvement]
RECOMMENDATION: [re-run with changes / accept / minor edit needed]
```

---

## FEEDBACK PATTERNS

### N — Image Feedback Loop

User-driven refinement for images. The user types natural language feedback, an LLM rewrites the image prompt, the model re-runs. Repeat until satisfied.

```
FILE UPLOAD (reference) ──→ ROUTER ──┬──→ IMAGE MODEL (image_1)
                                     └──→ LLM: IMAGE REFINER (image input)

TEXT (original brief) ──────→ CONCAT ──→ LLM: IMAGE REFINER ──→ IMAGE MODEL (NB Pro / Flux)
TEXT (user feedback)  ──────→ CONCAT            ↑
                                         TEXT (system prompt)
```
**Use for:** iterating on a single image. The user watches the output, writes what's wrong in plain language, and re-runs. The IMAGE REFINER LLM synthesizes the original brief + user feedback into a revised image prompt.

**How the loop works:**
1. **First run:** Leave the feedback Text node empty (or write "Generate as described"). The Refiner passes through the original brief as a proper image prompt.
2. **Review output:** User sees the result in Weavy.
3. **Type feedback:** User opens the feedback Text node and writes what's wrong: *"Skin tone is too warm, background is cluttered, needs more negative space on the left"*
4. **Re-run:** The Refiner reads original brief + feedback, writes a revised prompt that addresses all feedback while preserving everything else.
5. **Repeat:** User updates the feedback text with cumulative notes, re-runs until satisfied.

**Cumulative feedback strategy:** The user appends to their feedback each round:
```
Round 1: "Skin tone too warm"
Round 2: "Skin tone too warm. Background is better but needs more bokeh."
Round 3: "Skin and background good. Lighting on face is too flat — add rim light."
```
The Refiner always works from the stable original brief, so it doesn't drift.

**IMAGE REFINER LLM setup:**
- Model: `anthropic/claude-sonnet-4-5` or `openai/gpt-4o` (must have vision — sees reference)
- Temperature: 0.3
- Image inputs: reference image via Router
- System prompt: see `prompts/CREATIVE-ROLES.md` → Image Refiner role

**Node count:** ~8 nodes (File Upload, Router, 2x Text, Concat, LLM + system prompt Text, Image Model)

### Q — Video Feedback Loop

User-driven refinement for Kling video. The first frame is fixed (already perfected via Pattern N or provided directly). Only the motion prompt and negative prompt are refined.

```
FIRST FRAME (file or upstream) ──→ KLING 3 PRO (image input)

TEXT (motion brief)     ──→ CONCAT ──→ LLM: MOTION REFINER ──→ KLING 3 PRO (prompt)
TEXT (video feedback)   ──→ CONCAT            ↑
                                       TEXT (system prompt)

TEXT (negative prompt)  ──────────────────────────────────→ KLING 3 PRO (negative_prompt)
```
**Use for:** iterating on video output. The user watches the Kling output, writes what's wrong, and re-runs. The MOTION REFINER rewrites the motion prompt. The user edits the negative prompt Text node directly (negatives are additive blocklists — no LLM needed).

**How the loop works:**
1. **First run:** Leave the video feedback Text node empty. The Motion Refiner writes the initial motion prompt from the brief.
2. **Review output:** User watches the video in Weavy.
3. **Type feedback:** User opens the feedback Text node: *"The runner's arm swing looks robotic, and there's a morph on the sunglasses around 3 seconds"*
4. **Update negative prompt:** User adds "morphing sunglasses, distorted limbs" to the negative prompt Text node directly.
5. **Re-run:** The Motion Refiner rewrites the motion prompt addressing the feedback. Kling gets the revised motion prompt + updated negative prompt.
6. **Repeat:** User updates feedback and negative prompt, re-runs until satisfied.

**MOTION REFINER LLM setup:**
- Model: `anthropic/claude-sonnet-4-5` or `google/gemini-2.5-flash`
- Temperature: 0.3
- Image inputs: None (user describes what they saw — no vision needed)
- System prompt: see `prompts/CREATIVE-ROLES.md` → Motion Refiner role

**Node count:** ~8 nodes (First Frame input, 3x Text for brief+feedback+negative, Concat, LLM + system prompt Text, Kling)
