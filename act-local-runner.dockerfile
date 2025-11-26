# Dockerfile to create a custom image with the Anypoint CLI and required plugins pre-installed.
# This image is intended to be used as a base for GitHub Actions pipelines (instead of ubuntu-latest),
# and to speed up local development and testing using the `act` tool.

# To build the image, run:
# docker build -f act-local-runner.dockerfile -t act-local-runner:latest .

FROM ubuntu:latest

USER root

# Install Node.js 18 and Anypoint CLI with required plugins
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g anypoint-cli-v4 && \
    anypoint-cli-v4 plugins:install anypoint-cli-exchange-plugin && \
    anypoint-cli-v4 plugins:install anypoint-cli-api-mgr-plugin && \
    anypoint-cli-v4 plugins:install anypoint-cli-runtime-mgr-plugin && \
    anypoint-cli-v4 plugins:install anypoint-cli-governance-plugin

# Install jq (useful for processing JSON in scripts)
RUN apt-get install -y jq

# Clean up APT cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
