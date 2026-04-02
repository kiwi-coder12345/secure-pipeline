# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy source code
COPY . .

# Resolve dependencies via JFrog Artifactory and build
ARG JFROG_URL
ARG JFROG_USERNAME
ARG JFROG_TOKEN

RUN mvn clean package -DskipTests=false \
    --settings settings.xml

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
