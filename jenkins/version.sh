#!/bin/bash
# version.sh - A script to handle semantic versioning for CI/CD pipelines
# Usage: ./version.sh -v [major|minor|patch]

# Default values
VERSION=""
PACKAGE_UPDATE=false
CREATE_BRANCH=false
GIT_TOKEN=""

# Process command line arguments
while getopts "v:pub:t:" flag; do
  case "${flag}" in
    v) VERSION=${OPTARG};; # Version increment type (major, minor, patch)
    p) PACKAGE_UPDATE=true;; # Update package.json
    u) CREATE_BRANCH=true;; # Create and push a release branch
    b) BRANCH_PREFIX=${OPTARG};; # Branch prefix (default: release/)
    t) GIT_TOKEN=${OPTARG};; # GitHub token for authentication
  esac
done

# Set default branch prefix if not provided
if [[ -z "$BRANCH_PREFIX" ]]; then
  BRANCH_PREFIX="release/"
fi

# Fetch all tags
git fetch --tags --prune --unshallow 2>/dev/null || git fetch --tags --prune 2>/dev/null

# Get current version from the highest tag, or default to v0.1.0 if none exists
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v0.1.0")
echo "Current Version: $CURRENT_VERSION"

# Remove the 'v' prefix and split into parts
CURRENT_VERSION_CLEAN=${CURRENT_VERSION#v}
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION_CLEAN"

# Calculate new version based on increment type
if [[ $VERSION == "major" ]]; then
  MAJOR=$((MAJOR+1))
  MINOR=0
  PATCH=0
  echo "Incrementing major version"
elif [[ $VERSION == "minor" ]]; then
  MINOR=$((MINOR+1))
  PATCH=0
  echo "Incrementing minor version"
elif [[ $VERSION == "patch" ]]; then
  PATCH=$((PATCH+1))
  echo "Incrementing patch version"
else
  echo "Error: Version type must be one of [major, minor, patch]"
  echo "Usage: ./version.sh -v [major|minor|patch] [-p] [-u] [-b branch_prefix] [-t git_token]"
  echo "  -p: Update package.json with new version"
  echo "  -u: Create and push a release branch"
  echo "  -b: Branch prefix (default: release/)"
  echo "  -t: GitHub token for authentication"
  exit 1
fi

# Create the new tag
NEW_TAG="v$MAJOR.$MINOR.$PATCH"
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "Updating $CURRENT_VERSION to $NEW_TAG"

# Check if current commit already has a tag
GIT_COMMIT=$(git rev-parse HEAD)
NEEDS_TAG=$(git describe --contains $GIT_COMMIT 2>/dev/null || echo "")

# Only tag if no tag already exists
if [[ -z "$NEEDS_TAG" ]]; then
  echo "Creating new tag: $NEW_TAG"
  
  # Configure git if token is provided
  if [[ -n "$GIT_TOKEN" ]]; then
    git config --global credential.helper "!f() { echo username=x-access-token; echo password=$GIT_TOKEN; }; f"
    git config user.email "ci@example.com"
    git config user.name "CI Pipeline"
  fi
  
  # Update package.json if requested
  if [[ "$PACKAGE_UPDATE" == true ]]; then
    echo "Updating package.json version to $NEW_VERSION"
    npm version $NEW_VERSION --no-git-tag-version
    git add package.json package-lock.json
    git commit -m "Bump version to $NEW_TAG"
  fi
  
  # Create the tag
  git tag $NEW_TAG
  
  # Push the tag
  if [[ -n "$GIT_TOKEN" ]]; then
    git push --tags
  else
    echo "Git token not provided. Tag created locally but not pushed."
  fi
  
  # Create and push release branch if requested
  if [[ "$CREATE_BRANCH" == true ]]; then
    BRANCH_NAME="${BRANCH_PREFIX}${NEW_TAG}"
    echo "Creating release branch: $BRANCH_NAME"
    git checkout -b $BRANCH_NAME
    
    if [[ -n "$GIT_TOKEN" ]]; then
      git push origin $BRANCH_NAME
      echo "Pushed release branch: $BRANCH_NAME"
    else
      echo "Git token not provided. Branch created locally but not pushed."
    fi
  fi
else
  echo "This commit already has tag: $NEEDS_TAG"
fi

# Output the new version for CI system
echo $NEW_TAG > .version
echo "::set-output name=new-version::$NEW_TAG"
echo "::set-output name=version-number::$NEW_VERSION"

exit 0