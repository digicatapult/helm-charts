#!/usr/bin/env bash
set -euo pipefail

parent_dir="$1"

chart_file="charts/${parent_dir}/Chart.yaml"

if [[ ! -f "$chart_file" ]]; then
  echo "Chart file not found: $chart_file"
  exit 1
fi

version=$(grep "^version:" "$chart_file" | awk '{print $2}')
if [[ -z "$version" ]]; then
  echo "No valid version was found in $chart_file"
  exit 1
fi

IFS='.' read -r major minor patch <<< "$version"

# Always increment the patch version
patch=$((patch + 1))

new_version="${major}.${minor}.${patch}"
echo -e "\nBumping version for $parent_dir from $version to $new_version"

sed -i "s/^version:.*/version: ${new_version}/g" "$chart_file"
