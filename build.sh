#!/bin/bash

# Clean and build the solution in Release configuration
xbuild /property:Platform="Any CPU" /property:Configuration=Release /target:Clean
xbuild /property:Platform="Any CPU" /property:Configuration=Release

# Create a new release directory
rm -rf release
mkdir release

# Get the overall version from the Unarchiver project's assembly information
AKPKGVERSION=`cat Unarchiver/Properties/AssemblyInfo.cs | grep "^\[assembly: AssemblyVersion(\"[^\"]*" --color=never -o | grep -o -P --color=never "\d.\d.\d"`

# Akeeba eXtract Wizard for Linux
zip -j release/extract-wizard-linux-$AKPKGVERSION.zip ExtractWizardGtk/bin/Release/*.exe ExtractWizardGtk/bin/Release/*.dll

# Akeeba eXtract Wizard for macOS
pushd release
mkdir 000
cp -Rf ../ExtractWizardGtk/macOS/Akeeba\ eXtract\ Wizard.app .
cp ../ExtractWizardGtk/bin/Release/*.exe Akeeba\ eXtract\ Wizard.app/Contents/Resources/
cp ../ExtractWizardGtk/bin/Release/*.dll Akeeba\ eXtract\ Wizard.app/Contents/Resources/
mv Akeeba\ eXtract\ Wizard.app 000
cd 000
zip -r ../extract-wizard-macos-$AKPKGVERSION.zip *
cd ..
rm -rf 000
popd

# Akeeba eXtract CLI for macOS and Linux
zip -j release/extract-cli-macos-linux-$AKPKGVERSION.zip extractCLI/bin/Release/*.exe extractCLI/bin/Release/*.dll
