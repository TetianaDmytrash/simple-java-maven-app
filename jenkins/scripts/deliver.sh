#!/usr/bin/env bash
#!/bin/bash

# Вывод текущего пути
echo "Current working directory:"
pwd

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn clean package
set +x

# Проверка содержимого директории target после сборки
echo 'Contents of target directory after build:'
ls -l target

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
set +x
echo "Project name: $NAME"

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
set +x
echo "Project version: $VERSION"

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x

# Проверка существования JAR файла
JAR_FILE="target/${NAME}-${VERSION}.jar"
if [[ -f "$JAR_FILE" ]]; then
    echo "JAR file $JAR_FILE found. Checking permissions:"
    ls -l "$JAR_FILE"
    java -jar "$JAR_FILE"
else
    echo "Error: JAR file $JAR_FILE not found."
    exit 1
fi
set +x
