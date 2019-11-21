#!/usr/bin/env bash
docker run --rm -d --name dynamicd -v `pwd`/.dynamic:/root/.dynamic -p 33350:33350 dynamicd-testing:latest
