#!/bin/bash

groupmod -o -g "$PGID" abc
usermod -o -u "$PUID" abc

chown abc:abc /00-asp
chown abc:abc /01-asp
chown abc:abc /02-asp
chown abc:abc /03-asp