source $stdenv/setup

mkdir -p $out/lib/java
cp -av $src $out/lib/java

mkdir -p $out/bin
cat > $out/bin/jenkins <<EOF
#! $SHELL -e
exec $jre/bin/java -jar $out/lib/java/jenkins.war
EOF
chmod +x $out/bin/jenkins