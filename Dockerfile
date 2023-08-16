ARG BUNDLE=default
## Use Admin image as the builder
FROM cp.icr.io/cp/manage/manageadmin:8.6.2 as admin

ARG BUNDLE
USER root

## Replace web.xml for maximo-all maximo-x
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximo-x/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-guest.xml  web-guest-oidc.xml
RUN mv web-dev.xml  web.xml
RUN mv web-guest-dev.xml  web-guest.xml

## Replace web.xml for maximo-all maximouiweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-all maxrestweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maxrestweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-all mboweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/mboweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-all meaweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/meaweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-cron
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-cron/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-mea maxrestweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-mea/maxrestweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-mea meaweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-mea/meaweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-report
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-report/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-ui
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-ui/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

## Replace web.xml for maximo-x
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-x/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-guest.xml  web-guest-oidc.xml
RUN mv web-dev.xml  web.xml
RUN mv web-guest-dev.xml  web-guest.xml

## update package files
WORKDIR /opt/IBM/SMP/maximo/tools/maximo
RUN ./pkginstall.sh

## create the EAR file
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default
RUN ./maximo-$BUNDLE.sh
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-$BUNDLE/maximo-$BUNDLE-server/apps/
RUN ls -l

# Build the final image
FROM cp.icr.io/cp/manage/ubi-wlp-manage:3.0.1

ARG BUNDLE
RUN ls -l config/apps

## Copy the new EAR file from the admin builder
COPY --from=admin /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-$BUNDLE/maximo-$BUNDLE-server/apps/*.ear /config/apps/
RUN ls -l config/apps

## Copy the server xml from the admin builder
COPY --from=admin /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-$BUNDLE/maximo-$BUNDLE-server/server.xml /config/server-oidc.xml
COPY --from=admin /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-$BUNDLE/maximo-$BUNDLE-server/server-dev.xml /config/server.xml

# Set the env vars - Database params need to be edited
ENV DB_SSL_ENABLED=nossl
ENV MXE_DB_URL='jdbc:db2://db:50000/maximo'
ENV MXE_DB_SCHEMAOWNER=maximo
ENV MXE_DB_DRIVER='com.ibm.db2.jcc.DB2Driver'
ENV MXE_USEAPPSERVERSECURITY=0
ENV MXE_DB_USER=maximo
ENV MXE_DB_PASSWORD=maximo
ENV MXE_MASDEPLOYED=0
ENV LC_ALL=en_US.UTF-8

USER 1001
