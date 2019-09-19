#!/bin/bash

pegasus-graphviz -f -o graph.dot fork-join-workflow.xml && \
	dot -T pdf graph.dot -o graph.pdf
