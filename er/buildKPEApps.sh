#!/bin/bash
export DISPLAY=:0.0
GIT_REPO=ssh://ehuhern@gerrit.ericsson.se:29418/DCOM/KPIs
PATH=.:$PATH:/usr/local/bin:/usr/bin/X11
BUILD_DIR=~/temp/buildKPIs
WORKSPACE=~/temp/KPIs
TEMP_DIR=/home/ehuhern/Work/shells/temp
ICON_TEMP=/home/ehuhern/Work/shells/ericsson/data/_icons.less
ICON_FILE=$WORKSPACE/dcomlib/src/dcomlib/icons/_icons.less
TEMPAPPS="dcomlib,dcomcorelib,dcomwidgetlib,dashboard"
#TEMPAPPS="dcomlib,dashboard"
#APPS=(dcomlib aaa accounts dashboard dcomadmin resetpassword o2f o2fgordon compadmin)
APPS=(aaa accounts dcomadmin resetpassword o2f o2fgordon compadmin compmgmt competence)
#APPS=(aaa accounts dcomadmin)
notify-send "Running in background the cdt2 build"
echo $?
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

#If workspace dir does not exists, it creates a new one and clone the repository.
if [ ! -e $WORKSPACE ]; then
	echo "Creating workspace..."
	mkdir $WORKSPACE
	echo "Cloning workspace..."
	git clone $GIT_REPO $WORKSPACE
	cd $WORKSPACE/dashboard
#	echo "Downloading commit..."
#	git reset --hard 11f8007c1ccf8c348e3a12af8440dfd03b508f69
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
   	#app=`echo "${app,,}"`
   	TEMPAPPS="$TEMPAPPS,$app"
done
echo "TEMPAPPS = $TEMPAPPS"
notify-send "Apps: $TEMPAPPS"
cdt2 build --packages $TEMPAPPS --deploy $BUILD_DIR
asset 0 $? "Build failed"

echo "Removing temporary icon file"
git checkout -- $ICON_FILE
#git checkout -- $RADAR_FILE
asset 0 $? "Checkout -- failed"
notify-send "DONE"
echo "CDT2 Build done"
