#!/usr/bin/env bash

if [ -z "$IMAGE_NAME" ] || [ -z "$TRAVIS_BUILD_ID" ]
then
    echo "Script dedicated to CI. Don't run it on your machine !"
    exit 255
fi

cd $IMAGE_NAME
if [ -f .env ]
then
    source .env
fi
git log $TRAVIS_COMMIT_RANGE | grep "\[force ci\]"
FORCE=$?

if [ "${IMAGE_BUILT}" != "true" ] && [ "$FORCE" != "0" ]; then
    echo "No change, no need to run tests";
    exit 0;
fi

exit 1;
