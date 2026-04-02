# Photorealistic Prompt Engineering Guide

This guide is loaded by the REALISM-ADVISOR sub-agent. It provides actionable techniques for writing prompts that produce photorealistic output from AI image generation models in Weavy workflows.

---

## 1. The Reframe Strategy

This is the single most important technique for photorealistic results: **assert that the image IS already a photograph.** Never ask the model to "generate" or "create" an image. Treat the output as a pre-existing photo you are describing.

**Why it works:** Image generation models respond to framing cues. When the prompt reads like a caption or description of an existing photograph, the model activates its photographic training data rather than its illustration or digital art training data. The word "photograph" alone shifts the entire rendering pipeline toward realism.

**BAD prompts:**
- "Generate an image of a woman in a red dress"
- "Create a realistic photo of a man standing in a kitchen"
- "Make a portrait of a young woman with brown hair"

**GOOD prompts:**
- "This is a photograph of a woman in a red dress, shot on Canon EOS R5 with an 85mm f/1.4 lens"
- "A candid photograph of a man standing in a sunlit kitchen, captured on Sony A7R V at 35mm f/1.4"
- "Editorial portrait of a young woman with brown hair, photographed with Hasselblad X2D, 80mm f/2.8, natural window light from camera left"

The framing verbs to use: "photographed," "captured," "shot on," "taken with." The framing nouns: "photograph," "portrait," "editorial image," "product shot." These signal that the output should look like it came out of a real camera.

---

## 2. Prompt Structure Template

Use this mental framework when building photorealistic prompts. The sections do not need labels in the actual prompt text -- they should flow as natural descriptive prose. But every strong prompt covers all seven areas.

```
FRAME:       Assert this is a photograph. Name the format: editorial portrait,
             product shot, environmental portrait, candid street photo, etc.

SUBJECT:     Detailed description of the main subject. Physical characteristics,
             expression, pose, wardrobe, accessories. Be specific and grounded.

ENVIRONMENT: Setting, background, depth. Foreground elements that add dimension.
             Background blur/bokeh characteristics. Contextual objects.

LIGHTING:    Key light position, fill ratio, color temperature, ambient light,
             practical lights in frame. Use technical lighting terms.

CAMERA:      Camera body, lens, focal length, aperture, ISO, shutter speed.
             Shooting distance and angle.

MATERIALS:   Textures to emphasize: skin pores, fabric weave, metal reflections,
             glass transparency, wood grain. Specific tactile descriptors.

QUALITY:     Resolution cues, sharpness, color depth. "High-resolution,"
             "fine detail," "professional color grading," "shot for publication."
```

**How to use this:** Before writing a prompt, mentally walk through each section and decide what belongs. Then write the prompt as a single flowing paragraph (or two) that naturally incorporates information from each section. The result reads like a photographer's shot description or a photo editor's caption.

---

## 3. Optical Imperfection Layer

Real photographs contain optical artifacts from light passing through glass elements in a lens assembly. Their absence is the single strongest signal the human brain reads as "not a photograph." AI models trained on captioned photographs respond to these descriptors because they co-occur with photographic training data.

Adding 2-3 of these per prompt produces a significant shift toward photorealism. Do NOT use all simultaneously -- that produces an over-processed look. Choose the ones that match your scene.

### Chromatic Aberration
The failure of a lens to focus all colors to the same point, most visible at high-contrast edges near the frame periphery.
**Prompt language:** "subtle color fringing on high-contrast edges toward the frame periphery" or "faint magenta-green chromatic aberration visible where the dark jacket meets the bright sky"

### Film Grain / Sensor Noise
The texture introduced by film emulsion or digital sensor amplification. Varies by ISO -- lower ISO = finer grain, higher ISO = coarser, more visible noise.
**Prompt language:** "fine luminance grain consistent with ISO 400 on a full-frame sensor" or "subtle color noise in the deepest shadow areas, characteristic of high-ISO digital capture"

### Lens Vignetting
The natural darkening of image corners caused by light falloff through the lens barrel. More pronounced at wider apertures and with wider lenses.
**Prompt language:** "natural lens vignetting with slightly darkened corners, approximately half a stop of falloff" or "subtle corner darkening from the wide-aperture optics"

