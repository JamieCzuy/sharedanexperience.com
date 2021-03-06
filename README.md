sharedanexperience.com (v0.0.1)
===
Website for People that have Shared An Experience


Repo Folder Structure:
---
**./bin** - DevOp scripts
**./data** - Local Postgres data file (not checked into GitHub)
**./django** - The Django project and app (manage.py is in this folder)
**./documentation** - User docs, API docs, Design docs
**./env_files** - Environment variable files (**Private** - not checked into GitHub)
**./test_cases** - Functional testing / text cases


DevOps Scripts:
---
* dev_locally.sh
  * Creates a dockered Postgres container which uses local ./data folder
  * Runs the django project locally (runserver)

* run_dockered.sh
  * Creates a dockered Postgres container which uses local ./data folder
  * Creates a dockered django project container which uses the local ./django folder


Versioning:
---
* The current version is (v0.0.1)
* The three parts are major.minor.patch
* Versioning is maintained by [bumpversion](https://pypi.python.org/pypi/bumpversion)

* Every new deployment should have a new version number (at least a patch level change).

* Use one of these commands to up the appropriate level:
```
bumpversion patch
bumpversion minor
    or
bumpversion major
```

* bumpversion updates the files listed in the config file and does a git tag and commit.

**NOTE:** You must run git push after bumpversion and use the `--tags` option
to have the tag pushed as well as the files with updated version numbers:
```
git push --tags
```

**Note:** bumpversion is in the `requirements.txt` and install through `pip`

**Note:** The configuration file for bumpversion is the hidden file: `.bumpversion.cfg`
