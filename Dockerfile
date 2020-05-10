FROM golang:1.14-alpine

ENV REVIEWDOG_VERSION=v0.10.0
ENV TMPL_VERSION=v1.2.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} && \
  wget -O - -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh| sh -s -- -b /usr/local/bin/ ${TMPL_VERSION}

RUN go get honnef.co/go/tools/cmd/staticcheck

COPY entrypoint.sh /entrypoint.sh
COPY json.tmpl /json.tmpl

ENTRYPOINT ["/entrypoint.sh"]
