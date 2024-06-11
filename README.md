<h1 align="center">
🚀 Git Automation Script
</h1>
<p align="center">
<img src="https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white">
</p>

> This script automates various Git operations including backing up changed files, syncing the codebase with a remote repository, and committing and pushing changes to the current branch. It is designed to streamline the development process by handling repetitive tasks efficiently.

## Clone or Download

```terminal
git clone https://github.com/yourusername/git-automation-script.git
```

## Usage

1. **Navigate to your local Git repository**:

   ```sh
   cd /path/to/your/repository
   ```

2. **Make the script executable**:

   ```sh
   chmod +x path/to/your/script.sh
   ```

3. **Run the script**:
   ```sh
   ./path/to/your/script.sh
   ```

## Script Workflow

1. **Set Destination Folder**:

   - Determines the destination folder based on the current branch.
   - Creates the folder if it doesn't exist.

2. **Backup Changed Files**:

   - Identifies modified and untracked files with the extensions `.jsp`, `.xsd`, and `.java`.
   - Copies these files to the destination folder.

3. **Sync Codebase with Remote**:

   - Clears any existing stash.
   - Stashes current changes.
   - Switches to the main branch and pulls the latest changes.
   - Switches back to the current branch and rebases it with the main branch.
   - Applies the stashed changes.

4. **Add, Commit, and Push Changes**:
   - Displays the files to be added.
   - Prompts for confirmation before staging the files.
   - Prompts for a commit message and commits the changes.
   - Pushes the changes to the current branch.

## Customization

- **Main Branch**: The script uses `MAIN_BRANCH` as the main branch. You can change this by modifying the `main_branch` variable.
- **File Extensions**: The script currently backs up files with `.jsp`, `.xsd`, and `.java` extensions. You can add or remove extensions by updating the regular expression in the `get_changed_files_and_backup` function.

## Project Status

> The script is functional and can be customized based on specific project requirements.

### Example Output

When you run the script, you will see prompts and output similar to the following:

```
You are on the branch 'feature_branch'. Is this the correct feature branch? (y/n): y
feature_branch Folder Created Successfully

Copied example.jsp to D:\Study\GitScript\tasks\feature_branch
Copy process completed.

Clearing Git stash...
Creating a new Git stash...
Switching to MAIN_BRANCH...
Pulling from MAIN_BRANCH...
Switching to feature_branch...
Rebasing with MAIN_BRANCH...
Applying the stashed changes

Code base Sync completed.

Files that will be added:
example.jsp

Do you want to proceed with adding these files? (y/n): y
Files staged:
example.jsp

Do you want to proceed with commit? (y/n): y
Enter the commit message (will be appended to 'feature_branch: '): Added example.jsp

Git add and commit completed successfully.

Do you want to proceed with pushing these changes to 'feature_branch'? (y/n): y
Git add, commit, and push completed successfully.
```

## BUGs or comments

[Create new Issues](https://github.com/prajyotzankar/Git-Automation-Script/issues/new/choose) (preferred)

Email Me: zankarprajyotsushil@gmail.com (welcome, say hi)

## Author

[Prajyot Zankar](https://www.linkedin.com/in/prajyotzankar/)

### License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/prajyotzankar/Git-Automation-Script/blob/master/LICENSE)
