FROM eclipse-temurin:17-jre-alpine as builder
# First stage : Extract the layers
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

#FROM adoptopenjdk/openjdk11:alpine-jre as runtime
FROM eclipse-temurin:17-jre-alpine as runtime
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser

# Second stage : Copy the extracted layers
COPY --from=builder application/dependencies/ ./app/
COPY --from=builder application/spring-boot-loader ./app/
COPY --from=builder application/snapshot-dependencies/ ./app/
COPY --from=builder application/application/ ./app/
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
CMD ["java", "org.springframework.boot.loader.launch.JarLauncher"]