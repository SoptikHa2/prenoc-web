#!/bin/bash
(
cd /var/www/prenoc || return
# Force pull
git fetch --all
git reset --hard origin/beta
# Write last commit hash to version.txt
echo $(git log -1 --oneline | cut -d' ' -f1) > version.txt
)
