# Enforce Git Committer Email Format

This is a two-part process. The first part is a script that rewrites the committer email addresses in the git history to use the `@users.noreply.github.com` domain. The second part is an optional Husky hook that enforces the email format for all commits. If you'd prefer to catch email issues in pull requests by manual review, you can skip the Husky setup.

## Rewrite Emails

Small script to rewrite git committer emails to use no-reply:
`username <username@gmail.com>` -> `username <username@users.noreply.github.com>`

Adds all committers to a mailmap file which is sent to `git filter-repo` to rewrite the authors and emails.
After running the script, you'll need to force push the changes to the remote.

## **THIS OVERWRITES YOUR GIT HISTORY, USE WITH CAUTION**

### Pre-requisites

- [git filter-repo](https://github.com/newren/git-filter-repo) - install via most package managers

### Usage

Place script in root of repo you're rewriting committers. Run the script with the `--live` flag to actually rewrite git history.

```shell
./rewrite-emails.sh # dry-run, will gather emails but will not overwrite git history. Check emails in generated mailmap file, then proceed

./rewrite-emails.sh --live # will rewrite committers in git history

./rewrite-emails.sh --strip-id # strips committer id from username (77667589+username <77667589+bartenra@users.noreply.github.com> -> username <77667589+bartenra@users.noreply.github.com>).
```

By default, git-filter-repo requires you to have a fresh clone of the repo as a safeguard. This can be overwritten by adding the `--force` flag to the `git filter-repo` command in the script.

## Husky

[Husky](https://github.com/typicode/husky) is a tool that allows you to set up Git hooks easily. You can use Husky to enforce the email format for all commits in your repository.

### Setup

To set up Husky in your repository, follow these steps:

1. Install Husky as a development dependency:

    ```bash
    npm install husky --save-dev
    ```

2. Add a prepare script to your `package.json` to automatically install Husky hooks:

    ```json
    "scripts": {
      "prepare": "husky install"
    }
    ```

3. Create the `pre-commit` script in the `.husky` directory (can use the example in this repo at .husky/pre-commit):

    ```bash
    #!/bin/sh

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
    ```

4. Make the script executable:

    ```bash
    chmod +x ./.husky/pre-commit
    ```

### Husky Usage

After setting up Husky, any commit attempt with an invalid email format will be blocked, ensuring that all committers use the specified email format.
