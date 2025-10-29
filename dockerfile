FROM  openjdk:17
ADD https://trialirs226.jfrog.io/artifactory/jfrogjava-libs-release-local/spring-petclinic-4.0.0-SNAPSHOT.jar karthik.jar
EXPOSE 8080
CMD [ "java", "-jar", "karthik.jar"] 