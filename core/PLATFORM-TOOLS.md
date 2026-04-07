# Weavy Platform Tools Reference

Non-model-dependent tools and features available in Weavy (Figma Weave) for workflow construction. These are the building blocks beyond AI model nodes.

**Note:** Weavy was acquired by Figma in October 2025 and rebranded as Figma Weave. Documentation lives at help.weavy.ai. The platform is accessible at weave.figma.com (also app.weavy.ai).

---

## Node Color System

Weavy uses color coding to classify node types at a glance:

| Color | Category |
|---|---|
| Green | Image processing nodes |
| Purple | Text manipulation nodes |
| Red | Video processing nodes |
| Blue | Array/List operations and 3D nodes |
| White | Multi-input selector nodes |
| Lime | Mask-related nodes |

---

## Node Categories

### Generative Nodes (require credits)
- Feature a "Run" button
- Require credits per generation
- Include all AI model nodes (image gen, video gen, LLM, etc.)

### Non-Generative Nodes (free to use)
- Manual tools: Painter, Blur, multi-layer composition
- Utility functions: prompt concatenator, data type converters
- No credits required to run

---

## Built-in Editing Tools

These are non-generative nodes for hands-on image manipulation. No credits needed.

| Tool | Function | Use Case |
|---|---|---|
| **Painter** | Manual painting/drawing on canvas | Touch-ups, adding elements by hand, masking |
| **Blur** | Apply blur effects to images | Background softening, depth simulation, privacy |
| **Invert** | Color/value inversion | Mask preparation, creative effects |
| **Crop** | Image cropping and reframing | Composition adjustment, aspect ratio correction |
| **Mask** | Create and manipulate masks | Selective editing, compositing regions |
| **Inpaint** | AI-assisted fill of masked regions | Remove objects, fill gaps, repair areas |
| **Outpaint** | AI-assisted image expansion | Extend canvas, add surrounding environment |
| **Relight** | Adjust lighting on existing images | Change light direction, intensity, color temperature |
| **Upscale** | Resolution increase | Prepare for print, increase detail |
| **Z Depth** | Extract depth maps from images | 3D effects, parallax, selective focus |
| **Channels** | Channel manipulation (RGB, Alpha) | Color correction, alpha editing, channel isolation |
| **Image Describer** | Auto-generate text description of image | Feed into LLM prompts, accessibility, cataloging |
| **Compositing** | Multi-layer blending and composition | Combine elements, layer images, blend modes |

---

## Matte Tools

Specialized nodes for alpha channel, transparency, and compositing operations.

- Alpha channel manipulation
- Matte generation and refinement
- Transparency control for compositing workflows
- Key for clean composites when combining AI-generated elements

---

## Text Tools

Nodes for text processing and manipulation within workflows.

- **Prompt Concatenator** -- Combine multiple text inputs into a single prompt. Essential for building dynamic prompts from separate components (style + subject + lighting + camera).
- **Prompt Variables** -- Define reusable variables in workflows. Allows swapping subjects, styles, or parameters without rebuilding the workflow.
- Text formatting and transformation utilities

---

## Iterators

Control flow nodes for batch processing and loop operations.

- Process multiple items through the same workflow path
- Enable batch generation (e.g., same prompt with different seeds, or multiple subjects through one pipeline)
- Essential for production workflows generating variants at scale

---

## Helpers

| Helper | Function |
|---|---|
| **Compare Node** | Side-by-side comparison of two images/outputs. Useful for A/B testing model outputs or before/after editing. |
| **Sticky Notes** | Annotation nodes for documenting workflow logic. No functional effect -- purely for organization and team communication. |

---

## Data Types and Connectors

Utility nodes for data structure and format conversion:

- Convert between data types (text, image, video, audio, arrays)
- Route and transform data between incompatible node types
- Handle array/list operations for batch workflows

---

## Model Categories Available

Weavy integrates models across 10 categories via fal.ai:

1. **Image Models** -- Text-to-image generation
2. **Video Models** -- Text/image-to-video generation
3. **Generate from Image Models** -- Image-to-image transformation
4. **Generate From Video Models** -- Video-to-video transformation
5. **Enhance Video Models** -- Video upscaling and quality improvement
6. **Enhance Images Models** -- Image upscaling and enhancement
7. **Edit Image Models** -- Image editing and manipulation
8. **Lip Sync Models** -- Audio-driven avatar/talking head generation
9. **3D Models** -- 3D asset generation
10. **Vector Models** -- Vector graphic generation

---

## Platform Features

### Workflow to App Mode
Convert any workflow into a simplified UI (called "Design App"). Non-technical users or clients can interact with a clean form interface instead of the node canvas. Useful for handoff to clients or production teams who need to run workflows without understanding the graph.

### Workflow Sharing and Templates
- Share workflows with team members or publicly
- Browse and clone community workflows ("Explore Our Workflows")
- Templates available for common use cases

### LoRA Support
Import custom LoRAs (Low-Rank Adaptation models) for fine-tuned generation. Allows character consistency, brand style enforcement, or custom aesthetic training within standard model nodes.

### Canvas Navigation
Standard node-based canvas with zoom, pan, and organization tools. Group and ungroup nodes for visual organization.

### Wire Styles
Customizable connection wire styles for visual clarity in complex workflows.

### Prompt Variables
Define variables that can be swapped across the workflow without editing individual nodes. Enables template workflows where only the variables change per run.

---

## Integrated AI Providers

Weavy integrates models from:
- Google (Imagen, Gemini/Nano Banana, Veo)
- OpenAI (GPT, DALL-E)
- Anthropic (Claude)
- Black Forest Labs (Flux)
- Runway
- Luma
- Kling (Kuaishou)
- Lightricks (LTX)
- Wan
- Grok (xAI)
- Recraft
- Bria
- ByteDance (Seedream, Omnihuman, Seedance)
- Higgsfield
- Topaz Labs
- Magnific
- Meta (Llama)

---

## Security and Compliance

- SOC 2 Type II certified
- Enterprise plan available with additional security controls
- Web-based platform (no local installation required)

---

## Pricing Structure

Tiered pricing model:
- Credits-based for generative nodes (AI model runs)
- Non-generative editing tools are free to use
- Enterprise tier available for teams
- Some premium nodes (e.g., Topaz Video Upscaler) have additional per-run costs

---

## What's NOT Available (as of April 2026)

Based on research, these features are not documented as available:

- **Audio generation nodes** (text-to-speech, music generation) -- not found as built-in platform tools. Audio is an input type for some models (Wan 2.7, Omnihuman) but no dedicated audio generation nodes.
- **Conditional branching / if-else logic** -- not found as explicit node types. Workflow logic is handled through routing and node connections rather than programmatic conditionals.
- **Variable storage / state management** -- Prompt Variables exist but no general-purpose variable/state nodes.
- **API webhook integration** -- not documented as a built-in feature for external triggering.
- **Version control for workflows** -- not explicitly documented beyond save/load.

These gaps may exist as undocumented features or may be added in future updates. Check help.weavy.ai for latest documentation.
