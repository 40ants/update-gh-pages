#!/bin/bash

set -e
set -x

BUILD_DOCS_FROM_BRANCH=${BUILD_DOCS_FROM_BRANCH:-master}
BUILD_DOCS_WHEN_LISP=${BUILD_DOCS_WHEN_LISP:-ccl}
BUILD_DOCS_WHEN_OS=${BUILD_DOCS_WHEN_OS:-linux}

# we only want to build documentation from the "reblocks" branch
# and want to make it only once.
# Also, we need to check if TRAVIS_PULL_REQUEST=false because Travis
# builds which are running for pull requests will have
# TRAVIS_BRANCH=reblocks, but TRAVIS_PULL_REQUEST_BRANCH=the-branch
# and TRAVIS_PULL_REQUEST=42 where 42 is a pull request number
if [ "$TRAVIS_BRANCH" = "$BUILD_DOCS_FROM_BRANCH" \
  -a "$TRAVIS_PULL_REQUEST" = "false" \
  -a "$LISP" = "$BUILD_DOCS_WHEN_LISP" \
  -a "$TRAVIS_OS_NAME" = "$BUILD_DOCS_WHEN_OS" ]; then
    virtualenv env --python=python2.7
    . env/bin/activate
    python --version
    pip --version
    pip install pyopenssl
    pip install -r docs/requirements.txt
    ros install 40ants/cldomain
    curl -L https://raw.githubusercontent.com/40ants/update-gh-pages/master/build-docs.ros | sh
else
    echo "Skipping documentation build because environment is not suitable."
fi
