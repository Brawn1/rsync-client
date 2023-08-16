FROM debian:bullseye-slim
MAINTAINER Günter Bailey <guenter.brawn@gmail.com>

ENV LANG C.UTF-8

RUN set -x; \
	apt update && \
	apt install -y --no-install-recommends rsync ssh gzip && \
	rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    chown -R root:root /root/.ssh && \
    chmod a+x /entrypoint.sh

VOLUME ["/root/.ssh", "/config"]
ENTRYPOINT ["/entrypoint.sh"]
