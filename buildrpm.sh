#!/bin/bash

PROJECT=vmfs-tools
CWD=`pwd`
RPMDIR=$CWD/rpmbuild
GITCOMMIT=`git rev-parse --short HEAD`
GITVERSION=`git describe --match "v[0-9].*" --abbrev=0 HEAD`
VERSION=${GITVERSION//v}_${GITCOMMIT}

function package() {
    cleanup

    rm -f $PROJECT-$VERSION-*rpm

    # create rpm build environment
    mkdir -p $RPMDIR/SPECS
    mkdir -p $RPMDIR/BUILD
    mkdir -p $RPMDIR/RPMS
    mkdir -p $RPMDIR/SRPMS
    mkdir -p $RPMDIR/SOURCES/$PROJECT-$VERSION

    # copy files into rpm build environment
    (tar -c --exclude .git --exclude $RPMDIR  .  | tar -C $RPMDIR/SOURCES/$PROJECT-$VERSION -x )
    (cd $RPMDIR/SOURCES/; tar -czf $PROJECT-$VERSION.tar.gz $PROJECT-$VERSION)
    cp $PROJECT.spec $RPMDIR/SPECS

    # build RPM
    rpmbuild --define "_topdir $RPMDIR" "-D_ver $VERSION" -bb $RPMDIR/SPECS/$PROJECT.spec || exit
    cp $RPMDIR/RPMS/x86_64/$PROJECT-$VERSION-*rpm .

    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo RPM BUILD COMPLETE, check current directory for RPMs
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    cleanup
}

function cleanup() {
    if [ -d $RPMDIR ]; then
        rm -rf $RPMDIR
    fi
}

package
