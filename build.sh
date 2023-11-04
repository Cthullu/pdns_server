#!/usr/bin/env bash

set -eo pipefail

#
# Build the containerimage
#

#
# Author: Daniel Kuß
# License: MIT
# Source: https://github.com/Cthullu/pdns_dnsdist
#

usage() {

    # Display script syntax
    echo
    echo "Usage: $(basename "${0}") [-h] [-n <string] [-r <string] [-f <string>] [-b <int>} -v <string>"
    echo

}

help() {

    # Display the help message
    echo "Container build script."
    echo
    echo "This script build the container from the provided Dockerfile."

    usage

    echo "Options:"
    echo "-b    Build number of the container image. Will be used in the"
    echo "      created image tag. Defaults to '1'."
    echo "-f    Dockerfile used to build the container image."
    echo "      Defaults to 'Dockerfile'."
    echo "-h    Print this help message"
    echo "-n    The container image namespace inside the provided registry."
    echo "      Defaults to 'cthullu'."
    echo "-p    Set target platform for build. Defaults to 'linux/amd64'"
    echo "-r    Set the container image registry. Defaults to 'quay.io'."
    echo "-v    Set the version of the tool provided by the container image."
    echo

}

build() {

    echo
    echo "Building container image: ${TAG}"
    echo "Building for platform: ${PLATFORM:-"linux/amd64"}"
    echo

    docker build \
        --file "${DOCKERFILE}" \
        --no-cache \
        --platform "${PLATFORM:-"linux/amd64"}" \
        --tag "${TAG}" \
        .

}

#
# Get CLI arguments
#

while getopts ":b:f:hn:p:r:v:" option; do
    case ${option} in
        b)  # Store provided argument as BUILDNUMBER
            BUILDNUMBER="${OPTARG}"
            re_isanum='^[0-9]+$'

            if ! [[ ${BUILDNUMBER} =~ ${re_isanum} ]]; then

                echo "Error: Buildnumber must be a positive integer."
                usage
                exit 1

            fi
            ;;

        f)  # Store provided argument as Dockerfile
            DOCKERFILE="${OPTARG}"
            ;;

        h)  # Print the help message
            help
            exit 0
            ;;

        n)  # Save continer image namespace
            NAMESPACE="${OPTARG}"
            ;;

        p)  # Set target platform for build
            PLATFORM="${OPTARG}"
            ;;

        r)  # Save contaienr image registry
            REGISTRY="${OPTARG}"
            ;;

        v)  # Save version
            TOOLVERSION="${OPTARG}"
            ;;

        :)  # In case argument is missing
            echo "Error: -${OPTARG} requires an argument."
            usage
            exit 1
            ;;

        *)  #  Catch invalid options. Simply print the usage and exit.
            echo "Error: Invalid argument."
            usage
            exit 1
            ;;
    esac
done

#
# Check if mandatory arguments are provided.
# Exit if not.
#

if [[ -z ${TOOLVERSION} ]]; then

    echo "Error: A versionstring must be provided."
    usage
    exit 1

fi

#
# Create container image tag from provided information
#
TAG="${REGISTRY:-"quay.io"}"/"${NAMESPACE:-"cthullu"}"/pdns_server:"${TOOLVERSION}"-b"${BUILDNUMBER:-1}"

build

exit 0