### Micro Motion Blur
Barely perceptible blur on moving elements that signals a real exposure time rather than an infinitely fast synthetic shutter.
**Prompt language:** "barely perceptible motion blur on the fingertips suggesting a 1/125s shutter speed" or "the slightest directional blur on wind-swept hair indicating a real exposure"

### Depth-of-Field Falloff Specificity
Rather than vague "shallow depth of field," describe exactly WHERE focus falls off and how. Real lenses have a specific focal plane.
**Prompt language:** "pin-sharp focus on the near eye, ears slightly soft, background detail dissolving into smooth bokeh at f/1.8 -- the transition from sharp to soft follows a gradual plane tilted slightly toward camera left"

### Lens Flare / Halation
Light scattering when a bright source hits the lens elements, or the glow around overexposed highlights in film.
**Prompt language:** "faint warm halation around the backlit highlights where sunlight wraps the subject's shoulder" or "a subtle hexagonal flare artifact from shooting into the golden-hour sun"

### Scene Matching Guide

| Scene type | Best imperfections to include |
|-----------|------------------------------|
| Outdoor action / sports | Micro motion blur + lens flare + chromatic aberration |
| Studio portrait | DOF falloff specificity + film grain + subtle vignetting |
| Golden hour / backlit | Lens flare/halation + chromatic aberration + grain |
| Product close-up | DOF falloff specificity + vignetting + grain |
| Street / documentary | Grain + vignetting + chromatic aberration |

---

## 4. Film Stock Anchoring

Film stock and sensor color science references are not decorative -- they shift the model's entire color pipeline. A single film stock name activates a specific color profile the model learned from millions of images tagged with that stock. This one addition produces more consistent realism than multiple color adjectives combined.

**Rule:** Every photorealistic prompt should include exactly one film stock or sensor color science reference.

### Reference Table

| Stock | Character | Best for |
|-------|-----------|----------|
| Kodak Portra 400 | Warm skin tones, soft highlight rolloff, subtle warm color shift, forgiving exposure latitude | Editorial portraits, lifestyle, fashion, warm golden-hour work |
| Cinestill 800T | Cool tungsten cast, red halation around bright highlights, cinematic grain structure, moody | Night scenes, urban, neon-lit environments, moody editorial |
| Kodak Vision3 500T | Cinema-grade color separation, rich midtones, controlled highlight rolloff, neutral-warm | Motion picture stills, high-end commercial, cinematic campaigns |
| Fujifilm Pro 400H | Cool, pastel, slightly desaturated, lifted shadows, ethereal quality | Airy editorial, wedding, soft lifestyle, delicate product |
| Kodak Ektar 100 | Extremely saturated, ultra-fine grain, punchy contrast, vivid color | Landscape, product photography, bold commercial with vivid color |

### Processing Modifiers

These further refine the look by describing how the film was developed:
- **"pushed one stop"** -- increases contrast and grain, deepens shadows, adds intensity
- **"pull processed"** -- reduces contrast, softens tones, produces a pastel quality
- **"bleach bypass"** -- desaturated, metallic highlights, crushed blacks, gritty cinematic look
- **"cross-processed"** -- shifted color channels, unpredictable palette, editorial/experimental

### Digital Sensor References

For a purely digital look, reference sensor color science instead of film stock:
- **"Canon color science"** -- warm, saturated skin tones
- **"Sony color science"** -- neutral, accurate, slightly cooler
- **"Hasselblad natural color"** -- medium-format color depth, wide tonal range
- **"Phase One IQ4 color"** -- reference-grade color accuracy, ultra-wide dynamic range

---

## 5. The Subtraction Principle

Photorealism is achieved by removing degrees of freedom from the model, not by stacking adjectives. Every specific, constraining clause in a prompt takes away a dimension the model would otherwise fill with its default synthetic-looking behavior.

**The test:** For every clause in a prompt, ask: "Does this narrow what the model can produce?" If the answer is no, cut it.

