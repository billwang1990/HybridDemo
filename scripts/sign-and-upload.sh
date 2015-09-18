if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
echo "This is a pull request. No deployment will be done."
exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
echo "Testing on a branch other than master. No deployment will be done."
exit 0
fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"

echo $PROVISIONING_PROFILE

OUTPUTDIR="$PWD/build/Release-iphoneos"
echo $OUTPUTDIR
xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APPNAME.app" -o "$OUTPUTDIR/$APPNAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
ls $OUTPUTDIR
echo "billwang1990.github.io"
fir p $OUTPUTDIR/$APPNAME.ipa -T $FIR_APP_TOKEN
RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"
