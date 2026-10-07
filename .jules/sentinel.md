## 2025-03-22 - Subprocess Context Cancellation and Diagnostic File Permissions
**Vulnerability:** Subprocesses spawned via `execFind` in `cmd/find.go` ignored context cancellation (`exec.Command`), and diagnostic output dumps in `cmd/support-diag.go` were written with overly permissive world-readable `0666` permissions.
**Learning:** Functions accepting `context.Context` when executing external sub-processes must use `exec.CommandContext` to prevent lingering child processes when context is cancelled or times out. Additionally, diagnostic dumps containing sensitive system metadata must be restricted to owner-only permissions (`0600`).
**Prevention:** Always pass `ctx` to `exec.CommandContext` in CLI subcommands and default file permissions for sensitive dumps to `0600`.
