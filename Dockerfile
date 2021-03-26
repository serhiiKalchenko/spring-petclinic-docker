FROM openjdk:17-oraclelinux7
RUN mkdir ~/myapp
WORKDIR ~/myapp
COPY ./target/*.jar ./spring-petclinic.jar
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic.jar"]
