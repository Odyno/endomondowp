#!/usr/bin/env bash

#Temp Directory to work
TEMP_WORKSPACE_DEFAULT="/tmp"

# GITHUB Repository name
GITHUB_REPO_NAME_DEFAULT="endomondowp"

# GITHUB user who owns the repo
GITHUB_REPO_OWNER_DEFAULT="Odyno"

# ADD COMPILE COMMAND
COMPILE_COMMAND_DEFAULT="npm run release"

#the SVN User
SVN_USER_DEFAULT="Odyno"

# The slug of your WordPress.org plugin
PLUGIN_SLUG_DEFAULT="endomondowp"

#Script is Interactive
INTERACTIVE=true




printusage(){
  echo "$ deploy.sh <version> <interactive>"
  echo "    <version>       string    The tag version on GitHUB"
  echo "    <interactive>   boolean   request interaction, default true"
}


checkVariable(){
    echo You have selected the tag version     : ${GITHUB_TAG_NAME}


    if [ "$INTERACTIVE" != "false" ]; then
        echo You have selected the interactive mode

        read -p "Please enter the slug of your WordPress.org plugin [$PLUGIN_SLUG_DEFAULT]: " PLUGIN_SLUG

        read -p "Please enter the SVN User [${SVN_USER_DEFAULT}]: " SVN_USER

        read -p " Please Enter GITHUB user who owns the repo [${GITHUB_REPO_OWNER_DEFAULT}]: " GITHUB_REPO_OWNER

        read -p "Please enter GITHUB Repository name [${GITHUB_REPO_NAME_DEFAULT}]: " GITHUB_REPO_NAME

        read -p " Please enter the command for the build [${COMPILE_COMMAND_DEFAULT}]: " COMPILE_COMMAND

        read -p "Please Enter the Workspace where the script can work safety [${TEMP_WORKSPACE_DEFAULT}]: " TEMP_WORKSPACE
    fi

    PLUGIN_SLUG="${PLUGIN_SLUG:-$PLUGIN_SLUG_DEFAULT}"

    SVN_USER="${SVN_USER:-${SVN_USER_DEFAULT}}"

    GITHUB_REPO_OWNER="${GITHUB_REPO_OWNER:-${GITHUB_REPO_OWNER_DEFAULT}}"

    GITHUB_REPO_NAME="${GITHUB_REPO_NAME:-${GITHUB_REPO_NAME_DEFAULT}}"

    COMPILE_COMMAND="${COMPILE_COMMAND:-${COMPILE_COMMAND_DEFAULT}}"

    TEMP_WORKSPACE="${TEMP_WORKSPACE:-${TEMP_WORKSPACE_DEFAULT}}"


    # Version will be used
    VERSION=$GITHUB_TAG_NAME

    MAINFILE=${PLUGIN_SLUG}.php

    # VARS
    ROOT_PATH=${TEMP_WORKSPACE}"/"

    TEMP_GITHUB_REPO=${PLUGIN_SLUG}"-git"

    TEMP_SVN_REPO=${PLUGIN_SLUG}"-svn"

    SVN_REPO="http://plugins.svn.wordpress.org/"${PLUGIN_SLUG}"/"

    GIT_REPO="git@github.com:"${GITHUB_REPO_OWNER}"/"${GITHUB_REPO_NAME}".git"

    echo PLUGIN_SLUG=$PLUGIN_SLUG
    echo SVN_USER=$SVN_USER
    echo GITHUB_REPO_OWNER=$GITHUB_REPO_OWNER
    echo GITHUB_REPO_NAME=$GITHUB_REPO_NAME
    echo COMPILE_COMMAND=$COMPILE_COMMAND
    echo TEMP_WORKSPACE=$TEMP_WORKSPACE
    echo GITHUB_TAG_NAME=$GITHUB_TAG_NAME
    echo VERSION=$VERSION
    echo MAINFILE=$MAINFILE
    echo ROOT_PATH=$ROOT_PATH
    echo TEMP_GITHUB_REPO=$TEMP_GITHUB_REPO
    echo TEMP_SVN_REPO=$TEMP_SVN_REPO
    echo SVN_REPO=$SVN_REPO
    echo GIT_REPO=$GIT_REPO

}


check_env () {

    # Check if subversion is installed before getting all worked up
    if ! which svn >/dev/null; then
        echo " [ ERROR ] You'll need to install subversion before proceeding. Exiting....";
        exit 1;
    fi

    # Check if subversion is installed before getting all worked up
    if ! which git >/dev/null; then
        echo " [ ERROR ] You'll need to install git before proceeding. Exiting....";
        exit 1;
    fi

}

clean_repo () {
    # DELETE OLD TEMP DIRS
    rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO
    rm -Rf $ROOT_PATH$TEMP_SVN_REPO
}


prepare_git_repo (){
    # MOVE INTO ROOT DIR
    cd $ROOT_PATH
    ###
    # PREPARE GIT REPOSITORY
    ###
    # CLONE GIT DIR
    echo "[ INFO ] Cloning GIT repository from GITHUB"
    git clone --progress $GIT_REPO $TEMP_GITHUB_REPO || { echo "Unable to clone repo."; exit 1; }
}



