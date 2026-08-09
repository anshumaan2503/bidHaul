# Multi-stage Dockerfile for BidHaul Backend Container
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy backend pom.xml and dependencies
COPY backend/pom.xml .
RUN mvn dependency:go-offline -B

# Copy backend source code and build
COPY backend/src ./src
RUN mvn package -DskipTests -B

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENV PORT=8080

ENTRYPOINT ["java", "-jar", "app.jar"]
