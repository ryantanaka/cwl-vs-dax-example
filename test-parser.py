#!/usr/bin/env python
import argparse
import sys
import os

import cwl_utils.parser_v1_0 as cwl

sys.path.insert(0, "/Users/ryantanaka/ISI/pegasus/dist/pegasus-5.0.0dev/lib/pegasus/python")
from Pegasus.DAX3 import *

def parse_args():
    parser = argparse.ArgumentParser(
            description="Test tool to parse a cwl workflow using cwl_utils")
    parser.add_argument("cwl_workflow_file_path", help="cwl workflow file")
    return parser.parse_args()

def main():
    args = parse_args()
    workflow_file_path = args.cwl_workflow_file_path
    workflow_file_dir = os.path.dirname(workflow_file_path)

    workflow = cwl.load_document(workflow_file_path)

    adag = ADAG("from-cwl-workflow", auto=True)
    for step in workflow.steps:
        # EXECUTABLE 
        '''
        - step.run points to a cwl file with a CommandLineTool class.
        - CommandLineTool.baseCommand must either be an absolute path
            to some executable OR the executable name, in which case it
            must be added to the run environment's PATH
        - in this case, I am assuming absolute paths and will just add it
            as a PFN to the Executable 
        '''
        # this step's run cwl document 
        parameter_reference = cwl.load_document(step.run)
        executable = Executable(parameter_reference.id)
        executable.addPFN(PFN(parameter_reference.baseCommand, "what to do about 'site'???"))

        if not adag.hasExecutable(executable):
            adag.addExecutable(executable)

        # INPUT FILES
        input_files = set()
        
        for input_file in step.in_:
            if isinstance(input_file.source, list):
                input_files |= set(map(lambda filename : File(filename), input_file.source))
            # should be a string in this case, just being careful for now
            elif isinstance(input_file.source, str):
                input_files.add(File(input_file.source))
            else:
                raise Exception("didn't get a string from a step's input file field")

        for input_file in input_files:
            if not adag.hasFile(input_file.name):
                adag.addFile(input_file)

        # OUTPUT FILES
        output_files = set()

        for output_file in step.out:
            # seems like this is always a list of filenames
            if isinstance(output_file, str):
                output_files.add(File(output_file))
            else:
                raise Exception("didn't get a string from a step's output file field")

        for output_file in output_files:
            if not adag.hasFile(output_file.name):
                adag.addFile(output_file)

        # JOB 
        job = Job(executable)
        for input_file in input_files:
            job.uses(input_file, link=Link.INPUT)

        for output_file in output_files:
            job.uses(output_file, link=Link.OUTPUT)

        adag.addJob(job)
        
        '''
        What about the notion of arguments? In CWL, a CommandLineTool has an arguments field but,
        according to the docs, this is meant for command line bindings which are not directly 
        associated with input parameters
        '''
        
        with open("cwl-to-dax-conversion-workflow.xml", "w") as f:
            adag.writeXML(f)

if __name__=="__main__":
    sys.exit(main())
    
