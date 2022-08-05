#!/bin/bash

#This script fix a Rails-specific issue that prevents the server from restarting when a certain server.pid
#file pre-exists. This script will be executed every time the container gets started. entrypoint.sh

set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
