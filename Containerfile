FROM alpine:latest

# Install Asterisk and core PJSIP modules
RUN apk add --no-cache \
    asterisk \
    asterisk-sample-config \
    asterisk-sounds-en

# Expose SIP and RTP ports
EXPOSE 5060/udp 5060/tcp 10000-20000/udp

# Run Asterisk in foreground mode
ENTRYPOINT ["asterisk", "-f", "-U", "asterisk"]

