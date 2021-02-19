# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /
RUN make geth
# RUN cd /go-ethereum && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /build/bin/geth /node_drive/

RUN PATH=$PATH:/node_drive/eth-node/go-ethereum/build/bin/geth
EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth --identity FINXRopsten --rpc --ws --wsapi eth,web3,debug,txpool,net,shh,db,admin,debug --ropsten --syncmode light --rpcapi eth,web3,debug,txpool,net,shh,db,admin,debug --wsorigins localhost --gcmode full --rpcport=8547 --cache 2048 --http --http.addr 0.0.0.0 http.port --graphql --metrics"]