- "Beautiful" -- does not constrain. A thousand images could be called beautiful. CUT.
- "Rembrandt lighting with key at 2 o'clock, 45 degrees above, 3:1 fill ratio" -- constrains heavily. One lighting setup. KEEP.
- "Powerful athlete" -- vaguely constraining. REPLACE with: "male athlete in his late 20s, 6'1, lean-muscular build at approximately 8% body fat, visible deltoid and quadricep definition"

### Before and After

**Before (vague, 78 words):**
> A powerful athlete runs through a vast desert at golden hour. They wear Oakley sunglasses. The scene should look photorealistic and cinematic. The lighting is beautiful golden hour light. The athlete should look strong and determined. Use a dynamic camera angle. The image should be high quality and sharp.

**After (constrained, 82 words):**
> This is a photograph of a male athlete in his late 20s sprinting across cracked desert hardpan, captured on Canon EOS R5 with 70-200mm f/2.8 at 135mm, f/2.8. Low three-quarter front angle, camera two feet above ground. Golden hour backlight at 2700K from camera right, rim-lighting his shoulders and the Oakley wraparound lens edge. Fine luminance grain consistent with ISO 800. Skin glistening with perspiration, visible pore texture across the forehead, dust particles adhering to the sheen on his forearms. Shot on Kodak Vision3 500T.

Same word count. The second version constrains every visual dimension -- the model has far fewer "choices" to fill with synthetic defaults.

---

## 6. Camera & Lens Specifications

Naming specific camera bodies and lenses is one of the strongest realism signals. Each combination has a recognizable visual signature that the model has learned from millions of captioned photographs.

### Portrait Photography
**Canon EOS R5 + 85mm f/1.4L**
Visual signature: Extremely shallow depth of field at wide apertures. Creamy, circular bokeh in the background. Razor-sharp focus on the eyes with rapid falloff. Warm, slightly saturated color science. Skin tones lean warm and natural.
Prompt language: "shot on Canon EOS R5 with 85mm f/1.4 lens at f/1.8, ISO 200"

### Fashion Editorial
**Hasselblad X2D + 80mm f/2.8**
Visual signature: Medium format sensor produces a distinctive depth rendering that full-frame cannot replicate -- a three-dimensional quality where the subject seems to float in space. Extremely high resolution with fine color gradation. Slightly cooler, more neutral color science. The depth of field transition is smoother and more gradual.
Prompt language: "photographed on Hasselblad X2D, 80mm f/2.8, medium format"

### Product Photography
**Canon EOS R5 + 100mm f/2.8L Macro**
Visual signature: Exceptional detail and sharpness across the frame. Close focusing distance renders products at near life-size magnification. Controlled, precise background separation. Clean rendering of surface textures and material finishes.
Prompt language: "captured with Canon EOS R5, 100mm f/2.8 Macro lens, studio lighting"

### Environmental Portrait
**Sony A7IV + 35mm f/1.4**
Visual signature: Wider field of view includes the subject's surroundings as context. At f/1.4 the background is still soft but recognizable -- you can tell where the person is. Natural perspective with minimal distortion. Good balance between subject and environment.
Prompt language: "shot on Sony A7IV with 35mm f/1.4 GM lens, f/2.0"

### Dramatic Portrait
**50mm f/1.2 (Canon RF or Sony GM)**
Visual signature: Ultra-shallow depth of field that creates almost painterly subject separation. The extremely thin focus plane means ears may be soft while eyes are sharp. Distinctive rendering of specular highlights. Strong three-dimensionality.
Prompt language: "Canon RF 50mm f/1.2L, wide open at f/1.2, close shooting distance"

### Street / Documentary
**Leica M11 + 35mm f/2 Summicron**
Visual signature: Classic rendering with high contrast and slight vignetting. Sharp center with gentle falloff. "Leica glow" -- a subtle halation around highlight transitions that gives images a distinctive character.
Prompt language: "Leica M11, 35mm Summicron, natural light, f/4"

---

## 7. Lighting Setups

Lighting is the difference between a flat AI image and a convincing photograph. Always specify lighting. The model responds well to named lighting patterns.

