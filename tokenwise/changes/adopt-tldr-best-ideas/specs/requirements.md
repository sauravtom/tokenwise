# Requirements: adopt-tldr-best-ideas

## Requirements
- The CLI SHALL provide `warm` as a first-class command that performs bake and daemon startup in one call.
- The CLI SHALL provide daemon lifecycle subcommands: `start`, `stop`, `status`, and `notify`.
- The daemon SHALL maintain queue/state artifacts under `bakes/latest/daemon/`.
- The daemon SHALL process dirty files incrementally and refresh semantic embeddings after flush.
- `daemon notify` SHALL work even if daemon is not running by performing inline fallback reindex.
- MCP SHALL expose equivalent operations so agent workflows can use the same lifecycle.
- Existing read/write tools SHALL remain backward compatible.

## Scenarios
- Given a project without an index, when `tokenwise warm --path <project>` runs, then `bake.json` and `embeddings.db` are created and daemon startup status is returned.
- Given daemon is running, when `tokenwise daemon notify --file src/foo.rs` runs, then the file change is queued and visible in `daemon status`.
- Given daemon is stopped, when `tokenwise daemon notify --file src/foo.rs` runs, then incremental reindex is executed inline and success is returned.
- Given daemon was started, when `tokenwise daemon stop` runs, then daemon exits and `daemon status` reports `running=false`.
