FROM openjdk:8

ARG VERSION
ENV version=$VERSION

ADD jarstaging/com/valaxy/demo-workshop/${version}/demo-workshop-${version}.jar ttrend.jar 
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]