### Rembrandt Lighting
**Visual effect:** Key light positioned at 45 degrees to one side and slightly above, creating a small triangle of light on the shadow side of the face beneath the eye. Dramatic, painterly, dimensional. One side of the face is well-lit, the other falls into shadow with just that identifying triangle.
**Prompt language:** "Rembrandt lighting with key light at 45 degrees camera right, creating a triangle of light beneath the left eye, warm 3200K tungsten, deep shadows on the opposite side"

### Butterfly / Paramount Lighting
**Visual effect:** Light positioned directly above and slightly in front of the subject, casting a symmetrical butterfly-shaped shadow beneath the nose. Glamorous, high-fashion, flattering. Emphasizes cheekbones and creates even, symmetrical illumination.
**Prompt language:** "Paramount lighting from directly above, creating a butterfly shadow beneath the nose, beauty dish modifier, soft and even with defined cheekbones"

### Split Lighting
**Visual effect:** Light from one side only, dividing the face exactly in half -- one side fully illuminated, the other in deep shadow. Highly dramatic, moody, often used for character portraits and editorial work.
**Prompt language:** "hard split lighting from camera left, half the face in bright illumination, the other half in deep shadow, single bare bulb source"

### Broad Lighting
**Visual effect:** The side of the face closest to the camera receives the key light. This visually widens the face and produces a more open, approachable look. Flattering for most face shapes. Less dramatic than short/Rembrandt lighting.
**Prompt language:** "broad lighting with key light illuminating the side of the face turned toward camera, soft fill on the shadow side, 2:1 lighting ratio"

### Loop Lighting
**Visual effect:** Key light slightly above and to one side, creating a small, looping shadow from the nose that does not connect with the cheek shadow. The most commonly used portrait lighting pattern. Natural, versatile, universally flattering.
**Prompt language:** "loop lighting with key light 30 degrees camera right and slightly above eye level, creating a small nose shadow angled toward the corner of the mouth, soft modifier"

### Rim / Edge Lighting
**Visual effect:** Strong backlight (or two backlights) creating a bright edge or halo around the subject's outline, separating them from the background. Often combined with a lower-powered front key. Creates depth and drama.
**Prompt language:** "strong rim light from behind creating a bright edge along the shoulders and hair, low-key front fill, subject separated from dark background by the bright edge lighting"

### Natural Window Light
**Visual effect:** Soft, directional light from a large window source. Gentle gradient from highlight to shadow. Intimate, editorial quality. The light wraps around the subject naturally. Often produces a slight color shift -- warmer on the lit side, cooler in the shadows.
**Prompt language:** "soft natural window light from camera left, large window acting as a natural softbox, gentle highlight-to-shadow gradient across the face, warm daylight with cool shadow fill"

### Golden Hour / Magic Hour
**Visual effect:** Warm, low-angle sunlight with long shadows and golden color temperature. Atmospheric haze and lens flare possible. Extremely warm highlights with cool blue shadows.
**Prompt language:** "golden hour sunlight at low angle from behind the subject, warm 2700K backlight with cool blue shadow fill, long soft shadows, atmospheric warmth"

---

## 8. Material Descriptions

Realistic materials require specific, tactile language. Generic descriptions produce generic renders. The following vocabulary signals real-world material properties to the model.

### Skin

Skin is where the AI look is most visible. Generic descriptions like "realistic skin" or "natural skin texture" trigger the model's averaged, smoothed-out default. Fight this with zone-specific detail, color variation, and named imperfections.

**Pore detail by zone** -- Real pores vary across the face. Describe them where they are:
- Forehead: "larger sebaceous pores visible especially at the hairline, slightly oily texture"
- Nose bridge and sides: "tight, fine pores with slight blackhead texture on the sides of the nose"
- Cheeks: "medium pores with irregular spacing, natural skin grain visible in raking light"
- Chin: "slightly coarser texture, minor roughness"
- Body (arms, legs): "finer, less visible pores, goosebump texture in cooler conditions, visible hair follicles"

