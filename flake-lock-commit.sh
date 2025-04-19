#!/usr/bin/env bash
nix flake update
git add .
git commit -m "updated lockfile"
git pushall