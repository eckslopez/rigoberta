  # Ops Control Plane (MVP)

  ## Purpose
  Build a unified operations layer for Zavestudios that correlates events across tools and tenants.

  ## What This Is
  - A single live feed/dashboard for pipeline and ops events
  - Cross-tool normalization (GitHub, GitLab, ArgoCD, app jobs, data jobs)
  - Tenant-aware operational context and auditability

  ## What This Is Not
  - Not a replacement for GitHub/GitLab/ArgoCD UIs
  - Not a clone of CI/CD vendor features
  - Not a standalone pipeline engine

  ## Canonical Event Model (MVP)
  `PipelineRun` (initial fields):
  - `name`
  - `status` (`queued`, `running`, `passed`, `failed`)
  - `created_at`, `updated_at`

  Planned additions:
  - `source` (github_actions, gitlab_ci, argocd, app_job, data_job)
  - `external_id`
  - `started_at`, `finished_at`, `duration_ms`
  - `tenant_id`
  - `triggered_by`
  - `metadata` (jsonb)
  - `error_summary`

  ## Integration Order
  1. Local/manual events (MVP validation)
  2. GitHub Actions ingestion
  3. ArgoCD sync/deploy ingestion
  4. GitLab pipeline ingestion
  5. Internal background/data job ingestion

  ## MVP Success Criteria
  - New run events appear in realtime without refresh
  - Status transitions update existing rows without duplication
  - Events can be traced to source and tenant context
  - Links to source-of-truth vendor UIs are preserved

  ## Scope Guardrails
  - Prefer aggregation and correlation over feature duplication
  - Keep vendor systems as execution source of truth
  - Use this layer for visibility, policy, and coordination
