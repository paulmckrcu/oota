#!/bin/sh
#
# Extracts the "Observation" result from herd7 output.

grep '^Observation' | awk '{ print $3 " satisfied."; }' | tr 'A-Z' 'a-z'
