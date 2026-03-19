---
name: dot-do-ai
description: Business-as-Code semantic CLI for managing business data and knowledge
---
# dot-do AI Business-as-Code

This skill provides a semantic interface for managing business information using the `$.Subject.predicate.Object` pattern. It integrates with Cognee RAG for persistent knowledge storage.

## Usage
The `do` CLI (wrapped from dot-do/ai) allows you to perform semantic operations.

### Business Information Management
Use semantic commands to save and retrieve business data.

**Save Business Info:**
```bash
do db create Business '{"name": "My Business", "description": "AI-driven health platform"}'
```

**Relate to User:**
```bash
do db relate Business:my-business $.ownedBy Person:user-id
```

### Cognee Integration
When saving information about the business, the agent should also "cognify" it to ensure it is indexed in the RAG system.

**Store and Index:**
```bash
# 1. Save to business database
do db create Place '{"name": "Office", "address": "123 AI Lane"}'

# 2. Cognify for RAG (using Cognee MCP tool)
# (The agent will automatically call mcp_cognee_Cognify_and_search if configured)
```

## Core Patterns
- `$.Organization.owns.Brand`
- `$.Person.worksFor.Organization`
- `$.Product.category.Category`

Always prefer structured semantic storage for business-critical data.
