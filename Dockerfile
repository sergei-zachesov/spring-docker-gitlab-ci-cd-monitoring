FROM gradle:8.10.2-jdk21-alpine as build
WORKDIR /app
COPY --chown=gradle:gradle . /app
RUN gradle clean assemble

FROM eclipse-temurin:21.0.5_11-jre-noble as builder
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:21.0.5_11-jre-noble
WORKDIR /app
COPY --from=builder app/dependencies/ ./
COPY --from=builder app/spring-boot-loader/ ./
COPY --from=builder app/snapshot-dependencies/ ./
COPY --from=builder app/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]