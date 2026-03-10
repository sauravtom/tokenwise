# Proposal: adopt-tldr-best-ideas

## Why
- tokenwise already has AST indexing, call graph, and semantic search, but the developer workflow still relies on manual rebakes.
- We want TLDR-like ergonomics: one warm command, fast follow-up queries, and explicit daemon lifecycle commands for incremental freshness.
- This change improves real-world edit loops for both CLI users and MCP agents.

## What Changes
- Add `warm` command that runs `bake` and starts daemon by default.
- Add daemon lifecycle commands: `daemon start|stop|status|notify`.
- Add internal daemon worker loop (`daemon-run`) that batches dirty files and performs incremental reindex + embedding refresh.
- Expose equivalent MCP tools: `warm`, `daemon_start`, `daemon_stop`, `daemon_status`, `daemon_notify`.
- Update README onboarding to prefer `warm` and show daemon notify usage.

## Success Criteria
- `tokenwise warm --path <project>` builds indexes and reports daemon startup status.
- `tokenwise daemon notify --file <path>` queues change events when daemon is running and performs inline fallback when not.
- `tokenwise daemon status` shows running state, queue depth, and reindex counters.
- Existing commands and MCP tool behavior remain backward compatible.
