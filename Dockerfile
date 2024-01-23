FROM alpine:3.17
RUN apk add --no-cache gcompat=1.1.0-r0
COPY word-cloud-generator /opt/word-cloud-generator
RUN chmod +x /opt/word-cloud-generator
EXPOSE 8888
ENTRYPOINT ["/opt/word-cloud-generator"]
