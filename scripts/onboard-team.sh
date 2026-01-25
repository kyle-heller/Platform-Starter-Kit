#!/bin/bash
set -euo pipefail

# Usage: ./onboard-team.sh <team-name> [environment]

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <team-name> [environment]"
    echo "Example: $0 alpha dev"
    exit 1
fi

TEAM_NAME="$1"
ENVIRONMENT="${2:-dev}"
NAMESPACE="team-${TEAM_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/team-onboarding"

if [[ ! "$TEAM_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: team name must be lowercase alphanumeric with hyphens only"
    exit 1
fi

echo "Onboarding team: ${TEAM_NAME} (namespace: ${NAMESPACE}, env: ${ENVIRONMENT})"

# Check if namespace already exists
if kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "Warning: namespace ${NAMESPACE} already exists"
    read -p "Continue and update resources? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

TEMP_DIR=$(mktemp -d)
trap "rm -rf \"$TEMP_DIR\"" EXIT

# Process templates — replace placeholder team/env values
for template in "$TEMPLATE_DIR"/*.yaml; do
    filename=$(basename "$template")
    [[ "$filename" == "kustomization.yaml" ]] && continue

    sed -e "s/team-alpha/${NAMESPACE}/g" \
        -e "s/: alpha/: ${TEAM_NAME}/g" \
        -e "s/-alpha-/-${TEAM_NAME}-/g" \
        -e "s/environment: dev/environment: ${ENVIRONMENT}/g" \
        "$template" > "$TEMP_DIR/$filename"
done

kubectl apply -f "$TEMP_DIR/"

echo ""
echo "Done. Verify with:"
echo "  kubectl get resourcequota,limitrange,networkpolicy -n ${NAMESPACE}"
echo ""
echo "Next steps:"
echo "  1. Add team members to '${NAMESPACE}-developers' group in Azure AD"
echo "  2. Share namespace name with the team: ${NAMESPACE}"
