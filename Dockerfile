# Start from the base Ubuntu image
FROM jenkins/jenkins:jdk21

# Set a working directory inside the container
WORKDIR /app

# Switch to root to install packages
USER root
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    git \
    zip \
    build-essential \
    pkg-config \
    cmake \
    make \
    lcov \
    g++ \
    libgtest-dev \
    valgrind \
    libprotobuf-dev protobuf-compiler \
    npm \
    python3 python3-pip python3-venv

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && curl -fsSL https://get.docker.com | sh
RUN usermod -aG docker jenkins

# Install Google Test
RUN git clone -q https://github.com/google/googletest.git /googletest \
  && mkdir -p /googletest/build \
  && cd /googletest/build \
  && cmake .. && make && make install \
  && cd / && rm -rf /googletest

# Switch back to jenkins user
USER jenkins

COPY ./requirements.txt /app/requirements.txt
RUN python3 -m venv venv
RUN ./venv/bin/pip3 install --no-cache-dir -r requirements.txt

# Install Jenkins plugins
RUN jenkins-plugin-cli \
    --plugins \
    ant \
    antisamy-markup-formatter \
    apache-httpcomponents-client-4-api \
    apache-httpcomponents-client-5-api \
    asm-api \
    authentication-tokens \
    blueocean \
    blueocean-bitbucket-pipeline \
    blueocean-commons \
    blueocean-config \
    blueocean-core-js \
    blueocean-dashboard \
    blueocean-display-url \
    blueocean-events \
    blueocean-git-pipeline \
    blueocean-github-pipeline \
    blueocean-i18n \
    blueocean-jwt \
    blueocean-personalization \
    blueocean-pipeline-api-impl \
    blueocean-pipeline-editor \
    blueocean-pipeline-scm-api \
    blueocean-rest \
    blueocean-rest-impl \
    blueocean-web \
    bootstrap5-api \
    bouncycastle-api \
    branch-api \
    build-timeout \
    caffeine-api \
    checks-api \
    cloudbees-bitbucket-branch-source \
    cloudbees-disk-usage-simple \
    cloudbees-folder \
    commons-lang3-api \
    commons-text-api \
    credentials \
    credentials-binding \
    dark-theme \
    display-url-api \
    durable-task \
    echarts-api \
    eddsa-api \
    email-ext \
    favorite \
    font-awesome-api \
    git \
    git-client \
    github \
    github-api \
    github-branch-source \
    gradle \
    gson-api \
    handy-uri-templates-2-api \
    htmlpublisher \
    instance-identity \
    ionicons-api \
    jackson2-api \
    jakarta-activation-api \
    jakarta-mail-api \
    javax-activation-api \
    jaxb \
    jenkins-design-language \
    jjwt-api \
    joda-time-api \
    jquery3-api \
    json-api \
    json-path-api \
    jsoup \
    junit \
    ldap \
    mailer \
    matrix-auth \
    matrix-project \
    metrics \
    mina-sshd-api-common \
    mina-sshd-api-core \
    okhttp-api \
    pipeline-build-step \
    pipeline-github-lib \
    pipeline-graph-analysis \
    pipeline-graph-view \
    pipeline-groovy-lib \
    pipeline-input-step \
    pipeline-milestone-step \
    pipeline-model-api \
    pipeline-model-definition \
    pipeline-model-extensions \
    pipeline-rest-api \
    pipeline-stage-step \
    pipeline-stage-tags-metadata \
    plain-credentials \
    plugin-util-api \
    prometheus \
    pubsub-light \
    resource-disposer \
    scm-api \
    script-security \
    snakeyaml-api \
    sse-gateway \
    ssh-credentials \
    ssh-slaves \
    structs \
    theme-manager \
    timestamper \
    token-macro \
    trilead-api \
    variant \
    workflow-aggregator \
    workflow-api \
    workflow-basic-steps \
    workflow-cps \
    workflow-durable-task-step \
    workflow-job \
    workflow-multibranch \
    workflow-scm-step \
    workflow-step-api \
    workflow-support \
    ws-cleanup \
    xunit
