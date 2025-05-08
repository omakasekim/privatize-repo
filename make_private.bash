#!/bin/bash

# Ensure you are authenticated
echo "Checking GitHub CLI authentication..."
if ! gh auth status &>/dev/null; then
  echo "❌ Not authenticated. Please run 'gh auth login' first."
  exit 1
fi

# Get your GitHub username
echo "Fetching GitHub username..."
USERNAME=$(gh api user --jq '.login')
if [ -z "$USERNAME" ]; then
  echo "❌ Failed to fetch username. Check your authentication."
  exit 1
fi
echo "✅ Authenticated as $USERNAME"

# Fetch all repositories and filter out private ones
echo "Fetching public repositories..."
repos=$(gh repo list "$USERNAME" --limit 1000 --json name,visibility,owner -q '.[] | select(.visibility == "PUBLIC") | "\(.owner.login)/\(.name)"' 2>/dev/stderr)

# Debug: Print raw repo list
echo "Raw repository list:"
echo "$repos"
echo "End of repository list."

# Check if there are any public repositories
if [ -z "$repos" ]; then
  echo "✅ No public repositories found for $USERNAME."
  exit 0
fi

# Prompt user to select repositories to make private
echo "Select repositories to make private..."
selected=$(echo "$repos" | fzf --multi --prompt="Select public repos to make private: ")

# Debug: Print selected repos
echo "Selected repositories:"
echo "$selected"
echo "End of selected repositories."

# Confirm and apply changes
if [ -z "$selected" ]; then
  echo "✅ No repositories selected."
  exit 0
fi

# Process each selected repository
while IFS= read -r full_repo; do
  [[ -z "$full_repo" ]] && continue
  echo "Processing repository: $full_repo"
  read -p "Make '$full_repo' private? (y/n): " confirm < /dev/tty
  echo "User input: '$confirm'"
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "➡️ Making $full_repo private..."
    if gh repo edit "$full_repo" --visibility private; then
      echo "✅ Successfully made $full_repo private."
    else
      echo "❌ Failed to make $full_repo private."
    fi
  else
    echo "⏩ Skipped $full_repo"
  fi
done <<< "$selected"
