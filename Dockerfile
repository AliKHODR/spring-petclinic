FROM openjdk:8-jdk-alpine as build

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# download the dependency if needed or if the pom file is changed
RUN ./mvnw dependency:go-offline -B

COPY src src

RUN ./mvnw package -DskipTests

# Production Stage for Spring boot application image
FROM alpine:latest as production
RUN apk --update add openjdk8-jre

COPY --from=build /app/target/*.jar /app/spring-boot-application.jar

# Run the Spring boot application
CMD ["java", "-jar", "/app/spring-boot-application.jar"]
