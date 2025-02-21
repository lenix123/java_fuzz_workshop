FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget git unzip

# install jdk
RUN wget https://download.oracle.com/java/22/archive/jdk-22.0.2_linux-x64_bin.tar.gz
RUN tar -xf jdk-22.0.2_linux-x64_bin.tar.gz && rm jdk-22.0.2_linux-x64_bin.tar.gz
RUN mv jdk-22.0.2 /opt/
ENV JAVA_HOME='/opt/jdk-22.0.2'
ENV PATH="$JAVA_HOME/bin:$PATH"

# install mvn
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
RUN tar -xf apache-maven-3.9.6-bin.tar.gz && rm apache-maven-3.9.6-bin.tar.gz
RUN mv apache-maven-3.9.6 /opt/
ENV M2_HOME='/opt/apache-maven-3.9.6'
ENV PATH="$M2_HOME/bin:$PATH"

# clone pdfbox repository
RUN mkdir /home/fuzz
WORKDIR /home/fuzz
RUN wget https://dlcdn.apache.org/pdfbox/3.0.4/pdfbox-3.0.4-src.zip
RUN unzip pdfbox-3.0.4-src.zip && rm pdfbox-3.0.4-src.zip && mv pdfbox-3.0.4 pdfbox

# install jazzer
RUN mkdir jazzer
WORKDIR /home/fuzz/jazzer
RUN wget https://github.com/CodeIntelligenceTesting/jazzer/releases/download/v0.24.0/jazzer-linux.tar.gz
RUN tar xf jazzer-linux.tar.gz && rm jazzer-linux.tar.gz
ENV PATH="$PATH:/home/fuzz/jazzer"

# get log4j
WORKDIR /home/fuzz
RUN mkdir log4j
WORKDIR /home/fuzz/log4j
RUN wget https://downloads.apache.org/logging/log4j/2.24.3/apache-log4j-2.24.3-bin.zip
RUN unzip apache-log4j-2.24.3-bin.zip && rm apache-log4j-2.24.3-bin.zip
WORKDIR /home/fuzz

# get jacoco
RUN mkdir jacoco
WORKDIR /home/fuzz/jacoco
RUN wget https://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/0.8.12/jacoco-0.8.12.zip -O jacoco.zip
RUN unzip jacoco.zip && rm jacoco.zip
WORKDIR /home/fuzz
