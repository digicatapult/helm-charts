module.exports = (config = {}) => {
  const isSelfHosted = process.env.RENOVATE_SELF_HOSTED === "true";

  if (!isSelfHosted) {
    console.log("Renovate is disabled when running via GitHub App.");
    return {
      enabled: false,
      onboarding: false,
    };
  }

  console.log("Renovate is running in self-hosted mode.");

  return {
    $schema: "https://docs.renovatebot.com/renovate-schema.json",
    onboarding: false,
    requireConfig: false,
    allowedPostUpgradeCommands: ["scripts/bump-chart-version.sh"],
    ignoreDeps: [
      "common",
      "docker.io/bitnami",
      "docker.io/bitnamicharts",
      "keycloak",
      "minio",
      "nginx",
      "postgresql",
    ],
    prHourlyLimit: 20,
    prConcurrentLimit: 20,
    recreateWhen: "always",
    customManagers: [
      {
        customType: "regex",
        datasourceTemplate: "docker",
        fileMatch: ["(^|/)Chart\\.yaml$"],
        matchStrings: [
          '#\\s*renovate: image=(?<imageName>.*?)\\s+appVersion:\\s*[\"]?(?<currentValue>[\\w+\\.\\-]*)',
        ],
        depNameTemplate: "docker.io/{{{imageName}}}",
      },
    ],
    packageRules: [
      {
        description:
          "Disable all updates for deprecated SQNC charts (ENG-318). Source repositories are archived; these charts are frozen.",
        matchFileNames: [
          "charts/sqnc-attachment-api/**",
          "charts/sqnc-identity-service/**",
          "charts/sqnc-ipfs/**",
          "charts/sqnc-matchmaker-api/**",
          "charts/sqnc-node/**",
        ],
        enabled: false,
      },
      {
        matchManagers: ["helm-values", "regex", "helmv3"],
        groupName: null,
        labels: ["dependencies", "helm"],
        separateMinorPatch: true,
        separateMajorMinor: true,
      },
      {
        description:
          "Always bump chart version by a patch when updating values files.",
        matchManagers: ["helm-values", "regex"],
        postUpgradeTasks: {
          commands: ["scripts/bump-chart-version.sh '{{{parentDir}}}'"],
          fileFilters: ["**/Chart.yaml", "**/README.md"],
          executionMode: "branch",
        },
      },
      {
        matchManagers: ["helm-values", "regex"],
        matchUpdateTypes: ["patch", "minor"],
        automerge: true,
        automergeType: "pr",
        labels: ["dependencies", "helm", "automerge"],
      },
      {
        matchManagers: ["helm-values", "regex"],
        matchUpdateTypes: ["major"],
        automerge: false,
        labels: ["dependencies", "helm"],
      },
      {
        description: "Do not automerge updates for kubo in helm-values",
        matchManagers: ["helm-values"],
        matchDepNames: ["docker.io/ipfs/kubo"],
        matchUpdateTypes: ["minor", "patch"],
        automerge: false,
        labels: ["dependencies", "helm"],
      },
      {
        matchManagers: ["helmv3"],
        bumpVersion: "patch",
      },
      {
        matchManagers: ["helmv3"],
        groupName: null,
        matchUpdateTypes: ["patch", "minor"],
        automerge: true,
        automergeType: "pr",
        labels: ["dependencies", "helm", "automerge"],
      },
      {
        matchManagers: ["helmv3"],
        matchUpdateTypes: ["major"],
        automerge: false,
        labels: ["dependencies", "helm"],
      },
      {
        matchManagers: ["github-actions"],
        groupName: "{{{depName}}} GitHub Action Updates",
        separateMajorMinor: true,
        labels: ["dependencies", "github-actions"],
        automerge: false,
      },
      {
        matchManagers: ["github-actions"],
        matchPackageNames: ["renovatebot/github-action"],
        matchUpdateTypes: ["patch", "minor"],
        automerge: true,
        addLabels: ["automerge"],
      },
    ],
  };
};
