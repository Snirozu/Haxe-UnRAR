@echo off
cd test
haxe build.hxml
if not exist "build/" mkdir "build/"
xcopy bin\Test.exe build\ /Y
xcopy bin\*.dll build\ /Y
cd build
Test.exe