**Subsurface scattering** -- This is the #1 realism cue AI models skip. Real skin transmits light through thinner areas:
"Warm light transmitting through the thinner skin at the ear tips, slight pinkish translucency where backlight passes through the helix of the ear, nostrils showing warm internal glow when backlit, fingers appearing slightly translucent at the edges when held up to strong light."

**Micro-sheen and oil** -- NOT uniform shininess:
"Natural sebaceous sheen concentrated on the T-zone -- forehead, nose bridge, and chin -- with matte texture on the cheeks. In exertion: perspiration beading at the hairline and upper lip, rivulets forming along the temple, sweat-dampened hair clinging to the neck."

**Color variation** -- Real skin is never one uniform color:
"Slight redness at the nose tip and inner cheeks, cooler blue-gray undertones at the temples, warmth at the forehead where blood flow is closer to the surface, pinker tone at the knuckles and fingertips, slight yellowing at callused areas."

**Imperfections to include** -- Pick 2-3 per subject:
Moles, a faint tan line, visible veins at the temple or inner wrist, subtle razor bump texture on the jawline, fine vellus hair catching backlight along the jawline and cheekbone, a barely visible scar, slight asymmetry between the two sides of the face, minor sun damage or freckling across the nose bridge.

**What triggers the plastic look** -- NEVER use these in a photorealistic prompt:
"smooth skin," "clear complexion," "perfect skin," "beautiful face," "flawless features," "porcelain skin" (unless describing actual porcelain). Any language that implies skin uniformity pushes the model toward its airbrushed default.

**The anti-plastic rule:** If a skin description could apply to a mannequin or a cosmetics ad render, replace it with one that could only describe a living person in a real physical environment.

### Fabric
- **Cotton/linen:** "Visible thread texture and weave pattern, natural fabric drape with gravity, subtle wrinkles forming at bend points and joints, soft matte surface."
- **Silk/satin:** "High-sheen surface catching light in flowing highlights, liquid drape following body contours, subtle color shifts between highlight and shadow areas."
- **Wool/knit:** "Visible fiber texture, slight fuzz and pilling, dimensional knit pattern, matte light absorption."
- **Denim:** "Visible twill weave, natural fading at stress points, slight white thread showing through at creases, worn indigo color variation."

### Metal
- **Polished:** "Mirror-like specular highlights, environmental reflections on the surface, sharp bright spots where light sources reflect."
- **Brushed:** "Directional linear grain visible in surface, elongated specular highlights following the brushing direction, subtle machining marks."
- **Aged/patina:** "Verdigris, oxidation patterns, tarnish in recessed areas with polish on high-contact surfaces, warm dull sheen."

### Glass
"Refraction of objects visible through the glass, partial transparency with surface reflections competing with see-through clarity, caustic light patterns cast onto nearby surfaces, slight color tint, fingerprint smudges and micro-scratches visible in raking light."

### Hair
"Individual strand detail visible especially at edges and flyaways, highlight-to-shadow gradation through the volume of hair, flyaway strands catching backlight, scalp visibility at the part line, subtle color variation between inner and outer layers."

### Leather
"Visible grain texture varying from tight to loose across the surface, subtle waxy sheen, wear marks and patina at contact points, visible stitching with thread indentation, natural creasing at flex points, edge burnishing."

### Wood
"Visible grain running in natural patterns, knots with surrounding grain distortion, warm undertones in mid-tones, surface sheen variation between end-grain and long-grain areas, slight color deepening in recesses."

### Eyewear (Polycarbonate / Acetate / Metal)
"Polycarbonate lens with anti-reflective coating showing faint green-purple reflections at oblique angles, gradient tint darker at the top edge fading to clear at the bottom, micro-scratches visible only in raking light. Injection-molded O-Matter frame with subtle mold parting lines along the temple arms, matte rubberized Unobtainium grip texture on the nosepads and earstems, snap-fit stainless steel hinge pin with visible machining marks. Wraparound 8-base lens curvature following the contour of the face, thin visible gap between lens edge and frame channel. For acetate frames: visible layered color depth in the material, hand-polished edges with slight rounding, metal core wire visible at the temple tips."

