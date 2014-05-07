.PHONY: env tarball cli devrel

all: env

FILE=presto/presto-server/target/presto-server-0.66.tar.gz
#FILE=presto-server-0.62.tar.gz

CLIJAR=presto/presto-cli/target/presto-cli-0.66-executable.jar

#$(FILE):
#	wget http://central.maven.org/maven2/com/facebook/presto/presto-server/0.61/presto-server-0.61.tar.gz

presto:
	git clone git://github.com/facebook/presto.git
	cd presto && git checkout 0.66

$(FILE): presto
	cd presto/presto-server &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

$(CLIJAR): presto
	cd presto/presto-cli &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

devrel: $(FILE)
	tar xzf $<
	rm -rf dev
	mkdir dev
	mkdir -p presto-server-0.66/plugin/riak
	sh build_devrel.sh presto-server-0.66 1
	sh build_devrel.sh presto-server-0.66 2
	sh build_devrel.sh presto-server-0.66 3
	sh build_devrel.sh presto-server-0.66 4
	sh build_devrel.sh presto-server-0.66 5

presto-cli: $(CLIJAR)
	cp $< $@
	chmod 755 $@

cli: presto-cli

env: $(FILE) cli
	tar xzf $<
	mkdir -p data
	mv presto-server-0.66/* .
	mkdir presto-plugin/presto-riak

clean:
	rm -rf bin lib plugin data NOTICE README.txt
