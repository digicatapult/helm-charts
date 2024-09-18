# helm-charts

A collection of [helm](https://helm.sh) charts created by [Digital Catapult](https://github.com/digicatapult).

## Active Chart List

* [bridgeai-prediction-service](charts/bridgeai-prediction-service/README.md) - Deploy the bridgeai-prediction-service
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

To authenticate the self-hosted Renovate bot, a GitHub App is used. Follow [these steps](https://docs.renovatebot.com/modules/platform/github/#running-as-a-github-app) to set up the [GitHub App](https://github.com/organizations/digicatapult/settings/apps/) and obtain the `APP_ID` and `PRIVATE_KEY` secrets:

### Triggering the Workflow
  You can manually trigger the Renovate workflow, wait for it to run on schedule or have it run via [respository_dispatch event](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#repository_dispatch) using `renovate` as the event type.