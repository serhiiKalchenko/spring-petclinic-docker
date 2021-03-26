FROM openjdk:17-oraclelinux7
RUN mkdir ~/myapp
WORKDIR ~/myapp
COPY ./target/*.jar .
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-2.4.2.jar"]
