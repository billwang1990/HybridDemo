
###########################################################################
###########################################################################
###########################################################################
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
echo "This is a pull request. No deployment will be done."
exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
echo "Testing on a branch other than master. No deployment will be done."
exit 0
fi
PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"

# echo $PROVISIONING_PROFILE

OUTPUTDIR="$PWD/build/Release-iphoneos"
# echo $OUTPUTDIR
# echo "DEVELOPER_NAME is ："
# echo $DEVELOPER_NAME
echo "***************************"
echo "*        Signing          *"
echo "***************************"
echo $PWD
echo "OUTPUTDIR is"
echo $OUTPUTDIR
ls $OUTPUTDIR
echo "***************************"
echo "*        Signing 1         *"
echo "***************************"

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
fir p $OUTPUTDIR/$APP_NAME.ipa -T $FIR_APP_TOKEN

curl -F "file=@$OUTPUTDIR/$APP_NAME.ipa" \
-F "uKey=$PGYER_UKEY" \
-F "_api_key=$PGYER_APIKEY" \
http://www.pgyer.com/apiv1/app/upload

RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"
