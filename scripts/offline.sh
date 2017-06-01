#!/bin/bash
#
# This file is released under terms of BSD license
# See LICENSE file for more information
#
# Helper script to fetch all the git submodules and the Java dependencies for an
# offine build and installation
#
# author: clementval
#

echo ""
echo "=================================="
echo "CLAW FORTRAN Compiler offline step"
echo "=================================="
echo ""

# Gather all submodule
git submodule init
git submodule update --remote

# Initiate ANT dependency resolution
cd omni-cx2x/src || exit 1
ant -Dantfile.dir="$(pwd)" common.bootstrap
ant -Dantfile.dir="$(pwd)" common.resolve
cd - || exit 1