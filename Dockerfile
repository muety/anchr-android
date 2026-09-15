# Docker setup to build the app with all its outdated language and dependency versions
# Disclosure: this Dockerfile is mostly AI-generated

FROM ubuntu:20.04

ARG FLUTTER_VERSION=2.5.3
ARG ANDROID_COMPILE_SDK=30
ARG ANDROID_BUILD_TOOLS=30.0.3
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk-headless \
    git curl unzip xz-utils zip wget ca-certificates \
    lib32stdc++6 lib32z1 libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PUB_CACHE=/opt/pub-cache
ENV PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PUB_CACHE/bin:$PATH

# Android command line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -o /tmp/tools.zip \
    && unzip -q /tmp/tools.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm /tmp/tools.zip \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager --install \
        "platform-tools" \
        "platforms;android-${ANDROID_COMPILE_SDK}" \
        "build-tools;${ANDROID_BUILD_TOOLS}" \
    && rm -rf $ANDROID_HOME/.android

# Flutter at exact version
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git /opt/flutter \
    && flutter config --no-analytics \
    && flutter precache

WORKDIR /src
