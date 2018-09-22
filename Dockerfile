# Build-Stage
FROM alpine:3.8

ENV GOPATH=/

RUN apk add --update ca-certificates go ffmpeg make build-base opus-dev python aria2 wget
RUN apk upgrade

RUN wget https://yt-dl.org/downloads/latest/youtube-dl -O /bin/youtube-dl && chmod a+x /bin/youtube-dl

COPY . /src/github.com/matthieugrieger/mumbledj
COPY config.yaml /root/.config/mumbledj/config.yaml

WORKDIR /src/github.com/matthieugrieger/mumbledj

RUN make
RUN make install
RUN apk del go make build-base && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/mumbledj"]

# Final-Stage
FROM alpine:3.8

RUN        apk --no-cache add python ffmpeg opus aria2

VOLUME     /root/.config/mumbledj/

COPY       --from=0 /bin/youtube-dl         /bin/youtube-dl
COPY       --from=0 /usr/local/bin/mumbledj /usr/local/bin/mumbledj
COPY       --from=0 /root/.config/mumbledj/ /root/.config/mumbledj/

ENTRYPOINT ["/usr/local/bin/mumbledj"]
