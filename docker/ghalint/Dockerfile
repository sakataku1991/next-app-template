FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS builder
ENV GHALINT_VERSION=1.5.5

RUN wget -q -O /tmp/ghalint.tar.gz "https://github.com/suzuki-shunsuke/ghalint/releases/download/v${GHALINT_VERSION}/ghalint_${GHALINT_VERSION}_linux_amd64.tar.gz" \
    && echo "579cbf9024f86a8255ce8acdd56c7792f0f9a7e76063d64cfb7b66ff65c396e4  /tmp/ghalint.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/ghalint.tar.gz -C /tmp

# ---

FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS runner
WORKDIR /repo
ENV GHALINT_LOG_COLOR=always

COPY --from=builder /tmp/ghalint /usr/local/bin/ghalint
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
