# Usage #

## System Requirements
* Running MacOS
* Having XCode and Developer tools installed

## Make sure you have the following files in one directory ##

* The `IPA` file to be resigned
* Valid `.mobileprovision` file
* `Entitlements.plist` file configured for the project 
* Valid Apple Developer program with valid distribution certificate

## Outcome
* Resigned application IPA file 
* Backup of the old IPA file

## Script calling ##
` ./resign.sh path/to/myapp.ipa `
