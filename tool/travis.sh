#!/bin/bash

# Fast fail the script on failures.
set -e

if [ -n "$API_KEY" ]; then
  dart tool/create_config.dart
  pub run test -p firefox
else
  echo 'Missing firebase ENV variables.'
fi
