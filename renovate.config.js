module.exports = (config = {}) => {
	const isSelfHosted = process.env.RENOVATE_SELF_HOSTED === 'true';
  
	if (!isSelfHosted) {
	  console.log('Renovate is disabled when running via GitHub App.');
	  return {
		enabled: false,
		onboarding: false,
	  };
	}
  
	console.log('Renovate is running in self-hosted mode.');
  
	return {
	  $schema: 'https://docs.renovatebot.com/renovate-schema.json',
	  onboarding: false,
	  requireConfig: false,
	  customManagers: [
		{
		  customType: 'regex',
		  datasourceTemplate: 'docker',
		  fileMatch: ['(^|/)Chart\\.yaml$'],
		  matchStrings: [
			'#\\s*renovate: image=(?<depName>.*?)\\s+appVersion:\\s*[\'"]?(?<currentValue>[\\w+\\.\\-]*)',
		  ],
		},
	  ],
	  packageRules: [
		{
		  description: 'Always bump chart version by a patch when updating values files.',
		  matchManagers: ['helm-values', 'regex'],
		  postUpgradeTasks: {
			commands: ["scripts/bump-chart-version.sh '{{{parentDir}}}'"],
			fileFilters: ['**/Chart.yaml'],
			executionMode: 'branch',
		  },
		},
		{
		  matchManagers: ['helm-values', 'regex'],
		  matchUpdateTypes: ['patch'],
		  automerge: true,
		  automergeType: 'pr',
		  labels: ['automerge'],
		},
		{
		  matchManagers: ['helm-values', 'regex'],
		  matchUpdateTypes: ['minor', 'major'],
		  automerge: false,
		},
		{
		  matchManagers: ['github-actions'],
		  matchUpdateTypes: ['patch'],
		  automerge: true,
		  labels: ['automerge'],
		},
	  ],
	};
  };
  
