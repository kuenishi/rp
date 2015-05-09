.PHONY: env tarball cli devrel riak-release latest-presto riak-devrel presto-devrel

all: env cli latest-presto riak-release

PRESTO_VERSION=0.102
FILE=presto/presto-server/target/presto-server-$(PRESTO_VERSION).tar.gz

CLIJAR=presto/presto-cli/target/presto-cli-$(PRESTO_VERSION)-executable.jar
VERIFIER=presto/presto-verifier/target/presto-verifier-$(PRESTO_VERSION)-executable.jar

#$(FILE):
#	wget http://central.maven.org/maven2/com/facebook/presto/presto-server/0.61/presto-server-0.61.tar.gz


presto:
	git clone git://github.com/facebook/presto.git

latest-presto: presto
	@cd presto && git fetch && git checkout $(PRESTO_VERSION)

$(FILE): latest-presto
	@cd presto/presto-server &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

$(CLIJAR): presto
	@cd presto/presto-cli &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

$(VERIFIER): presto
	@cd presto/presto-verifier &&  mvn package assembly:assembly -DdescriptorId=bin -Dtest=skip -DfailIfNoTests=false

devrel:  presto-devrel riak-devrel

presto-devrel: $(FILE) riak-devrel
	tar xzf $(FILE)
	rm -rf dev
	mkdir dev
	mkdir -p presto-server-$(PRESTO_VERSION)/plugin/presto-riak
	sh build_devrel.sh presto-server-$(PRESTO_VERSION) 1
	sh build_devrel.sh presto-server-$(PRESTO_VERSION) 2
	sh build_devrel.sh presto-server-$(PRESTO_VERSION) 3
	sh build_devrel.sh presto-server-$(PRESTO_VERSION) 4
	sh build_devrel.sh presto-server-$(PRESTO_VERSION) 5

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
	rm -rf lib
	cp -r presto-server-$(PRESTO_VERSION)/lib .
	cp -r presto-server-$(PRESTO_VERSION)/bin/* ./bin/
	cp -r presto-server-$(PRESTO_VERSION)/plugin .
	mkdir -p plugin/presto-riak

clean:
	rm -rf lib plugin data NOTICE README.txt

test:
	mvn -Dmaven.junit.usefile=false test 

riak:
	git clone git://github.com/basho/riak -b 2.1.1

riak-release: riak/rel/riak

riak/rel/riak: riak
	cd riak && make clean
	cd riak && make stage
	sed -e "s/storage_backend = bitcask/storage_backend = leveldb/" -i.back riak/rel/riak/etc/riak.conf

riak-devrel: riak/dev/dev1

riak/dev/dev1: riak
	cd riak && make stagedevrel
	for NODE in '1 2 3 4'; do sed -e "s/storage_backend = bitcask/storage_backend = leveldb/" -i.back riak/dev/dev${NODE}/etc/riak.conf; done
