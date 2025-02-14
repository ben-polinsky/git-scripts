#!/bin/bash

# Get all unique emails and names from the git repository
emails_and_names=$(git log --format='%an <%ae>' | sort | uniq)

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

# Loop through each email and name and format it
while IFS= read -r entry; do
  name=$(echo "$entry" | sed -E 's/(.*) <.*/\1/')
  email=$(echo "$entry" | sed -E 's/.* <(.*)>/\1/')
  username=$(echo "$email" | cut -d '@' -f 1)
  noreply_username=$username
  if $strip_id; then
    noreply_username=$(echo $username | sed 's/[0-9+]//g')
  fi
  noreply_email="$noreply_username@users.noreply.github.com"
  echo "$name <$noreply_email> $name <$email>" >> $output_file
done <<< "$emails_and_names"

echo "emails_gh.mailmap file has been created."

# Check if the --live argument is passed
if $live; then
  echo "Re-writing all email addresses to noreply"
  git-filter-repo --mailmap ./emails_gh.mailmap --force
else
  echo "Dry run: --live argument not passed, skipping git-filter-repo command."
fi
