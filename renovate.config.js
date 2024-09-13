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
    prHourlyLimit: 20,
    prConcurrentLimit: 20,
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
          "Group updates per dependency across Chart.yaml and values.yaml",
        matchManagers: ["helm-values", "regex"],
        groupName: "{{{depName}}}",
        labels: ["dependencies", "helm"],
      },
      {
        description:
          "Always bump chart version by a patch when updating values files.",
        matchManagers: ["helm-values", "regex"],
        postUpgradeTasks: {
          commands: ["scripts/bump-chart-version.sh '{{{parentDir}}}'"],
          fileFilters: ["**/Chart.yaml"],
          executionMode: "branch",
        },
      },
      {
        matchManagers: ["helm-values", "regex"],
        matchUpdateTypes: ["patch"],
        automerge: true,
        automergeType: "pr",
        labels: ["dependencies", "helm"],
      },
      {
        matchManagers: ["helm-values", "regex"],
        matchUpdateTypes: ["minor", "major"],
        automerge: false,
        labels: ["dependencies", "helm"],
      },
      {
        matchManagers: ["helmv3"],
        groupName: "Chart Dependency Updates for {{parentDir}}",
        separateMajorMinor: true,
        labels: ["dependencies", "helm"],
        automerge: false,
      },
      {
        matchManagers: ["github-actions"],
        groupName: "{{{depName}}} GitHub Action Updates",
        separateMajorMinor: true,
        labels: ["dependencies", "github-actions"],
        automerge: false,
      },
    ],
  };
};
