# Sample scripts.

Here are sample script using CEoR.

## nodelist.sh
This script sets target node list to ALL_TARGET.

## getconfs.sh
This script collects configuration files.

Usage: /bin/sh getconfs.sh [nodeA nodeB ...]

If no argument, getconfs.sh reads nodelist.sh and use ALL_TARGET.

## putconf.sh
This script uploads configuration files to target node.

Usage: /bin/sh putconf.sh [nodeA nodeB ...]

putconf.sh need target node list. It does not read nodelist.sh.
