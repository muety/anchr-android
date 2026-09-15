#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=anchr-build

docker build -t "$IMAGE_NAME" -f Dockerfile .

docker run --rm \
    -v "$PWD":/src \
    "$IMAGE_NAME" \
    bash -c "flutter clean && flutter pub get && flutter build apk --release --flavor fdroid 2>&1 && ls -lh build/app/outputs/flutter-apk"
