# Publishing to the wpm Registry

## Contents
- Prerequisites
- Authentication
- Publish commands
- CI/CD notes
- .wpmignore

## Prerequisites

Before publishing, ensure `wpm.json` has:
- `type` set (`plugin`, `theme`, or `mu-plugin`)
- `version` (SemVer)
- `private` is **not** `true`
- Valid `license` and metadata
- All `dependencies` use exact versions
- `requires` defines supported WP/PHP ranges

## Authentication

Interactive login:

```bash
wpm auth login
```

For CI (recommended): use `WPM_TOKEN` environment variable.

```bash
export WPM_TOKEN="your-token-here"
```

## Publish commands

Always dry-run first:

```bash
wpm publish --dry-run
```

Publish:

```bash
wpm publish
```

Publish publicly:

```bash
wpm publish --access public
```

## CI/CD notes

- Use `WPM_TOKEN` for non-interactive auth
- Always `wpm publish --dry-run` before publishing
- Commit `wpm.lock` for deterministic installs
- Use `wpm install --no-dev` for production builds

## .wpmignore

Exclude files from published packages. Common entries:

```
.git/
node_modules/
vendor/
.env
```
