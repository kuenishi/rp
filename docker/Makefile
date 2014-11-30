.PHONY: all

all:
	@cp ../presto/presto-server/target/presto-server-0.85.tar.gz .
	@cp ../presto/presto-cli/target/presto-cli-0.85-executable.jar .
	@cp ../../presto-riak/target/presto-riak-0.0.5-SNAPSHOT.jar .
	@cp ../../presto-riak/bin/testdata.py .
	@cp ../../presto-riak/ldna.beam .
	@sudo docker build -t 'rp-t' .
