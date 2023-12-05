FROM tomcat:10-jdk17

EXPOSE 8080

COPY src/main/webapp/WEB-INF/lib/mssql-jdbc-11.2.0.jre11.jar /usr/local/tomcat/lib/mssql-jdbc-11.2.0.jre11.jar


CMD ["catalina.sh", "run"]
