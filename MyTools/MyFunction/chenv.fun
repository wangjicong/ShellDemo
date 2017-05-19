#!/bin/bash
function chenv5
{
	export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
	export JRE_HOME=${JAVA_HOME}/jre
	export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
	export PATH=${JAVA_HOME}/bin:$PATH

	#gcc
	export PATH=/usr/bin:$PATH
}
function chenv4
{
	export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
	export JRE_HOME=${JAVA_HOME}/jre
	export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
	export PATH=${JAVA_HOME}/bin:$PATH

	#gcc
	export PATH=~/MyTools/MyRecovery/android4:$PATH
}
