# Rewrite Emails

Small script to rewrite git committer emails to use no-reply:
`username <username@gmail.com>` -> `username <username@users.noreply.github.com>`

Adds all committers to a mailmap file which is sent to `git filter-repo` to rewrite the authors and emails.
After running the script, you'll need to force push the changes to the remote.

## **THIS OVERWRITES YOUR GIT HISTORY, USE WITH CAUTION**

## Pre-requisites

- [git filter-repo](https://github.com/newren/git-filter-repo) - install via most package managers

## Usage

Place script in root of repo you're rewriting committers. Run the script with the `--live` flag to actually rewrite git history.

```shell
./rewrite-emails.sh # dry-run, will gather emails but will not overwrite git history. Check emails in generated mailmap file, then proceed

./rewrite-emails.sh --live # will rewrite committers in git history

./rewrite-emails.sh --strip-id # strips committer id from username (77667589+username <77667589+bartenra@users.noreply.github.com> -> username <77667589+bartenra@users.noreply.github.com>).
```

By default, git-filter-repo requires you to have a fresh clone of the repo as a safeguard. This can be overwritten by adding the `--force` flag to the `git filter-repo` command in the script.
