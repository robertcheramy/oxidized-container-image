# Build manualy with
podman build -t oxidized-custom .

# Single-stage build of an oxidized container from phusion/baseimage-docker
FROM docker.io/phusion/baseimage:noble-1.0.0

ENV DEBIAN_FRONTEND=noninteractive

# add runit services
COPY oxidized/extra/oxidized.runit /etc/service/oxidized/run
COPY oxidized/extra/auto-reload-config.runit /etc/service/auto-reload-config/run
COPY oxidized/extra/update-ca-certificates.runit /etc/service/update-ca-certificates/run

# add non-privileged user
ARG UID=30000
ARG GID=$UID
RUN groupadd -g "${GID}" -r oxidized && useradd -u "${UID}" -r -m -d /home/oxidized -g oxidized oxidized

# update and set up dependencies
RUN apt-get -yq update \
    && apt-get -yq upgrade \
    && apt-get -yq --no-install-recommends install \
       # dependencies of oxidized
       ruby \
       # Gems needed by oxidized
       ruby-rugged ruby-slop \
       ruby-net-telnet ruby-net-ssh ruby-net-ftp ruby-ed25519 \
       # needed by psych (replace with deb package ruby-psych after 0.30.1)
       ruby-dev libyaml-dev cmake gcc make pkg-config libc6-dev \
       # Gems for specific inputs
       ruby-net-http-persistent ruby-mechanize \
       # Gems needed by oxidized-web
       ruby-charlock-holmes \
       # Needed by rugged [for oxidized]
       # ruby-dev libgit2-dev cmake pkg-config \
       # Needed by charlock_holmes [for oxidzed-web]
       # libicu-dev g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document psych:3.3.4
RUN gem install --no-document \
  # gems not present in unbuntu noble
  net-tftp \
  # oxidized itself
  oxidized:0.30.1 oxidized-web:0.14.0

EXPOSE 8888/tcp
