#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

# Get the committer email
committer_email=$(git config user.email)

# Define the regex pattern for the email format
email_pattern="^[a-zA-Z0-9._%+-]+@users\.noreply\.github\.com$"

# Check if the committer email matches the pattern
if [[ ! $committer_email =~ $email_pattern ]]; then
  echo "Error: Committer email '$committer_email' is invalid. It must be in the format 'username@users.noreply.github.com'."
  exit 1
fi

# If the email is valid, allow the commit
exit 0
