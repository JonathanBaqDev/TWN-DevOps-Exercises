#!/bin/bash

#Functions	
#Check Java version
check_java_version () {
	VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
} 

#Check major version
check_major () {
	#Get major version for Java 8 and earlier (1.x format)
	if [[ "$VERSION" == 1.* ]]; then
		MAJOR=$(echo "$VERSION" | cut -d. -f2)
	else
		MAJOR=$(echo "$VERSION" | cut -d. -f1)
	fi
}

check_java_install() {
	check_java_version
	check_major
}

#Check if Java is installed
if command -v java >/dev/null 2>&1; then

	check_java_install
	
	if [ "$MAJOR" -ge 11 ]; then
		echo "Java is already installed."
		echo "Detected version: $VERSION"
		exit 0
	else 
		echo "An older Java version is installed ($VERSION)."
		echo "Installing a newer version..."
	fi
else 
	echo "Java is not installed."
	echo "Installing Java..."
fi

#Install latest Java version
sudo apt update
sudo apt install -y default-jdk

check_java_install

if [ "$MAJOR" -ge 11 ]; then
	echo "Installation successful."
	echo "Java version $VERSION is installed."
else
	echo "Installation failed or Java version is still below 11."
fi
