#!/bin/bash
# Run spec syncing script and create PR

SPEC_DIRECTORY="../../test"
# I assume MDB_SPECS was set...this might not be true??
SCRIPT="../resync-specs.sh"
BRANCH_NAME="spec-resync-"$(date '+%m-%d-%Y')

# List of directories to skip
SKIP_DIRECTORIES=("asynchronous" "__pycache__")
# we have a list of specs that we manually override *if the git diff is that specific line, then don't change it
# *ask in python channel
SKIP_FILES=()
# ask steve for how to create PR from evergreen account(?)
# for now, treat it like a command line thing and git add *, git commit, git push

# Check that resync script exists and is executable
if [[ ! -x $SCRIPT ]]; then
  echo "Error: $SCRIPT not found or is not executable."
  exit 1
fi

# List to store names of specs that were changed or errored during change
changed_specs=()
errored_specs=()

# create branch
git branch $BRANCH_NAME
git checkout $BRANCH_NAME

for item in "$SPEC_DIRECTORY"/*; do
  item_name=$(basename "$item")
  if [[ " ${SKIP_DIRECTORIES[*]} " =~ ${item_name} ]]; then
    continue
  fi

  # Check that item is not a python file
  if [[ $item != *.py ]]; then

    output=$(./$SCRIPT "$item_name" 2>&1)

    # Check if the script ran successfully
    if [[ $? -ne 0 ]]; then
      errored_specs+=("$item_name")
    else
      # if script had output, then changes were made
      if [[ -n "$output" ]]; then
        changed_specs+=("$item_name")
      fi
    fi
  fi
done

# Output the list of changed specs
if [[ ${#changed_specs[@]} -gt 0 ]]; then
  echo "The following specs were changed:"
  for spec in "${changed_specs[@]}"; do
    echo "- $spec"
  done
else
  echo "No changes detected in any specs."
fi

# Output the list of errored specs
if [[ ${#errored_specs[@]} -gt 0 ]]; then
  echo "The following spec syncs encountered errors:"
  for spec in "${errored_specs[@]}"; do
    echo "- $spec"
  done
else
  echo "No errors were encountered in any specs syncs."
fi

git add $SPEC_DIRECTORY
git commit -m $BRANCH_NAME
