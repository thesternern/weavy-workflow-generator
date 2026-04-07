# Weavy Node Builders

All Python builder functions for generating Weavy workflow nodes. Each builder is verified against real Weavy JSON (March 2026).

**Usage:** Include these functions in your Python script along with the boilerplate from `core/SKILL-CORE.md`.

---

## INPUT NODES

### FILE UPLOAD
`type: "import"` — 460 x 558 — No root `kind`

```python
def make_file_node(node_id, name, x, y):
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "import",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {"output": {"file": {"type": "any", "label": "File", "order": 0, "format": "uri", "description": "The uploaded file"}}},
            "name": name, "description": None, "color": "Yambo_Blue", "label": None, "menu": None, "params": None, "schema": None, "version": 3,
            "dark_color": "Yambo_Blue_Dark", "border_color": "Yambo_Blue_Stroke",
            "files": [], "cameraLocked": False, "selectedIndex": 0, "output": {}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 558
    }
```

---

## TEXT NODES

### TEXT
`type: "string"` — 460 x 268 — No root `kind` — Default name: `"Text"`

```python
def make_string_node(node_id, name, value, x, y):
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "string",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {"input": {}, "output": {"text": {"id": uid(), "type": "text", "order": 0, "format": "text", "description": "Text"}}},
            "name": name, "description": "", "color": "Yambo_Green", "label": None, "menu": None, "params": None, "schema": None, "version": 3,
            "result": {"string": ""}, "dark_color": "Yambo_Green_Dark", "border_color": "Yambo_Green_Stroke",
            "value": value, "output": {"type": "text", "text": "", "string": ""}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 268
    }
```

### PROMPT
`type: "promptV3"` — 460 x 335 — No root `kind` — Supports `{{variableName}}` inline variables

```python
def make_prompt_node(node_id, name, prompt_text, x, y, variables=None):
    """
    variables: list of (var_name, label, ref_or_none)
    Example: [("variable1", "Variable 1", {"nodeId":"x","outputId":"prompt","string":""})]
    Use {{variable1}} in prompt_text where the value should appear.
    Pass None or [] for a prompt without variables.
    """
    input_handles = {} if variables else []
    input_nodes = []
    if variables:
        for i, (var_name, label, ref) in enumerate(variables):
            input_handles[var_name] = {
                "description": "", "format": "text", "id": uid(),
                "order": i, "required": False, "label": label, "type": "text"
            }
            input_nodes.append([var_name, ref])
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "promptV3",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {"input": input_handles, "output": {"prompt": {"type": "text", "order": 0, "format": "text", "description": "Text prompt"}}},
            "name": name, "description": None, "color": "Yambo_Green", "label": "prompt", "menu": None, "params": None, "schema": None, "version": 3,
            "prompt": prompt_text, "result": {"prompt": prompt_text},
            "dark_color": "Yambo_Green_Dark", "border_color": "Yambo_Green_Stroke",
            "inputNodes": input_nodes, "displayMode": "source-value",
            "output": {"type": "text", "prompt": prompt_text}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 335
    }
```

### CONCATENATOR
`type: "prompt_concat"` — 460 x 368 (2 inputs) — No root `kind`

`additionalPrompt` = intro text BEFORE inputs. `inputNodes` order = concatenation order.

```python
def make_concat_node(node_id, name, input_refs, x, y, additional_prompt=""):
    input_handles = {}
    input_nodes = []
    for i, (hname, ref) in enumerate(input_refs):
        input_handles[hname] = {"type": "text", "label": f"text_{i+1}", "order": i, "format": "text", "description": "Text input"}
        input_nodes.append([hname, ref])
    total_height = 268 + len(input_refs) * 50
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "prompt_concat",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {"input": input_handles, "output": {"prompt": {"type": "text", "label": "combined_text", "format": "text", "description": "The combined text"}}},
            "name": name, "description": "Join multiple text inputs to one output.", "color": "Yambo_Green",
            "label": None, "menu": None, "params": None, "schema": None, "version": 3,
            "dark_color": "Yambo_Green_Dark", "inputNodes": input_nodes, "border_color": "Yambo_Green_Stroke",
            "additionalPrompt": additional_prompt, "result": {"additionalPrompt": additional_prompt},
            "output": {"type": "text", "prompt": ""}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": total_height
    }
```

---

## MODEL NODES

### LLM
`type: "custommodelV2"` / `data.kind.type = "any_llm"` — 460 x 562 — **No root `kind`** — `isModel: true`

Up to 14 image inputs. `prompt`/`systemPrompt` in `data.kind` only when connected (omit when None).

```python
LLM_MODELS = [
    "anthropic/claude-sonnet-4-5","anthropic/claude-opus-4-6","anthropic/claude-opus-4-5",
    "anthropic/claude-3-haiku","google/gemini-2.0-flash-001","google/gemini-2.5-flash",
    "google/gemini-2.5-flash-lite","google/gemini-3-pro","openai/gpt-4o","openai/gpt-4.1",
    "openai/gpt-5-chat","meta-llama/llama-4-maverick","meta-llama/llama-4-scout"
]

def make_llm_node(node_id, name, model, prompt_ref, sys_ref, image_refs, x, y):
    """
    prompt_ref / sys_ref: text ref or None. Omitted from data.kind when None.
    image_refs: list of (label, ref_or_none). Always pass at least [("image", None)].
    """
    kind_data = {
        "type": "any_llm",
        "images": image_refs if image_refs else [["image", None]],
        "model": {"type": "value", "data": {"type": "string", "value": model}},
        "temperature": {"type": "value", "data": {"type": "float", "value": 0}},
        "thinking": {"type": "value", "data": {"type": "boolean", "value": False}}
    }
    if prompt_ref: kind_data["prompt"] = prompt_ref
    if sys_ref: kind_data["systemPrompt"] = sys_ref

    input_handles = {
        "prompt": {"type": "text", "order": 0, "format": "text", "required": True,
                   "description": "Describe your request from the model"},
        "system_prompt": {"type": "text", "order": 1, "format": "text", "required": False,
                          "description": "Describe the purpose of the model (e.g \"you are a prompt generator\")"}
    }
    if image_refs:
        for i, (label, _) in enumerate(image_refs):
            input_handles[label] = {"type": "image", "label": f"image {i+1}", "order": 2+i,
                                    "format": "uri", "required": False, "description": "Image to analyse"}

    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"text": {"type": "text", "order": 0, "format": "text", "description": "The LLM response"}}},
            "name": name, "description": "Run any large language model.", "color": "Yambo_Purple",
            "label": None, "menu": None, "model": {"name": "any_llm"},
            "params": {"model": model, "temperature": 0},
            "schema": {
                "model": {"type": "enum", "order": 0, "title": "Model Name", "default": "google/gemini-3-pro",
                    "options": LLM_MODELS, "description": "Name of the model to use"},
                "thinking": {"type": "boolean", "order": 5, "title": "Thinking", "default": False, "required": False,
                    "description": "Enhanced reasoning capabilities for complex task (For supported models only)"},
                "temperature": {"max": 2, "min": 0, "type": "number", "title": "Temperature", "default": 0,
                    "description": "This setting influences the variety in the model's responses. Lower values lead to more predictable and typical responses, while higher values encourage more diverse and less common responses. At 0, the model always gives the same response for a given input."}
            },
            "version": 3, "dark_color": "Yambo_Purple_Dark", "border_color": "Yambo_Purple_Stroke",
            "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 562
    }
```

### NANO BANANA PRO
`fal-ai/nano-banana-pro/edit` — 460 x 560 — Wildcard — `isModel: true`

Seed = type `"seed"` (object). Resolutions: `1K/2K/4K`. No `output_format`. Input refs = `null` when not connected.

