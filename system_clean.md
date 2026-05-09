# Some Commands for anything

cleanmgr.exe /D C: /VERYLOWDISK /SETUP

## wsl movement

wsl --list --verbose
wsl --shutdown
wsl --export Ubuntu-22.04 Ubuntu-22.04.tar
wsl --unregister Ubuntu-22.04
wsl --import Ubuntu-22.04 x:\package_manager\ubuntu x:\package_manager\ubuntu\Ubuntu-22.04.tar --version 2

COMPOSER_HOME=x:\Composer

composer config --list --global

CODE=code --extensions-dir x:\.vscode\extensions

## JAVA ENVIRONMENT

CLASSPATH=;;;
JAVA_HOME=x:\java20
JAVA_JRE=x:\jre
CATALINA_BASE=x:\tomcat_base
CATALINA_HOME=x:\apache-tomcat-10.1.13
ANDROID_SDK_HOME=x:\android
GRADLE_USER_HOME=x:\android\.gradle

## nuget

NUGET_HTTP_CACHE_PATH=x:\package_manager\nuget\.nuget\v3-cache
NUGET_PACKAGES=x:\package_manager\nuget\.nuget\packages

## oracle

ORACLE_HOME=x:\oracle
ORACLE_SID=orcl

## yarn

YARN_CACHE_FOLDER=x:\yarn\Cache\v6

## temp

TEMP=x:\package_manager\Temp
