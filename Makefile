.PHONY: env tarball cli devrel

all: env

FILE=presto/presto-server/target/presto-server-0.62.tar.gz
#FILE=presto-server-0.62.tar.gz

#$(FILE):
#	wget http://central.maven.org/maven2/com/facebook/presto/presto-server/0.61/presto-server-0.61.tar.gz

presto:
	git clone git://github.com/facebook/presto.git
	cd presto/presto-server && git checkout 0.62 

$(FILE): presto
	cd presto/presto-server &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

presto-cli-0.61-executable.jar:
	wget http://central.maven.org/maven2/com/facebook/presto/presto-cli/0.61/presto-cli-0.61-executable.jar

devrel: $(FILE)
	tar xzf $<
	rm -rf dev
	mkdir dev
	mkdir -p presto-server-0.62/plugin/riak
	sh build_devrel.sh presto-server-0.62 1
	sh build_devrel.sh presto-server-0.62 2
	sh build_devrel.sh presto-server-0.62 3
	sh build_devrel.sh presto-server-0.62 4
	sh build_devrel.sh presto-server-0.62 5

presto-cli: presto-cli-0.61-executable.jar
	mv $< $@
	chmod 755 $@

cli: presto-cli

env: $(FILE)
	tar xzf $<
	mkdir -p data
	mv presto-server-0.62/* .

clean:
	rm -rf bin lib plugin data NOTICE README.txt