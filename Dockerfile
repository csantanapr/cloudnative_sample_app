# Build stage - could use maven or our image
FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift as builder

COPY . /

RUN ./mvnw clean install

FROM openliberty/open-liberty:springBoot2-ubi-min

COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
RUN springBootUtility thin \
    --sourceAppPath=/config/app.jar \
    --targetThinAppPath=/config/dropins/spring/thinClinic.jar \
    --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache




