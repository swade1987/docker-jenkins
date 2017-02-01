FROM openjdk:8-jdk
MAINTAINER Steve Wade <steven@stevenwade.co.uk> (@swade1987)

# Set necessary environment variables
ENV JENKINS_VERSION=1.651.3
ENV TINI_VERSION 0.9.0
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_UC https://updates.jenkins.io
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

RUN apt-get update && apt-get install -y git curl && \
rm -rf /var/lib/apt/lists/* && \
mkdir -p /usr/share/jenkins/ref/init.groovy.d && \
curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && chmod +x /bin/tini && \
curl -fsSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war -o /usr/share/jenkins/jenkins.war && \
mkdir -p ${JENKINS_HOME}/plugins

# Jenkins home directory is a volume, so configuration and build history can be persisted and survive image upgrades
VOLUME /var/jenkins_home

RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface and expose port for attached slave agents:
EXPOSE 8080 50000

USER root

COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY apprenda.hpi ${JENKINS_HOME}/plugins

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]