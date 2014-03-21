.PHONY: env tarball cli

all: env

FILE=presto-server-0.61.tar.gz

$(FILE):
	wget http://central.maven.org/maven2/com/facebook/presto/presto-server/0.61/presto-server-0.61.tar.gz

presto-cli-0.61-executable.jar:
	wget http://central.maven.org/maven2/com/facebook/presto/presto-cli/0.61/presto-cli-0.61-executable.jar

presto: presto-cli-0.61-executable.jar
	mv $< $@
	chmod 755 $@

cli: presto

env: $(FILE)
	tar xzf presto-server-0.61.tar.gz
	mv presto-server-0.61/* .
