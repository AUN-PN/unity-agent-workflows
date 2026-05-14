# Security Policy

## Supported Versions

Security fixes are considered for the current published package line.

## Reporting a Vulnerability

Please report suspected vulnerabilities privately. Use GitHub private vulnerability reporting for the source repository when available, or contact the repository owner before opening a public issue.

Do not include secrets, tokens, private project files, or exploit details in public issues, pull requests, logs, screenshots, or generated artifacts.

## Handling Secrets

This plugin should not require committed credentials. Keep local values in files such as `.env` or `.npmrc`; those files are intentionally ignored by Git and Codex context.
