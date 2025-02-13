#!/bin/bash

# Get all unique emails from the git repository
emails=$(git log --format='%ae' | sort | uniq)

# Create or overwrite the emails_gh.mailmap file
output_file="emails_gh.mailmap"
> $output_file

# Initialize flags
strip_id=false
live=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --strip-id) strip_id=true ;;
    --live) live=true ;;
  esac
  shift
done

# Loop through each email and format it
for email in $emails; do
  username=$(echo $email | cut -d '@' -f 1)
  noreply_username=$username
  if $strip_id; then
    noreply_username=$(echo $username | sed 's/[0-9+]//g')
  fi
  noreply_email="$username@users.noreply.github.com"
  echo "$noreply_username <$noreply_email> $username <$email>" >> $output_file
done

echo "emails_gh.mailmap file has been created."

# Check if the --live argument is passed
if $live; then
  echo "Re-writing all email addresses to noreply"
  git-filter-repo --mailmap ./emails_gh.mailmap --force
else
  echo "Dry run: --live argument not passed, skipping git-filter-repo command."
fi