# General instructions to contribute in a GitHub project

## Fork, Clone and set Upstream

* Go to the GitHub project
* Click the **Fork** button

> **NOTE:** if you are part of one or more organizations, you must select where to fork.

* Clone your fork:
```bash
git clone git@github.com:<YOUR_USER_OR_ORG>/<PROJECT>.git
```
* Change directory to the cloned project
```bash
cd <PROJECT>
```
* Add a remote to the official repository:
```bash
git remote add upstream https://github.com/<OFFICIAL_USER_OR_ORG>/<PROJECT>.git
```
* You can check your remotes:
```bash
git remote -v
origin	git@github.com:<YOUR_USER>/<PROJECT>.git (fetch)
origin	git@github.com:<YOUR_USER>/<PROJECT>.git (push)
upstream	git@github.com:<OFFICIAL_USER>/<PROJECT>.git (fetch)
upstream	git@github.com:<OFFICIAL_USER>/<PROJECT>.git (push)
```

## Create a clean branch for your changes

> **NOTE:** tipically, the target branch will be `master` (for projects created before 2020) or `main`.

```bash
git checkout <BRANCH>
git reset --hard upstream/<BRANCH>
git pull --rebase upstream <BRANCH>
```

Optionally, you can force a push to your fork (to be updated)
```
git push origin <BRANCH> --force
```

> **NOTE:** the previous procedure will destroy any diverged history against the upstream repository, so be carefull to avoid data lost.

Now, you can create you branch for a new PR:
```
git checkout -b <YOUR_NEW_BRANCH>
```

Alternatively, to avoid the `reset --hard` and the `pull --rebase`, you can directly generate a branch from upstream:
```bash
git checkout -b <YOUR_NEW_BRANCH> upstream/<BRANCH>
```

## Create a Pull Request

* Push your changes:
```bash
git push origin <YOUR_NEW_BRANCH>
```

TODO:
* Adding commits (and --force)
* Rebase/squash
* PR instructions