```python
def make_nb_pro_node(node_id, name, prompt_ref, image_1_ref, x, y, resolution="1K", aspect_ratio="auto"):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "The prompt for image editing.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_1", "title": "image_1", "description": "The image you want to edit", "validTypes": ["image"], "required": False}, image_1_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "Description of the edits you want to make"},
        "image_1": {"id": uid(), "type": "image", "label": "image_1", "order": 1, "format": "uri", "required": False, "description": "The image you want to edit"},
    }
    parameters = [
        [{"id": "seed", "title": "Seed", "description": "Seed value for random number generator. Uncheck for reproducible results.",
          "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "resolution", "title": "Resolution", "description": "The resolution of the image to generate.",
          "constraint": {"type": "enum", "options": ["1K","2K","4K"]}, "defaultValue": {"type": "string", "value": "1K"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "aspect_ratio", "title": "Aspect Ratio", "description": "The aspect ratio of the generated image.",
          "constraint": {"type": "enum", "options": ["auto","1:1","21:9","16:9","3:2","4:3","5:4","4:5","3:4","2:3","9:16"]},
          "defaultValue": {"type": "string", "value": "auto"}},
         {"type": "value", "data": {"type": "string", "value": aspect_ratio}}],
        [{"id": "enable_web_search", "title": "Enable Web Search", "description": "Enable web search for the image generation task.",
          "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": False}},
         {"type": "value", "data": {"type": "boolean", "value": False}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/nano-banana-pro/edit", "version": "fal-ai/nano-banana-pro/edit",
                  "service": "fal_imported", "description": "Google's state-of-the-art image generation and editing model"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Google's state-of-the-art image generation and editing model", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Gemini 3 Pro (with Nano Banana)"},
            "model": {"name": "fal-ai/nano-banana-pro/edit", "service": "fal_imported", "version": "fal-ai/nano-banana-pro/edit"},
            "params": {"seed": {"seed": 0, "isRandom": True}, "prompt": "", "num_images": 1, "resolution": resolution, "aspect_ratio": aspect_ratio, "enable_web_search": False},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False, "description": "Seed value for random number generator."},
                "prompt": {"type": "string", "title": "Prompt", "required": True, "description": "The prompt for image editing."},
                "resolution": {"type": "enum", "title": "Resolution", "default": "1K", "options": ["1K","2K","4K"], "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio", "default": "auto", "options": ["auto","1:1","21:9","16:9","3:2","4:3","5:4","4:5","3:4","2:3","9:16"], "required": False},
                "enable_web_search": {"type": "boolean", "title": "Enable Web Search", "default": False, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### FLUX 2 PRO
`fal-ai/flux-2-pro` — 460 x 560 — Wildcard — `isModel: true`

Same seed pattern as NB Pro. Uses `image_size` (type `fal_image_size`) instead of resolution/aspect_ratio.

```python
def make_flux_pro_node(node_id, name, prompt_ref, image_1_ref, x, y):
    inputs = [
        [{"id": "prompt", "title": "prompt", "description": "The prompt to generate an image from.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_1", "title": "image_1", "description": "The image you want to edit", "validTypes": ["image"], "required": False}, image_1_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "format": "text", "required": True, "description": "The prompt to generate an image from."},
        "image_1": {"id": uid(), "type": "image", "label": "image_1", "order": 1, "format": "uri", "required": False, "description": "The image you want to edit"},
    }
    parameters = [
        [{"id": "seed", "title": "Seed", "description": "Seed value for random number generator.",
          "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "image_size", "title": "Image Size", "description": "The size of the generated image.",
          "constraint": {"type": "image_size", "options": ["Default","auto","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9"]},
          "defaultValue": {"type": "image_size", "value": {"type": "built_in", "value": "match_input"}}},
         {"type": "value", "data": {"type": "image_size", "value": {"type": "built_in", "value": "match_input"}}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/flux-2-pro", "version": "fal-ai/flux-2-pro",
                  "service": "fal_imported", "description": "Image generation and editing with FLUX.2 [pro] from Black Forest Labs."},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": "private", "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Image generation and editing with FLUX.2 [pro] from Black Forest Labs.", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Flux 2 Pro"},
            "model": {"name": "fal-ai/flux-2-pro", "service": "fal_imported", "version": "fal-ai/flux-2-pro"},
            "params": {"seed": {"seed": 0, "isRandom": True}, "prompt": "", "image_size": None, "output_format": "png", "safety_tolerance": "1", "enable_safety_checker": True},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "image_size": {"type": "fal_image_size", "title": "Image Size", "default": None,
                    "options": ["Default","auto","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9"], "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### KLING 3
`type: "custommodelV2"` / `data.kind.type = "kling"` — 460 x 560 — `isModel: true`

Refs named directly in `data.kind`: `prompt`, `image`, `endImageUrl`, `negativePrompt`, `elements[]`.

```python
def make_kling_node(node_id, name, prompt_ref, image_ref, end_image_ref, neg_prompt_ref, element_refs, x, y,
                    kling_model="3.0 Pro", duration=5, cfg_scale=0.5, aspect_ratio="16:9", generate_audio=False):
    kind_data = {
        "type": "kling",
        "model": {"type": "value", "data": {"type": "string", "value": kling_model}},
        "duration": {"type": "value", "data": {"type": "integer", "value": duration}},
        "cfgScale": {"type": "value", "data": {"type": "float", "value": cfg_scale}},
        "shotType": {"type": "value", "data": {"type": "string", "value": "customize"}},
        "aspectRatio": {"type": "value", "data": {"type": "string", "value": aspect_ratio}},
        "generateAudio": {"type": "value", "data": {"type": "boolean", "value": generate_audio}},
        "elements": element_refs if element_refs else []
    }
    if prompt_ref: kind_data["prompt"] = prompt_ref
    if image_ref: kind_data["image"] = image_ref
    if end_image_ref: kind_data["endImageUrl"] = end_image_ref
    if neg_prompt_ref: kind_data["negativePrompt"] = neg_prompt_ref

    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True,
                   "description": "Text prompt for video generation."},
        "image": {"id": uid(), "type": "image", "label": "first_frame", "order": 1, "format": "text", "required": False,
                  "description": "The image to be used for the video"},
        "end_image_url": {"id": uid(), "type": "image", "label": "last_frame", "order": 2, "format": "text", "required": False,
                          "description": "The image to be used for the end of the video"},
        "negative_prompt": {"id": uid(), "type": "text", "label": "negative_prompt", "order": 3, "format": "text", "required": False},
    }
    for i, (label, _) in enumerate(element_refs or []):
        input_handles[label] = {"id": uid(), "type": "kling-element", "label": label, "order": 4+i, "format": "uri", "required": False}

    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": "private", "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"type": "video", "label": "video", "order": 0, "format": "uri", "description": "The video result"}}},
            "name": name, "description": "Kling 3.0 Pro: Top-tier image-to-video.", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Kling 3 Pro"},
            "model": {"name": "kling"},
            "params": {"model": kling_model, "duration": str(duration), "cfg_scale": cfg_scale, "shot_type": "customize", "aspect_ratio": aspect_ratio, "generate_audio": generate_audio},
            "schema": {
                "model": {"type": "enum", "order": 0, "title": "Model", "default": "Pro", "options": ["3.0 Pro","3.0 Standard"], "required": False},
                "duration": {"max": 15, "min": 3, "type": "integer", "title": "Duration", "default": 5, "required": False},
                "cfg_scale": {"max": 1, "min": 0, "type": "number", "title": "Cfg Scale", "default": 0.5, "required": False},
                "shot_type": {"type": "enum", "title": "Shot Type", "default": "customize", "options": ["customize"], "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio (T2I only)", "default": "16:9", "options": ["16:9","9:16","1:1"], "required": False},
                "generate_audio": {"type": "boolean", "title": "Generate Audio", "default": False, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### VIDEO DOWNSCALE (FFmpeg API)
`fal-ai/ffmpeg-api/compose` — 460 x 560 — Wildcard — `isModel: true`

Downscales video to a smaller resolution for downstream processing (e.g., before passing to an LLM quality gate). Uses fal.ai's FFmpeg API.

```python
def make_video_downscale_node(node_id, name, video_ref, x, y, resolution="landscape_4_3"):
    inputs = [
        [{"id": "video_url", "title": "video", "description": "The video to downscale",
          "validTypes": ["video"], "required": True}, video_ref],
    ]
    input_handles = {
        "video_url": {"id": uid(), "type": "video", "label": "video", "order": 0,
                      "format": "uri", "required": True, "description": "The video to downscale"},
    }
    parameters = [
        [{"id": "resolution", "title": "Resolution", "description": "Target resolution for the downscaled video.",
          "constraint": {"type": "image_size",
                         "options": ["Default","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9"]},
          "defaultValue": {"type": "image_size", "value": {"type": "built_in", "value": "match_input"}}},
         {"type": "value", "data": {"type": "image_size", "value": {"type": "built_in", "value": resolution}}}],
    ]
    outputs = [{"id": "video", "title": "video", "description": "The downscaled video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/ffmpeg-api/compose", "version": "fal-ai/ffmpeg-api/compose",
                  "service": "fal_imported", "description": "Downscale video for downstream processing via FFmpeg API."},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": "private", "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "description": "The downscaled video"}}},
            "name": name, "description": "Downscale video for downstream processing via FFmpeg API.", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "FFmpeg Video Downscale"},
            "model": {"name": "fal-ai/ffmpeg-api/compose", "service": "fal_imported", "version": "fal-ai/ffmpeg-api/compose"},
            "params": {"resolution": resolution},
            "schema": {
                "resolution": {"type": "fal_image_size", "title": "Resolution", "default": None,
                    "options": ["Default","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9"],
                    "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": NOW, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### NANO BANANA 2
`fal-ai/nano-banana-2/edit` — 460 x 560 — Wildcard — `isModel: true`

Same input pattern as NB Pro (prompt + image_1). Adds `512` resolution option and extreme aspect ratios.

```python
def make_nb2_node(node_id, name, prompt_ref, image_1_ref, x, y, resolution="1K", aspect_ratio="Default"):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "The prompt for image editing.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_1", "title": "image_1", "description": "The image you want to edit", "validTypes": ["image"], "required": False}, image_1_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "The prompt for image editing."},
        "image_1": {"id": uid(), "type": "image", "label": "image_1", "order": 1, "format": "uri", "required": False, "description": "The image you want to edit"},
    }
    parameters = [
        [{"id": "seed", "title": "Seed", "description": "Seed value for random number generator.",
          "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "resolution", "title": "Resolution", "description": "The resolution of the image to generate.",
          "constraint": {"type": "enum", "options": ["512","1K","2K","4K"]}, "defaultValue": {"type": "string", "value": "1K"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "aspect_ratio", "title": "Aspect Ratio", "description": "The aspect ratio of the generated image.",
          "constraint": {"type": "enum", "options": ["Default","1:1","21:9","16:9","3:2","4:3","5:4","4:5","3:4","2:3","9:16","9:21","8:1","1:8","6:1","1:6","4:1","1:4"]},
          "defaultValue": {"type": "string", "value": "Default"}},
         {"type": "value", "data": {"type": "string", "value": aspect_ratio}}],
        [{"id": "enable_web_search", "title": "Enable Web Search", "description": "Enable web search for the image generation task.",
          "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": False}},
         {"type": "value", "data": {"type": "boolean", "value": False}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/nano-banana-2/edit", "version": "fal-ai/nano-banana-2/edit",
                  "service": "fal_imported", "description": "Google's state-of-the-art image generation and editing model"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Google's state-of-the-art image generation and editing model", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Gemini 3.1 Flash (Nano Banana 2)"},
            "model": {"name": "fal-ai/nano-banana-2/edit", "service": "fal_imported", "version": "fal-ai/nano-banana-2/edit"},
            "params": {"seed": {"seed": 0, "isRandom": True}, "prompt": "", "resolution": resolution, "aspect_ratio": aspect_ratio, "enable_web_search": False},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "resolution": {"type": "enum", "title": "Resolution", "default": "1K", "options": ["512","1K","2K","4K"], "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio", "default": "Default",
                    "options": ["Default","1:1","21:9","16:9","3:2","4:3","5:4","4:5","3:4","2:3","9:16","9:21","8:1","1:8","6:1","1:6","4:1","1:4"], "required": False},
                "enable_web_search": {"type": "boolean", "title": "Enable Web Search", "default": False, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### HIGGSFIELD IMAGE
`higgsfield_t2i` — 460 x 560 — Wildcard — `isModel: true`

80+ style presets. Optional image_reference for style transfer.

```python
def make_higgsfield_image_node(node_id, name, prompt_ref, image_ref, x, y,
                                width_and_height="1696x960", style="General", style_strength=1, enhance_prompt=True):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "Text prompt for image generation.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_reference", "title": "image_reference", "description": "Reference image for style transfer", "validTypes": ["image"], "required": False}, image_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "Text prompt for image generation."},
        "image_reference": {"id": uid(), "type": "image", "label": "image_reference", "order": 1, "format": "uri", "required": False, "description": "Reference image for style transfer"},
    }
    parameters = [
        [{"id": "width_and_height", "title": "Width and Height", "description": "Image dimensions.",
          "constraint": {"type": "enum", "options": ["1152x2048","1200x1600","1344x1792","1536x1536","1696x960","960x1696","1792x1344","1600x1200","2048x1152","1024x1024","768x1344","1344x768","832x1216"]},
          "defaultValue": {"type": "string", "value": "1696x960"}},
         {"type": "value", "data": {"type": "string", "value": width_and_height}}],
        [{"id": "style", "title": "Style", "description": "Style preset to apply.",
          "constraint": {"type": "enum", "options": ["General","Realistic","2000s Cam","2000s Fashion","Indie sleaze","Y2K","Grunge","90's Editorial","90s Grain","Vintage PhotoBooth","Tumblr","FashionShow","Gorpcore","Quiet luxury","Tokyo Streetstyle","iPhone","DigitalCam","Overexposed","Fisheye","CCTV"]},
          "defaultValue": {"type": "string", "value": "General"}},
         {"type": "value", "data": {"type": "string", "value": style}}],
        [{"id": "style_strength", "title": "Style Strength", "description": "How strongly to apply the style preset.",
          "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 1}},
         {"type": "value", "data": {"type": "float", "value": style_strength}}],
        [{"id": "enhance_prompt", "title": "Enhance Prompt", "description": "Automatically enhance the prompt.",
          "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": enhance_prompt}}],
        [{"id": "seed", "title": "Seed", "description": "Seed value.",
          "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "higgsfield_t2i", "version": "higgsfield_t2i",
                  "service": "fal_imported", "description": "Higgsfield's image generation model"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Higgsfield's image generation model", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Higgsfield Image"},
            "model": {"name": "higgsfield_t2i", "service": "fal_imported", "version": "higgsfield_t2i"},
            "params": {"prompt": "", "width_and_height": width_and_height, "style": style, "style_strength": style_strength, "enhance_prompt": enhance_prompt, "seed": {"seed": 0, "isRandom": True}},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "width_and_height": {"type": "enum", "title": "Width and Height", "default": "1696x960", "required": False},
                "style": {"type": "enum", "title": "Style", "default": "General", "required": False},
                "style_strength": {"type": "number", "title": "Style Strength", "default": 1, "min": 0, "max": 1, "required": False},
                "enhance_prompt": {"type": "boolean", "title": "Enhance Prompt", "default": True, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### GOOGLE IMAGEN 4
`imagen4` — 460 x 560 — Wildcard — `isModel: true`

Text-to-image ONLY. Has negative_prompt. No image input.

```python
def make_imagen4_node(node_id, name, prompt_ref, neg_prompt_ref, x, y,
                       resolution="1K", model="Standard", aspect_ratio="1:1"):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "Text prompt for image generation.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "negative_prompt", "title": "Negative Prompt", "description": "What to avoid.", "validTypes": ["text"], "required": False}, neg_prompt_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "Text prompt for image generation."},
        "negative_prompt": {"id": uid(), "type": "text", "label": "negative_prompt", "order": 1, "format": "text", "required": False, "description": "What to avoid in the generated image."},
    }
    parameters = [
        [{"id": "resolution", "title": "Resolution", "constraint": {"type": "enum", "options": ["1K","2K"]}, "defaultValue": {"type": "string", "value": "1K"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["Standard","Ultra","Fast"]}, "defaultValue": {"type": "string", "value": "Standard"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "aspect_ratio", "title": "Aspect Ratio", "constraint": {"type": "enum", "options": ["1:1","9:16","16:9","3:4","4:3"]}, "defaultValue": {"type": "string", "value": "1:1"}},
         {"type": "value", "data": {"type": "string", "value": aspect_ratio}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "imagen4", "version": "imagen4",
                  "service": "fal_imported", "description": "Google's highest quality image generation model"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Google's highest quality image generation model", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Imagen 4"},
            "model": {"name": "imagen4", "service": "fal_imported", "version": "imagen4"},
            "params": {"prompt": "", "resolution": resolution, "model": model, "aspect_ratio": aspect_ratio},
            "schema": {
                "resolution": {"type": "enum", "title": "Resolution", "default": "1K", "options": ["1K","2K"], "required": False},
                "model": {"type": "enum", "title": "Model", "default": "Standard", "options": ["Standard","Ultra","Fast"], "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio", "default": "1:1", "options": ["1:1","9:16","16:9","3:4","4:3"], "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### FLUX PRO 1.1 ULTRA
`black-forest-labs/flux-1.1-pro-ultra` — 460 x 560 — **Kind type: `flux11_pro_ultra`** (NOT wildcard) — `isModel: true`

Has `raw` mode for photorealism. Redux `image_prompt` for composition blending.

```python
def make_flux_ultra_node(node_id, name, prompt_ref, image_prompt_ref, x, y,
                          aspect_ratio="1:1", raw=False, image_prompt_strength=0.1, safety_tolerance=2, output_format="jpg"):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "Text prompt for image generation.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_prompt", "title": "image_prompt", "description": "Image for Redux composition blending.", "validTypes": ["image"], "required": False}, image_prompt_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "Text prompt for image generation."},
        "image_prompt": {"id": uid(), "type": "image", "label": "image_prompt", "order": 1, "format": "uri", "required": False, "description": "Image for Redux composition blending."},
    }
    parameters = [
        [{"id": "aspect_ratio", "title": "Aspect Ratio",
          "constraint": {"type": "enum", "options": ["21:9","16:9","3:2","4:3","5:4","1:1","4:5","3:4","2:3","9:16","9:21"]},
          "defaultValue": {"type": "string", "value": "1:1"}},
         {"type": "value", "data": {"type": "string", "value": aspect_ratio}}],
        [{"id": "image_prompt_strength", "title": "Image Prompt Strength", "description": "Blend between text and image prompt.",
          "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 0.1}},
         {"type": "value", "data": {"type": "float", "value": image_prompt_strength}}],
        [{"id": "safety_tolerance", "title": "Safety Tolerance",
          "constraint": {"type": "integer", "min": 1, "max": 6}, "defaultValue": {"type": "integer", "value": 2}},
         {"type": "value", "data": {"type": "integer", "value": safety_tolerance}}],
        [{"id": "seed", "title": "Seed", "constraint": {"type": "seed"},
          "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "raw", "title": "Raw", "description": "Generate less processed, more natural-looking images.",
          "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": False}},
         {"type": "value", "data": {"type": "boolean", "value": raw}}],
        [{"id": "output_format", "title": "Output Format", "constraint": {"type": "enum", "options": ["jpg","png"]},
          "defaultValue": {"type": "string", "value": "jpg"}},
         {"type": "value", "data": {"type": "string", "value": output_format}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "flux11_pro_ultra",
        "model": {"type": "predefined", "name": "black-forest-labs/flux-1.1-pro-ultra", "version": "black-forest-labs/flux-1.1-pro-ultra",
                  "service": "fal_imported", "description": "FLUX1.1 [pro] in ultra and raw modes. Up to 4 megapixels."},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "FLUX1.1 [pro] in ultra and raw modes. Up to 4 megapixels.", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Flux Pro 1.1 Ultra"},
            "model": {"name": "black-forest-labs/flux-1.1-pro-ultra", "service": "fal_imported", "version": "black-forest-labs/flux-1.1-pro-ultra"},
            "params": {"prompt": "", "aspect_ratio": aspect_ratio, "image_prompt_strength": image_prompt_strength, "safety_tolerance": safety_tolerance, "raw": raw, "output_format": output_format, "seed": {"seed": 0, "isRandom": True}},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio", "default": "1:1",
                    "options": ["21:9","16:9","3:2","4:3","5:4","1:1","4:5","3:4","2:3","9:16","9:21"], "required": False},
                "image_prompt_strength": {"type": "number", "title": "Image Prompt Strength", "default": 0.1, "min": 0, "max": 1, "required": False},
                "safety_tolerance": {"type": "integer", "title": "Safety Tolerance", "default": 2, "min": 1, "max": 6, "required": False},
                "raw": {"type": "boolean", "title": "Raw", "default": False, "required": False},
                "output_format": {"type": "enum", "title": "Output Format", "default": "jpg", "options": ["jpg","png"], "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### SEEDREAM V5 EDIT
`fal-ai/bytedance/seedream/v5/lite/edit` — 460 x 560 — Wildcard — `isModel: true`

ByteDance model. Uses fal_image_size. Has enhance_prompt_mode and model version selection.

```python
def make_seedream_node(node_id, name, prompt_ref, image_1_ref, x, y,
                        model="V5.0", image_size="match_input", enhance_prompt_mode="standard"):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "The prompt for image editing.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_1", "title": "image_1", "description": "The image you want to edit", "validTypes": ["image"], "required": False}, image_1_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True, "description": "The prompt for image editing."},
        "image_1": {"id": uid(), "type": "image", "label": "image_1", "order": 1, "format": "uri", "required": False, "description": "The image you want to edit"},
    }
    parameters = [
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["V4.0","V4.5","V5.0"]}, "defaultValue": {"type": "string", "value": "V5.0"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "seed", "title": "Seed", "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "image_size", "title": "Image Size",
          "constraint": {"type": "image_size", "options": ["Default","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9","auto_2K","auto_3K"]},
          "defaultValue": {"type": "image_size", "value": {"type": "built_in", "value": "match_input"}}},
         {"type": "value", "data": {"type": "image_size", "value": {"type": "built_in", "value": image_size}}}],
        [{"id": "enhance_prompt_mode", "title": "Enhance Prompt Mode", "constraint": {"type": "enum", "options": ["standard","fast"]}, "defaultValue": {"type": "string", "value": "standard"}},
         {"type": "value", "data": {"type": "string", "value": enhance_prompt_mode}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/bytedance/seedream/v5/lite/edit", "version": "fal-ai/bytedance/seedream/v5/lite/edit",
                  "service": "fal_imported", "description": "Image editing endpoint for the fast Lite version of Seedream 5.0"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Result image"}}},
            "name": name, "description": "Image editing endpoint for the fast Lite version of Seedream 5.0", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Seedream V5 Edit"},
            "model": {"name": "fal-ai/bytedance/seedream/v5/lite/edit", "service": "fal_imported", "version": "fal-ai/bytedance/seedream/v5/lite/edit"},
            "params": {"prompt": "", "model": model, "seed": {"seed": 0, "isRandom": True}, "image_size": None, "enhance_prompt_mode": enhance_prompt_mode},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "model": {"type": "enum", "title": "Model", "default": "V5.0", "options": ["V4.0","V4.5","V5.0"], "required": False},
                "image_size": {"type": "fal_image_size", "title": "Image Size", "default": None,
                    "options": ["Default","square_hd","square","portrait_4_3","portrait_16_9","landscape_4_3","landscape_16_9","auto_2K","auto_3K"], "required": False},
                "enhance_prompt_mode": {"type": "enum", "title": "Enhance Prompt Mode", "default": "standard", "options": ["standard","fast"], "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

---

### VEO 3.1 TEXT TO VIDEO
`google-veo3-t2v` — 460 x 617 — Wildcard — `isModel: true`

Text-to-video ONLY. Native audio generation. No image input.

```python
def make_veo3_node(node_id, name, prompt_ref, neg_prompt_ref, x, y,
                    model="Fast", version="3.1", duration="8s", resolution="720p", aspect_ratio="16:9",
                    auto_fix=True, enhance_prompt=True, generate_audio=True):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "description": "Text prompt for video generation.", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "negative_prompt", "title": "Negative Prompt", "description": "What to avoid.", "validTypes": ["text"], "required": False}, neg_prompt_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True},
        "negative_prompt": {"id": uid(), "type": "text", "label": "negative_prompt", "order": 1, "format": "text", "required": False},
    }
    parameters = [
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["Standard","Fast"]}, "defaultValue": {"type": "string", "value": "Fast"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "version", "title": "Version", "constraint": {"type": "enum", "options": ["3","3.1"]}, "defaultValue": {"type": "string", "value": "3.1"}},
         {"type": "value", "data": {"type": "string", "value": version}}],
        [{"id": "auto_fix", "title": "Auto Fix", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": auto_fix}}],
        [{"id": "duration", "title": "Duration", "constraint": {"type": "enum", "options": ["4s","6s","8s"]}, "defaultValue": {"type": "string", "value": "8s"}},
         {"type": "value", "data": {"type": "string", "value": duration}}],
        [{"id": "resolution", "title": "Resolution", "constraint": {"type": "enum", "options": ["720p","1080p"]}, "defaultValue": {"type": "string", "value": "720p"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "aspect_ratio", "title": "Aspect Ratio", "constraint": {"type": "enum", "options": ["16:9","9:16","1:1"]}, "defaultValue": {"type": "string", "value": "16:9"}},
         {"type": "value", "data": {"type": "string", "value": aspect_ratio}}],
        [{"id": "seed", "title": "Seed", "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "enhance_prompt", "title": "Enhance Prompt", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": enhance_prompt}}],
        [{"id": "generate_audio", "title": "Generate Audio", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": generate_audio}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "google-veo3-t2v", "version": "google-veo3-t2v",
                  "service": "fal_imported", "description": "Google's flagship Veo 3 text to video model, with audio"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "video", "label": "result", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Google's flagship Veo 3 text to video model, with audio", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Veo 3.1"},
            "model": {"name": "google-veo3-t2v", "service": "fal_imported", "version": "google-veo3-t2v"},
            "params": {"prompt": "", "model": model, "version": version, "auto_fix": auto_fix, "duration": duration, "resolution": resolution, "aspect_ratio": aspect_ratio, "enhance_prompt": enhance_prompt, "generate_audio": generate_audio, "seed": {"seed": 0, "isRandom": True}},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "model": {"type": "enum", "title": "Model", "default": "Fast", "options": ["Standard","Fast"], "required": False},
                "version": {"type": "enum", "title": "Version", "default": "3.1", "options": ["3","3.1"], "required": False},
                "auto_fix": {"type": "boolean", "title": "Auto Fix", "default": True, "required": False},
                "duration": {"type": "enum", "title": "Duration", "default": "8s", "options": ["4s","6s","8s"], "required": False},
                "resolution": {"type": "enum", "title": "Resolution", "default": "720p", "options": ["720p","1080p"], "required": False},
                "aspect_ratio": {"type": "enum", "title": "Aspect Ratio", "default": "16:9", "options": ["16:9","9:16","1:1"], "required": False},
                "enhance_prompt": {"type": "boolean", "title": "Enhance Prompt", "default": True, "required": False},
                "generate_audio": {"type": "boolean", "title": "Generate Audio", "default": True, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

### WAN 2.7 VIDEO
`fal-ai/wan/v2.7/image-to-video` — 460 x 617 — Wildcard — `isModel: true`

Most flexible video model. Supports image, end_image, audio, negative_prompt. Output handle is `video` (not `result`).

```python
def make_wan_node(node_id, name, prompt_ref, image_ref, end_image_ref, audio_ref, neg_prompt_ref, x, y,
                   resolution="1080p", duration=5, enable_prompt_expansion=True):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_url", "title": "image_url", "description": "First frame image", "validTypes": ["image"], "required": False}, image_ref],
        [{"id": "end_image_url", "title": "end_image_url", "description": "Last frame image", "validTypes": ["image"], "required": False}, end_image_ref],
        [{"id": "audio_url", "title": "audio_url", "description": "Driving audio (WAV/MP3, 2-30s)", "validTypes": ["audio"], "required": False}, audio_ref],
        [{"id": "negative_prompt", "title": "Negative Prompt", "validTypes": ["text"], "required": False}, neg_prompt_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True},
        "image_url": {"id": uid(), "type": "image", "label": "image_url", "order": 1, "format": "uri", "required": False},
        "end_image_url": {"id": uid(), "type": "image", "label": "end_image_url", "order": 2, "format": "uri", "required": False},
        "audio_url": {"id": uid(), "type": "audio", "label": "audio_url", "order": 3, "format": "uri", "required": False},
        "negative_prompt": {"id": uid(), "type": "text", "label": "negative_prompt", "order": 4, "format": "text", "required": False},
    }
    parameters = [
        [{"id": "resolution", "title": "Resolution", "constraint": {"type": "enum", "options": ["720p","1080p"]}, "defaultValue": {"type": "string", "value": "1080p"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "duration", "title": "Duration", "constraint": {"type": "integer", "min": 2, "max": 15}, "defaultValue": {"type": "integer", "value": 5}},
         {"type": "value", "data": {"type": "integer", "value": duration}}],
        [{"id": "seed", "title": "Seed", "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
        [{"id": "enable_prompt_expansion", "title": "Enable Prompt Expansion", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": enable_prompt_expansion}}],
    ]
    outputs = [{"id": "video", "title": "video", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/wan/v2.7/image-to-video", "version": "fal-ai/wan/v2.7/image-to-video",
                  "service": "fal_imported", "description": "Enhanced motion smoothness, superior scene fidelity, and greater visual coherence"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Enhanced motion smoothness, superior scene fidelity, and greater visual coherence", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Wan 2.7"},
            "model": {"name": "fal-ai/wan/v2.7/image-to-video", "service": "fal_imported", "version": "fal-ai/wan/v2.7/image-to-video"},
            "params": {"prompt": "", "resolution": resolution, "duration": duration, "seed": {"seed": 0, "isRandom": True}, "enable_prompt_expansion": enable_prompt_expansion},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "resolution": {"type": "enum", "title": "Resolution", "default": "1080p", "options": ["720p","1080p"], "required": False},
                "duration": {"type": "integer", "title": "Duration", "default": 5, "min": 2, "max": 15, "required": False},
                "enable_prompt_expansion": {"type": "boolean", "title": "Enable Prompt Expansion", "default": True, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

### LTX 2 VIDEO
`ltx2_video` — 460 x 617 — Wildcard — `isModel: true`

Fast video generation. Optional first frame image.

```python
def make_ltx2_node(node_id, name, prompt_ref, image_ref, x, y,
                    model="ltx-2-fast", fps=25, duration=6, resolution="1920x1080", prompt_enhancement=True):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image_uri", "title": "image_uri", "description": "First frame image", "validTypes": ["image"], "required": False}, image_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True},
        "image_uri": {"id": uid(), "type": "image", "label": "image_uri", "order": 1, "format": "uri", "required": False},
    }
    parameters = [
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["ltx-2-fast","ltx-2-pro"]}, "defaultValue": {"type": "string", "value": "ltx-2-fast"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "fps", "title": "FPS", "constraint": {"type": "enum", "options": [25, 50]}, "defaultValue": {"type": "integer", "value": 25}},
         {"type": "value", "data": {"type": "integer", "value": fps}}],
        [{"id": "duration", "title": "Duration", "constraint": {"type": "enum", "options": [6, 8, 10]}, "defaultValue": {"type": "integer", "value": 6}},
         {"type": "value", "data": {"type": "integer", "value": duration}}],
        [{"id": "resolution", "title": "Resolution", "constraint": {"type": "enum", "options": ["1920x1080","2560x1440","3840x2160"]}, "defaultValue": {"type": "string", "value": "1920x1080"}},
         {"type": "value", "data": {"type": "string", "value": resolution}}],
        [{"id": "prompt_enhancement", "title": "Prompt Enhancement", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": prompt_enhancement}}],
    ]
    outputs = [{"id": "video", "title": "video", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "ltx2_video", "version": "ltx2_video",
                  "service": "fal_imported", "description": "Enhanced textures, prompt adherence, motion and native high resolution"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Enhanced textures, prompt adherence, motion and native high resolution", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "LTX 2"},
            "model": {"name": "ltx2_video", "service": "fal_imported", "version": "ltx2_video"},
            "params": {"prompt": "", "model": model, "fps": fps, "duration": duration, "resolution": resolution, "prompt_enhancement": prompt_enhancement},
            "schema": {
                "model": {"type": "enum", "title": "Model", "default": "ltx-2-fast", "options": ["ltx-2-fast","ltx-2-pro"], "required": False},
                "fps": {"type": "enum", "title": "FPS", "default": 25, "options": [25, 50], "required": False},
                "duration": {"type": "enum", "title": "Duration", "default": 6, "options": [6, 8, 10], "required": False},
                "resolution": {"type": "enum", "title": "Resolution", "default": "1920x1080", "options": ["1920x1080","2560x1440","3840x2160"], "required": False},
                "prompt_enhancement": {"type": "boolean", "title": "Prompt Enhancement", "default": True, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

### HIGGSFIELD VIDEO
`higgsfield_i2v` — 460 x 617 — Wildcard — `isModel: true`

Camera motion on stills. Image is REQUIRED. 120+ motion presets.

```python
def make_higgsfield_video_node(node_id, name, prompt_ref, image_ref, x, y,
                                model="dop-lite", motion="Cinematic", enhance_prompt=True):
    inputs = [
        [{"id": "prompt", "title": "Prompt", "validTypes": ["text"], "required": True}, prompt_ref],
        [{"id": "image", "title": "image", "description": "Source image (REQUIRED)", "validTypes": ["image"], "required": True}, image_ref],
    ]
    input_handles = {
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 0, "format": "text", "required": True},
        "image": {"id": uid(), "type": "image", "label": "image", "order": 1, "format": "uri", "required": True},
    }
    parameters = [
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["dop-lite","dop-turbo","dop-preview"]}, "defaultValue": {"type": "string", "value": "dop-lite"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "motion", "title": "Motion", "description": "Camera motion preset.",
          "constraint": {"type": "enum", "options": ["360 Orbit","Paparazzi","Handheld","Super 8MM","VHS","Dolly Zoom In","Bullet Time","FPV Drone","Snorricam","Cinematic","Static","Crash Zoom In","Whip Pan","Low Shutter","Timelapse Human","Catwalk"]},
          "defaultValue": {"type": "string", "value": "360 Orbit"}},
         {"type": "value", "data": {"type": "string", "value": motion}}],
        [{"id": "enhance_prompt", "title": "Enhance Prompt", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": enhance_prompt}}],
        [{"id": "seed", "title": "Seed", "constraint": {"type": "seed"}, "defaultValue": {"type": "seed", "value": {"seed": 1, "isRandom": False}}},
         {"type": "value", "data": {"type": "seed", "value": {"seed": 0, "isRandom": True}}}],
    ]
    outputs = [{"id": "video", "title": "video", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "higgsfield_i2v", "version": "higgsfield_i2v",
                  "service": "fal_imported", "description": "Generate video from an image and a prompt"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Generate video from an image and a prompt", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Higgsfield Video"},
            "model": {"name": "higgsfield_i2v", "service": "fal_imported", "version": "higgsfield_i2v"},
            "params": {"prompt": "", "model": model, "motion": motion, "enhance_prompt": enhance_prompt, "seed": {"seed": 0, "isRandom": True}},
            "schema": {
                "seed": {"type": "seed", "title": "Seed", "required": False},
                "model": {"type": "enum", "title": "Model", "default": "dop-lite", "options": ["dop-lite","dop-turbo","dop-preview"], "required": False},
                "motion": {"type": "enum", "title": "Motion", "default": "360 Orbit", "required": False},
                "enhance_prompt": {"type": "boolean", "title": "Enhance Prompt", "default": True, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

---

### OMNIHUMAN V1.5
`fal-ai/bytedance/omnihuman/v1.5` — 460 x 617 — Wildcard — `isModel: true`

Audio + image in, video out. No parameters. Both inputs REQUIRED.

```python
def make_omnihuman_node(node_id, name, audio_ref, image_ref, x, y):
    inputs = [
        [{"id": "audio_url", "title": "audio_url", "description": "Driving audio (under 30s)", "validTypes": ["audio"], "required": True}, audio_ref],
        [{"id": "image_url", "title": "image_url", "description": "Source portrait image", "validTypes": ["image"], "required": True}, image_ref],
    ]
    input_handles = {
        "audio_url": {"id": uid(), "type": "audio", "label": "audio_url", "order": 0, "format": "uri", "required": True, "description": "Driving audio (under 30s)"},
        "image_url": {"id": uid(), "type": "image", "label": "image_url", "order": 1, "format": "uri", "required": True, "description": "Source portrait image"},
    }
    outputs = [{"id": "result", "title": "result", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/bytedance/omnihuman/v1.5", "version": "fal-ai/bytedance/omnihuman/v1.5",
                  "service": "fal_imported", "description": "Produces vivid, high-quality videos where the character's emotions and movements"},
        "inputs": inputs, "parameters": [], "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "video", "label": "result", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Produces vivid, high-quality videos where the character's emotions and movements", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Omnihuman V1.5"},
            "model": {"name": "fal-ai/bytedance/omnihuman/v1.5", "service": "fal_imported", "version": "fal-ai/bytedance/omnihuman/v1.5"},
            "params": {}, "schema": {},
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

### KLING AI AVATAR PRO
`fal-ai/kling-video/v1/pro/ai-avatar` — 460 x 617 — Wildcard — `isModel: true`

Image + audio + optional prompt. Supports humans, animals, cartoons, stylized characters.

```python
def make_kling_avatar_node(node_id, name, image_ref, audio_ref, prompt_ref, x, y):
    inputs = [
        [{"id": "image_url", "title": "image_url", "description": "Avatar source image", "validTypes": ["image"], "required": True}, image_ref],
        [{"id": "audio_url", "title": "audio_url", "description": "Driving audio", "validTypes": ["audio"], "required": True}, audio_ref],
        [{"id": "prompt", "title": "Prompt", "description": "Optional scene direction", "validTypes": ["text"], "required": False}, prompt_ref],
    ]
    input_handles = {
        "image_url": {"id": uid(), "type": "image", "label": "image_url", "order": 0, "format": "uri", "required": True, "description": "Avatar source image"},
        "audio_url": {"id": uid(), "type": "audio", "label": "audio_url", "order": 1, "format": "uri", "required": True, "description": "Driving audio"},
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 2, "format": "text", "required": False, "description": "Optional scene direction"},
    }
    outputs = [{"id": "result", "title": "result", "description": "Result video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fal-ai/kling-video/v1/pro/ai-avatar", "version": "fal-ai/kling-video/v1/pro/ai-avatar",
                  "service": "fal_imported", "description": "Premium endpoint for creating avatar videos with realistic humans, animals, cartoons, or stylized characters"},
        "inputs": inputs, "parameters": [], "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "video", "label": "result", "order": 0, "format": "uri", "description": "Result video"}}},
            "name": name, "description": "Premium endpoint for creating avatar videos", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Kling AI Avatar Pro"},
            "model": {"name": "fal-ai/kling-video/v1/pro/ai-avatar", "service": "fal_imported", "version": "fal-ai/kling-video/v1/pro/ai-avatar"},
            "params": {}, "schema": {},
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 617
    }
```

---

### TOPAZ IMAGE UPSCALE
`fal-ai/topaz/upscale/image` — 460 x 560 — **Kind type: `topaz_image_upscale`** — `isModel: true`

No text prompt. Image-only input. Multiple model modes and face enhancement controls.

```python
def make_topaz_upscale_node(node_id, name, image_ref, x, y,
                             model="Standard V2", upscale_factor=2, face_enhancement=True,
                             face_enhancement_strength=0.8, face_enhancement_creativity=0, subject_detection="All"):
    inputs = [
        [{"id": "image_url", "title": "image_url", "description": "Image to upscale", "validTypes": ["image"], "required": True}, image_ref],
    ]
    input_handles = {
        "image_url": {"id": uid(), "type": "image", "label": "image_url", "order": 0, "format": "uri", "required": True, "description": "Image to upscale"},
    }
    parameters = [
        [{"id": "model", "title": "Model",
          "constraint": {"type": "enum", "options": ["Low Resolution V2","Standard V2","CGI","High Fidelity V2","Text Refine","Recovery","Redefine","Recovery V2"]},
          "defaultValue": {"type": "string", "value": "Standard V2"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "upscale_factor", "title": "Upscale Factor", "constraint": {"type": "number", "min": 1, "max": 4}, "defaultValue": {"type": "float", "value": 2}},
         {"type": "value", "data": {"type": "float", "value": upscale_factor}}],
        [{"id": "face_enhancement", "title": "Face Enhancement", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": face_enhancement}}],
        [{"id": "face_enhancement_strength", "title": "Face Enhancement Strength", "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 0.8}},
         {"type": "value", "data": {"type": "float", "value": face_enhancement_strength}}],
        [{"id": "face_enhancement_creativity", "title": "Face Enhancement Creativity", "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 0}},
         {"type": "value", "data": {"type": "float", "value": face_enhancement_creativity}}],
        [{"id": "subject_detection", "title": "Subject Detection", "constraint": {"type": "enum", "options": ["All","Foreground","Background"]}, "defaultValue": {"type": "string", "value": "All"}},
         {"type": "value", "data": {"type": "string", "value": subject_detection}}],
        [{"id": "crop_to_fill", "title": "Crop to Fill", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": False}},
         {"type": "value", "data": {"type": "boolean", "value": False}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Upscaled image", "dataType": "image"}]
    kind_data = {
        "type": "topaz_image_upscale",
        "model": {"type": "predefined", "name": "fal-ai/topaz/upscale/image", "version": "fal-ai/topaz/upscale/image",
                  "service": "fal_imported", "description": "Topaz professional image upscaling"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Upscaled image"}}},
            "name": name, "description": "Topaz professional image upscaling", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Topaz Image Upscale"},
            "model": {"name": "fal-ai/topaz/upscale/image", "service": "fal_imported", "version": "fal-ai/topaz/upscale/image"},
            "params": {"model": model, "upscale_factor": upscale_factor, "face_enhancement": face_enhancement, "face_enhancement_strength": face_enhancement_strength, "face_enhancement_creativity": face_enhancement_creativity, "subject_detection": subject_detection, "crop_to_fill": False},
            "schema": {
                "model": {"type": "enum", "title": "Model", "default": "Standard V2", "options": ["Low Resolution V2","Standard V2","CGI","High Fidelity V2","Text Refine","Recovery","Redefine","Recovery V2"], "required": False},
                "upscale_factor": {"type": "number", "title": "Upscale Factor", "default": 2, "min": 1, "max": 4, "required": False},
                "face_enhancement": {"type": "boolean", "title": "Face Enhancement", "default": True, "required": False},
                "face_enhancement_strength": {"type": "number", "title": "Face Enhancement Strength", "default": 0.8, "min": 0, "max": 1, "required": False},
                "face_enhancement_creativity": {"type": "number", "title": "Face Enhancement Creativity", "default": 0, "min": 0, "max": 1, "required": False},
                "subject_detection": {"type": "enum", "title": "Subject Detection", "default": "All", "options": ["All","Foreground","Background"], "required": False},
                "crop_to_fill": {"type": "boolean", "title": "Crop to Fill", "default": False, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### TOPAZ SHARPEN
`topaz-sharpen` — 460 x 560 — **Kind type: `topaz_image_sharpen`** — `isModel: true`

No text prompt. Image-only input. Handle name is `image` (not `image_url`).

```python
def make_topaz_sharpen_node(node_id, name, image_ref, x, y,
                             model="Standard", face_enhancement=True, face_enhancement_strength=0.8,
                             face_enhancement_creativity=0, subject_detection="All", output_format="jpeg"):
    inputs = [
        [{"id": "image", "title": "image", "description": "Image to sharpen", "validTypes": ["image"], "required": True}, image_ref],
    ]
    input_handles = {
        "image": {"id": uid(), "type": "image", "label": "image", "order": 0, "format": "uri", "required": True, "description": "Image to sharpen"},
    }
    parameters = [
        [{"id": "model", "title": "Model", "constraint": {"type": "enum", "options": ["Standard","Strong","Lens Blur","Motion Blur","Natural","Refocus"]}, "defaultValue": {"type": "string", "value": "Standard"}},
         {"type": "value", "data": {"type": "string", "value": model}}],
        [{"id": "output_format", "title": "Output Format", "constraint": {"type": "enum", "options": ["jpeg","jpg","png","tiff","tif"]}, "defaultValue": {"type": "string", "value": "jpeg"}},
         {"type": "value", "data": {"type": "string", "value": output_format}}],
        [{"id": "subject_detection", "title": "Subject Detection", "constraint": {"type": "enum", "options": ["All","Foreground","Background"]}, "defaultValue": {"type": "string", "value": "All"}},
         {"type": "value", "data": {"type": "string", "value": subject_detection}}],
        [{"id": "face_enhancement", "title": "Face Enhancement", "constraint": {"type": "boolean"}, "defaultValue": {"type": "boolean", "value": True}},
         {"type": "value", "data": {"type": "boolean", "value": face_enhancement}}],
        [{"id": "face_enhancement_strength", "title": "Face Enhancement Strength", "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 0.8}},
         {"type": "value", "data": {"type": "float", "value": face_enhancement_strength}}],
        [{"id": "face_enhancement_creativity", "title": "Face Enhancement Creativity", "constraint": {"type": "number", "min": 0, "max": 1}, "defaultValue": {"type": "float", "value": 0}},
         {"type": "value", "data": {"type": "float", "value": face_enhancement_creativity}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Sharpened image", "dataType": "image"}]
    kind_data = {
        "type": "topaz_image_sharpen",
        "model": {"type": "predefined", "name": "topaz-sharpen", "version": "topaz-sharpen",
                  "service": "fal_imported", "description": "Topaz professional image sharpening"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Sharpened image"}}},
            "name": name, "description": "Topaz professional image sharpening", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Topaz Sharpen"},
            "model": {"name": "topaz-sharpen", "service": "fal_imported", "version": "topaz-sharpen"},
            "params": {"model": model, "output_format": output_format, "subject_detection": subject_detection, "face_enhancement": face_enhancement, "face_enhancement_strength": face_enhancement_strength, "face_enhancement_creativity": face_enhancement_creativity},
            "schema": {
                "model": {"type": "enum", "title": "Model", "default": "Standard", "options": ["Standard","Strong","Lens Blur","Motion Blur","Natural","Refocus"], "required": False},
                "output_format": {"type": "enum", "title": "Output Format", "default": "jpeg", "options": ["jpeg","jpg","png","tiff","tif"], "required": False},
                "subject_detection": {"type": "enum", "title": "Subject Detection", "default": "All", "options": ["All","Foreground","Background"], "required": False},
                "face_enhancement": {"type": "boolean", "title": "Face Enhancement", "default": True, "required": False},
                "face_enhancement_strength": {"type": "number", "title": "Face Enhancement Strength", "default": 0.8, "min": 0, "max": 1, "required": False},
                "face_enhancement_creativity": {"type": "number", "title": "Face Enhancement Creativity", "default": 0, "min": 0, "max": 1, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### TOPAZ VIDEO UPSCALER
`topaz-upscale-video` — 460 x 560 — Wildcard — `isModel: true` — **Premium (paid: 10)**

Video-only input. Simple: just upscale_factor.

```python
def make_topaz_video_upscale_node(node_id, name, video_ref, x, y, upscale_factor=2):
    inputs = [
        [{"id": "video", "title": "video", "description": "Video to upscale", "validTypes": ["video"], "required": True}, video_ref],
    ]
    input_handles = {
        "video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "required": True, "description": "Video to upscale"},
    }
    parameters = [
        [{"id": "upscale_factor", "title": "Upscale Factor", "constraint": {"type": "number", "min": 1, "max": 4}, "defaultValue": {"type": "float", "value": 2}},
         {"type": "value", "data": {"type": "float", "value": upscale_factor}}],
    ]
    outputs = [{"id": "video", "title": "video", "description": "Upscaled video", "dataType": "video"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "topaz-upscale-video", "version": "topaz-upscale-video",
                  "service": "fal_imported", "description": "Topaz professional video upscaling"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"video": {"id": uid(), "type": "video", "label": "video", "order": 0, "format": "uri", "description": "Upscaled video"}}},
            "name": name, "description": "Topaz professional video upscaling", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Topaz Video Upscaler"},
            "model": {"name": "topaz-upscale-video", "service": "fal_imported", "version": "topaz-upscale-video"},
            "paid": 10,
            "params": {"upscale_factor": upscale_factor},
            "schema": {
                "upscale_factor": {"type": "number", "title": "Upscale Factor", "default": 2, "min": 1, "max": 4, "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### MAGNIFIC SKIN ENHANCER
`fp_skin_enhancer` — 460 x 560 — Wildcard — `isModel: true`

No text prompt. Image-only input. Three methods with mode-specific params.

```python
def make_magnific_skin_node(node_id, name, image_ref, x, y,
                             method="creative", sharpen=50, smart_grain=2, skin_detail=80,
                             optimized_for="enhance_skin"):
    inputs = [
        [{"id": "image", "title": "image", "description": "Portrait image to enhance", "validTypes": ["image"], "required": True}, image_ref],
    ]
    input_handles = {
        "image": {"id": uid(), "type": "image", "label": "image", "order": 0, "format": "uri", "required": True, "description": "Portrait image to enhance"},
    }
    parameters = [
        [{"id": "method", "title": "Method", "constraint": {"type": "enum", "options": ["creative","faithful","flexible"]}, "defaultValue": {"type": "string", "value": "creative"}},
         {"type": "value", "data": {"type": "string", "value": method}}],
        [{"id": "sharpen", "title": "Sharpen", "constraint": {"type": "integer", "min": 0, "max": 100}, "defaultValue": {"type": "integer", "value": 50}},
         {"type": "value", "data": {"type": "integer", "value": sharpen}}],
        [{"id": "smart_grain", "title": "Smart Grain", "constraint": {"type": "integer", "min": 0, "max": 100}, "defaultValue": {"type": "integer", "value": 2}},
         {"type": "value", "data": {"type": "integer", "value": smart_grain}}],
        [{"id": "skin_detail", "title": "Skin Detail", "description": "Faithful mode only.",
          "constraint": {"type": "integer", "min": 0, "max": 100}, "defaultValue": {"type": "integer", "value": 80}},
         {"type": "value", "data": {"type": "integer", "value": skin_detail}}],
        [{"id": "optimized_for", "title": "Optimized For", "description": "Flexible mode only.",
          "constraint": {"type": "enum", "options": ["enhance_skin","improve_lighting","enhance_everything","transform_to_real","no_make_up"]},
          "defaultValue": {"type": "string", "value": "enhance_skin"}},
         {"type": "value", "data": {"type": "string", "value": optimized_for}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Enhanced image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fp_skin_enhancer", "version": "fp_skin_enhancer",
                  "service": "fal_imported", "description": "AI skin enhancement and retouching"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Enhanced image"}}},
            "name": name, "description": "AI skin enhancement and retouching", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Magnific Skin Enhancer"},
            "model": {"name": "fp_skin_enhancer", "service": "fal_imported", "version": "fp_skin_enhancer"},
            "params": {"method": method, "sharpen": sharpen, "smart_grain": smart_grain, "skin_detail": skin_detail, "optimized_for": optimized_for},
            "schema": {
                "method": {"type": "enum", "title": "Method", "default": "creative", "options": ["creative","faithful","flexible"], "required": False},
                "sharpen": {"type": "integer", "title": "Sharpen", "default": 50, "min": 0, "max": 100, "required": False},
                "smart_grain": {"type": "integer", "title": "Smart Grain", "default": 2, "min": 0, "max": 100, "required": False},
                "skin_detail": {"type": "integer", "title": "Skin Detail", "default": 80, "min": 0, "max": 100, "required": False, "description": "Faithful mode only"},
                "optimized_for": {"type": "enum", "title": "Optimized For", "default": "enhance_skin",
                    "options": ["enhance_skin","improve_lighting","enhance_everything","transform_to_real","no_make_up"], "required": False, "description": "Flexible mode only"}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

### MAGNIFIC UPSCALE
`fp_magnific_upscale` — 460 x 560 — Wildcard — `isModel: true`

Optional prompt input (reuse generation prompt for best results). Up to 8x. Creativity/HDR/Resemblance/Fractality sliders.

```python
def make_magnific_upscale_node(node_id, name, image_ref, prompt_ref, x, y,
                                scale_factor="2x", optimized_for="standard", creativity=0, hdr=0,
                                resemblance=0, fractality=0, engine="automatic"):
    inputs = [
        [{"id": "image", "title": "image", "description": "Image to upscale", "validTypes": ["image"], "required": True}, image_ref],
        [{"id": "prompt", "title": "Prompt", "description": "Optional: reuse generation prompt for guided upscale", "validTypes": ["text"], "required": False}, prompt_ref],
    ]
    input_handles = {
        "image": {"id": uid(), "type": "image", "label": "image", "order": 0, "format": "uri", "required": True, "description": "Image to upscale"},
        "prompt": {"id": uid(), "type": "text", "label": "prompt", "order": 1, "format": "text", "required": False, "description": "Optional: reuse generation prompt for guided upscale"},
    }
    parameters = [
        [{"id": "scale_factor", "title": "Scale Factor", "constraint": {"type": "enum", "options": ["2x","4x","8x"]}, "defaultValue": {"type": "string", "value": "2x"}},
         {"type": "value", "data": {"type": "string", "value": scale_factor}}],
        [{"id": "optimized_for", "title": "Optimized For",
          "constraint": {"type": "enum", "options": ["standard","soft_portraits","hard_portraits","art_n_illustration","videogame_assets","nature_n_landscapes","films_n_photography","3d_renders","science_fiction_n_horror"]},
          "defaultValue": {"type": "string", "value": "standard"}},
         {"type": "value", "data": {"type": "string", "value": optimized_for}}],
        [{"id": "creativity", "title": "Creativity", "constraint": {"type": "integer", "min": -10, "max": 10}, "defaultValue": {"type": "integer", "value": 0}},
         {"type": "value", "data": {"type": "integer", "value": creativity}}],
        [{"id": "hdr", "title": "HDR", "constraint": {"type": "integer", "min": -10, "max": 10}, "defaultValue": {"type": "integer", "value": 0}},
         {"type": "value", "data": {"type": "integer", "value": hdr}}],
        [{"id": "resemblance", "title": "Resemblance", "constraint": {"type": "integer", "min": -10, "max": 10}, "defaultValue": {"type": "integer", "value": 0}},
         {"type": "value", "data": {"type": "integer", "value": resemblance}}],
        [{"id": "fractality", "title": "Fractality", "constraint": {"type": "integer", "min": -10, "max": 10}, "defaultValue": {"type": "integer", "value": 0}},
         {"type": "value", "data": {"type": "integer", "value": fractality}}],
        [{"id": "engine", "title": "Engine", "constraint": {"type": "enum", "options": ["automatic","magnific_illusio","magnific_sharpy","magnific_sparkle"]}, "defaultValue": {"type": "string", "value": "automatic"}},
         {"type": "value", "data": {"type": "string", "value": engine}}],
    ]
    outputs = [{"id": "result", "title": "result", "description": "Upscaled image", "dataType": "image"}]
    kind_data = {
        "type": "wildcard",
        "model": {"type": "predefined", "name": "fp_magnific_upscale", "version": "fp_magnific_upscale",
                  "service": "fal_imported", "description": "AI-powered creative upscaling"},
        "inputs": inputs, "parameters": parameters, "outputs": outputs
    }
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "custommodelV2",
        "visibility": None, "isModel": True,
        "data": {
            "handles": {"input": input_handles, "output": {"result": {"id": uid(), "type": "image", "label": "result", "order": 0, "format": "uri", "description": "Upscaled image"}}},
            "name": name, "description": "AI-powered creative upscaling", "color": "Red",
            "label": None,
            "menu": {"icon": "EmojiObjectsIcon", "isModel": True, "displayName": "Magnific Upscale"},
            "model": {"name": "fp_magnific_upscale", "service": "fal_imported", "version": "fp_magnific_upscale"},
            "params": {"scale_factor": scale_factor, "optimized_for": optimized_for, "creativity": creativity, "hdr": hdr, "resemblance": resemblance, "fractality": fractality, "engine": engine},
            "schema": {
                "scale_factor": {"type": "enum", "title": "Scale Factor", "default": "2x", "options": ["2x","4x","8x"], "required": False},
                "optimized_for": {"type": "enum", "title": "Optimized For", "default": "standard",
                    "options": ["standard","soft_portraits","hard_portraits","art_n_illustration","videogame_assets","nature_n_landscapes","films_n_photography","3d_renders","science_fiction_n_horror"], "required": False},
                "creativity": {"type": "integer", "title": "Creativity", "default": 0, "min": -10, "max": 10, "required": False},
                "hdr": {"type": "integer", "title": "HDR", "default": 0, "min": -10, "max": 10, "required": False},
                "resemblance": {"type": "integer", "title": "Resemblance", "default": 0, "min": -10, "max": 10, "required": False},
                "fractality": {"type": "integer", "title": "Fractality", "default": 0, "min": -10, "max": 10, "required": False},
                "engine": {"type": "enum", "title": "Engine", "default": "automatic", "options": ["automatic","magnific_illusio","magnific_sharpy","magnific_sparkle"], "required": False}
            },
            "version": 3, "kind": kind_data,
            "generations": [], "selectedIndex": 0, "cameraLocked": False,
            "result": [], "output": {}, "selectedOutput": 0
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 560
    }
```

---

### KLING ELEMENT
`type: "kling_element"` — 460 x 507 — Color `#000000` — `visibility: "public"`

```python
def make_kling_element_node(node_id, name, x, y):
    return {
        "id": node_id, "type": "kling_element",
        "data": {
            "version": 3, "color": "#000000",
            "description": "Provide structured element data for the Kling model",
            "type": "kling_element", "name": name,
            "handles": {
                "input": {
                    "frontal_image_url": {"id": "frontal_image_url", "type": "image", "label": "Frontal Image", "format": "uri", "order": 0, "required": True, "description": "Frontal image URL"},
                    "reference_image_url1": {"id": "reference_image_url1", "type": "image", "label": "Reference Image 1", "format": "uri", "order": 1, "required": True, "description": "Reference image URL"},
                    "reference_image_url2": {"id": "reference_image_url2", "type": "image", "label": "Reference Image 2", "format": "uri", "order": 2, "required": False, "description": "Reference image URL"},
                    "reference_image_url3": {"id": "reference_image_url3", "type": "image", "label": "Reference Image 3", "format": "uri", "order": 3, "required": False, "description": "Reference image URL"}
                },
                "output": {"result": {"id": "result", "type": "kling-element", "label": "Kling Element", "format": "uri", "order": 0, "required": False, "description": "Kling element data"}}
            }
        },
        "isModel": False, "owner": None, "visibility": "public", "locked": False,
        "position": {"x": x, "y": y},
        "createdAt": NOW, "selected": False, "width": 460, "height": 507
    }
```

---

## CONTROL NODES

### ROUTER
`type: "router"` — 250 x 64 — No root `kind`

```python
def make_router_node(node_id, name, x, y):
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "router",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {
                "input": {"in": {"id": uid(), "type": "any", "label": "In", "order": 0, "description": "The input"}},
                "output": {"out": {"id": uid(), "type": "any", "label": "Out", "order": 0, "description": "The output"}}
            },
            "name": name, "description": None, "color": "Yambo_Orange", "label": None, "menu": None, "params": None, "schema": None, "version": 3,
            "dark_color": "Yambo_Orange_Dark", "border_color": "Yambo_Orange_Stroke", "output": {}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 250, "height": 64
    }
```

### ARRAY
`type: "array"` — 460 x 230 (static) / 460 x 278 (dynamic) — No root `kind`

```python
def make_array_node(node_id, name, delimiter, input_ref, x, y):
    """Dynamic array — splits incoming text by delimiter."""
    data = {
        "handles": {
            "input": {"text": {"id": uid(), "type": "text", "order": 0, "format": "text", "required": False, "description": "Text to split into array"}},
            "output": {"array": {"id": uid(), "type": "array", "order": 0, "format": "text", "description": "Array of text items"}}
        },
        "name": name, "description": "Array of elements", "color": "Yambo_Green",
        "label": None, "menu": None, "params": None, "schema": None, "version": 3,
        "array": [""], "result": [], "delimiter": delimiter,
        "dark_color": "Yambo_Green_Dark", "border_color": "Yambo_Green_Stroke",
        "output": {"type": "array", "array": []}
    }
    if input_ref:
        data["inputNode"] = input_ref
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "array",
        "visibility": None, "isModel": False, "data": data,
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 278
    }

def make_static_array_node(node_id, name, items, delimiter, x, y):
    """Static array — fixed list of values."""
    return {
        "id": node_id, "dragHandle": ".node-header", "owner": None, "type": "array",
        "visibility": None, "isModel": False,
        "data": {
            "handles": {
                "input": {"text": {"id": uid(), "type": "text", "order": 0, "format": "text", "required": False, "description": "Text to split into array"}},
                "output": {"array": {"id": uid(), "type": "array", "order": 0, "format": "text", "description": "Array of text items"}}
            },
            "name": name, "description": "Array of elements", "color": "Yambo_Green",
            "label": None, "menu": None, "params": None, "schema": None, "version": 3,
            "array": items, "result": items, "delimiter": delimiter,
            "dark_color": "Yambo_Green_Dark", "border_color": "Yambo_Green_Stroke",
            "output": {"type": "array", "array": items}
        },
        "createdAt": NOW, "updatedAt": UPD, "locked": False,
        "position": {"x": x, "y": y},
        "selected": False, "width": 460, "height": 230
    }
```

### LIST SELECTOR
`type: "muxv2"` — 250 x 102 — No root `kind` — No `dragHandle` — `visibility: "public"`

`isIterator: true` triggers downstream for EACH element.

```python
def make_list_selector_node(node_id, name, options_ref, is_iterator, x, y):
    return {
        "id": node_id, "type": "muxv2",
        "data": {
            "version": 3, "description": "Select an option from a list", "type": "list_selector",
            "name": name,
            "handles": {
                "input": {"options": {"id": uid(), "type": "array", "label": "Options", "format": "array", "required": False, "order": 0, "description": "Array of options to choose from"}},
                "output": {"option": {"id": uid(), "type": "text", "label": "Text", "order": 0, "format": "text", "description": "The selected option", "required": False}}
            },
            "options": options_ref, "delimiter": ",", "list": [], "selected": 0,
            "schema": {"options": {"order": 0, "type": "array", "title": "Options", "exposed": True, "required": False, "description": "Array of options to choose from"}},
            "isIterator": is_iterator, "color": "Yambo_Green",
            "result": "", "output": {"type": "text", "option": ""}, "params": {"options": []}
        },
        "isModel": False, "owner": None, "visibility": "public", "locked": False,
        "position": {"x": x, "y": y},
        "createdAt": NOW,
        "selected": False, "width": 250, "height": 102
    }
```

---

## FEEDBACK LOOP HELPERS

### build_image_feedback_loop

Generates the nodes and edges for Pattern N (Image Feedback Loop). Returns a list of nodes and edges to append to your workflow. Requires a reference image routed through a Router upstream.

```python
def build_image_feedback_loop(router_id, brief_text, system_prompt_text, x_start, y_start,
                               image_model="nb_pro", resolution="1K", aspect_ratio="auto"):
    """
    Builds Pattern N: Image Feedback Loop.
    
    router_id: ID of the upstream Router that provides the reference image
    brief_text: the original creative brief text
    system_prompt_text: IMAGE REFINER system prompt (from CREATIVE-ROLES.md)
    x_start, y_start: top-left position for the feedback loop block
    image_model: "nb_pro" or "flux" — which image model to use
    
    Returns: (nodes, edges, node_ids)
        node_ids is a dict with keys: brief, feedback, concat, sys_prompt, refiner, image_model
    """
    # Node IDs
    ids = {
        "brief": uid(),
        "feedback": uid(),
        "concat": uid(),
        "sys_prompt": uid(),
        "refiner": uid(),
        "image_model": uid(),
    }
    
    nodes = []
    edges = []
    
    # Column 1: Text inputs (x_start)
    nodes.append(make_string_node(ids["brief"], "ORIGINAL BRIEF", brief_text, x_start, y_start))
    nodes.append(make_string_node(ids["feedback"], "USER FEEDBACK", "", x_start, y_start + 400))
    
    # Column 2: Concat (x_start + 600)
    concat_refs = [
        ("prompt1", {"nodeId": ids["brief"], "outputId": "text", "string": ""}),
        ("prompt2", {"nodeId": ids["feedback"], "outputId": "text", "string": ""}),
    ]
    nodes.append(make_concat_node(ids["concat"], "FEEDBACK CONCAT", concat_refs, x_start + 600, y_start + 100,
                                  additional_prompt="Below is the original creative brief followed by the user's iteration feedback."))
    
    # Column 2: System prompt
    nodes.append(make_string_node(ids["sys_prompt"], "IMAGE REFINER SYSTEM PROMPT", system_prompt_text,
                                  x_start + 600, y_start + 500))
    
    # Column 3: LLM Refiner (x_start + 1200)
    prompt_ref = {"nodeId": ids["concat"], "outputId": "prompt", "string": ""}
    sys_ref = {"nodeId": ids["sys_prompt"], "outputId": "text", "string": ""}
    image_refs = [["image", {"nodeId": router_id, "outputId": "out", "file": {}}]]
    refiner_node = make_llm_node(ids["refiner"], "IMAGE REFINER", "anthropic/claude-sonnet-4-5",
                                prompt_ref, sys_ref, image_refs, x_start + 1200, y_start + 200)
    refiner_node["data"]["kind"]["temperature"]["data"]["value"] = 0.3
    refiner_node["data"]["params"]["temperature"] = 0.3
    nodes.append(refiner_node)
    
    # Column 4: Image Model (x_start + 1800)
    refiner_ref = {"nodeId": ids["refiner"], "outputId": "text", "string": ""}
    router_img_ref = {"nodeId": router_id, "outputId": "out", "file": {}}
    if image_model == "nb_pro":
        nodes.append(make_nb_pro_node(ids["image_model"], "IMAGE OUTPUT", refiner_ref, router_img_ref,
                                       x_start + 1800, y_start + 200, resolution=resolution, aspect_ratio=aspect_ratio))
    else:
        nodes.append(make_flux_pro_node(ids["image_model"], "IMAGE OUTPUT", refiner_ref, router_img_ref,
                                         x_start + 1800, y_start + 200))
    
    # Edges
    # Brief → Concat
    edges.append(make_edge(ids["brief"], ids["concat"], "text", "prompt1",
                           "Yambo_Green", "Yambo_Green", "text", "text"))
    # Feedback → Concat
    edges.append(make_edge(ids["feedback"], ids["concat"], "text", "prompt2",
                           "Yambo_Green", "Yambo_Green", "text", "text"))
    # Concat → Refiner (prompt)
    edges.append(make_edge(ids["concat"], ids["refiner"], "prompt", "prompt",
                           "Yambo_Green", "Yambo_Purple", "text", "text"))
    # System prompt → Refiner
    edges.append(make_edge(ids["sys_prompt"], ids["refiner"], "text", "system_prompt",
                           "Yambo_Green", "Yambo_Purple", "text", "text"))
    # Router → Refiner (image)
    edges.append(make_edge(router_id, ids["refiner"], "out", "image",
                           "Yambo_Orange", "Yambo_Purple", "any", "image"))
    # Refiner → Image Model (prompt)
    edges.append(make_edge(ids["refiner"], ids["image_model"], "text", "prompt",
                           "Yambo_Purple", "Red", "text", "text"))
    # Router → Image Model (image_1)
    edges.append(make_edge(router_id, ids["image_model"], "out", "image_1",
                           "Yambo_Orange", "Red", "any", "image"))
    
    return nodes, edges, ids
```

### build_video_feedback_loop

Generates the nodes and edges for Pattern Q (Video Feedback Loop). Returns a list of nodes and edges to append to your workflow. The first frame must come from upstream (file upload, router, or image model output).

```python
def build_video_feedback_loop(first_frame_id, first_frame_output, first_frame_type, motion_brief_text,
                               system_prompt_text, x_start, y_start,
                               kling_model="3.0 Pro", duration=5, cfg_scale=0.5, aspect_ratio="16:9"):
    """
    Builds Pattern Q: Video Feedback Loop.
    
    first_frame_id: ID of the node providing the first frame
    first_frame_output: output handle name of that node ("out" for Router, "result" for NB/Flux, "file" for File)
    first_frame_type: edge source type ("any" for Router, "image" for model)
    motion_brief_text: the original motion/video brief text
    system_prompt_text: MOTION REFINER system prompt (from CREATIVE-ROLES.md)
    x_start, y_start: top-left position for the feedback loop block
    
    Returns: (nodes, edges, node_ids)
        node_ids is a dict with keys: motion_brief, video_feedback, concat, sys_prompt, refiner, neg_prompt, kling
    """
    ids = {
        "motion_brief": uid(),
        "video_feedback": uid(),
        "concat": uid(),
        "sys_prompt": uid(),
        "refiner": uid(),
        "neg_prompt": uid(),
        "kling": uid(),
    }
    
    nodes = []
    edges = []
    
    # Build the first frame reference
    frame_ref = {"nodeId": first_frame_id, "outputId": first_frame_output, "file": {}}
    
    # Column 1: Text inputs (x_start)
    nodes.append(make_string_node(ids["motion_brief"], "MOTION BRIEF", motion_brief_text, x_start, y_start))
    nodes.append(make_string_node(ids["video_feedback"], "VIDEO FEEDBACK", "", x_start, y_start + 400))
    nodes.append(make_string_node(ids["neg_prompt"], "NEGATIVE PROMPT", "", x_start, y_start + 800))
    
    # Column 2: Concat (x_start + 600)
    concat_refs = [
        ("prompt1", {"nodeId": ids["motion_brief"], "outputId": "text", "string": ""}),
        ("prompt2", {"nodeId": ids["video_feedback"], "outputId": "text", "string": ""}),
    ]
    nodes.append(make_concat_node(ids["concat"], "VIDEO FEEDBACK CONCAT", concat_refs, x_start + 600, y_start + 100,
                                  additional_prompt="Below is the original motion brief followed by the user's iteration feedback."))
    
    # Column 2: System prompt
    nodes.append(make_string_node(ids["sys_prompt"], "MOTION REFINER SYSTEM PROMPT", system_prompt_text,
                                  x_start + 600, y_start + 500))
    
    # Column 3: LLM Motion Refiner (x_start + 1200)
    prompt_ref = {"nodeId": ids["concat"], "outputId": "prompt", "string": ""}
    sys_ref = {"nodeId": ids["sys_prompt"], "outputId": "text", "string": ""}
    refiner_node = make_llm_node(ids["refiner"], "MOTION REFINER", "anthropic/claude-sonnet-4-5",
                                prompt_ref, sys_ref, [["image", None]], x_start + 1200, y_start + 200)
    refiner_node["data"]["kind"]["temperature"]["data"]["value"] = 0.3
    refiner_node["data"]["params"]["temperature"] = 0.3
    nodes.append(refiner_node)
    
    # Column 4: Kling (x_start + 1800)
    kling_prompt_ref = {"nodeId": ids["refiner"], "outputId": "text", "string": ""}
    neg_ref = {"nodeId": ids["neg_prompt"], "outputId": "text", "string": ""}
    nodes.append(make_kling_node(ids["kling"], "VIDEO OUTPUT", kling_prompt_ref, frame_ref, None, neg_ref, [],
                                  x_start + 1800, y_start + 200,
                                  kling_model=kling_model, duration=duration, cfg_scale=cfg_scale, aspect_ratio=aspect_ratio))
    
    # Edges
    # Motion Brief → Concat
    edges.append(make_edge(ids["motion_brief"], ids["concat"], "text", "prompt1",
                           "Yambo_Green", "Yambo_Green", "text", "text"))
    # Video Feedback → Concat
    edges.append(make_edge(ids["video_feedback"], ids["concat"], "text", "prompt2",
                           "Yambo_Green", "Yambo_Green", "text", "text"))
    # Concat → Refiner (prompt)
    edges.append(make_edge(ids["concat"], ids["refiner"], "prompt", "prompt",
                           "Yambo_Green", "Yambo_Purple", "text", "text"))
    # System prompt → Refiner
    edges.append(make_edge(ids["sys_prompt"], ids["refiner"], "text", "system_prompt",
                           "Yambo_Green", "Yambo_Purple", "text", "text"))
    # Refiner → Kling (prompt)
    edges.append(make_edge(ids["refiner"], ids["kling"], "text", "prompt",
                           "Yambo_Purple", "Red", "text", "text"))
    # First frame → Kling (image)
    edges.append(make_edge(first_frame_id, ids["kling"], first_frame_output, "image",
                           "Yambo_Orange" if first_frame_type == "any" else "Red", "Red",
                           first_frame_type, "image"))
    # Negative prompt → Kling
    edges.append(make_edge(ids["neg_prompt"], ids["kling"], "text", "negative_prompt",
                           "Yambo_Green", "Red", "text", "text"))
    
    return nodes, edges, ids
```

---

## LAYOUT NODES

### GROUP
`type: "custom_group"` — Children: `parentId` = group ID, **relative** positions

```python
def make_group_node(group_id, name, x, y, width, height):
    return {
        "id": group_id, "type": "custom_group",
        "data": {
            "version": 3, "color": "rgba(227, 232, 236, 0.64)",
            "description": "Group of nodes", "type": "custom_group",
            "name": name,
            "handles": {"input": [], "output": []},
            "width": width, "height": height, "labelFontSize": 16
        },
        "position": {"x": x, "y": y},
        "locked": False, "selected": False,
        "width": width, "height": height
    }
# For each child: node["parentId"] = group_id
# Child positions are RELATIVE to group top-left
```
