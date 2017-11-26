#!/bin/bash

echo "Push commits and launch build for all versions..."
git tag -fa 5.6 -m 5.6
git tag -fa 7.0 -m 7.0
git tag -fa 7.1 -m 7.1

git push --tags --force