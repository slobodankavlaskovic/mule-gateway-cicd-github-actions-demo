# MuleSoft APIM CI/CD Demo

This project demonstrates a complete CI/CD pipeline for managing API specifications and instances in MuleSoft's Anypoint Platform, using GitHub Actions. It showcases the use of both the Anypoint CLI and Anypoint Platform REST APIs to automate API lifecycle tasks such as validation, publication, deployment, and policy management.

## 🚀 Workflow Overview

This pipeline is triggered manually (`workflow_dispatch`) and runs the following stages:

### 1. **Validate API Spec**
- Validates the OpenAPI spec using Governance rulesets.
- Skipped if `ENABLE_GOVERNANCE_VALIDATE` is not set to `true`.

### 2. **Publish API to Exchange**
- Extracts metadata from the API spec.
- Checks if the asset version already exists in Exchange.
- If not, uploads the API spec as a new asset.

### 3. **Manage API Instance**
- Creates a new API instance in API Manager if it doesn't exist.
- Updates existing instances if needed.
- Deprecates older versions if configured.

### 4. **Manage API Policies**
- If `ENABLE_MANAGE_POLICIES` is `true`, applies or updates policies based on the JSON file referenced by `API_POLICIES_FILE_PATH`.


## 🔐 Secrets and Variables

| Type     | Name                         | Description                                           | Required | Default | Options                        |
|----------|------------------------------|-------------------------------------------------------|----------|---------|--------------------------------|
| Secret   | `ANYPOINT_CLIENT_ID`         | Client ID for Anypoint authentication                 | Yes      | —       | —                              |
| Secret   | `ANYPOINT_CLIENT_SECRET`     | Client secret for Anypoint authentication             | Yes      | —       | —                              |
| Variable | `ANYPOINT_HOST`              | Hostname of the Anypoint Platform                     | Yes       | —       | `anypoint.mulesoft.com`, `eu1.anypoint.mulesoft.com`          |
| Variable | `ANYPOINT_ORG_ID`            | Organization ID in Anypoint                           | Yes      | —       | —                              |
| Variable | `ANYPOINT_ENV`               | Environment name                                      | Yes      | —       | `Sandbox`, `Production`, etc. |
| Variable | `ANYPOINT_ENV_ID`            | Environment ID in Anypoint                            | Yes      | —       | —                              |
| Variable | `API_SPEC_FILE_PATH`         | Path to the API specification file (OAS)              | Yes      | —       | —                              |
| Variable | `API_POLICIES_FILE_PATH`     | Path to JSON file describing required policies        | No       | —       | —                              |
| Variable | `ENABLE_GOVERNANCE_VALIDATE` | Whether to run governance validation                  | No       | `false` | `true`, `false`                |
| Variable | `ENABLE_MANAGE_POLICIES`     | Whether to enable automatic policy management         | No       | `false` | `true`, `false`                |
| Variable | `API_PROTOCOL`               | Protocol of the API                                   | Yes      | `http`  | `http`, `https`                |
| Variable | `API_LISTEN_PORT`            | Listening port for the API                            | No       | `8081`  | —                              |
| Variable | `API_BASE_PATH`              | Base path of the API                                  | No       | —       | —                              |
| Variable | `API_TLS_SECRET_GROUP_ID`    | Secret group ID for TLS configuration (Sef-Hosted FG) | No | — | —                   |
| Variable | `API_TLS_CONTEXT_ID`         | TLS context ID for inbound communication (Sef-Hosted FG) | No | — | —                   |
| Variable | `API_BACKEND_UPSTREAM_URI`   | Backend URI where the API proxies requests            | Yes      | —       | —                              |
| Variable | `GATEWAY_TYPE`               | Gateway type                                          | Yes      | —       | `flexGateway`, `mule4`         |
| Variable | `GATEWAY_VERSION`            | Version of the Flex/Mule Gateway to deploy to         | Yes      | —       | —                              |
| Variable | `GATEWAY_TARGET`             | Target identifier (e.g., the Gateway ID, Shared/Private Space ID)| Yes      | —       | —                    |
| Variable | `GATEWAY_DEPLOYMENT_TYPE`    | Deployment type (FGW: `hybrid`, MuleGW: `cloudhub2`)  | Yes      | —       | `hybrid`, `cloudhub2`          |

## Testing the Workflow Locally

You can test the workflow locally using the [act](https://github.com/nektos/act) tool.

### Steps  

1. **Install `act`:**  
   Follow the installation steps in the [official documentation](https://github.com/nektos/act#installation).  

2. **Prepare environment files:**  
   - Use the provided `.secrets.template` and `.vars.template` files in the repository to create `.secrets` and `.vars` files:  
     ```sh
     cp .secrets.template .secrets
     cp .vars.template .vars
     ```
   - Edit `.secrets` and `.vars` with the appropriate values.  
     - **`.secrets`:** Add your Anypoint Platform `ANYPOINT_CLIENT_ID` and `ANYPOINT_CLIENT_SECRET`.  
     - **`.vars`:** Fill in the required environment variables for the workflow, such as `ANYPOINT_ORG_ID`, `ANYPOINT_ENV`, etc.

3. **Build a custom Docker image with pre-installed Anypoint CLI and other required comands:**  
   If you prefer to use a custom Docker image, build it using the `act-local-runner.dockerfile` included in the repository:  
   ```sh
   docker build -f act-local-runner.dockerfile -t act-local-runner .
   ```

4. **Run the workflow with the custom image:**  
   ```sh
   act -P self-hosted=act-local-runner --action-offline-mode
   ```
    > Use `-v` to activate debug mode
