# OpenRSSGate

OpenRSSGate is a public RSS source index for developers, AI tool builders, and vibe coders.
It collects source metadata and recent feed metadata, then exposes the same index through a web UI, REST API, MCP server, and CLI.

## Why This Exists

RSS is still the simplest open format for discovering writing on the web, but the ecosystem is fragmented.
OpenRSSGate exists to make RSS sources easier to find, validate, index, and query from both software and AI tools.

This project is not a personal feed reader.
It is a shared source-and-feed metadata layer that other products, scripts, agents, and interfaces can build on top of.

## Who It Is For

- Developers building apps on top of RSS metadata
- AI and MCP tool builders who want structured source and feed access
- CLI-heavy users who prefer terminal workflows over browser UIs
- Contributors who want to improve source quality, indexing, and open web discovery

## Core Capabilities

- Public source index with language, type, category, and tag metadata
- Recent feed metadata collection and search
- Anonymous source registration with validation and moderation flows
- REST API for apps and scripts
- MCP server for agent tools and LLM clients
- CLI for search, feeds lookup, stats, and validation

## Interfaces

### Web

- Public website: [`https://openrssgate.vercel.app/`](https://openrssgate.vercel.app/)
- Browse indexed sources
- Register new RSS sources
- Check public stats

### REST API

- Base URL: `https://openrssgate-production.up.railway.app/v1`
- Example endpoints:
  - `GET /sources`
  - `GET /sources/{source_id}`
  - `GET /feeds`
  - `GET /feeds/{feed_id}`
  - `GET /stats`
  - `POST /sources/validate`

### MCP

- Remote MCP endpoint: `https://openrssgate-production.up.railway.app/mcp`
- Legacy SSE debug endpoint: `https://openrssgate-production.up.railway.app/mcp/sse`
- Tool manifest: `https://openrssgate-production.up.railway.app/mcp/tools`

Typical MCP tools include:

- `search_sources`
- `get_source`
- `get_source_status`
- `get_stats`
- `get_recent_feeds`
- `list_feeds`
- `get_feed`
- `get_source_feeds`
- `validate_source`
- `autofill_source`
- `create_source`

### CLI

- PyPI: `pipx install openrssgate`
- Homebrew: `brew tap windbug99/homebrew-tap && brew install openrssgate`
- Preferred command: `org`
- Backward-compatible alias: `openrssgate`

Example:

```bash
org list --keyword platformer
org feeds --q openai --since 7d
org stats
org validate https://example.com/rss.xml
```

## Quick Start

### Use The Public Service

```bash
curl https://openrssgate-production.up.railway.app/v1/stats
curl "https://openrssgate-production.up.railway.app/v1/sources?limit=5"
```

If you want to use the CLI against the public API:

```bash
pipx install openrssgate
org list --keyword ai
```

### Run Locally

1. Start the backend API in [`backend/README.md`](backend/README.md)
2. Start the collector worker in [`backend/README.md`](backend/README.md)
3. Start the frontend in [`frontend/README.md`](frontend/README.md)
4. Use the CLI from [`cli/README.md`](cli/README.md)

If you want the CLI to target your local backend instead of the deployed API:

```bash
export OPENRSSGATE_API_BASE_URL=http://127.0.0.1:8000/v1
org list
```

## Architecture

OpenRSSGate is split into a few focused parts:

- `frontend/`: Next.js public website and admin UI
- `backend/`: FastAPI API, MCP server, source validation, moderation, and collector services
- `cli/`: Python CLI published as `openrssgate`, with `org` as the preferred command
- `docs/`: deployment, MCP setup, and planning docs

The backend stores source records, validates RSS URLs, collects feed metadata, and serves the same dataset to the web UI, API clients, MCP clients, and CLI users.

## Contribution Paths

Contributions do not need to start with large feature PRs.
Focused improvements are more useful.

- Report bugs in API responses, indexing, validation, or UI flows
- Propose features for REST, MCP, CLI, admin tooling, or source moderation
- Submit targeted PRs to `frontend/`, `backend/`, `cli/`, or `docs/`
- Improve docs, examples, and onboarding for API and MCP users
- Improve source quality, metadata classification, and feed handling
- Add example workflows for agents, Claude Desktop, Cursor, or shell scripts
- Improve tests, smoke checks, and operational tooling

For larger changes, open an issue first so the scope and interface can be aligned before implementation.

## Documentation Index

- Frontend: [`frontend/README.md`](frontend/README.md)
- Backend: [`backend/README.md`](backend/README.md)
- CLI: [`cli/README.md`](cli/README.md)
- Remote MCP setup: [`docs/claude-desktop-mcp.md`](docs/claude-desktop-mcp.md)
- Local stdio MCP setup: [`docs/claude-desktop-local-mcp.md`](docs/claude-desktop-local-mcp.md)

## Current Scope And Non-Goals

OpenRSSGate focuses on public source and feed metadata.
It does not aim to be a full reader product.

Non-goals for this repository include:

- Personal subscriptions and accounts
- Read state, bookmarks, and folders
- Full-content storage and reader UX
- AI summaries, translation, and recommendation features
- Billing and paid plan management

## License

This project is licensed under the MIT License.
See [`LICENSE`](LICENSE).
