# SPDX-FileCopyrightText: 2025 GSI Helmholtzzentrum für Schwerionenforschung GmbH <https://www.gsi.de/en/>
#
# SPDX-License-Identifier: LGPL-3.0-only

FROM golang:alpine AS build
ENV CGO_ENABLED=0
ENV GOBIN=/go/bin
WORKDIR /go/src
RUN --mount=type=bind,source=.,target=/go/src \
    --mount=type=cache,target="/root/.cache/go-build" \
 go build -v -o ${GOBIN} ./...

FROM scratch AS buildresult
ENV GOBIN=/go/bin
COPY --link --from=build ${GOBIN}/* /

# https://github.com/ofek/terminal-demo/blob/master/README.md
FROM ofekmeister/terminal-demo AS record
ARG CAST ROWS COLS
ENV GOBIN=/go/bin
WORKDIR /record
COPY --link --from=build ${GOBIN} _out/
COPY cast/${CAST}/config.toml .
RUN /root/.internal/venv/bin/python -u /root/.internal/record.py --rows ${ROWS} --cols ${COLS}

FROM scratch AS recordresult
ARG CAST
COPY --link --from=record /record/record.gif /${CAST}.gif
