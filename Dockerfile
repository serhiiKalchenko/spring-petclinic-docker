FROM openjdk:17-oraclelinux7
RUN mkdir ~/myapp
WORKDIR ~/myapp
COPY ./target/*.jar .
CMD ["java", "-jar", "spring-petclinic-2.4.2.jar"]
