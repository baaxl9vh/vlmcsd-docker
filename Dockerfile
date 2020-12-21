FROM alpine:latest as builder
WORKDIR /root
RUN apk add --no-cache git make build-base \
    && git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git \
    && cd vlmcsd/ \
    && make

FROM alpine:latest
ENV TZ="Asia/Shanghai"
WORKDIR /root/
RUN apk add -U tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd
EXPOSE 1688/tcp
CMD [ "/usr/bin/vlmcsd", "-D", "-d" ]