# Agent.md

## 1. Deployment Configuration

### Target Space
- **Profile:** `harvesthealth`
- **Space:** `browser-use-webui`
- **Full Identifier:** `harvesthealth/browser-use-webui`
- **Frontend Port:** `7860` (mandatory for all Hugging Face Spaces)

### Deployment Method
Choose the correct SDK based on the app type based on the codebase language:

- **Docker SDK** — recommended default for flexibility (used for this Rust application)

### HF Token
- The environment variable **`HF_TOKEN` will always be provided at execution time**.
- Never hardcode the token. Always read it from the environment.
- All monitoring and log‑streaming commands rely on `HF_TOKEN`.

### Required Files
- `Dockerfile`
- `README.md` with Hugging Face YAML frontmatter:
  ```yaml
  ---
  title: OpenFang
  sdk: docker
  app_port: 7860
  ---
  ```
- `.hfignore` to exclude unnecessary files
- This `Agent.md` file (must be committed before deployment)

---

## 2. API Exposure and Documentation

### Mandatory Endpoints
Every deployment **must** expose:

- **`/health`**
  - Returns HTTP 200 when the app is ready.
  - Required for Hugging Face to transition the Space from *starting* → *running*.

- **`/api-docs`**
  - Documents **all** available API endpoints.
  - Must be reachable at:
    `https://harvesthealth-browser-use-webui.hf.space/api-docs`

### Functional Endpoints

### /health
- Method: GET
- Purpose: Health check
- Response Example:
  ```json
  {
    "status": "ok",
    "version": "0.1.0"
  }
  ```

### /api-docs
- Method: GET
- Purpose: API documentation
- Response Example:
  ```json
  {
    "endpoints": [
      { "method": "GET", "path": "/health", "purpose": "Health check" },
      { "method": "GET", "path": "/api-docs", "purpose": "API documentation" }
    ]
  }
  ```

### /api/agents
- Method: GET
- Purpose: List all agents
- Response Example: JSON array of agent objects

### /api/agents
- Method: POST
- Purpose: Spawn a new agent
- Request Example:
  ```json
  {
    "manifest_toml": "name = 'my-agent'..."
  }
  ```

### /api/agents/:id/message
- Method: POST
- Purpose: Send a message to an agent
- Request Example:
  ```json
  {
    "message": "hello world"
  }
  ```

### /api/status
- Method: GET
- Purpose: Kernel status and basic metrics

All endpoints listed here **must** appear in `/api-docs`.

---

## 3. Deployment Workflow

### Standard Deployment Command
After any code change, run:

```bash
hf upload harvesthealth/browser-use-webui --repo-type=space
```

This command must be executed **after updating and committing Agent.md**.

### Deployment Steps
1. Ensure all code changes are committed.
2. Ensure `Agent.md` is updated and committed.
3. Run the upload command.
4. Wait for the Space to build.
5. Monitor logs (see next section).
6. When the Space is running, execute all test cases.

### Continuous Deployment Rule
After **every** relevant edit (logic, dependencies, API changes):

- Update `Agent.md`
- Redeploy using the upload command
- Re-run all test cases
- Confirm `/health` and `/api-docs` are functional

This applies even for long-running projects.

---

## 4. Monitoring and Logs

### Build Logs (SSE)
```bash
curl -N \
  -H "Authorization: Bearer $HF_TOKEN" \
  "https://huggingface.co/api/spaces/harvesthealth/browser-use-webui/logs/build"
```

### Run Logs (SSE)
```bash
curl -N \
  -H "Authorization: Bearer $HF_TOKEN" \
  "https://huggingface.co/api/spaces/harvesthealth/browser-use-webui/logs/run"
```

### Notes
- If the Space stays in *starting* for too long, `/health` is usually failing.
- If the Space times out after ~30 minutes, check logs immediately.
- Fix issues, commit changes, redeploy.

---

## 5. Test Run Cases (Mandatory After Every Deployment)

These tests ensure the agentic system can verify the deployment automatically.

### 1. Health Check
```
GET https://harvesthealth-browser-use-webui.hf.space/health
Expected: HTTP 200, body: {"status": "ok"} or similar
```

### 2. API Docs Check
```
GET https://harvesthealth-browser-use-webui.hf.space/api-docs
Expected: HTTP 200, valid documentation UI or JSON spec
```

### 3. Functional Endpoint Tests

#### List Agents
```
GET https://harvesthealth-browser-use-webui.hf.space/api/agents
Expected: HTTP 200, JSON array
```

#### Kernel Status
```
GET https://harvesthealth-browser-use-webui.hf.space/api/status
Expected: HTTP 200, JSON with "status": "running"
```

### 4. End-to-End Behaviour
- Confirm the UI loads at the Space root URL.
- Confirm API endpoints respond within reasonable time.
- Confirm no errors appear in run logs.

---

## 6. Maintenance Rules

- `Agent.md` must always reflect the **current** deployment configuration, API surface, and test cases.
- Any change to:
  - API routes
  - Dockerfile
  - Dependencies
  - App logic
  - Deployment method
  requires updating this file.
- This file must be committed **before** every deployment.
- This file is the operational contract for autonomous agents interacting with the project.
