# wpm.json schema

## Overview

This document defines the JSON schema and behavioral rules for the `wpm.json` configuration file used by **wpm**, a package manager for WordPress ecosystem.

A `wpm.json` file can represent either:

- a **publishable package** (plugin/theme/mu-plugin), OR
- a **WordPress project** (a site that installs packages)

This document describes the supported fields, validation rules, and recommended usage patterns.

---

## Core Concepts

### Package vs Project behavior (IMPORTANT)

A `wpm.json` file can describe either a **publishable package** or a **project**.

#### Publishable package
A publishable package is meant to be published to the wpm registry.

Rules:
- `"private"` must be missing or set to `false`
- `"type"` is required
- `"version"` is required
- `"requires"` is strongly recommended

#### Project configuration
A project configuration represents a WordPress site that consumes packages.

Rules:
- `"private": true` is recommended (prevents accidental publishing)
- `"type"` is optional
- `"version"` is optional
- `"config.runtime"` is strongly recommended

---

## Version Rules (Non-Ambiguous)

wpm uses **two different version styles**, depending on the field.

### Exact versions (required in these fields)
The following fields must contain **exact versions only**:

- `dependencies.*`: strict semver versions of package dependencies
- `devDependencies.*`: strict semver versions of development dependencies
- `config.runtime.wp`: the exact WordPress version of the runtime environment
- `config.runtime.php`: the exact PHP version of the runtime environment

Exact version means:
- No ranges
- No constraints
- No operators

✅ Valid examples:
- `"1.2.3"`
- `"6.4.2"`
- `"8.2"`

❌ Invalid examples:
- `"^1.2.3"`
- `"~2.0.0"`
- `">=6.0.0"`
- `"8.x"`

Reason:
- Dependencies must resolve deterministically.
- Runtime is a single installed version of WordPress and PHP.

---

### Version ranges / constraints (allowed in these fields)

The following fields support version ranges and constraints:

- `requires.wp`
- `requires.php`

Examples:
- `">=6.0.0"`
- `">=7.4"`
- `"<8.4"`

Reason:
- `requires` describes the compatibility range of a package, so it must support constraints.

---

## Why `requires` Exists

The `requires` field exists primarily for **publishable packages**.

When a package is installed into a project, wpm can validate that the project runtime (`config.runtime.wp` and `config.runtime.php`) satisfies the package compatibility constraints (`requires.wp` and `requires.php`).

This prevents installing packages into incompatible environments.

---

## Field Reference Summary

| Field | Required | Applies To | Format Notes |
|------|----------|------------|-------------|
| `name` | Yes | Package + Project | lowercase letters/numbers/hyphens only |
| `private` | No | Package + Project | if true, publishing is refused |
| `type` | Required for packages | Package | `plugin`, `theme`, `mu-plugin` |
| `version` | Required for packages | Package | must be SemVer |
| `description` | No | Package + Project | free text |
| `license` | No | Package + Project | string |
| `homepage` | No | Package + Project | must be a valid URL |
| `tags` | No | Package + Project | max 5 strings |
| `team` | No | Package + Project | max 100 strings |
| `bin` | No | Package | maps command name → executable path |
| `requires` | No | Package | supports version constraints |
| `dependencies` | No | Package + Project | versions must be exact |
| `devDependencies` | No | Package + Project | versions must be exact |
| `config` | No | Project | runtime + directory configuration |
| `scripts` | No | Package + Project | string map of script commands |

---

## JSON Schema

This schema validates the basic structure of `wpm.json`.

Note: Some behavioral rules (such as exact-only dependency versions) may be validated by wpm itself even if not enforced by JSON Schema.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema",
  "title": "Schema for wpm configuration file",
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z0-9]+(-[a-z0-9]+)*$",
      "maxLength": 164,
      "minLength": 3,
      "description": "The name of the package."
    },
    "version": {
      "type": "string",
      "description": "A Semver-compliant version string."
    },
    "type": {
      "type": "string",
      "enum": [
        "theme",
        "plugin",
        "mu-plugin"
      ],
      "description": "The type of package in the wp-content directory."
    },
    "description": {
      "type": "string",
      "description": "A brief summary of what the package is about."
    },
    "private": {
      "type": "boolean",
      "default": false,
      "description": "If set to true, wpm will refuse to publish the package."
    },
    "bin": {
      "type": "object",
      "additionalProperties": {
        "type": "string"
      },
      "description": "The binaries associated with the package."
    },
    "requires": {
      "type": "object",
      "properties": {
        "wp": {
          "type": "string",
          "description": "The WordPress versions range supported by the package."
        },
        "php": {
          "type": "string",
          "description": "The PHP versions range supported by the package."
        }
      },
      "additionalProperties": false,
      "description": "The PHP and WordPress version constraints for the package."
    },
    "license": {
      "type": "string",
      "description": "The license under which the package is released. WordPress is licensed under GPLv2 or later."
    },
    "homepage": {
      "type": "string",
      "format": "uri",
      "description": "The URL of the package's homepage."
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "maxItems": 5,
      "description": "Tags that help categorize the package."
    },
    "team": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "maxItems": 100,
      "description": "The team members responsible for the package."
    },
    "dependencies": {
      "type": "object",
      "additionalProperties": {
        "type": "string"
      },
      "description": "The dependencies required by the package."
    },
    "devDependencies": {
      "type": "object",
      "additionalProperties": {
        "type": "string"
      },
      "description": "The development dependencies required by the package."
    },
    "config": {
      "type": "object",
      "properties": {
        "bin-dir": {
          "type": "string",
          "default": "wp-bin",
          "description": "The path to the directory where the package's binaries are installed."
        },
        "content-dir": {
          "type": "string",
          "default": "wp-content",
          "description": "The path to the WordPress content directory."
        },
        "runtime": {
          "type": "object",
          "properties": {
            "wp": {
              "type": "string",
              "description": "The WordPress runtime version where this project is expected to run."
            },
            "php": {
              "type": "string",
              "description": "The PHP runtime version where this project is expected to run."
            }
          },
          "additionalProperties": false,
          "description": "The actual runtime requirements where this project is expected to run."
        }
      }
    },
    "scripts": {
      "type": "object",
      "additionalProperties": {
        "type": "string"
      },
      "description": "Scripts to run during the package lifecycle or development."
    }
  },
  "required": [
    "name"
  ],
  "if": {
    "not": {
      "properties": {
        "private": {
          "const": true
        }
      }
    }
  },
  "then": {
    "required": [
      "type",
      "version"
    ]
  }
}
```
