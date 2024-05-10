# Create an Oracle Account
```
google-chrome --incognito https://login.oracle.com/
```
# Log in the Registry webpage, Search for Weblogic and Accept the License Agreement
- "You must agree to and accept the Oracle Standard Terms and Restrictions prior to downloading from the Oracle Container Registry"
```
google-chrome --incognito https://container-registry.oracle.com
```
# Log in the Registry to pull the images
```
docker login container-registry.oracle.com
```
# Pull a Weblogic Base Image
```
docker pull \
  container-registry.oracle.com/middleware/weblogic:14.1.1.0-dev-8-ol8
```
# Tag the Base Image to match the Oracle's sample Dockerfile on Github
```
docker tag \
  container-registry.oracle.com/middleware/weblogic:14.1.1.0-dev-8-ol8 \
  oracle/weblogic:12.2.1.3-dev
```
# Build the final Image from Github sample
```
docker build -t weblogic-domain-home-in-image \
  github.com/oracle/docker-images#main:/OracleWebLogic/samples/12213-domain-home-in-image
```
# Run the Compose and wait for the containers to became healthy
```
docker-compose up -d
watch "docker-compose ps | grep healthy | grep -E 'MS|admin|nginx'"
```
# weblogic.Deployer - Sample1 - Deploy Tomcat Sample WAR
```
docker run -it --rm --name deploy --net=host --entrypoint= weblogic-domain-home-in-image bash

mkdir -p mydeployments
curl -fSL# https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war \
  -o mydeployments/sample1.war

export CLASSPATH=/u01/oracle/wlserver/server/lib/weblogic.jar

java weblogic.Deployer -targets cluster-1 -adminurl t3://localhost:7001 \
  -user myuser -password mypassword1 -deploy mydeployments/sample1.war \
  -remote -upload -usenonexclusivelock

google-chrome --incognito localhost/sample1/hello

google-chrome --incognito http://localhost:7001/console
```
# weblogic.Deployer - Sample2 - Deploy Weblogic Sample WAR
```
docker run -it --rm --name deploy --net=host --entrypoint= weblogic-domain-home-in-image bash

mkdir /tmp/docker-images
curl -fSL# https://github.com/oracle/docker-images/tarball/main | \
  tar xvz -C /tmp/docker-images --strip-components=1

sed -i 's/sample/sample2/g' \
  /tmp/docker-images/OracleWebLogic/samples/12213-deploy-application/sample/WEB-INF/weblogic.xml

mkdir -p mydeployments
jar -cvf mydeployments/sample2.war \
  -C /tmp/docker-images/OracleWebLogic/samples/12213-deploy-application/sample .

export CLASSPATH=/u01/oracle/wlserver/server/lib/weblogic.jar

java weblogic.Deployer -targets cluster-1 -adminurl t3://localhost:7001 \
  -user myuser -password mypassword1 -deploy mydeployments/sample2.war \
  -remote -upload -usenonexclusivelock

google-chrome --incognito localhost/sample2

google-chrome --incognito http://localhost:7001/console
```
# Stop
```
docker-compose down
```