### Synthetic Performance Fabrics
"Moisture-wicking polyester blend with visible flat-knit compression weave catching light in a fine grid pattern, micro-mesh ventilation panels with honeycomb structure at the sides, bonded heat-sealed seams replacing traditional stitching for a flat smooth profile. Subtle sheen on stretched fabric over muscle groups where the weave is pulled taut, matte finish in relaxed areas where fabric drapes naturally. High-elastane compression sections clinging to the quadriceps and calves with slight dimpling where the knit anchors. Reflective brand logos and accent strips catching light at specific angles, matte screen-printed graphics with slight texture raised above the base fabric."

---

## 9. Anti-Artifact Techniques

AI-generated images have telltale signs. These techniques reduce or eliminate them.

### Words to Avoid
- **"Perfect," "flawless," "beautiful," "ideal"** -- These trigger the model's concept of synthetic perfection, producing waxy skin, unnaturally symmetrical features, and a "too clean" look. Real photographs capture real imperfections.
- **"Hyper-realistic," "ultra-realistic"** -- Paradoxically, these terms often produce stylized or over-processed results. The model overcompensates. Instead, just describe a photograph with technical detail.
- **Numbered lists of features** -- "1. Blue eyes, 2. Red hair, 3. Freckles" triggers unnatural, checklist-like rendering. Weave features into natural description instead.
- **"8K," "masterpiece," "best quality"** -- Stable Diffusion-era quality tokens that VLM-based models (Flux, NB Pro) either ignore or misinterpret, potentially triggering aesthetic modes that compete with photorealism.
- **"highly detailed" (standalone)** -- Too generic to constrain anything. Replace with specific detail targets: "visible pores on the nose bridge," "individual eyelash separation," "thread-level weave texture on the collar."
- **"smooth skin," "clear complexion," "flawless complexion," "porcelain skin"** -- These directly trigger the plastic AI skin look. Always replace with zone-specific texture descriptions from the Skin material guide above.

### Structural Problems to Avoid
- **Conflicting descriptions without specificity** -- "bright and moody" confuses the model. Instead: "brightly lit key side with deep moody shadows on the fill side, high contrast ratio."
- **Too many subjects without spatial grounding** -- If multiple people are in the scene, describe their spatial relationship. "Two people" is vague. "A woman seated in the foreground camera left, a man standing behind her camera right" is grounded.
- **Vague composition** -- Let the model know the framing. "Medium close-up," "full-length," "three-quarter crop from the waist up."

### Things to Include for Realism
- **Natural imperfections** -- Slightly asymmetric features, minor skin texture variations, a few flyaway hairs, one shirt collar slightly higher than the other. Real life is asymmetric.
- **Environmental interaction** -- Shadows cast on the subject's face by nearby objects, reflected color from a nearby wall, ambient light contributing a secondary color temperature.
- **Specific depth cues** -- Background at a different focus distance (describe the bokeh), foreground elements partially out of focus, subject at a specific distance from the camera.
- **Context-appropriate wear** -- Clothes that look worn or at least not brand-new, shoes with slight scuffing, a watch with natural wrist wear.

### NB Pro Composition Anchoring
When using Nano Banana Pro, always start the prompt with the output frame and composition description. If you bury the composition information mid-prompt or omit it, NB Pro tends to recompose the image from scratch, ignoring reference images. Lead with: "Full-body portrait, centered composition, shot from slightly above eye level..." THEN follow with subject and technical details.

### Natural Language Over Keywords
Flux 2 Pro and Nano Banana Pro are VLM-based models -- they understand natural language, not keyword lists. Keyword-list formatting ("cinematic, 8K, dramatic lighting, studio photo, masterpiece") is a holdover from Stable Diffusion and Midjourney's CLIP-based architectures. When VLM models encounter keyword-list formatting, they activate associations with digital art prompts -- because keyword lists dominated the training data for those styles.

Write prompts as complete sentences describing what a photographer would see. "Dramatic rim lighting from behind creating a bright edge along both shoulders, separating the subject from the dark background" beats "rim light, dramatic, dark background, edge lighting, cinematic."

