
openssl aes-256-cbc -k "qwe" -in scripts/profile/HbridADHoc1.mobileprovision.enc -d -a -out scripts/profile/HbridADHoc1.mobileprovision
openssl aes-256-cbc -k "qwe" -in scripts/certs/dist.cer.enc -d -a -out scripts/certs/dist.cer
openssl aes-256-cbc -k "qwe" -in scripts/certs/dist.p12.enc -d -a -out scripts/certs/dist.p12
security delete-keychain ios-build.keychain
export KEY_PASSWORD="qwe"
export PROFILE_NAME="HbridADHoc1"



echo $KEY_PASSWORD
echo $PROFILE_NAME

security create-keychain -p travis ios-build.keychain
security import ./scripts/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/certs/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/certs/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/profile/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

security find-identity -p codesigning ~/Library/Keychains/ios-build.keychain
security list-keychains