FROM openjdk:17-oraclelinux7
COPY ./target/*.jar /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
