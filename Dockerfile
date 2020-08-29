FROM cirrusci/flutter:1.17.5 AS builder
LABEL stage=flutter-builder

ARG FLAVOR
ENV FLAVOR $FLAVOR

WORKDIR /app
COPY . .
USER root
RUN flutter build apk -t lib/program.dart --flavor=$FLAVOR

FROM ruby:2.7.1 AS ruby
LABEL stage=flutter-deployer

ARG FIB_APP_ID
ARG FIB_TESTER_GROUPS
ARG FLAVOR
ENV FIB_APP_ID $FIB_APP_ID
ENV FIB_TESTER_GROUPS $FIB_TESTER_GROUPS
ENV FLAVOR $FLAVOR

WORKDIR /app
COPY --from=builder /app /app
COPY firebasekeyfile.json .
WORKDIR /app/android
RUN bundle install
RUN GOOGLE_APPLICATION_CREDENTIALS=/app/firebasekeyfile.json && \
    bundle exec fastlane deployFirebase