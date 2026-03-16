---
name: google-cli
description: Google Workspace operations expert using the gws CLI
---
# Google Workspace CLI (gws)

This skill provides access to Google Workspace services (Calendar, Drive, Gmail, etc.) via the `gws` CLI.

## Authentication
The CLI is pre-authenticated using environment variables:
- `GOOGLE_WORKSPACE_CLI_TOKEN`: The OAuth2 access token.
- `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE`: Path to the credentials JSON file.

## Usage
Use `shell_exec` to run `gws` commands.

### Examples

**List calendar events:**
```bash
gws calendar events list
```

**List files in Drive:**
```bash
gws drive files list
```

**Send an email:**
```bash
gws gmail messages send --to user@example.com --subject "Hello" --body "Message body"
```

**Check for new emails:**
```bash
gws gmail messages list --query "is:unread"
```

Always check the help for available commands:
```bash
gws --help
gws calendar --help
```
