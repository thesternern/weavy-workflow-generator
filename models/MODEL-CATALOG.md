# Model Catalog

Experience-driven model selection guide for Weavy workflows. Model descriptions lie -- this catalog prioritizes practical, battle-tested knowledge over surface-level feature names.

**Rule: Read "Reality" and "Use Instead" fields when selecting models. Never trust "Claims" alone.**

## Defaults

These are the standing defaults. Use them unless the brief gives a compelling reason to diverge (specific capability gap, content-policy issue, budget ceiling, or a use case where the default is on the "Avoid for" list).

| Domain | Default | When to diverge |
|---|---|---|
| **Image generation / editing** | **Nano Banana Pro** | Text-critical at 4K (NB2), pure photorealism with no humans/products (Flux 2 Pro), raw skin texture (Flux 1.1 Ultra raw mode), single-subject preset aesthetic (Higgsfield Image), tight budget (Seedream V5), pure T2I no editing (Imagen 4) |
| **Video generation** | **Seedance 2.0** | Specific capability gap only — camera-motion-on-stills (Higgsfield Video), photorealistic face hero shots where Seedance falls short (Kling 3 Pro), longest-duration with first+last frame interpolation (Wan 2.7), fast preview-tier iteration (LTX 2). Veo 3.1 is no longer the audio default — Seedance has native audio-video. |

When in doubt, pick the default. Divergence requires evidence, not aesthetic preference.

---

## Quick Decision Tree

### Image Generation

| You need... | Use this | Why |
|---|---|---|
| **Default — anything not explicitly listed below** | **Nano Banana Pro** | Standing default. Handles the broadest range of image work reliably. Diverge only when a row below specifically applies. |
| Full-body humans, action poses, or hero product shots | Nano Banana Pro | Better proportions, accurate product rendering; connect reference image to image_1 when available |
| High-volume production (cost-sensitive) | Nano Banana 2 | 50% cheaper than NB Pro, 40-50% faster, 4K capable |
| Budget image gen ($0.035/img) | Seedream V5 Edit | 4-7x cheaper than NB Pro with solid quality |
| Simple photorealistic scene (no humans or products to match) | Flux 2 Pro | Strong prompt adherence for landscapes, objects, abstract scenes |
| Raw photorealism with natural imperfections | Flux 1.1 Pro Ultra (raw mode) | Organic skin texture, grain, imperfections that read as real |
| Simple single-subject fashion portrait with preset aesthetic | Higgsfield Image | 80+ style presets — BUT only for 1 person, simple composition. Fails on groups/complex scenes |
| Single-shot natural scene with people (no editing needed) | Imagen 4 | Best human proportions/poses in pure text-to-image |
| Text rendering in images | Nano Banana Pro | 94% accuracy; NB2 at 87% is runner-up |
| Image editing / compositing with a reference | Nano Banana Pro | Excels at editing with reference image input |
| Vague/creative editing ("make it more atmospheric") | Seedream V5 Edit | Unique vague intent interpretation |
| Clothing on a model / virtual try-on | Nano Banana Pro (good prompting) | Outperforms the specialized Try On model in practice |
| Reference image exists anywhere in the workflow | Nano Banana Pro | Always route the reference to NB Pro's image_1 in addition to any LLM intermediary |

### Video Generation

| You need... | Use this | Why |
|---|---|---|
| **Default — anything not explicitly listed below** | **Seedance 2.0** | Standing default. Multimodal (text/image/audio/video inputs), native audio-video joint generation, multi-shot storytelling, phoneme-level lip-sync in 8+ languages, up to 15s. #1 image-to-video-with-audio on Artificial Analysis benchmarks. Diverge only when a row below specifically applies. |
| Image-to-video with native audio | Seedance 2.0 | Only model with true native audio-video joint generation (not post-processed) |
| Multi-shot storytelling from a single prompt | Seedance 2.0 | Only model offering this in one pass |
| Camera motion on a still image (subject frozen) | Higgsfield Video | 120+ motion presets, no competitor for pure 2.5D parallax |
| Photorealistic face hero shots where Seedance underdelivers | Kling 3 Pro | Battle-tested face quality; verify Seedance falls short before diverging |
| First+last frame interpolation | Wan 2.7 | Unique capability if Seedance's keyframe control is insufficient |
| Fast preview / draft iteration | Seedance 2.0 Fast | Same capabilities as Standard, ~2x faster, ~half cost. Use LTX 2 only when its stylized / non-photoreal aesthetic is the goal. |
| Negative prompt control on video | Wan 2.7 | Most effective negative prompting if Seedance's prompt control is insufficient |

### Avatar / Lip Sync

| You need... | Use this | Why |
|---|---|---|
| Photorealistic human talking head with emotion | Omnihuman V1.5 | Film-grade full-body animation with emotional cognition |
| Animals, cartoons, or stylized characters | Kling Avatar Pro | Only option supporting non-human subjects |
| Text prompt control over avatar scene | Kling Avatar Pro | Omnihuman has no prompt input |
| Audio-driven talking head (budget) | Omnihuman V1.5 | No per-second pricing, simpler inputs |

### Post-Processing

| You need... | Use this | Why |
|---|---|---|
| Faithful upscale (preserve original) | Topaz Image Upscale | Gold standard for restoration-style upscaling |
| Creative upscale (add new detail) | Magnific Upscale | Generative upscaler, prompt-guided, up to 8x |
| Fix AI plastic skin / uncanny valley | Magnific Skin Enhancer (transform_to_real) | Adds realistic skin texture AI images lack |
| Sharpen AI-generated softness | Topaz Sharpen (Natural mode) | Adds texture detail without over-sharpening |
| Upscale AI video to 4K | Topaz Video Upscaler (Astra model) | Specifically trained on AI-generated video artifacts |
| Upscale + face preservation | Topaz Image Upscale | Face Recovery model preserves identity |

### Supporting Roles

| You need... | Use this | Why |
|---|---|---|
| LLM with vision (Critic role) | Claude Sonnet 4.5 or GPT-4o | Both handle image analysis well at temperature 0 |
| Fast LLM for structured output (Refiner) | Gemini 2.5 Flash | Fast, reliable structured text generation |
| High-quality LLM for creative direction | Claude Opus or GPT-4.1 | Strongest reasoning for Art Director role |

### Image Model Selection Logic (read this before choosing)

**Start from NB Pro.** It is the default. Only diverge if one of the conditions below is true *and* the divergence is actually worth it.

1. **Default → Nano Banana Pro.** Handles editing, compositing, full-body humans, hero products, clothing-on-model, text rendering, and reference-image workflows better than alternatives. If a reference image exists anywhere in the workflow, route it to NB Pro's `image_1` AND to the Art Director LLM.
2. **Diverge to Nano Banana 2** only if the brief requires 4K output OR cost/volume is the primary constraint AND text rendering accuracy is not critical (NB2 drops from 94% → 87% on text).
3. **Diverge to Flux 2 Pro** only for simple scenes with no humans and no product-matching needs (landscapes, objects, abstract). Never for full-body humans or hero products.
4. **Diverge to Flux 1.1 Ultra (raw mode)** only when raw, organic, unprocessed skin texture is the explicit goal — the "anti-AI-perfection" look.
5. **Diverge to Higgsfield Image** only for single-subject fashion portraits where a specific preset aesthetic is the entire goal. Never for groups, complex scenes, or anything requiring prompt control.
6. **Diverge to Imagen 4** only for pure text-to-image with people where no editing/iteration is needed and SynthID watermark is acceptable.
7. **Diverge to Seedream V5 Edit** only when budget is the primary constraint ($0.035/img is 4-7x cheaper than NB Pro) OR for vague creative editing intent.
8. **When in doubt → NB Pro.** Aesthetic preference for another model is not a compelling reason. The diverge conditions above are the bar.