### Skin-Specific Anti-Artifact Checklist
Before finalizing any prompt that includes a human subject, verify:
- [ ] Pore detail is zone-specific (forehead, nose, cheeks -- not just "visible pores")
- [ ] Subsurface scattering is described at at least one thin-skin area (ears, nostrils, fingers)
- [ ] Color variation is described (redness, cooler areas, warmth)
- [ ] At least one named skin imperfection is included (mole, vein, tan line, vellus hair)
- [ ] No banned skin words are present (smooth, clear, flawless, porcelain, perfect)
- [ ] The description could NOT apply to a mannequin

---

## 10. Model-Specific Tips

### Nano Banana Pro (NB Pro)
- **Output frame anchoring is critical.** The first sentence of the prompt must describe the shot's framing and composition. "Medium close-up portrait, subject centered in frame, shot at eye level" before any other details.
- **Best for editing and compositing.** NB Pro excels when you provide a reference image and ask it to modify, extend, or composite elements. It is not the strongest pure text-to-image generator.
- **When using for pure generation,** be extremely explicit about composition, framing, camera angle, and subject placement. Leave nothing to inference.
- **Resolution matters significantly.** Use 2K minimum for any production output. 4K for final delivery. Lower resolutions degrade quality disproportionately with this model.
- **For clothing composites:** Provide a reference image of the model AND the clothing item together. Do NOT use the specialized "Try On" endpoint -- direct prompting with NB Pro and reference images produces more controllable, higher-quality results.

### Flux 2 Pro
- **Strong prompt adherence.** Flux 2 Pro follows long, detailed prompts more faithfully than most models. Do not be afraid to write 150-250 word prompts. More detail produces better results, not confusion.
- **Superior for pure text-to-image generation.** When generating from scratch without a reference image, Flux 2 Pro typically outperforms NB Pro in prompt fidelity and coherence.
- **image_size "match_input" works well** when a reference image is provided. The model respects the aspect ratio and resolution of the input.
- **Use PNG output format** for highest quality. JPEG compression introduces artifacts that compound with any model-generated imperfections.
- **Handles complex scenes better** than NB Pro. Multiple subjects, detailed environments, and specific spatial relationships are more reliably rendered.

### General Cross-Model Tips
- Always specify output resolution and format explicitly in the workflow node configuration.
- When iterating on a prompt, change one variable at a time to isolate what works.
- Save successful prompts as templates. Small wording changes can produce disproportionate output changes.
- Seed values enable reproducibility. Lock the seed when iterating on prompt language so you can compare outputs fairly.

---

## 11. Example Prompts

### Editorial Portrait

> This is a studio editorial portrait of a woman in her early 30s, framed as a medium close-up from the collarbones up, shot slightly above eye level. She has warm brown skin with visible pores and natural texture, dark brown eyes with sharp catchlights, and black hair pulled back in a low chignon with a few loose strands framing her face. Her expression is composed and direct, looking straight into the lens with a slight tension in her jaw. She wears a structured ivory silk blouse with a high neckline, the fabric catching the light in soft liquid highlights along the folds.
>
> The lighting is Rembrandt -- key light positioned 45 degrees camera right and above, creating a defined triangle of light on her left cheek and deep shadows on the left side. A subtle fill card from camera left opens the shadows just enough to retain detail. Background is a smooth, muted warm gray, slightly out of focus.
>
> Shot on Hasselblad X2D with 80mm f/2.8 at f/3.5, ISO 100. Medium format rendering with smooth depth falloff and dimensional separation. Fine skin detail, individual hair strands visible at the edges, subsurface scattering visible in the thinner skin near the ears. Professional color grading, high resolution, shot for a print editorial.

### Product Shot

