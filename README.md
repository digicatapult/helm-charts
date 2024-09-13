# helm-charts

A collection of [helm](https://helm.sh) charts created by [Digital Catapult](https://github.com/digicatapult).

## Active Chart List

* [openapi-merger](charts/openapi-merger/README.md) - Deploy the openapi-merger
* [sqnc-identity-service](charts/sqnc-identity-service/README.md) - Deploy sqnc-identity-service
* [sqnc-ipfs](charts/sqnc-ipfs/README.md) - Deploy sqnc-ipfs
* [sqnc-matchmaker-api](charts/sqnc-matchmaker-api/README.md) - Deploy sqnc-matchmaker-api service
* [sqnc-node](charts/sqnc-node/README.md) - Deploy sqnc-node
* [veritable-cloudagent](charts/veritable-cloudagent/README.md) - Deploy the veritable-cloudagent
* [veritable-ui](charts/veritable-ui/README.md) - Deploy the veritable-ui

---

## Renovate Setup

This repository uses [Renovate](https://renovatebot.com/) to automate dependency updates for the Helm charts and GitHub Actions workflows.

### Overview

The self-hosted Renovate bot is configured to:

- Update Helm chart dependencies individually.
- Update `appVersion` in `Chart.yaml` files.
- Run a script to bump the chart version after updates.
- Update GitHub Actions workflows.
- Automerge patch updates for dependencies and workflows.
- Only run in self-hosted mode and not via the Renovate GitHub App.
- Disable Renovate onboarding.

### GitHub App Setup

To authenticate the self-hosted Renovate bot, a GitHub App is used. Follow these steps to set up the GitHub App and obtain the `APP_ID` and `PRIVATE_KEY` secrets:

#### 1. Create a GitHub App

- **Navigate to GitHub Developer Settings:**
  - Go to [GitHub Developer Settings](https://github.com/organizations/digicatapult/settings/apps/) for the Digicatapult Org.
- **Create a New GitHub App:**
  - Click on **"New GitHub App"**.
- **Configure the GitHub App:**
  - **App Name:** Choose a unique name, e.g., `self-hosted-renovate-bot`.
  - **Homepage URL:** Enter your repository URL or `https://github.com/digicatapult/helm-charts`.
  - **Callback URL:** Leave empty.
  - **Webhook URL and Secret:** Leave empty.
  - **Permissions:**
    - **Repository Permissions:** as per the [Renovate Documentation](https://docs.renovatebot.com/modules/platform/github/#running-as-a-github-app).
- **Save the GitHub App:**
  - Click **"Create GitHub App"**.

#### 2. Generate a Private Key

- **Generate Private Key:**
  - On the GitHub App page, scroll to **"Private keys"**.
  - Click **"Generate a private key"**.
  - A `.pem` file will be downloaded. This is your `PRIVATE_KEY`.
- **Copy the Private Key:**
  - Open the `.pem` file in a text editor.
  - Copy the entire contents, including the `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----` lines.

#### 3. Obtain the App ID

- **Find the App ID:**
  - On the GitHub App page, note the **"App ID"** displayed near the top.
  - This number is your `APP_ID`.

#### 4. Install the GitHub App on Your Repository

- **Install the App:**
  - On the GitHub App page, click **"Install App"**.
  - Select the repository you want to use with Renovate.
  - Click **"Install"**.

#### 5. Add Secrets to Your Repository

- **Navigate to Repository Settings:**
  - Go to your repository on GitHub.
  - Click on the **"Settings"** tab.
- **Add Secrets:**
  - In the sidebar, click **"Secrets and variables"** > **"Actions"**.
  - Click **"New repository secret"**.
- **Add `APP_ID` Secret:**
  - **Name:** `APP_ID`
  - **Value:** Paste the `APP_ID` number.
- **Add `PRIVATE_KEY` Secret:**
  - **Name:** `PRIVATE_KEY`
  - **Value:** Paste the contents of the `.pem` file.

#### 6. Verify the Setup

- **Trigger the Workflow:**
  - Manually trigger the Renovate workflow or wait for it to run on schedule.
- **Check the Workflow Run:**
  - Ensure the **"Get GitHub App Token"** step completes successfully.
- **Monitor Renovate:**
  - Check that Renovate runs without authentication errors and processes updates as expected.