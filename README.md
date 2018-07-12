# Auth ZUMA

A client for interacting with IAMs that implement the [UMA protocol](https://docs.kantarainitiative.org/uma/wg/oauth-uma-federated-authz-2.0-09.html).

It is meant to be used by resource servers that need to comunicate with an IAM like Keycloak to manage its own resources.

## Docker

An example docker-compose.yml configuration for Keycloak is provided. More servers might be added in the future.

This imports a default realm so you can test AuthZuma on a shell.
