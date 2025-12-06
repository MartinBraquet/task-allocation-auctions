#!/bin/bash

# Release script for release.yaml (a GitHub Action)
# Can be run locally as well if desired
# It creates a tag based on the version in pyproject.toml and creates a GitHub release based on the tag

set -e
cd "$(dirname "$0")"/..

pip install --no-deps -e .
tag=v$(python -c "from importlib.metadata import version; print(version('gcaa'))")

tagged=$(git tag -l $tag)
if [ -z "$tagged" ]; then
  git tag -a "$tag" -m "Release $tag"
  git push origin "$tag"
  echo "Tagged release $tag"

  gh release create "$tag" \
      --repo="$GITHUB_REPOSITORY" \
      --title="$tag" \
      --generate-notes
  echo "Created release"

pip install wheel build twine
python -m build
twine upload -u __token__ -p $PYPI_API_TOKEN dist/*

else
  echo "Tag $tag already exists"
fi


#RELEASE=$1
#if [ -z "$RELEASE" ]
#then
#    RELEASE=0
#fi
#
#rm -rf dist
#python -m build
#if [ "$RELEASE" -eq 0 ]; then
#    twine check dist/*
#else
#    twine upload dist/*
#fi