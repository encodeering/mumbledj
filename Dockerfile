# Build-Stage
FROM alpine:3.17

ENV GOPATH=/
ENV GO111MODULE=off

RUN apk add --update ca-certificates go ffmpeg make build-base opus-dev aria2

COPY . /src/github.com/matthieugrieger/mumbledj
COPY config.yaml /root/.config/mumbledj/config.yaml

WORKDIR /src/github.com/matthieugrieger/mumbledj

RUN make
RUN make install


# Final-Stage
FROM alpine:3.17

RUN        apk --no-cache add ffmpeg opus aria2 yt-dlp

VOLUME     /root/.config/mumbledj/

COPY       --from=0 /usr/local/bin/mumbledj /usr/local/bin/mumbledj
COPY       --from=0 /root/.config/mumbledj/ /root/.config/mumbledj/

ENTRYPOINT ["/usr/local/bin/mumbledj"]
