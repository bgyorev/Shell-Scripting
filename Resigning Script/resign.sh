#!/bin/sh

originFile="$1"
filename=$(basename "$originFile")
directory=$(dirname "$originFile")
entitlements="$directory/Entitlements.plist"
provisioning=$(find -E "$directory" -maxdepth 1 -regex '.*(mobileprovision)')

touch "$directory/logfile.log"
logfile="$directory/logfile.log"

logit() 
{
    echo "[${USER}][`date`] - ${*}" >> ${logfile}
}
logit "----------------------------"

rm -rf "$directory/Payload"
logit "Removing old Payload"

unzip -d "$directory" "$originFile" 
logit "Unzipping old IPA file"

payload="$directory/Payload"
day=$(date +%d%m%Y)
backupFilename="${filename%.*} $day.ipa"
appBundle=$(find -E "$payload" -maxdepth 1 -regex '.*(app)')

cp "$provisioning" "$appBundle/embedded.mobileprovision"

signature="Replace with your certificate signature"
alias resigningCommand=$(codesign -f -s "$signature" --entitlements "$entitlements" "$appBundle")
resigningCommandLog=`(codesign -f -s "$signature" --entitlements "$entitlements" "$appBundle") 2>&1 &`

if [ resigningCommand ]; then
	logit "Resigning successful"
else
	logit "Failed to replace existing signature"
	logit $resigningCommandLog
	exit 1
fi

cp "$originFile" "$directory/$backupFilename"
logit "Origin file backuped as $backupFilename"

cd "$directory"

zip -qr "$filename" Payload
logit "SUCCESS"
logit "----------------------------"
exit 0