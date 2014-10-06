.PHONY: env tarball cli devrel riak-release latest-presto riak-devrel presto-devrel

all: env cli latest-presto riak-release

FILE=presto/presto-server/target/presto-server-0.77.tar.gz

CLIJAR=presto/presto-cli/target/presto-cli-0.77-executable.jar
VERIFIER=presto/presto-verifier/target/presto-verifier-0.77-executable.jar

#$(FILE):
#	wget http://central.maven.org/maven2/com/facebook/presto/presto-server/0.61/presto-server-0.61.tar.gz

presto:
	git clone git://github.com/facebook/presto.git

latest-presto: presto
	@cd presto && git fetch && git checkout 0.77

$(FILE): latest-presto
	@cd presto/presto-server &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

$(CLIJAR): presto
	@cd presto/presto-cli &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

$(VERIFIER): presto
	@cd presto/presto-verifier &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

devrel:  presto-devrel riak-devrel

presto-devrel: $(FILE) dev
	tar xzf $(FILE)	
	rm -rf dev
	mkdir dev
	mkdir -p presto-server-0.77/plugin/presto-riak
	sh build_devrel.sh presto-server-0.77 1
	sh build_devrel.sh presto-server-0.77 2
	sh build_devrel.sh presto-server-0.77 3
	sh build_devrel.sh presto-server-0.77 4
	sh build_devrel.sh presto-server-0.77 5

presto-verifier: $(VERIFIER)
	cp $< $@
	chmod 755 $@
	mv $@ bin/

presto-cli: $(CLIJAR)
	cp $< $@
	chmod 755 $@
	mv $@ bin/

cli: presto-cli presto-verifier

env: $(FILE)
	tar xzf $<
	mkdir -p data
	mv presto-server-0.77/* .
	mkdir plugin/presto-riak

clean:
	rm -rf bin lib plugin data NOTICE README.txt

test:
	mvn -Dmaven.junit.usefile=false test 

riak:
	git clone git://github.com/basho/riak -b 2.0

riak-release: riak
	cd riak && (git pull && ./rebar update-deps)
	cd riak && make stage
	sed -e "s/storage_backend = bitcask/storage_backend = leveldb/" -i.back riak/rel/riak/etc/riak.conf

riak-devrel: riak
	cd riak && (git pull && ./rebar update-deps)
	cd riak && make stagedevrel
	sed -e "s/storage_backend = bitcask/storage_backend = leveldb/" -i.back riak/dev/dev$NODE/etc/riak.conf
