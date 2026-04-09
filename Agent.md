# OpenFang Agent OS - Operational Guidelines

## Configuration
- Default API Port: 7860
- Bind Address: 0.0.0.0
- Home Directory: `/app/data`
- User: `user` (UID 1000)

## API Surface
- `/health`: GET - System health status (Alias for `/api/health`)
- `/api-docs`: GET - API documentation and endpoint list
- `/api/status`: GET - Kernel and agent status
- `/api/version`: GET - Build and version info
- `/api/agents`: GET - List agents, POST - Spawn agent
- `/api/agents/:id/message`: POST - Send message to agent
- `/api/models`: GET - List available models

## Deployment Checklist
1. Ensure `Cargo.toml` and `Cargo.lock` are NOT ignored by `.hfignore`.
2. Verify `Dockerfile` uses port 7860 and sets up user 1000.
3. Confirm `/health` and `/api-docs` endpoints are implemented.
4. Relocate `agents` and `skills` to subdirectories of `/app/data` to match the kernel's configuration.
5. Set up necessary environment variables (e.g., `HF_TOKEN`) in the Space settings.

## Test Cases
- Health Check: `curl -f http://localhost:7860/health` should return HTTP 200.
- API Documentation: `curl -f http://localhost:7860/api-docs` should return JSON metadata.
- Agent Listing: `curl -f http://localhost:7860/api/agents` should return an array of agents.