prepare_svn_repo (){
    # MOVE INTO ROOT DIR
    cd $ROOT_PATH

    # CHECKOUT SVN DIR IF NOT EXISTS
    if [[ ! -d $TEMP_SVN_REPO ]];
    then
        echo "[ INFO ] Checking out WordPress.org plugin repository"
        svn checkout --username $SVN_USER $SVN_REPO $TEMP_SVN_REPO || { echo "Unable to checkout repo."; exit 1; }
    fi
}



prepare_for_release (){

    # MOVE INTO GIT DIR
    cd $ROOT_PATH$TEMP_GITHUB_REPO

    # Switch Branch
    echo "[ INFO ] Switching to branch"
    git checkout ${GITHUB_TAG_NAME} || { echo "[ ERROR ] Unable to checkout branch."; exit 1; }


    # Check version in readme.txt is the same as plugin file after translating both to unix line breaks to work around grep's failure to identify mac line breaks
    NEWVERSION1=`grep "^Stable tag:" README.txt | awk -F' ' '{print $NF}'`
    echo "[ INFO ] readme.txt version: $NEWVERSION1"
    NEWVERSION2=`grep "^ \* Version:" $MAINFILE | awk -F' ' '{print $NF}'`
    echo "[ INFO ] $MAINFILE version: $NEWVERSION2"

    if [ "$NEWVERSION1" != "$NEWVERSION2" ]; then echo "[ ERROR ] Version in readme.txt & $MAINFILE don't match. Exiting...."; exit 1; fi


   if [ "$NEWVERSION1" != "$GITHUB_TAG_NAME" ]; then echo "[ ERROR ] Version don't match with tags, Exiting...."; exit 1; fi


    echo "[ INFO ] Versions match in readme.txt and $MAINFILE. Let's proceed..."

    echo "[ INFO ] Compile Project Let's proceed..."
    $COMPILE_COMMAND || { echo "[ ERROR ] Error on build"; exit 1; }

    # REMOVE UNWANTED FILES & FOLDERS
    echo "[ INFO ] Removing unwanted files"
    rm -Rf .git
    rm -Rf .github
    rm -Rf tests
    rm -Rf apigen
    rm -f .gitattributes
    rm -f .gitignore
    rm -f .gitmodules
    rm -f .travis.yml
    rm -f Gruntfile.js
    rm -f package.json
    rm -f .jscrsrc
    rm -f .jshintrc
    rm -f composer.json
    rm -f phpunit.xml
    rm -f phpunit.xml.dist
    rm -f README.md
    rm -f .coveralls.yml
    rm -f .editorconfig
    rm -f .scrutinizer.yml
    rm -f apigen.neon
    rm -f CHANGELOG.txt
    rm -f CONTRIBUTING.md
    rm -f deploy.sh
    rm -rf node_modules
}



release_it() {
    # MOVE INTO SVN DIR
    cd $ROOT_PATH$TEMP_SVN_REPO

    # UPDATE SVN
    echo "[ INF ]Updating SVN"
    svn update || { echo "[ ERROR ] Unable to update SVN."; exit 1; }

    # DELETE TRUNK
    echo "[ INFO ] Replacing trunk"
    rm -Rf trunk/

    # COPY GIT DIR TO TRUNK
    cp -R $ROOT_PATH$TEMP_GITHUB_REPO trunk/

    # DO THE ADD ALL NOT KNOWN FILES UNIX COMMAND
    svn add --force * --auto-props --parents --depth infinity -q

    # DO THE REMOVE ALL DELETED FILES UNIX COMMAND
    MISSING_PATHS=$( svn status | sed -e '/^!/!d' -e 's/^!//' )

    # iterate over filepaths
    for MISSING_PATH in $MISSING_PATHS; do
        svn rm --force "$MISSING_PATH"
    done

    # COPY TRUNK TO TAGS/$VERSION
    echo "[ INFO ] Copying trunk to new tag"
    svn copy trunk tags/${VERSION} || { echo "[ ERROR ] Unable to create tag."; exit 1; }

    # DO SVN COMMIT
    clear
    echo "[ INFO ] Showing SVN status"
    svn status


    if $INTERACTIVE ; then

        # PROMPT USER
        echo "";
        read -p "PRESS [ENTER] TO COMMIT RELEASE "${VERSION}" TO WORDPRESS.ORG AND GITHUB";
        echo "";

    fi

    # DEPLOY
    echo ""
    echo "[ INFO ] Committing to WordPress.org...this may take a while..."
    svn commit --username $SVN_USER -m "Release "${VERSION}", see readme.txt for the changelog." || { echo "[ ERROR ] Unable to commit."; exit 1; }

}




if [ -z "$1" ] ; then echo "[ ERROR ] Please provide the tag name to deploy "; printusage; exit 1; fi
GITHUB_TAG_NAME=$1

if  [ ! -z "$2" ] ; then INTERACTIVE=$2; fi


checkVariable


echo "[ INFO ] ************ [1/7] Check enviroment ************"
check_env
echo "[ INFO ] ************ [2/7] Clean repository space ************"
clean_repo
echo "[ INFO ] ************ [3/7] Get git repository ************"
prepare_git_repo
echo "[ INFO ] ************ [4/7] Prepare code for release ************"
prepare_for_release
echo "[ INFO ] ************ [5/7] Get svn repository ************"
prepare_svn_repo
echo "[ INFO ] ************ [6/7] Release It ************"
release_it
echo "[ INFO ] ************ [7/7] Done Clean Up ************ "
clean_repo

echo "[ INFO ] RELEASER DONE :D"
