# Build stage - could use maven or our image
FROM adoptopenjdk/openjdk8-openj9 as builder

RUN mkdir /app
WORKDIR /app
COPY . /app/

RUN ./mvnw clean install

FROM openliberty/open-liberty:springBoot2-ubi-min

COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
RUN springBootUtility thin \
    --sourceAppPath=/config/app.jar \
    --targetThinAppPath=/config/dropins/spring/thinClinic.jar \
    --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache




