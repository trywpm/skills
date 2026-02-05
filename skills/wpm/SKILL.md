---
name: wpm
description: Package manager for WordPress. Use this skill whenever the user is looking to extend WordPress functionalities and wants to install or manage WordPress themes or plugins, setup a new WordPress project, update outdated themes/plugins, or publish a theme/plugin to the wpm registry.
metadata:
  version: "1.0.0"
  author: wpm-team
---

# wpm - package manager for WordPress

This skill provides instructions for using **wpm**, a package manager for WordPress plugins and themes (similar to npm/composer, but designed for the WordPress ecosystem).

Use wpm to:
- initialize WordPress projects
- install and manage plugins/themes
- track dependencies in `wpm.json`
- generate a lockfile (`wpm.lock`)
- validate runtime requirements
- publish packages to the wpm registry

---

## Key Concepts

### Project vs Publishable Package

A `wpm.json` file may represent either:

#### 1. WordPress project (site)
- Typically contains `"private": true`
- Installs dependencies (plugins/themes) into `wp-content/`
- Should define exact runtime versions using `config.runtime`

#### 2. Publishable package (plugin/theme/mu-plugin)
- Intended to be published to the wpm registry
- Must include:
  - `type` (`plugin`, `theme`, or `mu-plugin`)
  - `version` (SemVer)
- Should define compatibility ranges using `requires`

---

## Version Rules

### Exact versions only
The following fields must contain exact versions (no ranges/operators):
- `dependencies`
- `devDependencies`
- `config.runtime.wp`
- `config.runtime.php`

Example valid dependency:
```json
"dependencies": {
  "woocommerce": "8.5.0"
}
````

Invalid dependency:

```json
"dependencies": {
  "woocommerce": "^8.5.0"
}
```

### Version ranges allowed

The following fields support constraints/ranges:

* `requires.wp`
* `requires.php`

Example:

```json
"requires": {
  "wp": ">=6.0.0",
  "php": ">=8.0"
}
```

---

## Installation / Setup

### Check if wpm is installed

```bash
wpm --version
```

### Install wpm (if missing)

```bash
./scripts/install.sh
```

If installation fails, inspect the script output and ensure required permissions.

---

## Command Discovery (Avoid Hallucinating Flags)

If unsure about a command or flag, always run:

```bash
wpm --help
wpm <command> --help
```

Use the help output as the source of truth.

---

## Common Workflows

### 1) Initialize a New Project

Use when starting a new WordPress site managed by wpm.

```bash
wpm init
```

This generates a `wpm.json` file.

Recommended next step: set `"private": true` for projects.

---

### 2) Initialize / Migrate an Existing Plugin or Theme

Use when a plugin/theme already exists (headers already defined in `style.css` or the main plugin file).

```bash
wpm init --existing
```

This scans WordPress headers (Name, Version, License, etc.) and populates `wpm.json`.

---

### 3) Install Dependencies

By default, packages install into:

* `wp-content/plugins`
* `wp-content/themes`

Install a package:

```bash
wpm install <package-name>
```

Install a specific version:

```bash
wpm install <package-name>@<version>
```

Example:

```bash
wpm install wordpress-seo@26.9.0
```

Install and save as a development dependency:

```bash
wpm install <package-name> --save-dev
```

Install from `wpm.json`:

```bash
wpm install
```

Install production dependencies only:

```bash
wpm install --no-dev
```

---

### 4) List Installed Packages

List dependency tree:

```bash
wpm ls
```

Top-level only:

```bash
wpm ls --depth=0
```

---

### 5) Check Outdated Packages

Use this before upgrading dependencies.

```bash
wpm outdated
```

---

### 6) Update Packages

Recommended safe workflow:

1. Run `wpm outdated`
2. Based on the output, re-install specific versions explicitly (do not use version ranges or operators).
3. Verify the site still works
4. Commit updated `wpm.json` + `wpm.lock`

Example:

```bash
wpm install wordpress-seo@26.9.0
```
---

### 7) Remove a Package

⚠️ Removing packages is destructive. Confirm with the user before running uninstall.

```bash
wpm uninstall <package-name>
```

---

## Publishing to the wpm Registry

Publishing is only valid for **publishable packages**.

Before publishing ensure:

* `wpm.json` contains `type` and `version`
* `private` is not set to true
* package includes a valid license and metadata
* dependencies use exact versions
* `requires` defines supported WP/PHP ranges

### Authenticate

Authentication can be done using:

* interactive login (`wpm auth login`)
* environment variable `WPM_TOKEN` (recommended for CI)

Example:

```bash
export WPM_TOKEN="your-token-here"
```

### Publish

```bash
wpm publish
```

Always prefer validating first:

```bash
wpm publish --dry-run
```

To publish publicly:

```bash
wpm publish --access public
```

---

## Configuration: `wpm.json`

`wpm.json` is the manifest file for wpm projects and packages.

Refer to the full schema documentation:

* [wpm.json schema reference](references/schema.md)

Key recommendations:

* Use `"private": true` for WordPress projects (sites).
* Use `config.runtime` for exact environment versions (wp/php).
* Use `requires` for publishable package compatibility constraints.
* Keep dependency versions exact.

---

## Lockfile: `wpm.lock`

wpm generates a lockfile:

* `wpm.lock` should be committed to version control.
* Do not edit `wpm.lock` manually.
* It ensures reproducible installs across environments.

---

## Ignoring Files During Publish

Use `.wpmignore` to exclude unnecessary files when publishing packages.

Common ignored files:

* `.git/`
* `node_modules/`
* `vendor/`
* `.env`
* build artifacts

---

## Automation / CI Notes

* Avoid interactive authentication in CI.
* Prefer `WPM_TOKEN` for non-interactive publishing.
* Prefer `wpm publish --dry-run` before publishing.
* Always commit `wpm.lock` for deterministic installs.

---

## Common Pitfalls (Important)

* Do not use version constraints in `dependencies` or `devDependencies`.
* Do not use ranges in `config.runtime`.
* Do not publish a project config (`"private": true`).
