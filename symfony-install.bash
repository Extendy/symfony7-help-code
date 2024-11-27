#!/bin/bash
# This bash script checks if the Symfony CLI is installed and creates a new Symfony project if the requirements are satisfied.
# Usage: symfony-install.bash <project_name> [symfony_version] [--webapp]
# Example: symfony-install.bash my_project 7.1 --webapp
# Example: symfony-install.bash my_project --webapp
# If you don't provide the Symfony version, it will create a project with the current release version.
######
# Copyright (c) 2024, Extendy Ltd.
# Developed by: Mohammed AlShannaq <mohd@extendy.uk>
# Licensed under the MIT License
######


# Ensure the script exits on the first failure
set -e

# Check if a project name was provided
if [ -z "$1" ]; then
    echo "This bash script checks if the Symfony CLI is installed and creates a new Symfony project if the requirements are satisfied"
    echo "Take a look into Symfony releases: https://symfony.com/releases"
    echo "Usage: $0 <project_name> [symfony_version] [--webapp]"
    exit 1
fi

PROJECT_NAME="$1"
SYMFONY_VERSION=""
WEBAPP_OPTION=""

# Parse arguments
for arg in "$@"; do
    if [[ "$arg" == "--webapp" ]]; then
        WEBAPP_OPTION="--webapp"
    elif [[ "$arg" != "$1" ]]; then
        SYMFONY_VERSION="$arg"
    fi
done

echo "Check and setup a new Symfony project"

# Check if Symfony CLI is installed
if ! command -v symfony &> /dev/null; then
    echo "Symfony CLI is not installed. Please install it and try again."
    exit 1
fi

# Check Symfony requirements
echo "Checking Symfony requirements..."
if symfony check:requirements | grep -q "OK"; then
    echo "All requirements are satisfied."
else
    echo "Some requirements are not met. Please fix the issues and try again."
    exit 1
fi

# Construct the symfony new command
SYMFONY_COMMAND="symfony new $PROJECT_NAME"
if [ -n "$SYMFONY_VERSION" ]; then
    SYMFONY_COMMAND+=" --version=\"$SYMFONY_VERSION\""
fi
if [ -n "$WEBAPP_OPTION" ]; then
    SYMFONY_COMMAND+=" $WEBAPP_OPTION"
fi

# Run the Symfony new command
echo "Creating Symfony project with the following command:"
echo "$SYMFONY_COMMAND"
eval "$SYMFONY_COMMAND"

echo "Symfony project '$PROJECT_NAME' has been successfully created."
exut 0