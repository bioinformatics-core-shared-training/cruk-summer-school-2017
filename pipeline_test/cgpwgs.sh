#!/bin/bash

#dockstore tool launch --entry quay.io/wtsicgp/dockstore-cgpwgs:1.0.8 --json cgpwgs.json

mkdir -p tmp
mkdir -p output

cwltool \
	--leave-container \
	--leave-tmpdir \
	--copy-outputs \
	--tmpdir-prefix /home/participant/pipeline_test/tmp/ \
	--tmp-outdir-prefix /home/participant/pipeline_test/output/ \
	--non-strict \
	https://www.dockstore.org:8443/api/ga4gh/v1/tools/quay.io%2Fwtsicgp%2Fdockstore-cgpwgs/versions/1.0.8/plain-CWL/descriptor \
	cgpwgs.json
