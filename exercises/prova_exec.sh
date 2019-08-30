#!/bin/bash

echo "-------------------------------------------------------"
echo "Generate Java code for prova:"

java -jar fly-standalone.jar /project/target/prova.fly


echo ""
echo "Java code generated!"
echo ""
echo "-------------------------------------------------------"
echo " "

mkdir prova

mv ./src-gen ./prova

cd prova

echo "-------------------------------------------------------"
echo "Generate jar file: "
mvn -q archetype:generate -DgroupId=fly -DartifactId=prova -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

if [ $? -ne 0 ]; then
        echo "Error in maven archetype:genarate"
        exit 1
    fi

cp src-gen/prova.java prova/src/main/java/fly/

cp src-gen/ prova/src/main/java/fly/

cd prova

echo '<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>fly</groupId>
  <artifactId>prova</artifactId>
  <packaging>jar</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>prova</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>tech.tablesaw</groupId>
      <artifactId>tablesaw-core</artifactId>
      <version>LATEST</version>
    </dependency>
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.8.5</version>
    </dependency>
    <dependency>
      <groupId>com.amazonaws</groupId>
      <artifactId>aws-java-sdk</artifactId>
      <version>1.11.448</version>
    </dependency>
  </dependencies>

  <build>
      <resources>
      <resource>
        <directory>src/main/java/fly</directory>
        <includes>
          <include>
            **/*.*
          </include>
        </includes>
      </resource>
    </resources>
    <plugins>
      <!-- download source code in Eclipse, best practice -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-eclipse-plugin</artifactId>
        <version>2.9</version>
        <configuration>
          <downloadSources>true</downloadSources>
          <downloadJavadocs>false</downloadJavadocs>
        </configuration>
      </plugin>

      <!-- Set a compiler level -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>2.3.2</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>

      <!-- Maven Assembly Plugin -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>2.4.1</version>
        <configuration>
          <!-- get all project dependencies -->
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
          <!-- MainClass in mainfest make a executable jar -->
          <archive>
            <manifest>
            <addClasspath>true</addClasspath>
            <mainClass>prova</mainClass>
            </manifest>
          </archive>
        </configuration>
        <executions>
          <execution>
          <id>make-assembly</id>
          <!-- bind to the packaging phase -->
          <phase>package</phase> 
          <goals>
            <goal>single</goal>
          </goals>
          </execution>
        </executions>
      </plugin>

    </plugins>
  </build>

</project>' >pom.xml

mvn -q clean package -DskipTests

if [ $? -ne 0 ]; then 
        echo "Error in maven clean package"
        exit 1
    fi

cd ..

cp prova/target/prova-1.0-SNAPSHOT-jar-with-dependencies.jar ./

mv prova-1.0-SNAPSHOT-jar-with-dependencies.jar prova.jar

echo ""
echo "-------------------------------------------------------"
echo "Jar file prova.jar is generated"
echo "Execute: java -jar prova.jar"
echo "-------------------------------------------------------"

java -jar prova.jar

cd ..
rm -r prova