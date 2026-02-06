# wpm CLI Commands

## Contents
- Command discovery
- Init (new project)
- Init (existing plugin/theme)
- Install packages
- List packages
- Check outdated
- Update workflow
- Uninstall packages

## Command discovery

Always verify commands before use:

```bash
wpm --help
wpm <command> --help
```

Use help output as source of truth. Do not guess flags.

## Init (new project)

```bash
wpm init
```

Generates `wpm.json`. Set `"private": true` for site projects.

## Init (existing plugin/theme)

```bash
wpm init --existing
```

Scans WordPress headers (`style.css` or main plugin file) and populates `wpm.json`.

## Install packages

Packages install into `wp-content/plugins` or `wp-content/themes`.

```bash
# Install from wpm.json
wpm install

# Install a specific package
wpm install <package-name>

# Install a specific version
wpm install <package-name>@<version>

# Save as dev dependency
wpm install <package-name> --save-dev

# Production only (skip devDependencies)
wpm install --no-dev
```

Example:

```bash
wpm install wordpress-seo@26.9.0
```

## List packages

```bash
# Full dependency tree
wpm ls

# Top-level only
wpm ls --depth=0
```

## Check outdated

```bash
wpm outdated
```

## Update workflow

wpm has no `update` command with ranges. Follow this workflow:

1. Run `wpm outdated`
2. Re-install specific versions explicitly based on output
3. Verify site still works
4. Commit updated `wpm.json` + `wpm.lock`

## Uninstall packages

⚠️ Destructive operation. Confirm with the user before running.

```bash
wpm uninstall <package-name>
```
