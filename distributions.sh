#!/bin/bash
NAME=alynn-website-content
MAINTAINER="Alistair Lynn <alistair@alynn.co.uk>"
VENDOR="Alistair Lynn"
LICENSE="All Rights Reserved"
DESCRIPTION="Alistair Lynn's personal/professional website content"
URL="http://alynn.co.uk"
INSTALL_TO="/var/www/html"
# END OF CONFIG
DIST="$1"
if [ -z "$DIST" ]; then
    echo "Must specify DIST. Usage: $0 <dist-directory>"
    exit 1
fi
set -e
mkdir -p "$DIST"
FPM="bundle exec fpm"
if [ -n "$CI_PULL_REQUESTS" ]; then
    VERSION="pr"
    RELEASE="$CIRCLE_BUILD_NUM"
elif [ -n "$CIRCLE_BRANCH" ]; then
    VERSION=$(echo "$CIRCLE_BRANCH" | tr '[:lower:]' '[:upper:]')
    RELEASE="$CIRCLE_BUILD_NUM"
else
    VERSION="dev"
    RELEASE=$(git describe 2>/dev/null || (git rev-list HEAD | wc -l | tr -d ' '))
fi
function package {
    $FPM -s dir \
         -n "$NAME" \
         -C _site \
         --force \
         --license "$LICENSE" \
         --version "$VERSION" \
         --iteration "$RELEASE" \
         --vendor "$VENDOR" \
         --maintainer "$MAINTAINER" \
         --description "$DESCRIPTION" \
         --architecture all \
         --url "$URL" \
         --directories "$INSTALL_TO" \
         $* \
         .="$INSTALL_TO"
}
package -t deb \
        --deb-compression xz \
        --deb-user www-data \
        --deb-group www-data \
        --package "$DIST/${NAME}_${VERSION}-${RELEASE}_all.deb"
