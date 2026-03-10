# Design: adopt-tldr-best-ideas

## Approach
- Introduce a lightweight file-backed daemon controller in `src/daemon.rs`.
- Keep daemon state under `bakes/latest/daemon/`:
  - `daemon.pid` for lifecycle coordination
  - `state.json` for status/counters
  - `notify.queue` for changed-file ingestion
- Use existing engine primitives:
  - `engine::util::reindex_files` for incremental AST updates
  - `engine::embed::build_embeddings` for semantic index refresh
- Favor reliability and compatibility over advanced IPC in phase 1.

## Implementation Notes
- `warm` flow:
  1. Run `engine::bake`.
  2. Start daemon unless `--no-daemon`.
  3. Return combined JSON payload.
- `daemon notify` flow:
  1. Append file path to queue.
  2. If daemon is running: return queued status.
  3. If daemon is offline: perform inline reindex + embeddings rebuild as fallback.
- `daemon-run` worker:
  - Poll queue on interval.
  - Deduplicate dirty files.
  - Flush on threshold (default 20) or idle timeout.
  - Persist state each loop for observability.
- MCP integration mirrors CLI surface to keep agent behavior aligned.

## Risks
- Stale pid file after hard crashes: handled by `kill -0` liveness checks and stale cleanup on start/status.
- Queue growth under heavy write load: mitigated by truncating queue after flush.
- Inline fallback cost when daemon is off: acceptable for phase 1; optimize with per-file embedding upserts in phase 2.
- Rollback is straightforward: remove daemon commands and keep `bake` as single indexing path.
