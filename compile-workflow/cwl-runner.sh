#!/bin/bash

# cwl-runner needs to be installed
export $INPUT_DIR = $(pwd)

envsubst < input.yml.template > input.yml

cwl-runner workflow.cwl input.yml
