FROM openjdk:17-oraclelinux7
RUN mkdir ~/myapp
WORKDIR ~/myapp
COPY ./target/*.jar .
RUN javac Main.java
CMD ["java", "Main"]
