#!/bin/bash
git filter-branch --force --env-filter '
OLD_NAME="凌封"
OLD_EMAIL=""
NEW_NAME="shenyulong2004"
NEW_EMAIL="shenyulong2004@example.com"

if [ "$GIT_COMMITTER_NAME" = "$OLD_NAME" ] || [ "$GIT_AUTHOR_NAME" = "$OLD_NAME" ]; then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' -- --all