FROM gradle:8.12.1-jdk21-alpine AS build
COPY build.gradle gradle.properties settings.gradle /app/
WORKDIR /app/
RUN gradle clean build --no-daemon > /dev/null 2>&1 || true
COPY --chown=gradle:gradle ./ /app/
RUN gradle clean assemble

FROM eclipse-temurin:21.0.6_7-jre-noble AS builder
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --destination extracted

FROM eclipse-temurin:21.0.6_7-jre-noble
WORKDIR /app
COPY --from=builder /app/extracted/dependencies/ ./
COPY --from=builder /app/extracted/spring-boot-loader/ ./
COPY --from=builder /app/extracted/snapshot-dependencies/ ./
COPY --from=builder /app/extracted/application/ ./
ENV TZ=Europe/Moscow
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENTRYPOINT ["java", "-jar", "app.jar"]
