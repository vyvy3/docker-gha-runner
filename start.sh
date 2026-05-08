#!/bin/bash

if [ ! -f ./.runner ]; then
    echo "Configuration file (.runner) not found. Configuring runner..."
    ./config.sh --url https://github.com/${REPOSITORY} --token ${ACCESS_TOKEN} --unattended
    touch .runner
else
    echo "Configuration file (.runner) found. Skipping configuration."
fi

unset ACCESS_TOKEN
unset REPOSITORY

./run.sh & wait $!