### Video Model Selection Logic (read this before choosing)

**Start from Seedance 2.0.** It is the default. Only diverge if one of the conditions below is true *and* the divergence is actually worth it.

1. **Default → Seedance 2.0.** Multimodal in / multimodal out: text, image, audio, video inputs in one model. Native audio-video joint generation (not bolted on). Multi-shot storytelling from a single prompt. Phoneme-level lip-sync in 8+ languages. Up to 15s duration. Currently #1 on Artificial Analysis for image-to-video-with-audio. Use it for general video, talking heads, narrative clips, and anything with native audio.
2. **Diverge to Higgsfield Video** only when the brief is camera motion on a still image with the subject frozen (2.5D parallax) AND a specific motion preset matches the request. Seedance does not replicate Higgsfield's 120+ preset library.
3. **Diverge to Kling 3 Pro** only when Seedance produces a face hero shot that fails QA AND the project demands Kling-grade photorealistic face quality. Verify the failure first — do not pre-empt.
4. **Diverge to Wan 2.7** only when the workflow specifically needs first+last frame interpolation OR the most effective negative-prompt control on video. Wan's flexibility is the differentiator, not its quality.
5. **Diverge to LTX 2** only when it beats Seedance 2.0 Fast on a specific axis (raw speed, non-photorealistic / stylized output, very-low-cost previews). Default to **Seedance 2.0 Fast** for draft iteration — same capabilities as Standard, ~2x faster, ~half cost — before reaching for LTX. Use LTX 2 only when its specific characteristics fit the brief.
6. **Veo 3.1 is no longer the default for native audio.** Seedance 2.0's audio-video generation is native and superior. Veo's value is now narrow: cinematic text-to-video where its specific aesthetic is wanted and content policy is acceptable.
7. **When in doubt → Seedance 2.0.** Aesthetic preference for another model is not a compelling reason. The diverge conditions above are the bar.

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

### Nano Banana 2

**Weavy ID:** `fal-ai/nano-banana-2/edit`
**Category:** Image Gen / Image Edit
**Builder:** `make_nb2_node()`
**Claims:** "Google's state-of-the-art image generation and editing model"
**Reality:** Successor to NB Pro, backed by Gemini 3.1 Flash instead of Gemini 3 Pro. 40-50% faster and 50% cheaper (~$0.07/img vs NB Pro's ~$0.134). Reaches 4K resolution (vs Pro's 2K max). Editing improved significantly -- fixes specific elements without collapsing the surrounding composition. However, text rendering regressed measurably (87% accuracy vs Pro's 94%). Speed advantage evaporates at 4K resolution and during peak hours due to dynamic throttling. As of April 2026, NB2 is the better default for most people; NB Pro is the better override for text-critical work.
**Best for:**
- High-volume production workflows where cost matters (50% cheaper than Pro)
- 4K output requirements (Pro maxes at 2K)
- Fast iteration cycles at 512 or 1K resolution
- Editing workflows where text accuracy isn't critical
- Budget-conscious pipelines that still need quality

**Avoid for:**
- Text-heavy images (marketing mockups, posters, labels, callout-heavy visuals) -- Pro's 94% text accuracy is measurably better than NB2's 87%
- When the quality ceiling absolutely matters more than cost

**Use instead:** "For text-critical deliverables (posters, labels, UI mockups), use NB Pro -- its 94% text rendering accuracy vs NB2's 87% is the deciding factor."

**Gotchas:**
- Same input structure as NB Pro (prompt + image_1 for editing), same workflow patterns apply
- Adds `512` resolution option (NB Pro doesn't have it) -- excellent for ultra-fast drafts
- Adds extreme aspect ratios up to `8:1` / `1:8`
- `enable_web_search` parameter exists but is experimental -- unclear value
- Speed advantage disappears at 4K and during peak hours (dynamic throttling)
- Seed is same `"seed"` type object as NB Pro

**Optimal params:**
- Resolution: `1K` for iteration, `2K` for production, `4K` for final deliverables only
- `512` for rapid concept testing (new option vs NB Pro)
- Aspect ratio: `Default` unless brief specifies otherwise
- Same prompt structure as NB Pro: OUTPUT FRAME first / CONTEXT / KEEP / REPLACE

---

### Higgsfield Image

**Weavy ID:** `higgsfield_t2i`
**Category:** Image Gen
**Builder:** `make_higgsfield_image_node()`
**Claims:** "Higgsfield's image generation model"
**Reality:** Style-preset model that works ONLY for simple single-subject compositions. The 80+ style presets (2000s Cam, Indie Sleaze, Y2K, etc.) are the core product and handle photographic treatment automatically. However, the model fundamentally breaks when asked to generate complex scenes, multiple people, or chaotic environments. Tested in production with early 2000s club/party scenes: output was incoherent — distorted bodies, no recognizable faces, abstract noise instead of people, flash reflections overwhelming the image. Multiple independent reviewers confirm: "complex actions lead to chaos or artifacts" (3.6/10 motion quality), "80% of the time gives you back a shiny model look with generic prompts," and community feedback describes it as "basically a UI wrapped around someone else's model doing a worse job than the free stuff." The presets actively fight detailed prompts — enhance_prompt overrides careful prompt engineering even when set to false, and the model defaults to a synthetic fashion look rather than realistic imperfections.

**STATUS: DO NOT USE for production workflows involving multi-person scenes, complex environments, or photorealistic humans requiring anatomical accuracy. Restrict to simple single-subject fashion/lifestyle shots where a specific preset aesthetic is the only goal.**

**Best for:**
- Simple single-subject fashion portraits with a specific preset aesthetic
- Style exploration and moodboarding (quick visual direction, not final output)
- Social media content where a single centered subject wears the preset's "look"
- Cases where you ONLY need one person, centered, clean background, preset-driven aesthetic

**Avoid for:**
- **Multi-person scenes of any kind** — faces distort, bodies merge, composition collapses
- **Complex environments** — clubs, streets, parties, any scene with background detail and multiple elements
- **Chaotic or candid compositions** — unposed, dynamic, asymmetric framing
- **Photorealistic humans requiring anatomical accuracy** — hands, faces in groups, body proportions in action
- **Any scene where prompt control matters more than preset aesthetic** — presets dominate and override
- **Product placement or specific accessory rendering** — sunglasses, jewelry, branded items get distorted
- **Production workflows where reliability matters** — high failure rate on non-trivial prompts

**Use instead:** "For any scene with 2+ people, complex environments, or photorealistic human subjects, use NB Pro (with reference image) or Flux 2 Pro (pure T2I). For group shots specifically, Imagen 4 has the best human proportions in pure T2I. Higgsfield should only be considered for simple single-subject fashion shots where the preset aesthetic is the primary goal."

**Gotchas:**
- **Native Weavy integration, NOT a fal.ai import.** `data.model` must be `{"name": "higgsfield_t2i"}` only — no `service` or `version` fields. `data.kind.model` must be `{"type": "predefined", "name": "higgsfield_t2i", "description": "..."}` — no `version` or `service`. Adding `service: "fal_imported"` triggers fal.ai app ID validation which rejects the model name.
- **Fails catastrophically on multi-person scenes.** Not "produces lower quality" — produces unusable abstract noise. This is a hard constraint, not a quality tradeoff.
- **Presets override prompt control even with enhance_prompt=false.** The model has a strong prior toward its internal aesthetic that detailed prompts cannot fully override.
- **80% synthetic look with generic prompts.** When given character descriptions without extremely specific anti-AI language, defaults to a "shiny model" appearance that reads as obviously AI-generated.
- **Sunglasses and accessories distort.** Confirmed in both production testing and community reports — eyewear is a particular failure mode.
- Style presets are the product -- without them it's a standard generator. 80+ presets available (see builder for full list).
- `image_reference` is style transfer, not composition blending. It copies the aesthetic, not the layout.
- `style_strength` constraint type is `float_with_limits`, not `number` — differs from other models.

**Optimal params (when used within its narrow valid use case):**
- Style: Single-subject fashion shots only. Notable presets: `Realistic`, `FashionShow`, `90's Editorial`, `Quiet luxury`, `Tokyo Streetstyle`
- Style strength: `1.0` for full preset commitment, `0.5-0.7` for subtler blend
- enhance_prompt: `false` always in Weavy workflows — prompt precision is critical
- Resolution: `1696x960` (default) for landscape, `960x1696` for portrait, `1536x1536` for square
- **Never use for batch generation via iterator** — the failure rate is too high for unattended batch runs

---

### Google Imagen 4

**Weavy ID:** `imagen4`
**Category:** Image Gen (text-to-image ONLY)
**Builder:** `make_imagen4_node()`
**Claims:** "Google's highest quality image generation model"
**Reality:** Strong for natural scenes with people -- handles human proportions, poses, facial expressions, and hand positions more reliably than most models. Text rendering is good but not best (Ideogram leads, NB Pro is better). Three tiers: Fast ($0.02/img, 10x faster, basic quality), Standard ($0.04/img, good all-around), Ultra ($0.06/img, marginal improvement over Standard for most uses). Content policy is Google-strict: blocks public figures, violence, sexual content at API level. SynthID watermark is embedded in all outputs. No image input whatsoever -- pure text-to-image only.
**Best for:**
- Single-shot natural scenes with people (best human proportions in pure T2I)
- Product accuracy from text prompts
- Budget workflows with Fast tier ($0.02/img)
- When no editing/iteration is needed (generate and ship)

**Avoid for:**
- Any workflow requiring image editing or reference images (text-to-image ONLY)
- Edgy, fashion, or content-policy-adjacent creative work (aggressive restrictions)
- Iterative refinement workflows (no image input means no edit loops)
- When SynthID watermark is undesirable

**Use instead:** "For any editing/compositing workflow, use NB Pro or Seedream V5. Imagen 4 has no image input. For content with policy risk, use Flux (more permissive safety_tolerance)."

**Gotchas:**
- NO image input. Cannot be used in Pattern H (Retouch Pipeline) or any editing pattern.
- Has `negative_prompt` (like Kling, unlike NB Pro/Flux)
- SynthID watermark is invisible but detectable -- consider for commercial use
- Standard vs Ultra difference is marginal -- Ultra only justified for hero deliverables
- Fast tier text rendering is noticeably worse than Standard/Ultra
- Content restrictions are the most aggressive of any image model in catalog

**Optimal params:**
- Model: `Standard` for production (best cost/quality), `Fast` for iteration, `Ultra` only for hero shots
- Resolution: `1K` for most work, `2K` for final deliverables
- Aspect ratio: `16:9` for cinematic, `9:16` for social, `1:1` for product

---

### Flux Pro 1.1 Ultra

**Weavy ID:** `black-forest-labs/flux-1.1-pro-ultra`
**Category:** Image Gen
**Builder:** `make_flux_ultra_node()`
**Claims:** "FLUX1.1 [pro] in ultra and raw modes. Images are up to 4 megapixels. Use raw mode for realism."
**Reality:** Raw mode is the headline feature -- produces organic, unprocessed images with natural skin texture, imperfections, and subtle grain that standard AI models smooth away. Renders individual skin textures, realistic lighting angles, natural asymmetry, freckles. 4MP native resolution (2048x2048). Redux image_prompt works via composition blending with adjustable strength. 2.5x faster than comparable high-res models. Raw mode also increases diversity in human subjects.
**Best for:**
- Photorealistic portraits where "unprocessed" natural look is desired (raw mode)
- Nature photography requiring authentic textures (raw mode)
- High-resolution output (4MP native)
- Image variation via Redux blending (image_prompt input)
- When you need the opposite of the typical AI "too perfect" look

**Avoid for:**
- When Flux 2 Pro's newer multi-reference control features are needed
- Image editing workflows (this is generation, not editing)
- Polished/commercial look (raw mode adds imperfections by design)

**Use instead:** "For multi-reference control and latest Flux features, use Flux 2 Pro. For editing workflows, use NB Pro. Flux 1.1 Ultra's unique value is raw mode photorealism."

**Gotchas:**
- **Unique kind type: `flux11_pro_ultra`** -- NOT wildcard like most models
- `raw` is a boolean toggle (true/false), not a slider. Default false.
- `image_prompt_strength` default 0.1 is very low -- increase to 0.3-0.5 for meaningful reference influence
- `safety_tolerance` range 1-6 (higher = more permissive). Default 2 is conservative.
- `output_format` supports jpg/png (unlike NB Pro which has no output_format)
- Structurally different from Flux 2 Pro -- different builder, different kind type

**Optimal params:**
- raw: `true` for photorealism (the reason to use this model), `false` for polished output
- Aspect ratio: 11 options including `21:9`/`9:21` for ultrawide
- image_prompt_strength: `0.3-0.5` when using reference, `0.1` for light influence
- safety_tolerance: `2` default, increase to `4-5` for creative freedom

---

### Seedream V5 Edit

**Weavy ID:** `fal-ai/bytedance/seedream/v5/lite/edit`
**Category:** Image Gen / Image Edit
**Builder:** `make_seedream_node()`
**Claims:** "Image editing endpoint for the fast Lite version of Seedream 5.0"
**Reality:** ByteDance's model, 4-7x cheaper than NB Pro at $0.035/img. Unique "vague intent editing" -- interprets ambiguous instructions like "make this photo feel more atmospheric" and auto-adjusts lighting/tones without precise instruction. Web search capability for time-sensitive content (first model to offer this). Three generations available (V4.0/V4.5/V5.0). Better editing controllability than previous versions -- preserves non-edited areas more stably. Quality below NB Pro for peak photorealism but closing the gap fast. Intelligent spatial reasoning understands complex object/light relationships.
**Best for:**
- Budget workflows ($0.035/img is 4-7x cheaper than NB Pro)
- Creative/vague editing ("make it more high-end", "more atmospheric")
- High-volume iteration where cost adds up
- Web-search-driven content (current events, accurate weather, etc.)
- When editing instructions are natural language, not technical

**Avoid for:**
- Maximum photorealism (NB Pro and Imagen 4 still lead)
- Text rendering accuracy (NB Pro is significantly better)
- When precise technical editing control matters more than creative interpretation

**Use instead:** "For peak photorealism and text accuracy, use NB Pro. For precise editing control, use NB Pro. Seedream's value is budget + creative interpretation."

**Gotchas:**
- "Lite" in the name is about speed, not reduced quality -- it's the primary Seedream endpoint
- `model` parameter: V5.0 is default and best. V4.0/V4.5 available for comparison but no reason to use them.
- `enhance_prompt_mode`: `standard` is more thorough, `fast` is quicker. Standard is default and usually better.
- Uses `fal_image_size` parameter type (like Flux 2 Pro), including `auto_2K` and `auto_3K` options
- `match_input` is the default image_size -- auto-matches reference image dimensions
- Web search adds latency when triggered

**Optimal params:**
- Model: `V5.0` always
- Image size: `match_input` (default) when editing, `auto_2K` for generation
- enhance_prompt_mode: `standard` for quality, `fast` for speed

---

## Video Generation Models

---

### Seedance 2.0

**Standing default for all video work as of April 2026.** Two endpoints — both share parameters; choose based on what's driving the generation.

#### When to use which endpoint

| Use Case | Endpoint | Why |
|---|---|---|
| Animate a still image with synchronized audio | **I2V** | Typed `image_url` first-frame is the cleanest path; optional `end_image_url` for keyframed transitions |
| First+last frame interpolation | **I2V** | Dedicated last-frame handle (replaces Wan 2.7's old advantage here) |
| Single-image driver, no other refs needed | **I2V** | Simpler graph; the typed handle prevents mis-routing |
| Mix multiple images, videos, or audio clips as conditioning | **Reference** | Up to 9 images / 3 videos / 3 audio clips, tagged in the prompt |
| Style transfer (style from one image, identity from another) | **Reference** | Tag-based attribution (`@Image1` for character, `@Image2` for style, `@Video1` for camera) |
| Video editing (modify an existing clip while preserving motion/camera) | **Reference** | Pass a video to `reference_1` and describe the change in the prompt |
| Video extension (continue an existing clip) | **Reference** | Same input pattern; describe what happens next in the prompt |
| Chain Kling Elements output into video | **Reference** | `reference_1` accepts `kling-element` type directly |
| Camera-motion-from-video (use a reference video purely for its camera moves) | **Reference** | Tag `@Video1 for camera movement style` in the prompt |
| Lip-sync to a specific audio clip | **Reference** | Pass audio to a reference; tag `@Audio1 for lip-synced dialogue` |

**Decision shortcut:** If your only conditioning is one image (with optional last frame), use I2V. The moment you need to combine multiple modalities or do editing/extension, switch to Reference.

#### Endpoint specs

**`bytedance/seedance-2.0/image-to-video`** (service: `fal_imported`, kind.model.type: `predefined`)
- Inputs: `prompt` (text, required) · `image_url` (image, "first_frame", optional) · `end_image_url` (image, "Last Frame", optional)
- Cleanest for single-image driver with optional keyframed end

**`bytedance/seedance-2.0/reference-to-video`** (service: `fal_imported`, kind.model.type: `user_defined`)
- Inputs: `prompt` (text, required) · `reference_1` (polymorphic — image/video/audio/3D/text/number/boolean/seed/array/lora/kling-element, optional)
- Description claims up to 9 images / 3 videos / 3 audio clips. The schema exposes one `reference_1` handle, but in production each reference asset is uploaded with an auto-tag (`@Image1`–`@Image9`, `@Video1`–`@Video3`, `@Audio1`–`@Audio3`) and addressed in the prompt by tag. **Open question:** how Weavy expands this in practice — likely the node clones additional reference handles when you add more inputs, or you connect an array node upstream. **Verify this on the first real Reference workflow you build and update this entry.**

**Shared parameters (both endpoints):**
- `model`: enum [Standard, Fast]
- `duration`: enum string [`"4"`–`"15"`]
- `resolution`: enum [480p, 720p, 1080p] (no 4K native — chain Topaz for 4K delivery)
- `aspect_ratio`: enum [auto, 21:9, 16:9, 4:3, 1:1, 3:4, 9:16]
- `generate_audio`: boolean (default true)
- `seed`: seed object (`{seed: int, isRandom: bool}`)

**Builders:** `make_seedance_i2v_node(node_id, name, prompt_ref, image_ref, end_image_ref, x, y, ...)` and `make_seedance_ref_node(node_id, name, prompt_ref, reference_ref, x, y, ...)` — defined in `core/NODE-BUILDERS.md`. Both take optional kwargs `model`, `duration`, `resolution`, `aspect_ratio`, `generate_audio` with sane defaults (Standard / "5" / 720p / auto / true). Reference variant's `reference_ref` is a single polymorphic input — verify Weavy's multi-reference expansion on first production use.

#### Reality (research-grounded; update with production data)

Released February 12, 2026; on fal.ai April 2026. Unified multimodal architecture (composition, motion, camera planning, audio in one pass — not stitched together). Currently #1 on Artificial Analysis for image-to-video-with-audio. Native audio-video joint generation is the headline differentiator — audio is co-generated, not bolted on, and lip-sync covers 8+ languages at phoneme level.

**Where Seedance shines (per WaveSpeedAI, MagicHour, fal.ai guides):**
- Complex physics, detailed person tracking, nuanced light behavior — fight scenes, fashion walks, product light studies, wide cinematic frames
- Multi-shot storytelling from a single prompt (unique in the field)
- Director-level camera control language in prompts
- Multilingual lip-sync via the audio reference path

**Where Seedance still falls short (per WaveSpeedAI Issues review and ImaGera 2026 review):**
- **Detailed hand close-ups** (instruments, typing) — wide shots are fine; extreme close-ups of hands break down
- **Multi-subject scenes with >2-3 independent action sequences** — success rate drops sharply
- **Very fast motion** — objects can disappear or float when movement gets too fast
- **On-screen text rendering** — inconsistent; add typography in post
- **Native 4K** — not a strength; Kling 3 Pro is still ahead at 4K/60fps native
- **Realistic-face content moderation** — was extremely aggressive after Disney/Paramount IP letters; partially relaxed by April 2026 but verify per platform
- **Standard tier latency** — 60–120s for a 5s clip at Standard. Plan accordingly for batch runs.

**Standard vs Fast:** Both have identical capabilities (same inputs, same lip-sync, same params). Fast is ~2x faster at ~half the cost (~$0.77 vs ~$1.21 per generation). Quality gap is narrowest on simple/vertical/single-subject scenes — for social-feed content at scale, Fast is the default. Quality gap widens on cinematic frames, complex physics, fashion walks. **Working rule:** use Fast for all drafts; switch to Standard only for the final keeper, and only when the brief is in Standard's strength zone (cinematic / complex physics / multi-shot).

#### Best for

- General video generation — this is the default; start here unless a row in the diverge logic above applies
- Image-to-video with native audio (replaces Veo for audio-video) → I2V
- First+last frame interpolation → I2V
- Multi-modal conditioning (image + video + audio refs combined) → Reference
- Style transfer with explicit attribution (`@Image1` identity / `@Image2` style / `@Video1` camera) → Reference
- Video editing / extension → Reference
- Pipelines where Kling Elements outputs feed into video (`reference_1` accepts `kling-element`) → Reference
- Multilingual talking-head content (lip-sync via audio reference)
- Any workflow where audio and video should feel co-authored, not synced after the fact

#### Avoid for

- Pure camera motion on stills with subject frozen — Higgsfield Video's 120+ presets are unmatched here
- 4K-native delivery without an upscale step — caps at 1080p; chain Topaz Video Upscaler (Astra)
- Extreme close-ups of hands performing detail tasks (instruments, typing) — known weakness
- Scenes with 4+ subjects performing independent actions simultaneously
- Very fast / chaotic action where objects need to remain coherent — physics breaks under speed
- On-screen typography that needs to be precise — render text in post, not in-model
- Brief is content-policy-adjacent for realistic-human work — verify regional moderation status before committing

#### Use instead

"For pure camera-motion-on-stills, use Higgsfield Video. For fast preview/draft iteration where speed beats quality, use LTX 2 (or Seedance 2.0 Fast at draft tier — often a better choice now). For 4K/60fps face hero shots that demand Kling-grade fidelity, use Kling 3 Pro. For workflows where Wan 2.7's negative-prompt control is the actual differentiator, use Wan. Veo 3.1 is no longer a default for native audio — Seedance does it better."

#### Reference-endpoint prompt syntax (verify against Weavy's runtime)

Per ByteDance / Dreamina / fal.ai docs, the Reference endpoint expects tag-based attribution in the prompt:

```
@Image1 as character face reference, @Image2 for environment lighting,
@Video1 for camera movement style, @Audio1 as background music.
[Then describe the scene/action.]
```

Tag pattern: `@Image1`–`@Image9`, `@Video1`–`@Video3`, `@Audio1`–`@Audio3`. Be specific about *what attribute* should be extracted from *which reference* — the model rewards explicit attribution and drifts when prompts are vague.

**Open question for production verification:**
- Does Weavy's single `reference_1` handle accept an array of assets (each becoming `@Image1`, `@Image2`, etc.), or does adding inputs auto-expand the node into `reference_2`, `reference_3`...? Determine this on first real Reference workflow and update this entry.

#### Gotchas

- **Output handle is `result`** (type `video`), not `video` like Wan and most other video models. Edge wiring downstream must reference `result`.
- **Resolution caps at 1080p** on both endpoints — pair with Topaz Video Upscaler for 4K delivery.
- **`generate_audio` defaults to true** — disable explicitly when the pipeline scores audio separately or downstream nodes don't expect an audio track.
- `duration` is an **enum of strings** (`"4"`–`"15"`), not an integer. Pass strings in `params.duration`.
- `aspect_ratio` default is `auto` — infers from input. Override only when reframing.
- **`kind.model.type` differs**: `predefined` for I2V, `user_defined` for Reference. The builder must set this correctly per endpoint.
- **`kind.type` is `wildcard`** on both (like Wan) — model identifier lives in `kind.model.name` and `kind.model.version`.
- Reference endpoint's `reference_1` is **genuinely polymorphic** (`validTypes` includes image, video, audio, 3D, text, number, boolean, seed, array, lora, kling-element).
- **Standard tier is slow** — 60–120s for a 5s clip. Use Fast for drafts; Standard only when its quality strengths matter.
- Realistic-human content moderation was tightened post-Disney/Paramount letters; partially relaxed but **verify per platform** before committing client work.
- Output is `video` on handle `result` — wire to a Video Downscale node before any LLM Quality Gate (same pattern as Kling).
- 15s max per generation — for 60s+ narratives, plan multi-generation continuity (the Reference endpoint's video-extension capability is the right tool here).

#### Optimal params

- Model: **`Fast` for all drafts and most social-format work; `Standard` only for the final keeper on cinematic / complex-physics / multi-shot briefs.** Fast and Standard share capabilities; the gap narrows on simple scenes.
- Duration: `5` is the sweet spot. Extend to 10–15s only when narrative needs it (cost and latency scale).
- Resolution: `720p` for iteration, `1080p` for final (no higher native option).
- Aspect ratio: `auto` when image/reference is provided; explicit only when reframing.
- `generate_audio`: `true` for talking-head / narrative; `false` when scoring audio separately or downstream rejects audio tracks.
- Seed: `isRandom: True` for exploration; lock for reproducible refinement.
- Reference endpoint: write **explicit, attributed** prompts — `@Image1 for face`, `@Video1 for camera`, etc. Vague prompts cause drift.

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

**Use instead:** "For general video and any audio-video work, use Seedance 2.0 (the default). For camera motion on stills, use Higgsfield Video. For maximum input-mode flexibility (first+last frame, negative prompt), use Wan 2.7. For fast previews, use LTX 2. Kling is now reserved for face hero shots where Seedance has demonstrably underdelivered."

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

### Veo 3.1 Text to Video

**Weavy ID:** `google-veo3-t2v`
**Category:** Video Gen (text-to-video ONLY)
**Builder:** `make_veo3_node()`
**Claims:** "Sound on: Google's flagship Veo 3 text to video model, with audio"
**Reality:** Text-to-video only (no image input). Native audio generation was the headline feature -- but Seedance 2.0 (Feb 2026) now offers native audio-video joint generation in a multimodal architecture, making Veo's audio advantage largely obsolete. Veo's remaining value is its specific cinematic look for safe corporate text-to-video. Auto_fix prompt rewriting is a major pain point -- alters creative intent. Content policy restrictions are the most aggressive of any video model -- blocks edgy/fashion/action content frequently. Standard vs Fast: Fast is noticeably lower quality. v3.1 is incremental improvement over v3. **No longer a default for audio video — diverge to Veo only when its specific aesthetic is wanted.**
**Best for:**
- Talking head / dialogue scenes (audio sync is the differentiator)
- Cinematic establishing shots
- Safe corporate content
- When native audio saves a pipeline step

**Avoid for:**
- Anything with content policy risk (fashion, action, editorial)
- Workflows needing image-to-video (no image input)
- Precise prompt control (auto_fix rewrites your prompts)

**Use instead:** "For general video and audio-video work, use Seedance 2.0 (the default — Veo's old audio advantage is now superseded). For image-to-video face hero shots that Seedance underdelivers on, use Kling 3 Pro. For maximum input-mode flexibility, use Wan 2.7. Veo's narrow remaining value is text-to-video where its specific cinematic look is the goal."

**Gotchas:**
- Text-to-video ONLY -- no image input at all
- `auto_fix` (default true) rewrites prompts that fail content policy -- can alter creative intent. Set to false for control, but more generations will fail.
- `generate_audio` (default true) is the key feature -- disable only if you're adding audio separately
- `enhance_prompt` (default true) adds detail to prompts -- test with false for precise control
- Content policy blocks are frequent and frustrating for creative work
- Standard vs Fast: use Standard for anything client-facing

**Optimal params:**
- Model: `Standard` for production, `Fast` only for rough concepts
- Version: `3.1` always
- Duration: `8s` (max) for most content
- Resolution: `720p` for iteration, `1080p` for final
- auto_fix: `false` for creative control (accept more failures), `true` for reliability

---

### Wan 2.7 Video

**Weavy ID:** `fal-ai/wan/v2.7/image-to-video` (also `fal-ai/wan/v2.7/text-to-video`)
**Category:** Video Gen
**Builder:** `make_wan_node()`
**Claims:** "Enhanced motion smoothness, superior scene fidelity, and greater visual coherence"
**Reality:** Most flexible video model -- genuinely supports all input modes (text, image, first+last frame, audio, negative prompt). Image-to-video solid but a tier below Kling for photorealistic faces. First+last frame interpolation works but can produce unnatural motion for complex movements. Audio-driven video is experimental (lip sync works for simple talking heads). Negative prompts are a real differentiator. Motion quality good for slow-to-medium; fast motion shows more artifacts than Kling. Faster and cheaper than Kling.
**Best for:**
- Workflows needing both text-to-video AND image-to-video flexibility
- First+last frame interpolation (unique capability)
- Negative prompt control on video
- Budget-conscious production (cheaper than Kling)
- Longest duration needs (up to 15s)

**Avoid for:**
- Hero shots requiring Kling-level face photorealism
- Fast-motion / action sequences
- Production lip sync (audio-driven is experimental)

**Use instead:** "For best face quality, use Kling 3 Pro. For camera motion on stills, use Higgsfield Video. Wan's value is flexibility and negative prompts."

**Gotchas:**
- Two Weavy IDs: `fal-ai/wan/v2.7/image-to-video` (default) and `fal-ai/wan/v2.7/text-to-video`
- Output handle is `video` (not `result` like most models)
- `end_image_url` enables first+last frame mode -- powerful but interpolation can break on complex motion
- `audio_url` enables audio-driven generation -- experimental, works for simple talking heads
- `enable_prompt_expansion` (default true) adds detail -- test with false for control
- Duration is integer 2-15 (longest of any video model)

**Optimal params:**
- Resolution: `1080p` for production, `720p` for iteration
- Duration: `5` for standard clips, up to `15` when length matters
- enable_prompt_expansion: `true` for general use, `false` for precise control

---

### LTX 2 Video

**Weavy ID:** `ltx2_video`
**Category:** Video Gen
**Builder:** `make_ltx2_node()`
**Claims:** "Enhanced textures, prompt adherence, motion and native high resolution"
**Reality:** "Native 4K" is marketing -- perceptual quality is more like upscaled 1080p. 50fps is largely interpolated, not truly independent frames. Fast mode is genuinely fast but noticeably lower quality (draft mode). Motion coherence is weaker than Kling and Wan -- more morphing, physics breaking, temporal flicker. Speed is the genuine strength -- significantly faster than competitors.
**Best for:**
- Rapid iteration / concept exploration (fast mode for drafts)
- Workflows where speed > peak quality
- Higher resolution output for cropping / reframing
- Non-photorealistic styles (animation, stylized)

**Avoid for:**
- Photorealistic human subjects
- Marketing as "true 4K" (it's not)
- Complex motion or physics
- When Kling-level coherence is needed

**Use instead:** "For quality, use Kling 3 Pro or Wan 2.7. LTX is the fast preview stage -- use it for iteration, then Kling/Wan for final renders."

**Gotchas:**
- `model`: `ltx-2-fast` (default, speed) vs `ltx-2-pro` (quality). Fast is truly fast but visibly lower quality.
- `fps`: `25` (default) vs `50` -- 50fps is mostly interpolated
- Resolution options go up to `3840x2160` (4K) but quality doesn't scale with resolution
- `prompt_enhancement` (default true) -- same pattern as other models
- Duration: 6/8/10 seconds (shorter max than Wan/Kling)

**Optimal params:**
- Model: `ltx-2-fast` for previews, `ltx-2-pro` for usable output
- Resolution: `1920x1080` (higher resolutions don't add real quality)
- Duration: `6` for fast iteration
- fps: `25` (50 is interpolated)

---

### Higgsfield Video

**Weavy ID:** `higgsfield_i2v`
**Category:** Video Gen (camera motion on stills)
**Builder:** `make_higgsfield_video_node()`
**Claims:** "Generate video from an image and a prompt"
**Reality:** NOT a general-purpose video model -- specifically applies controlled camera motion to still images. This is fundamentally a 2.5D parallax system. The 120+ motion presets are the product and they generally work well for simple camera moves. Subject stays FROZEN -- only the camera moves. VHS/Super 8MM presets are stylistic filters as much as motion presets.
**Best for:**
- Adding cinematic camera motion to still images (its core purpose)
- Product photography animation
- Social media content with dynamic camera movement
- Predictable, repeatable motion (preset-based)

**Avoid for:**
- Subject motion (it can't do it -- camera only)
- Complex parallax scenes
- Long-duration video
- Subject-environment interaction

**Use instead:** "For subject motion, use Kling 3 Pro or Wan 2.7. Higgsfield only does camera motion on stills. It complements Kling, doesn't replace it."

**Gotchas:**
- `image` is REQUIRED -- no text-to-video mode
- `model`: `dop-lite` (highest quality), `dop-turbo` (usable for social/web), `dop-preview` (fast/low quality testing)
- `motion` has 120+ presets -- Notable: `Paparazzi`, `Handheld`, `Super 8MM`, `VHS`, `Dolly Zoom In`, `Bullet Time`, `FPV Drone`, `Snorricam`, `Cinematic`, `Static`, `Catwalk`
- Subject is FROZEN. Do not expect any subject motion.
- VHS/Super 8MM are stylistic filters + camera motion, not pure camera moves

**Optimal params:**
- Model: `dop-lite` for final output, `dop-preview` for testing motion presets
- Motion: Choose based on brief. `Cinematic` for safe default, `Handheld` for documentary feel, `Static` for subtle
- enhance_prompt: `false` for camera-motion-only (prompt is less important here)

---

## Avatar / Lip Sync Models

---

### Omnihuman V1.5

**Weavy ID:** `fal-ai/bytedance/omnihuman/v1.5`
**Category:** Avatar / Lip Sync
**Builder:** `make_omnihuman_node()`
**Claims:** "Produces vivid, high-quality videos where the character's emotions and movements"
**Reality:** Film-grade digital human generation from ByteDance. Full-body animation (not just face) -- generates natural gestures, head movements, body sway, and facial expressions matched to audio's emotional tone. V1.5 added cognitive simulation: excitement triggers animated body language, sadness triggers appropriate expressions, technical speech produces focused gestures. Lip sync accuracy is excellent. Output resolution 1024x1024, up to 30 seconds.
**Best for:**
- Photorealistic talking head videos with emotional performance
- Full-body character animation from a single photo
- Film-quality digital humans
- When emotional authenticity matters (it reads audio intent)

**Avoid for:**
- Non-human subjects (humans only)
- When text prompt control over the scene is needed (no prompt input)
- When resolution above 1024x1024 is needed
- Multiple people in frame

**Use instead:** "For animals, cartoons, or stylized characters, use Kling Avatar Pro. For scene control via text prompt, also use Kling Avatar Pro."

**Gotchas:**
- NO text prompt input -- purely audio-driven. You cannot direct the scene.
- No parameters at all -- zero configurability beyond input image + audio
- Audio must be under 30 seconds
- Output is 1024x1024 -- may need upscaling for production
- Best with front-facing, clear, well-lit portrait photos
- Profile views, multiple people, and occluded faces produce artifacts

**Optimal params:**
- N/A -- no parameters. Quality depends entirely on input image + audio quality.
- Use highest quality portrait photo possible (front-facing, well-lit, clean background)
- Audio should be clear, well-recorded, fluent speech

---

### Kling AI Avatar Pro

**Weavy ID:** `fal-ai/kling-video/v1/pro/ai-avatar`
**Category:** Avatar / Lip Sync
**Builder:** `make_kling_avatar_node()`
**Claims:** "Premium endpoint for creating avatar videos with realistic humans, animals, cartoons, or stylized characters"
**Reality:** Built on Kling's proven video technology. Supports not just realistic humans but also animals, cartoons, and stylized characters (genuinely works). Has optional text prompt for scene direction (moderate influence -- not transformative). 1080p/48fps output via Higgsfield platform integration. Strong lip-sync precision with good multilingual support when audio is fluent. $0.115/second (Pro) vs $0.0562/second (Standard).
**Best for:**
- Non-human avatars (animals, cartoons, stylized characters -- unique capability)
- When text prompt control over the scene is wanted
- Multilingual talking heads
- When higher resolution (1080p) is needed vs Omnihuman's 1024x1024
- Short-form social/marketing content

**Avoid for:**
- Maximum emotional realism (Omnihuman's cognitive simulation is more nuanced)
- When budget per-second matters (Omnihuman has no per-second pricing)
- Full-body animation needs (Kling is more face/upper-body focused)

**Use instead:** "For best emotional performance on human subjects, use Omnihuman V1.5. For non-human subjects or scene control, Kling Avatar Pro is the only option."

**Gotchas:**
- `prompt` is optional but influence is moderate, not dramatic
- Poor TTS or heavily accented audio reduces lip-sync quality noticeably
- Pro is 2x cost of Standard ($0.115 vs $0.056 per second)
- No parameters beyond the three inputs (image, audio, prompt)
- "Animals and cartoons" support is real but quality varies by subject

**Optimal params:**
- Use Pro for client-facing work, Standard for testing/iteration
- Prompt: keep short and directional ("speaking confidently to camera", "gentle smile")
- Audio: use high-quality, fluent speech for best lip sync
- Image: clear subject, good lighting, front-facing or slight angle

---

## Post-Processing Models

---

### Topaz Image Upscale

**Weavy ID:** `fal-ai/topaz/upscale/image`
**Category:** Post-Processing (Image Upscale)
**Builder:** `make_topaz_upscale_node()`
**Claims:** Topaz Labs professional image upscaling.
**Reality:** Gold standard for faithful restoration-style upscaling. Asks "what did this originally look like?" and recovers lost detail without altering identity or composition. Face Recovery model is excellent -- uses specialized model trained on human facial features, preserves identity. For AI-generated images specifically, Standard V2 or CGI models work best. Grain toggle can eliminate plastic smoothness.
**Best for:**
- Faithful upscaling that preserves the original look exactly
- Face enhancement/recovery on AI-generated portraits
- Production-ready final output (print, high-res deliverables)
- When identity preservation is critical

**Avoid for:**
- Creative reinterpretation / adding detail that wasn't there (use Magnific)
- When you want the upscaler to "improve" the image beyond enlarging it

**Gotchas:**
- `model` choices matter significantly for AI images:
  - `Standard V2` -- best general default for AI images
  - `CGI` -- excellent for AI art, 3D-style, illustration
  - `High Fidelity V2` -- maximum detail preservation
  - `Text Refine` -- specifically for images with text
  - `Recovery` / `Recovery V2` -- for very low quality sources
  - `Low Resolution V2` -- for very small source images
  - `Redefine` -- more creative enhancement (closer to Magnific territory)
- `face_enhancement` at default (true, strength 0.8) is good for AI faces
- `face_enhancement_creativity` at 0 preserves identity. Increase only if you want reinterpretation.
- `subject_detection` at `All` is usually right. Use `Foreground` to only enhance the subject.

**Optimal params for AI-generated images:**
- Model: `Standard V2` (default and best for most AI images)
- Upscale factor: `2` (default, safe). `4` only for print-size needs.
- face_enhancement: `true`
- face_enhancement_strength: `0.8`
- face_enhancement_creativity: `0` (preserve identity)
- subject_detection: `All`

---

### Topaz Sharpen

**Weavy ID:** `topaz-sharpen`
**Category:** Post-Processing (Image Sharpen)
**Builder:** `make_topaz_sharpen_node()`
**Claims:** Professional image sharpening and deblurring.
**Reality:** Useful for AI images despite them not being "blurry" in the traditional sense. AI images often have a soft, plastic quality that sharpening can fix. Portrait Sharpen model (within Standard) is specifically trained for natural skin, hair, and fabric detail. Adds texture without over-sharpening. The Natural model is best for AI images -- adds authentic texture detail. Run denoise first if applicable, then sharpen.
**Best for:**
- Fixing AI plastic skin softness (the primary use case for AI workflows)
- Adding authentic texture detail to AI-generated portraits
- Preparing AI images for print (removes AI smoothness)
- Enhancing fabric and material detail

**Avoid for:**
- Already-sharp AI images (risks over-sharpening and artifacts)
- Stylized / illustration work (designed for photorealism)
- Video (use Topaz Video Upscaler instead)

**Gotchas:**
- `model` choices for AI images:
  - `Natural` -- best for AI images, adds texture without harshness
  - `Standard` -- good general option, try before Strong
  - `Strong` -- aggressive, can over-sharpen AI images. Use with caution.
  - `Lens Blur` / `Motion Blur` -- designed for real photo blur types, less relevant for AI images
  - `Refocus` -- can help with AI "soft focus" look
- Same face enhancement controls as Topaz Upscale
- Use Standard before Strong to avoid unwanted artifacts

**Optimal params for AI-generated images:**
- Model: `Natural` (best for AI softness)
- face_enhancement: `true`
- face_enhancement_strength: `0.8`
- face_enhancement_creativity: `0`
- subject_detection: `All`
- output_format: `png` for quality, `jpeg` for size

---

### Topaz Video Upscaler

**Weavy ID:** `topaz-upscale-video`
**Category:** Post-Processing (Video Upscale)
**Builder:** `make_topaz_video_upscale_node()`
**Claims:** Video upscaling to 4K.
**Reality:** Astra model (2026) is specifically designed for AI-generated video artifacts -- fixes distortions from Kling, Sora, Wan, etc. Can upscale to 4K at 60fps. Improves realism by reducing plastic/artificial look, enhancing skin texture, fabric structure, and text clarity in AI video. Genuinely useful for production-ready AI video output.
**Best for:**
- Upscaling Kling / Wan / LTX output to 4K for production
- Fixing AI video artifacts (plastic skin, fabric smoothness, text blur)
- Final production pipeline step before delivery

**Avoid for:**
- Quick iteration (premium cost at 10 credits, slow processing)
- Draft / preview workflows (cost not justified)
- Video that will be further processed (upscale should be last step)

**Gotchas:**
- `paid: 10` -- this is a premium node, costs 10 credits per run
- Only parameter is `upscale_factor` (1-4, default 2). Max output 3840x2160.
- No model selection -- Astra is applied automatically for AI content
- Should be the LAST step in any pipeline (after all other processing)

**Optimal params:**
- upscale_factor: `2` for standard production (1080p → 4K)
- Only upscale once at the end of the pipeline

---

### Magnific Skin Enhancer

**Weavy ID:** `fp_skin_enhancer`
**Category:** Post-Processing (Portrait Enhancement)
**Builder:** `make_magnific_skin_node()`
**Claims:** AI skin enhancement and retouching.
**Reality:** Generative enhancement -- reimagines and adds detail rather than just restoring. `transform_to_real` is the killer feature for AI workflows: adds realistic skin texture that AI images lack, pushing portraits past the uncanny valley. `no_make_up` strips the AI-polished look. `smart_grain` adds photographic texture back. Creative mode reimagines aggressively, faithful preserves closely, flexible mode is guided by optimization presets.
**Best for:**
- Pushing AI portraits past uncanny valley (`transform_to_real`)
- Adding photographic texture to AI-smooth skin (`smart_grain`)
- Stripping the "too perfect" AI look (`no_make_up`)
- Natural skin enhancement on any AI-generated portrait
- Realism pipeline: chain after image generation, before final upscale

**Avoid for:**
- When exact face preservation is critical (generative enhancement can subtly change features)
- Budget workflows (Magnific subscription required, $39/mo minimum)
- Non-portrait images (designed specifically for skin/face enhancement)

**Gotchas:**
- `method` determines behavior:
  - `creative` -- most aggressive reimagination. Can change subtle facial features.
  - `faithful` -- closest to original. Uses `skin_detail` slider (0-100, default 80).
  - `flexible` -- guided by `optimized_for` preset. Most versatile.
- `optimized_for` (flexible mode only):
  - `transform_to_real` -- THE key feature for AI portraits. Adds realistic skin texture.
  - `no_make_up` -- strips AI-polished look. Useful for natural/editorial aesthetic.
  - `enhance_skin` -- general skin improvement (default)
  - `improve_lighting` -- adjusts lighting quality
  - `enhance_everything` -- full-face enhancement
- `smart_grain` adds photographic grain texture. Low values (2-20) for subtle realism.
- `sharpen` at 50 (default) is good. Increase for more texture, decrease for smoother.

**Optimal params for AI portraits:**
- Method: `flexible`
- optimized_for: `transform_to_real` (primary AI use case)
- sharpen: `30-50`
- smart_grain: `10-20` (subtle photographic texture)

**Realism pipeline recipe:**
Image Model → Magnific Skin Enhancer (flexible, transform_to_real) → Topaz Upscale (Standard V2)

---

### Magnific Upscale

**Weavy ID:** `fp_magnific_upscale`
**Category:** Post-Processing (Creative Upscale)
**Builder:** `make_magnific_upscale_node()`
**Claims:** AI-powered creative upscaling.
**Reality:** Generative upscaler -- invents detail that wasn't in the original. Closer to a text-to-image generator than a traditional upscaler. Asks "what could this look like?" rather than "what was here?" Prompt-guided upscaling (reusing the generation prompt improves results significantly). Sharpy engine for photorealism, Illusio for illustration. Two-pass workflow (Illusio 2x → Sharpy 2x) is the optimal approach per Magnific's own recommendation. Up to 8x upscale. Results can be stunning but unpredictable -- can change ethnicity, bone structure, or add hallucinated details at high creativity.
**Best for:**
- Creative upscaling where added detail is desired
- Maximum resolution output (up to 8x)
- Prompt-guided enhancement (reuse generation prompt for coherent detail addition)
- AI art where extra detail enriches the result
- Fashion / commercial imagery where "more is more"

**Avoid for:**
- Identity-critical portraits (can change subtle features, especially at high creativity)
- Faithful reproduction where added detail is unwanted (use Topaz)
- Budget-sensitive work (subscription required, credit-based)
- When predictability matters more than peak quality

**Gotchas:**
- `engine` choices:
  - `automatic` -- default, good starting point
  - `magnific_sharpy` -- maximum sharpness, best for photorealism
  - `magnific_illusio` -- best for illustrations, smoother/stylized output
  - `magnific_sparkle` -- balanced blend of Sharpy and Illusio
- `optimized_for` presets: `films_n_photography` for realism workflows, `soft_portraits` for beauty, `hard_portraits` for editorial
- `creativity` (-10 to 10): KEEP LOW for AI images. -5 to 0 preserves the original. High creativity = hallucinated details.
- `resemblance` (-10 to 10): Higher = closer to original. 5+ recommended for AI images.
- `hdr` (-10 to 10): 0 default is usually right. Increase for more dynamic range.
- `fractality` (-10 to 10): Controls detail recursion. Keep at 0 for most work.
- `prompt` is optional but significantly improves results -- reuse the generation prompt
- Two-pass workflow: Illusio 2x first pass → Sharpy 2x second pass = optimal results

**Optimal params for AI realism:**
- Engine: `magnific_sharpy` (or two-pass: Illusio → Sharpy)
- optimized_for: `films_n_photography`
- scale_factor: `2x` (or 2x + 2x in two passes)
- creativity: `-5` to `0` (preserve original, don't hallucinate)
- resemblance: `5` to `8` (stay close to source)
- hdr: `0`
- fractality: `0`
- prompt: Reuse the original generation prompt

---

### Topaz vs Magnific: When to Use Each

| Scenario | Use | Why |
|---|---|---|
| Faithful upscale (preserve exactly what's there) | Topaz | Restoration-focused, identity-preserving |
| Creative upscale (add detail that wasn't there) | Magnific | Generative, invents new detail |
| Face/identity preservation is critical | Topaz (Face Recovery) | Specialized facial model, won't change features |
| Push AI past uncanny valley | Magnific (Skin Enhancer, transform_to_real) | Adds realistic texture AI images lack |
| Budget-constrained | Topaz | One-time license vs Magnific's $39/mo subscription |
| Maximum resolution (8x) | Magnific | Topaz maxes at 4x |
| Realism pipeline | Both | Magnific Skin Enhancer → Topaz Upscale (chain them) |
| Video upscaling | Topaz Video (Astra) | Magnific is image-only |
| AI art / illustration | Magnific (Illusio engine) | Designed for stylized content |
| Print production | Topaz | More predictable, faithful to source |

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

### Image Model then Magnific Skin Enhancer then Topaz Upscale (Realism Pipeline)
The production realism chain. Any image model generates the base image → Magnific Skin Enhancer (flexible mode, transform_to_real, smart_grain 10-20) adds authentic skin texture and photographic grain → Topaz Upscale (Standard V2, 2x) does faithful resolution increase. This three-step pipeline pushes AI portraits past the uncanny valley. Cost-effective because Magnific and Topaz run on the enhanced image, not the model generation.

### LTX 2 (Preview) then Kling 3 Pro (Final)
Use LTX 2 in fast mode for rapid video concept iteration, then switch to Kling 3 Pro for the final hero render. LTX is significantly faster and cheaper -- use it to validate motion, timing, and composition before committing to expensive Kling runs.

### Higgsfield Image then Higgsfield Video
Fashion/editorial pipeline. Generate a style-preset-driven still with Higgsfield Image, then animate it with camera motion using Higgsfield Video's motion presets. Both share the same aesthetic DNA. Route the image output directly to the video model's required `image` input.

### Omnihuman V1.5 then Topaz Video Upscaler
Avatar pipeline for production. Omnihuman outputs 1024x1024 which may need upscaling. Topaz Video Upscaler (Astra) handles AI-generated video artifacts and can push to 4K. Chain: audio + image → Omnihuman → Topaz Video Upscale (2x).

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
