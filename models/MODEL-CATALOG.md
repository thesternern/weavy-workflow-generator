# Model Catalog

Experience-driven model selection guide for Weavy workflows. Model descriptions lie -- this catalog prioritizes practical, battle-tested knowledge over surface-level feature names.

**Rule: Read "Reality" and "Use Instead" fields when selecting models. Never trust "Claims" alone.**

---

## Quick Decision Tree

| You need... | Use this | Why |
|---|---|---|
| Full-body humans, action poses, or hero product shots | Nano Banana Pro | Better proportions, accurate product rendering; connect reference image to image_1 when available |
| Simple photorealistic scene (no humans or products to match) | Flux 2 Pro | Strong prompt adherence for landscapes, objects, abstract scenes |
| Image editing / compositing with a reference | Nano Banana Pro | Excels at editing with reference image input |
| Clothing on a model / virtual try-on | Nano Banana Pro (good prompting) | Outperforms the specialized Try On model in practice |
| Reference image exists anywhere in the workflow | Nano Banana Pro | Always route the reference to NB Pro's image_1 in addition to any LLM intermediary |
| Video from a still image | Kling 3 Pro | Top-tier image-to-video, supports first/last frame |
| LLM with vision (Critic role) | Claude Sonnet 4.5 or GPT-4o | Both handle image analysis well at temperature 0 |
| Fast LLM for structured output (Refiner) | Gemini 2.5 Flash | Fast, reliable structured text generation |
| High-quality LLM for creative direction | Claude Opus or GPT-4.1 | Strongest reasoning for Art Director role |

### Model Selection Logic (read this before choosing an image model)

1. **Is there a reference image anywhere in the workflow?** → Use NB Pro. Route the reference to NB Pro's `image_1` AND to the Art Director LLM. NB Pro performs best when it can see the visual target directly.
2. **Does the subject involve full-body humans or specific products?** → Use NB Pro. Flux struggles with human proportions (produces squat/compressed bodies in action poses) and hallucinates details on products.
3. **Is it a simple scene with no humans or product-matching requirements?** → Flux 2 Pro is fine. Its prompt adherence is strong for landscapes, objects, and abstract compositions.
4. **When in doubt** → Default to NB Pro. It handles more use cases reliably than Flux.

---

## Image Generation Models

---

### Nano Banana Pro

**Weavy ID:** `fal-ai/nano-banana-pro/edit`
**Category:** Image Gen / Image Edit
**Builder:** `make_nb_pro_node()`
**Claims:** "Google's state-of-the-art image generation and editing model"
**Reality:** The workhorse -- and increasingly the default image model. Genuinely excellent at editing and compositing when given a reference image. Surprisingly strong at tasks that specialized models claim to own -- including clothing composites, scene modifications, and style transfers. Also outperforms Flux 2 Pro for full-body human action shots and hero product accuracy, even in text-to-image mode. When a reference image exists anywhere in the workflow, always route it to NB Pro's image_1 input for best results.
**Best for:**
- Editing an existing image (swap elements, change lighting, add objects)
- Compositing (placing a product/person into a new scene)
- Full-body human subjects in action poses (better proportions than Flux)
- Hero product shots requiring accurate detail reproduction (sunglasses, accessories, branded items)
- Clothing on a model (with good prompting, outperforms Try On)
- Creating variations of an existing image
- Second-pass refinement in a Retouch Pipeline (Pattern H)
- Any workflow where a reference image is available (connect it to image_1)

**Avoid for:**
- Simple scenes with no humans or product-matching needs where Flux's prompt adherence is sufficient

**Use instead:** "For simple photorealistic scenes (landscapes, objects, abstract compositions) with no human subjects or product accuracy requirements, Flux 2 Pro's prompt adherence is sufficient."

**Gotchas:**
- Needs output frame anchoring as the FIRST sentence of the prompt, or it recomposes the entire image. Start every prompt with a sentence describing the final frame/composition.
- Uses `resolution` parameter (`1K` / `2K` / `4K`), NOT `image_size`. Do not confuse with Flux.
- No `output_format` parameter.
- Seed is type `"seed"` (an object with `seed` int + `isRandom` bool), not a plain integer.
- Input refs are `null` when not connected, not omitted.

**Optimal params:**
- Resolution: `2K` for most work, `4K` only for final deliverables that don't feed downstream models, `1K` for iteration/testing
- **When feeding Kling:** Use `2K` — Kling cannot accept 4K input images. 4K should only be used when NB Pro is the final output node in the pipeline.
- Aspect ratio: `auto` unless the brief specifies otherwise
- Seed: `isRandom: True` for exploration, lock seed for reproducible refinement
- Prompt structure: OUTPUT FRAME (first!) / CONTEXT / KEEP / REPLACE / LIGHTING / QUALITY

