# Build stage - could use maven or our image
FROM quay.io/eclipse/che-java8-maven:7.8.0 as builder

COPY . .
RUN mvn clean install

FROM openliberty/open-liberty:springBoot2-ubi-min as staging

COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
RUN springBootUtility thin \
    --sourceAppPath=/config/app.jar \
    --targetThinAppPath=/config/dropins/spring/thinClinic.jar \
    --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache




