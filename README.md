sharedanexperience.com (v0.0.1)
===
Website for People that have Shared An Experience



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
