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
