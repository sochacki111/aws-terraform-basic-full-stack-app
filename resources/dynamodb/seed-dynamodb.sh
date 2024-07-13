#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

aws dynamodb batch-write-item --request-items file://"$SCRIPT_DIR/items.json"
