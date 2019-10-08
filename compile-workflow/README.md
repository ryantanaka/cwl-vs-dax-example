

This workflow has been adopted from
https://www.commonwl.org/user_guide/21-1st-workflow/index.html.
Some aspects of the workflow are slightly different, however the DAG is
essentially the same.

The workflow takes in as input a tarball, which is specified in `input.yml`,
extracts the file HelloC.cpp from it, then compiles it into an object file
using gcc. (The example from www.commonwl.org uses javac.)

This workflow will run with the cwl reference runner as well:
`./cwl-runner.sh`.
