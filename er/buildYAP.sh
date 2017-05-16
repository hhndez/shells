#!/bin/bash
export DISPLAY=:0.0
############
IDENTITY_FILE=/home/ehuhern/Work/default_dcomos_key.pem
USER=centos
SERVER=dcomwww03
REMOTE_DIR=/var/www/html/yap
DAY=$(date -d "$D" '+%d')
MONTH=$(date -d "$D" '+%m')
YEAR=$(date -d "$D" '+%Y')
PREFIX=$YEAR$MONTH$DAY
############
GIT_REPO=ssh://ehuhern@gerrit.ericsson.se:29418/DCOM/YAP
PATH=.:$PATH:/usr/local/bin:/usr/bin/X11
BUILD_DIR=~/temp/build/YAP
WORKSPACE=~/temp/YAP_build
TEMP_DIR=/home/ehuhern/Work/shells/temp
ICON_TEMP=/home/ehuhern/Work/shells/er/data/YAP/_icons.less
ICON_FILE=$WORKSPACE/dcomlib/src/dcomlib/icons/_icons.less
TEMPAPPS="dcomlib,dcomcorelib,dcomwidgetlib,dashboard"
APPS=(aaa admin)
notify-send "Running in background the cdt2 build"
asset() {
  expected=$1
  received=$2
  message=$3
  if [ $expected -ne $received ]; then
	echo $message
	notify-send $message
	exit 1;
  fi
}

clear
if [ "$1" == "clean" ]; then
	echo "Removing workspace..."
	rm -fR $WORKSPACE
fi

rm -fR $BUILD_DIR

if [ ! -e $WORKSPACE ]; then
	echo "Creating workspace..."
	mkdir $WORKSPACE
	echo "Cloning workspace..."
	git clone $GIT_REPO $WORKSPACE
	cd $WORKSPACE/dashboard
	pwd
	count=1
	for app in ${APPS[@]}
        do
		linkApp="$WORKSPACE/$app"
		echo "---------------------------------------------------------------"	
		echo "Creating link... $linkApp ($count of ${#APPS[@]})"
		echo "---------------------------------------------------------------"	
		cdt2 package link $linkApp
		asset 0 $? "Error creating link"
		count=$((count + 1))
	done
else
	echo "Workpace already exists"
fi

cd $WORKSPACE/dashboard
cdt2 package list > $TEMP_DIR/list.txt
echo "Checking that every app is included in package list..."
for app in ${APPS[@]}
do
	app=`echo "${app,,}"`
	fgrep "$app -->" $TEMP_DIR/list.txt 	
	asset 0 $? "Does not exists $app in dashboard app"
done

echo "Check-updates"
count=1
for app in ${APPS[@]}
do
	echo "-------------------------------------------"	
	echo "App $app ($count of ${#APPS[@]})"
	echo "-------------------------------------------"	
	cd $WORKSPACE/$app
	cdt2 package install
	asset 0 $? "Package install $app"
	cdt2 package check-updates
	asset 0 $? "Package check-updates $app"
	cdt2 package install tablelib
	asset 0 $? "Package install $app"
	cdt2 package install chartlib
	asset 0 $? "Package install $app"
	count=$((count + 1))
done

echo "Replacing icon file"
cp $ICON_TEMP $ICON_FILE
asset 0 $? "Error copy file"

echo "Executing build"
cd $WORKSPACE
for app in ${APPS[@]}
do
   	TEMPAPPS="$TEMPAPPS,$app"
done
echo "TEMPAPPS = $TEMPAPPS"
notify-send "Apps: $TEMPAPPS"
cdt2 build --packages $TEMPAPPS --deploy $BUILD_DIR
asset 0 $? "Build failed"

echo "Removing temporary icon file"
git checkout -- $ICON_FILE
asset 0 $? "Checkout -- failed"
echo "CDT2 Build done"

TEMPAPPS="$TEMPAPPS,i18n,layouts,locales"
copyApps=$(echo $TEMPAPPS | tr "," "\n")
for apps in $copyApps
do
	if [ ! $apps == "dcomlib" ]; then
    	APPS+=($apps)
    fi
done

notify-send "Deploying: $TEMPAPPS"
ssh -i $IDENTITY_FILE $USER@$SERVER mkdir $REMOTE_DIR/temp
echo "Backup remote files $TEMPAPPS"
for app in ${APPS[@]}
do
	OLDAPP=$app"_$PREFIX"
   	echo "Backup $REMOTE_DIR/$app to $REMOTE_DIR/temp/$OLDAPP"
   	ssh -i $IDENTITY_FILE $USER@$SERVER mv $REMOTE_DIR/$app $REMOTE_DIR/temp/$OLDAPP
done

echo "Copying files..."
for app in ${APPS[@]}
do
   	echo "Copy $BUILD_DIR/$app into $REMOTE_DIR"
   	scp -i $IDENTITY_FILE -r $BUILD_DIR/$app $USER@$SERVER:$REMOTE_DIR
done
notify-send "DONE"
