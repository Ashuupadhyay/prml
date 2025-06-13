# Use official Tomcat 10.1 with Jakarta EE 9+ support
FROM tomcat:10.1-jdk21

# Remove default apps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*


# ← Add the connector to Tomcat's global lib directory
COPY mysql-connector-j-9.2.0.jar /usr/local/tomcat/lib/

# Copy your WAR file to Tomcat (rename to ROOT.war for root URL)
COPY medicinedonation.war /usr/local/tomcat/webapps/medicinedonation.war

# Configure for Render's port
ENV PORT 8080
RUN sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml

# Health check for Render
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/homepage.jsp || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