> A high-end product photograph of a mechanical wristwatch resting on a slab of dark Italian marble. The watch is positioned at a slight angle, dial facing upward and toward camera, showing the full face and a portion of the brushed titanium bracelet trailing off to the right. The dial is deep midnight blue with applied silver indices, and the hands show polished bevels catching the light in bright linear reflections.
>
> Lit with a large overhead softbox as the key light creating even illumination across the dial face, with a focused accent light from camera left producing a specular highlight along the case edge and lugs. The marble surface shows visible veining in gray and gold, with a subtle reflection of the watch visible in its polished surface. Background falls to soft black.
>
> Captured on Canon EOS R5 with 100mm f/2.8L Macro lens at f/8, ISO 100, focus stacked for full depth sharpness across the watch. Visible machining marks on the brushed bracelet links, fingerprint-free crystal with a single faint caustic light pattern on the marble beneath the crystal edge. High resolution, color-accurate, shot for a luxury brand catalog.

### Environmental Portrait

> A candid environmental portrait of a middle-aged man in his woodworking shop, framed as a three-quarter-length shot with the subject positioned in the left third of the frame. He stands at his workbench with one hand resting on a partially finished oak chair, the other hand holding a block plane. He wears a faded navy canvas apron over a gray henley shirt with pushed-up sleeves, forearms showing wood dust and natural arm hair. His expression is focused but relaxed, looking down at his work rather than at the camera.
>
> The shop is lit by a large north-facing window to camera right, providing soft directional daylight that rakes across the workbench and catches floating dust particles in the air. Warm tungsten overhead shop lights provide fill from above, creating a mixed color temperature -- cool daylight on the near side, warm tungsten in the background. Wood shavings on the bench and floor. Shelves of hand tools slightly out of focus in the background.
>
> Shot on Sony A7IV with 35mm f/1.4 GM lens at f/2.0, ISO 400. The background is soft but recognizable -- you can identify the tools on the pegboard but not read their labels. Visible wood grain on the chair and bench surface, natural leather grain on the apron strap, individual sawdust particles in the air. Natural, documentary feel, high resolution.

### Group / Casting Portrait Template

> This is a casting headshot photograph for a [production type], featuring a [age range] [gender presentation] [ethnicity descriptor]. Framed as a tight medium close-up from mid-chest to just above the head, centered in frame against a clean [light gray / warm white / neutral] backdrop.
>
> The subject has [specific physical description: skin tone, hair color/style/texture, eye color, facial hair if any, distinguishing features]. Their expression is [specific expression: warm and approachable / intense and serious / relaxed and confident], with [eye direction: looking directly into the lens / gaze slightly off-camera to the right]. They wear [simple, non-distracting wardrobe: a plain crew-neck t-shirt in [color] / a simple button-down collar].
>
> Lit with a soft key light in butterfly position directly above the lens, creating even, flattering illumination with gentle shadows beneath the cheekbones and a small shadow below the nose. White fill card below the face to open up under-chin shadows. Clean catchlights visible in both eyes.
>
> Shot on Canon EOS R5 with 85mm f/1.4L at f/2.8, ISO 200. Sharp focus on the eyes with gentle depth falloff at the ears and shoulders. Natural skin texture with visible pores, subtle under-eye detail, natural brow texture. High resolution, neutral color grading, no heavy retouching look.

**Usage note for casting prompts:** Fill in the bracketed sections for each character. Keep wardrobe simple so focus remains on the face. Maintain the same lighting, camera, and framing across all characters in a casting set for visual consistency.

---

## 12. Quick Reference Checklist

Before submitting any photorealistic prompt, verify:

- [ ] The prompt asserts this IS a photograph (not "generate" or "create")
- [ ] A specific camera body and lens are named
- [ ] Aperture, ISO, or other exposure details are included
- [ ] Lighting is described with position, quality, and color temperature
- [ ] At least one material is described with tactile/textural detail
- [ ] Composition and framing are explicit (shot type, camera angle, subject placement)
- [ ] No "perfect/flawless/beautiful" language that triggers synthetic rendering
- [ ] At least one natural imperfection is included (flyaway hair, skin texture, environmental wear)
- [ ] For NB Pro: composition/framing is the FIRST sentence
- [ ] For Flux 2 Pro: prompt is detailed (150+ words) to leverage its strong adherence
- [ ] At least 2 optical imperfections are included (grain, chromatic aberration, vignetting, motion blur, DOF specificity, or halation)
- [ ] A film stock or sensor color science reference is named
- [ ] The prompt is written in natural prose sentences (no keyword lists)
