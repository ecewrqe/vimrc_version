#!/bin/bash
owner="euewrqe-project-manage"
repo="bekazone_rails"
workflow_files=("ci.yml" "rails.cr.yml")
# gh run list -w ci
# gh repo list euewrqe-project-manage
# gh api orgs/euewrqe-project-manage/bekazone_rails/actions/runs?per_page=100
for file in "${workflow_files[@]}"; do
    gh api "repos/$owner/$repo/actions/workflows/$file/runs?per_page=100" \
        | jq '.workflow_runs[].id' | xargs -P4 -I {} gh api repos/$owner/$repo/actions/runs/{} -X DELETE
done

# gh api "repos/euewrqe-project-manage/bekazone_rails/actions/workflows/ci.yml/runs" | jq ".workflow_runs[].id" | xargs -P4 -I {} gh api repos/euewrqe-project-manage/bekazone_rails/actions/runs/{} -X DELETE