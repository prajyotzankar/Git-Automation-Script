#!/bin/bash

# Define the destination folder
destination_folder="D:\\Study\\GitScript\\tasks"

# Define the source_files as an environment variable
export source_files=""

dev_task_id=""

# Function to check the exit code of a Git command
check_git_exit_code() {
    if [ $? -ne 0 ]; then
        echo "Git command '$1' failed. Aborting."
        echo
        exit 1
    fi
}

# Function to retrieve and back up changed files from a Git repository.
get_changed_files_and_backup() {

    # Get a list of modified and untracked files with extensions .jsp, .xsd, or .java
    source_files=($(git status --porcelain | awk '{print $2}' | grep -E '\.jsp$|\.xsd$|\.java$'))

    # Loop through the source file locations and copy them to the destination folder
    for source_file in "${source_files[@]}"; do
        if [ -e "$source_file" ]; then
            # Use the 'basename' command to extract just the filename
            filename=$(basename "$source_file")

            # Copy the file to the destination folder
            cp "$source_file" "$destination_folder\\$filename"
            check_git_exit_code cp
            echo -e "Copied $filename to $destination_folder\n"
        else
            echo -e "File $source_file not found.\n"
        fi
    done
    echo -e "Copy process completed."
    echo
}

sync_codebase_with_remote() {

    echo "Clearing Git stash..."
    git stash clear
    check_git_exit_code "git stash clear"
    echo

    echo "Creating a new Git stash..."
    git stash save
    check_git_exit_code "git stash save"
    echo

    echo "Switching to $main_branch..."
    git checkout $main_branch
    check_git_exit_code "git checkout $main_branch"
    echo

    echo "Pulling from $main_branch..."
    git pull
    check_git_exit_code "git pull"
    echo

    echo "Switching to $current_branch..."
    git checkout $current_branch
    check_git_exit_code "git checkout $current_branch"
    echo

    echo "Rebasing with $main_branch..."
    git rebase $main_branch
    check_git_exit_code "git rebase $main_branch"
    echo

    echo "Applying the stashed changes"
    git stash pop
    check_git_exit_code "git stash pop"
    echo

    echo -e "\n\nCode base Sync completed.\n\n"
}

git_add_commit_push_code() {

    if [ -n "$source_files" ]; then

        echo "Files that will be added:"
        echo "${source_files[@]}"

        # Prompt for confirmation
        read -p "Do you want to proceed with adding these files? (y/n): " confirmation

        if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
            # Add the files using git add
            git add "${source_files[@]}"
            check_git_exit_code "git add"
        else
            echo "Operation aborted."
            echo
            exit 1
        fi

        echo

        echo "Files staged: "
        git diff --name-only --cached --diff-filter=AM
        echo

        # Prompt to proceed
        read -p "Do you want to proceed with commit? (y/n): " commit_confirmation

        if [[ $commit_confirmation != "y" && $commit_confirmation != "Y" ]]; then
            echo "Operation aborted."
            echo
            exit 1
        fi

        # Prompt for commit message
        read -p "Enter the commit message (will be appended to '$dev_task_id: '): " commit_message

        if [[ $commit_message != "n" && $commit_message != "N" ]]; then
            # Execute git commit with the specified message
            git commit -m "$dev_task_id: $commit_message"
            check_git_exit_code "git commit"
        else
            echo "Operation aborted."
            exit 1
        fi

        echo "Git add and commit completed successfully."

        # Prompt for confirmation before git push
        read -p "Do you want to proceed with pushing these changes to '$current_branch'? (y/n): " push_confirmation

        if [[ $push_confirmation == "y" || $push_confirmation == "Y" ]]; then
            # Push to current branch
            git push -f origin "$current_branch"
            check_git_exit_code "git push"
            echo "Git add, commit, and push completed successfully."
        else
            echo "Git push operation aborted."
            exit 1
        fi
    else
        echo "No files found to commit or push."
        exit 1
    fi
}

set_destination_folder() {

    # Get the current branch name
    current_branch=$1

    # Extract dev_task_id
    dev_task_id=$(echo "$current_branch" | cut -d'_' -f1)

    # Update destination folder
    destination_folder="$destination_folder\\$dev_task_id"

    # Check if the destination folder exists, create it if not
    if [ ! -d "$destination_folder" ]; then
        mkdir -p "$destination_folder"
        check_git_exit_code "mkdir -p $destination_folder"

        echo "$dev_task_id Folder Created Successfully"
        echo
    else
        echo "$dev_task_id Folder Found"
        echo
    fi
}

# Set the main branch
main_branch="MAIN_BRANCH"

# Get the current Git branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
check_git_exit_code "git rev-parse --abbrev-ref HEAD"

# Prompt the user to confirm the current branch
read -p "You are on the branch '$current_branch'. Is this the correct feature branch? (y/n): " confirmation

# Check if the user entered 'y' or 'Y' to confirm
if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
    set_destination_folder "$current_branch"
    get_changed_files_and_backup
    sync_codebase_with_remote
    git_add_commit_push_code
else
    echo "Aborted. Please switch to the correct feature branch before running this script."
    echo
fi
