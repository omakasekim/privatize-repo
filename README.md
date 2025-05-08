# Make Private Repositories Script

This Bash script (`make_private.bash`) allows you to interactively select public GitHub repositories owned by your account and change their visibility to private. It uses the GitHub CLI (`gh`) to fetch repositories and the `fzf` command-line tool for interactive selection.

## Features

- Fetches all public repositories for your GitHub account, handling pagination for accounts with more than 1000 repositories
- Displays a list of public repositories using `fzf` for easy selection
- Prompts for confirmation before making each selected repository private
- Includes debug output to track repository fetching and selection
- Handles errors gracefully, such as authentication failures or API issues

## Prerequisites

Before running the script, ensure you have the following installed:

- **GitHub CLI (gh)**: Used to interact with the GitHub API
  - Install: `brew install gh` (macOS) or follow [GitHub CLI installation instructions](https://github.com/cli/cli#installation)
  - Authenticate: Run `gh auth login` and follow the prompts to log in with your GitHub account. Ensure your token has the `repo` scope (`gh auth refresh -s repo` if needed)

- **fzf**: A command-line fuzzy finder for interactive repository selection
  - Install: `brew install fzf` (macOS) or follow [fzf installation instructions](https://github.com/junegunn/fzf#installation)
  - Optional: Run `$(brew --prefix)/opt/fzf/install` to set up keybindings and completion

- **Bash**: The script is written for Bash (version 4.0 or later recommended)
  - Most Unix-like systems (e.g., macOS, Linux) include Bash by default

- **jq**: A command-line JSON processor, required by `gh` for parsing API responses
  - Install: `brew install jq` (macOS) or follow [jq installation instructions](https://stedolan.github.io/jq/download/)

- **GitHub Account**: You must have a GitHub account with public repositories and appropriate permissions to change repository visibility

## Installation

1. **Download the Script**:
   ```
   Save make_private.bash to a directory (e.g., ~/scripts/).
   ```


2. **Make the Script Executable**:
   ```bash
   chmod +x make_private.bash
   ```

3. **Verify Dependencies**:
   ```bash
   gh --version
   fzf --version
   jq --version
   bash --version
   ```
   Ensure all tools are installed and accessible.

## Usage

1. **Run the Script**:
   ```bash
   ./make_private.bash
   ```

2. **Script Flow**:
   - **Authentication Check**: Verifies you're logged in with `gh auth status`
   - **Fetch Repositories**: Retrieves all public repositories for your GitHub account using the GitHub API with pagination
   - **Display Repositories**: Lists public repositories in an `fzf` interface
   - **Select Repositories**:
     - Use arrow keys (Up/Down or j/k) to navigate
     - Press Tab to select one or more repositories
     - Press Enter to confirm your selection
     - Press Ctrl+C or Esc to cancel selection
   - **Confirm Visibility Change**:
     - For each selected repository, the script prompts: `Make 'username/repo-name' private? (y/n):`
     - Type `y` (or `Y`) and press Enter to make the repository private
     - Type `n` (or `N`) or anything else to skip
   - **Output**: Shows success (`✅ Successfully made ... private`) or failure (`❌ Failed to make ... private`) for each repository

### Example Output
```
Checking GitHub CLI authentication...
✅ Authenticated as omakasekim
Fetching public repositories...
Raw repository list:
omakasekim/VMhunt64
omakasekim/FastFashion
omakasekim/HYCSE2010
...
End of repository list.
Total public repositories: 1200
Select repositories to make private...
Selected repositories:
omakasekim/HYCSE2010
End of selected repositories.
Processing repository: omakasekim/HYCSE2010
Make 'omakasekim/HYCSE2010' private? (y/n): y
User input: 'y'
➡️ Making omakasekim/HYCSE2010 private...
✅ Successfully made omakasekim/HYCSE2010 private.
```

## Troubleshooting

### No Repositories Listed:
- Ensure you have public repositories in your GitHub account
- Check authentication: `gh auth status`
- Verify API rate limits: `gh api rate_limit`. If limited, wait or refresh your token (`gh auth refresh -s repo`)
- Confirm `jq` is installed and working: `echo '{"visibility":"public"}' | jq '.visibility'`

### fzf Issues:
- If `fzf` doesn't display or closes immediately, ensure it's installed: `fzf --version`
- Test `fzf` manually: `echo -e "repo1\nrepo2" | fzf --multi`
- Reinstall if needed: `brew install fzf`

### Visibility Change Fails:
- If `gh repo edit` fails, check the error message. Common issues:
  - Permissions: Ensure your account/token has permission to edit repository settings
  - Rate Limits: See above
  - GitHub CLI Version: Ensure you're using a recent version (`gh --version`). Update: `brew upgrade gh`
- Test manually: `gh repo edit username/repo-name --visibility private --accept-visibility-change-consequences`

### Script Hangs or Slow:
- If you have thousands of repositories, fetching may take time due to API pagination
- Check the `Total public repositories:` count to confirm all repos are fetched
- Interrupt with Ctrl+C and check partial output

### Debugging:
- The script includes debug output:
  - `Raw repository list:`: Shows all fetched public repositories
  - `Total public repositories:`: Counts fetched repos
  - `Selected repositories:`: Shows your `fzf` selections
  - `User input:`: Shows your y/n input
- Share this output with support requests

## Notes

- **Visibility Change Consequences**: Making a repository private removes public access, disables public forks (unless explicitly allowed), and may affect collaborators or integrations. The script uses `--accept-visibility-change-consequences` to acknowledge this.
- **API Rate Limits**: The script uses the GitHub API, which has a limit of 5,000 requests/hour for authenticated users with the `repo` scope. Fetching many repositories consumes multiple requests (100 repos per page).
- **Repository Limits**: GitHub imposes a soft limit of 100,000 repositories per account, with warnings at 50,000. If you have a large number of repos, performance may degrade.
- **Error Handling**: The script checks for authentication, empty repository lists, and failed visibility changes, providing clear error messages.

## Contributing

If you encounter bugs or have feature suggestions, please:
- Open an issue on the repository (if hosted)
- Include the script's output, your `gh --version`, and a description of the issue
- Submit pull requests with proposed changes

## License

This script is provided under the MIT License.

## Acknowledgments

- Built with GitHub CLI for API interactions
- Uses `fzf` for interactive selection
- Powered by `jq` for JSON processing
