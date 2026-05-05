# common

Shared pure-Dart package for cross-app models, constants, and utility helpers.

## Purpose

`common` is the lowest shared layer in the mobile workspace.

It is the default home for code that:

- has no Flutter UI dependency
- is reused by more than one app or package
- represents shared data or protocol-level conventions

Typical contents:

- DTOs and response models
- constants such as auth header names
- small pure-Dart utilities
- shared enums and basic types

## Dependency Rule

`common` should remain Flutter-free.

That means:

- no widget imports
- no Riverpod
- no app-specific storage or platform plugin usage

This package is meant to be safely consumed by both `api_client` and app code.

## What Belongs Here

Put code here when it is:

- data-oriented rather than UI-oriented
- stable enough to be shared broadly
- independent from one app's route or screen flow

Examples:

- token response DTOs
- paginated response models
- shared auth constants

## What Does Not Belong Here

Do not put these here:

- reusable widgets or themes
- API orchestration logic
- platform storage code
- app-specific form controller state

Those belong in `design_system`, `api_client`, or the app layer.

## Split Rule

Avoid creating tiny shared packages for every utility category.

Use `common` until there is a clear reason to split, such as:

- a distinct domain model package with its own lifecycle
- a package that must be shared outside this workspace
- a dependency boundary that must stay lower than existing `common`
