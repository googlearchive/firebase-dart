#!/bin/bash

# Fast fail the script on failures.
set -e

if [ -n "$API_KEY" ]; then
  pushd shared_assets
  pub get
  dart create_config.dart
  popd
else
  echo 'Missing firebase ENV variables.'
  echo 'See tool/create_config.dart'
  exit 64
fi
