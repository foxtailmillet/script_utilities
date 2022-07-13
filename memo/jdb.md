# url
https://docs.oracle.com/javase/jp/1.3/tooldocs/solaris/jdb.html

# run java command
JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=9000,server=y,suspend=n"

# run Maven (MAVEN_OPTS env)
$env:MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=9000,server=y,suspend=y"

# jdb client
jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=9000

mvn -Dmaven.main.skip=true
mvn -Dmaven.test.skip=true

mvn install -U
mvn build-helper:remove-project-artifact
