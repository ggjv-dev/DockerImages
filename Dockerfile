FROM ubuntu

#install java
RUN apt update
RUN apt install -y openjdk-8-jre
RUN apt install -y openjdk-8-jdk

#Install git
RUN apt install -y git

#install maven
RUN apt install -y maven

# Install Google Chrome
RUN apt-get update \
        && apt-get install -y wget gnupg2 gnupg gnupg1 unzip

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
        && apt-get update -qqy \
        && apt-get -qqy install google-chrome-stable \
        && rm /etc/apt/sources.list.d/google-chrome.list \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
        && sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

#Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-6.3-bin.zip
RUN unzip gradle-*.zip
RUN mkdir /opt/gradle
RUN cp -pr gradle-*/* /opt/gradle
RUN echo "export PATH=/opt/gradle/bin:${PATH}" | tee /etc/profile.d/gradle.sh
RUN export PATH=/opt/gradle/bin:${PATH}
RUN chmod +x /etc/profile.d/gradle.sh
RUN /etc/profile.d/gradle.sh
RUN gradle -v

#Install Agent slave jenkins gabo
RUN wget http://93.189.95.96:8080/jnlpJars/agent.jar

VOLUME /var/lib/jenkins/workspace/ /workspace/
VOLUME $HOME/.m2 $HOME/.m2

CMD ["bash"]