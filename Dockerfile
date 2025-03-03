FROM ubuntu:22.04

# Install core utilities & dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    jq \
    docker.io \
    awscli \
    openjdk-11-jdk \
    build-essential \
    python3 python3-pip \
    && apt-get clean

# Install Trivy (direct from Aqua Security)
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -

# Install Node.js & NVM
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default

# Install Sonar Scanner CLI
RUN curl -o /opt/sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && apt-get install -y unzip \
    && unzip /opt/sonar-scanner-cli.zip -d /opt \
    && ln -s /opt/sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner \
    && ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Ensure sonar-scanner is in PATH
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner

# Cleanup
RUN rm -rf /var/lib/apt/lists/* /opt/sonar-scanner-cli.zip

# Set NVM in profile for future shells
RUN echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
