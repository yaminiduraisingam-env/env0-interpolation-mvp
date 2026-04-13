<h3 align="left">
  <img width="600" height="128" alt="image" src="https://raw.githubusercontent.com/artemis-env0/Packages/refs/heads/main/Images/Logo%20Pack/01%20Main%20Logo/Digital/SVG/envzero_logomark_fullcolor_rgb.svg" />
</h3>

---

# env0 Workflow Interpolation MVP: Deployment Guide

**Goal:** Prove that `${VAR_NAME}` string interpolation in `env0.workflow.yaml` resolves correctly
on the initial run, specifically for `name`, `revision`, and `workspace` fields.

**This is a no-op deployment. No real infrastructure resources are created.**

---

## Variables Used for Interpolation

| env0 Variable        | Purpose in workflow YAML            | Example value     |
|----------------------|--------------------------------------|-------------------|
| `WORKFLOW_ENV_PREFIX` | Resolves the `name` field for each sub-environment | `mvp-test`       |
| `TARGET_REVISION`    | Resolves the `revision` field        | `main`            |
| `WORKSPACE_ID`       | Resolves the `workspace` field       | `interp-ws`       |

When resolved, the `name` for the network sub-environment, for example, becomes `mvp-test-network`.

---

## Part 1 - GitHub Repo Setup

### Step 1.1 - Create the repo

Go to https://github.com/new and create a new repository with the following settings:

- Repository name: `env0-interpolation-mvp`
- Visibility: Public (env0 personal GitHub connections work with both, but public avoids
  any installation permission issues during initial setup)
- Do NOT initialize with a README (you will push the files yourself)

### Step 1.2 - Clone the repo locally

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/env0-interpolation-mvp.git
cd env0-interpolation-mvp
```

### Step 1.3 - Copy in the files from this archive

Place the files so the structure looks exactly like this:

```
env0-interpolation-mvp/
  env0.workflow.yaml
  modules/
    network/
      main.tf
      variables.tf
    security/
      main.tf
      variables.tf
    data/
      main.tf
      variables.tf
    app/
      main.tf
      variables.tf
    monitoring/
      main.tf
      variables.tf