---

### Flux 2 Pro

**Weavy ID:** `fal-ai/flux-2-pro`
**Category:** Image Gen
**Builder:** `make_flux_pro_node()`
**Claims:** "Image generation and editing with FLUX.2 [pro] from Black Forest Labs."
**Reality:** Strong prompt adherence for simple scenes -- what you describe is what you get. However, struggles significantly with full-body human proportions (produces squat, compressed body shapes in action poses) and hallucinates details on specific products (e.g., added phantom hardware to sunglasses that wasn't in the prompt). Not the right choice when human anatomy or product accuracy matters.
**Best for:**
- Simple photorealistic scenes without full-body humans (landscapes, objects, still life)
- Generating a base image that NB Pro will later edit/vary
- Abstract or stylized compositions where exact proportions are less critical

**Avoid for:**
- Full-body human subjects, especially in action poses (produces squat/compressed proportions)
- Hero product shots requiring detail accuracy (hallucinates extra details)
- Image editing with a reference (NB Pro is better)
- Tasks requiring compositing or element replacement (NB Pro)
- Any workflow where a reference image is available (use NB Pro with image_1 instead)

**Use instead:** "For full-body humans, action shots, or product hero images, use Nano Banana Pro -- it produces correct proportions and accurate product details. For editing or compositing with a reference image, also use NB Pro."

**Gotchas:**
- Uses `image_size` parameter (type `fal_image_size`), NOT `resolution` / `aspect_ratio`. Do not confuse with NB Pro.
- `image_size` options: `Default`, `auto`, `square_hd`, `square`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, `landscape_16_9`
- Default `image_size` is `match_input` (built-in value), which matches the input image if one is provided.
- Same seed object pattern as NB Pro (`"seed"` type with `seed` int + `isRandom` bool).
- Has `output_format` and `safety_tolerance` in params but NOT in the schema/parameters arrays.

**Optimal params:**
- Image size: `landscape_16_9` for cinematic, `portrait_4_3` for portraits, `square_hd` for social
- Seed: `isRandom: True` for exploration
- Use the "reframe" strategy for photorealism: assert the image IS already a photograph in the prompt

---

## Video Generation Models

---

### Kling 3 Pro

**Weavy ID:** `kling` (kind type)
**Category:** Video Gen
**Builder:** `make_kling_node()`
**Claims:** "Kling 3.0 Pro: Top-tier image-to-video."
**Reality:** Actually top-tier. Expensive and slow, but produces high-quality video from a still image. Supports first frame, last frame, negative prompt, and Kling Elements for character/object consistency. Duration is configurable from 3 to 15 seconds.
**Best for:**
- Bringing a hero image to life (image-to-video)
- Controlled video generation with first AND last frame
- Character-consistent video using Kling Elements

**Avoid for:**
- Quick iteration (it is slow and expensive -- use Pattern M Quality Gate to avoid wasted runs)
- Text-to-video without any image input (results are less controlled)

**Use instead:** N/A -- this is currently the only video model in the catalog.

**Gotchas:**
- Duration is an integer (3-15), but stored as a string in `params.duration` and integer in `kind.duration`.
- `cfg_scale` range is 0-1 (float), default 0.5. Higher = more prompt adherence, lower = more creative freedom.
- `shot_type` is always `"customize"` -- the only current option.
- `aspect_ratio` only applies to text-to-image mode (`16:9`, `9:16`, `1:1`).
- Kling Elements require a separate `kling_element` node with frontal + reference images, connected via `kling-element` type handles.
- `generate_audio` exists but defaults to False.
- Model options: `3.0 Pro` (quality) vs `3.0 Standard` (faster, cheaper).
- Refs use different field names than other models: `image` (not `image_1`), `endImageUrl`, `negativePrompt`, `elements`.
- **Output is too large for direct LLM analysis.** Always place a VIDEO DOWNSCALE node between Kling's output and any LLM quality gate. Do not feed Kling video directly into an LLM image input.

**Optimal params:**
- Model: `3.0 Pro` for final output, `3.0 Standard` for testing
- Duration: `5` seconds is the sweet spot for most use cases
- CFG scale: `0.5` default is usually right; increase to `0.7` if the video drifts from the prompt
- Always pair with Pattern M (Quality Gate) for expensive runs

---

## LLM Models (Creative Roles)

These models are used inside workflows as creative agents (Art Director, Critic, Refiner, Copywriter, DOP, etc.), not as standalone generators.

All use `make_llm_node()` builder with `kind.type = "any_llm"`.

---

### anthropic/claude-sonnet-4-5

**Category:** LLM
**Best for:** Critic role (Pattern K/L/M). Strong vision capabilities for evaluating generated images against reference. Good balance of quality and speed.
**Optimal params:** Temperature 0 for Critic. Needs image inputs connected.
**Role fit:** Critic, Analyst

### anthropic/claude-opus-4-6

**Category:** LLM
**Best for:** Art Director role. Highest quality reasoning and creative direction. Use when the prompt quality directly determines the final image quality.
**Optimal params:** Temperature 0 for structured direction, 0.3 for creative exploration.
**Role fit:** Art Director, Creative Director
**Note:** Most expensive Anthropic model. Reserve for workflows where creative quality is the bottleneck.

### anthropic/claude-opus-4-5

**Category:** LLM
**Best for:** Art Director role. Strong reasoning and creative direction, previous generation Opus.
**Optimal params:** Temperature 0-0.3.
**Role fit:** Art Director, Creative Director

### anthropic/claude-3-haiku

**Category:** LLM
**Best for:** Fast, cheap tasks where quality ceiling is lower. Good for simple text formatting, basic analysis, lightweight roles.
**Optimal params:** Temperature 0.
**Role fit:** Formatter, simple Copywriter
**Note:** Not suitable for Critic (lacks vision depth) or Art Director (lacks creative sophistication) roles.

### google/gemini-2.0-flash-001

**Category:** LLM
**Best for:** Fast structured output. Previous generation Flash.
**Optimal params:** Temperature 0.
**Role fit:** Refiner, Formatter

### google/gemini-2.5-flash

**Category:** LLM
**Best for:** Refiner role (Pattern K/L). Fast, reliable at structured text generation. Good at taking a Critic's KEEP/FIX/REVISED DIRECTION output and producing a clean revised prompt.
**Optimal params:** Temperature 0.3 for Refiner. Temperature 0 for strict formatting.
**Role fit:** Refiner, Prompt Writer, Formatter
**Note:** Excellent cost-to-quality ratio for high-volume workflows (batch iteration).

### google/gemini-2.5-flash-lite

**Category:** LLM
**Best for:** Lightest-weight tasks. Even faster and cheaper than Flash.
**Optimal params:** Temperature 0.
**Role fit:** Simple formatting, delimiter splitting, lightweight text transforms

### google/gemini-3-pro

**Category:** LLM
**Best for:** General-purpose tasks requiring more reasoning than Flash but at lower cost than Claude Opus.
**Optimal params:** Temperature 0-0.3.
**Role fit:** Art Director (budget), Copywriter
**Note:** Default model in the Weavy LLM schema.

### openai/gpt-4o

**Category:** LLM
**Best for:** Critic role (alternative to Claude Sonnet). Strong vision capabilities for image evaluation. Well-calibrated for structured assessment output.
**Optimal params:** Temperature 0 for Critic.
**Role fit:** Critic, Analyst
**Note:** Good alternative when you want a different "eye" than Claude for the Critic pass.

### openai/gpt-4.1

**Category:** LLM
**Best for:** Strong reasoning tasks. Good for Art Director when you want OpenAI's reasoning style.
**Optimal params:** Temperature 0-0.3.
**Role fit:** Art Director, complex Copywriter

### openai/gpt-5-chat

**Category:** LLM
**Best for:** Highest-quality OpenAI option. Use when you need OpenAI-family reasoning at the top tier.
**Optimal params:** Temperature 0-0.3.
**Role fit:** Art Director, Creative Director

### meta-llama/llama-4-maverick

**Category:** LLM
**Best for:** Open-source option. Good for cost-sensitive high-volume workflows.
**Optimal params:** Temperature 0-0.3.
**Role fit:** Copywriter, Refiner
**Note:** Performance varies more than proprietary models. Test before committing to production workflows.

### meta-llama/llama-4-scout

**Category:** LLM
**Best for:** Lightweight open-source option. Faster than Maverick.
**Optimal params:** Temperature 0.
**Role fit:** Formatter, simple text tasks

---

## Video Utility Models

---

### Video Downscale (FFmpeg API)

**Weavy ID:** `fal-ai/ffmpeg-api/compose`
**Category:** Video Processing
**Builder:** `make_video_downscale_node()`
**Claims:** FFmpeg-based video composition and processing.
**Reality:** Used to downscale Kling video output before passing to an LLM quality gate. Kling outputs are too large for LLMs to analyze directly — this node compresses the video to a manageable size.
**Best for:**
- Downscaling video before LLM analysis (Pattern M Quality Gate)
- Any pipeline where a video model's output feeds into an LLM

**Avoid for:**
- Upscaling (use `fal-ai/video-upscaler` instead)

**Gotchas:**
- Uses `resolution` parameter (type `fal_image_size`) with same presets as Flux: `landscape_4_3`, `landscape_16_9`, etc.
- Always place between the video Router and the QA LLM, never before the video model

**Optimal params:**
- Resolution: `landscape_4_3` for QA analysis (small enough for LLM context, large enough to evaluate quality)

---

## Specialized Models (Known but Avoided)

---

### Try On

**Category:** Specialized (Virtual Clothing Try-On)
**Claims:** Virtual try-on -- place clothing items onto a model photo.
**Reality:** Tested and underperforms. Nano Banana Pro with well-structured prompts (output frame anchoring + clear KEEP/REPLACE sections) produces better clothing composites with more control over the result.
**Best for:** Nothing in current practice.
**Avoid for:** Everything -- use NB Pro instead.
**Use instead:** "For any clothing-on-model task, use Nano Banana Pro with a reference image and structured prompting. Describe the output frame first, specify what to KEEP (the model's pose, face, skin), and what to REPLACE (the clothing). Results are consistently better than Try On."

---

## Model Pairings

Proven combinations that work well together in production workflows.

### Flux 2 Pro then Nano Banana Pro
Use only for simple scenes (no full-body humans or product matching). Flux generates a base composition from text, NB Pro refines it. For subjects involving humans or hero products, skip Flux and use NB Pro for both passes -- it produces better proportions and product accuracy from the start.

### LLM (Art Director) then Image Model
The reliable architecture. An LLM writes the image prompt with full creative direction (lighting, composition, camera, materials), and the image model executes it. The LLM handles the creative thinking; the image model handles the pixels. Works with any image model but most commonly paired with NB Pro.

### LLM (Critic) + LLM (Refiner) then Image Model
The Critic-Refine review loop from Patterns K, L, and M. After Pass 1 generation, a vision-capable LLM (Claude Sonnet or GPT-4o) evaluates the result and produces KEEP/FIX/REVISED DIRECTION feedback. A fast LLM (Gemini 2.5 Flash) incorporates the critique into a revised prompt. The image model runs Pass 2. This doubles generation cost but significantly improves output quality.

**Recommended role assignments for Critic-Refine:**
- Critic: `anthropic/claude-sonnet-4-5` or `openai/gpt-4o` (temperature 0, vision required)
- Refiner: `google/gemini-2.5-flash` (temperature 0.3, fast structured output)
- Art Director: `anthropic/claude-opus-4-6` or `openai/gpt-4.1` (temperature 0-0.3)

### Kling 3 Pro with Quality Gate
Always pair Kling with Pattern M (Quality Gate). Kling is expensive and slow -- having a Critic LLM score the output before re-running saves significant cost. The Critic evaluates the video and outputs a SCORE/ASSESSMENT/RECOMMENDATION so the user can decide whether to accept or re-run.

---

## Updating This Catalog

This catalog is a living document. It improves through real usage, not speculation.

### Via /add command
When a user pastes real Weavy node JSON with `/add`, the system registers the new model and asks: "What is this model best at in practice? Any gotchas?" The answer populates the Reality, Best for, and Gotchas fields. Claims come from the node's description field. Everything else starts blank until tested.

### Via feedback
When a user reports model performance during conversation (e.g., "Try On didn't work but NB Pro did"), update the relevant entries:
- Update "Reality" with the observed behavior
- Update "Use Instead" on the underperforming model
- Update "Avoid For" on both models
- Update "Best for" on the model that actually worked

### Via iteration results
When a workflow produces results (good or bad), capture what worked:
- Which model + parameter combo produced the best output?
- Did a model fail at a task its description claimed it could do?
- Did a model succeed at a task outside its claimed specialty?

### Priority of evidence
1. Direct user feedback from production use (highest)
2. Comparative testing (model A vs model B on same task)
3. Single successful use
4. Model description / documentation (lowest -- this is what we are correcting)

Always update Reality, Use Instead, and Avoid For based on real experience. Never update them based on descriptions alone.
