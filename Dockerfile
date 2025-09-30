# Start from the base Ubuntu image
FROM jenkins/jenkins:latest-jdk21

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
    wget \
    nano \
    bc \
    python3 python3-pip python3-venv \
    libx11-xcb1 \
    libxrender1 \
    libxcb1 \
    libxcb-glx0 \
    libxcb-keysyms1 \
    libxcb-image0 \
    libxcb-shm0 \
    libxcb-icccm4 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libgl1

# For debugging add:  libwww-perl iproute2 net-tools

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && curl -fsSL https://get.docker.com | sh
RUN usermod -aG docker jenkins

# Install Go and mcphost
RUN wget https://go.dev/dl/go1.25.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.25.1.linux-amd64.tar.gz
RUN GOBIN=/usr/local/bin/ /usr/local/go/bin/go install github.com/mark3labs/mcphost@latest

# install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

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
    docker-commons \
    docker-java-api \
    docker-plugin \
    docker-workflow \
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
    ssh-agent \
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
    xunit \
    xvfb