```

### Step 1.4 - Commit and push

```bash
git add .
git commit -m "feat: add env0 interpolation mvp workflow"
git push origin main
```

Confirm all files are visible on GitHub before continuing.

---

## Part 2 - Connect GitHub to env0

Skip this part if your personal GitHub account is already connected to your env0 organization.

### Step 2.1 - Install the env0 GitHub App

1. Log in to https://app.env0.com
2. Navigate to Settings (top-right menu) then VCS Providers
3. Click "Add VCS Provider" and choose GitHub
4. Follow the OAuth flow to authorize env0 on your personal GitHub account
5. When prompted to select repositories, choose "All repositories" or specifically select
   `env0-interpolation-mvp`
6. Note the GitHub Installation ID that appears after connecting - you will need this when
   creating templates

---

## Part 3 - Create the 5 Sub-Environment Templates

Each sub-environment in the workflow references a `templateName`. Those templates must exist
in env0 BEFORE you create the workflow template. You need to create one template per module folder.

Repeat the steps in this section five times, once for each row in the table below:

| Template Name      | Repository Path         |
|--------------------|-------------------------|
| `noop-network`     | `modules/network`       |
| `noop-security`    | `modules/security`      |
| `noop-data`        | `modules/data`          |
| `noop-app`         | `modules/app`           |
| `noop-monitoring`  | `modules/monitoring`    |

### Steps to create each template

1. In env0, go to Templates in the left sidebar
2. Click "Create New Template"
3. On the first screen (Template Details):
   - Template Name: use the exact name from the table above (e.g. `noop-network`)
   - Template Type: Terraform
4. Click Next (VCS)
5. On the VCS screen:
   - VCS Provider: select your connected GitHub account
   - Repository: `env0-interpolation-mvp`
   - Branch: `main`
   - Terraform Working Directory: use the path from the table above (e.g. `modules/network`)
   - Terraform Version: `1.7.5`
6. Click Next through the remaining screens, leaving all other settings at their defaults
7. Click Save / Create Template

Repeat for all 5 templates. When finished, you should see all 5 templates listed on the
Templates page.

**Important:** The template name you enter must be an exact character-for-character match with
the `templateName` value in `env0.workflow.yaml`. Casing matters. If there is any mismatch
the workflow will fail at parse time.

---

## Part 4 - Create the Workflow Template

### Step 4.1 - Create the template

1. In env0, go to Templates
2. Click "Create New Template"
3. On the Template Details screen:
   - Template Name: `interpolation-workflow`
   - Template Type: Workflow
4. Click Next (VCS)
5. On the VCS screen:
   - VCS Provider: select your connected GitHub account
   - Repository: `env0-interpolation-mvp`
   - Branch: `main`
   - Workflow File Path: leave as the default root `/` (the `env0.workflow.yaml` file is
     at the root of the repo)
6. Click Next through the remaining screens and click Save / Create Template

### Step 4.2 - Set template-level variables

This step is critical. The interpolation variables must be set BEFORE the first deployment
runs, so they must exist at the template level. Setting them here ensures they are available
when env0 parses the workflow YAML at the start of the initial run.

1. Open the `interpolation-workflow` template you just created
2. Go to the Variables tab
3. Add the following three variables:

   Variable 1:
   - Name: `WORKFLOW_ENV_PREFIX`
   - Value: `mvp-test`
   - Scope: Environment
   - Sensitive: No

   Variable 2:
   - Name: `TARGET_REVISION`
   - Value: `main`
   - Scope: Environment
   - Sensitive: No

   Variable 3:
   - Name: `WORKSPACE_ID`
   - Value: `interp-ws`
   - Scope: Environment
   - Sensitive: No

4. Save the variables

---

## Part 5 - Create and Run the Workflow Environment

### Step 5.1 - Create the environment

1. In env0, go to Environments in the left sidebar
2. Click "Create New Environment"
3. Select the `interpolation-workflow` template
4. Environment Name: `interpolation-mvp-run-1`
5. On the Variables screen, you will see the three variables already populated from the
   template. Do not change them for this first run.
6. Review the workflow graph that appears below - you should see all 5 sub-environments
   listed with a linear dependency chain:
   network -> security -> data -> app -> monitoring
7. Click Deploy

### Step 5.2 - Watch the run

The workflow graph in the environment view will show each sub-environment progressing through
the chain. Since these are no-op Terraform modules with no provider and no resources,
each sub-environment will:

- Run `terraform init` (succeeds with no provider downloads)
- Run `terraform plan` (shows "No changes. Your infrastructure matches the configuration.")
- Complete successfully

### Step 5.3 - Verify interpolation resolved

Once the run completes, verify that interpolation worked by checking the following:

1. Sub-environment names: Click into any sub-environment (e.g. network). The environment
   name displayed in the UI should be `mvp-test-network`, not the literal string
   `${WORKFLOW_ENV_PREFIX}-network`. This confirms the `name` field was interpolated.

2. Workspace: In the sub-environment Settings or Summary tab, the Terraform workspace
   should show `interp-ws-net` (not the raw `${WORKSPACE_ID}-net`). This confirms the
   `workspace` field was interpolated.

3. Revision: In the sub-environment Settings tab, the revision used for the run should
   show `main` (not `${TARGET_REVISION}`). This confirms the `revision` field was
   interpolated.

If any of those three fields show the raw `${...}` string instead of the resolved value,
interpolation did not fire on the initial run.

---

## Part 6 - Optional: Prove Re-interpolation on a Second Run

To prove the values are dynamic (not baked in at environment creation time), change
`WORKFLOW_ENV_PREFIX` to `mvp-v2` on the template or directly on the environment and
trigger a second deployment. The sub-environment names should update to `mvp-v2-network`,
`mvp-v2-security`, etc.

---

## Troubleshooting Reference

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Workflow fails immediately with "template not found" | `templateName` in YAML does not match an existing template name exactly | Check casing and spacing on all 5 template names |
| Sub-environment name shows raw `${...}` literal | Variable was not set before the run, or was scoped to a level env0 does not resolve at parse time | Confirm all 3 variables are set at the template level before deployment |
| `terraform init` fails | Missing provider block (not expected here since no provider is declared) | Verify the working directory path in the template points to the correct `modules/` subfolder |
| Workflow graph shows no chain arrows | `needs` references in YAML use the wrong YAML key (e.g. `needs: - Network` vs `needs: - network`) | YAML keys under `environments:` are case-sensitive; use all lowercase |
