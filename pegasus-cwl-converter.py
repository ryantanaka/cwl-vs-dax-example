#!/usr/bin/env python3

import logging
import argparse
import sys
import os
import shutil

from yaml import Loader, load

# TODO: these need to be changed when this script is added to pegasus master
#sys.path.insert(0, "/nfs/u2/tanaka/pegasus/lib/pegasus/python")
sys.path.insert(0, "/Users/ryantanaka/ISI/pegasus/dist/pegasus-5.0.0dev/lib/pegasus/python")
from Pegasus.DAX3 import *
import cwl_utils.parser_v1_0 as cwl

logger = logging.getLogger("logger")

def setup_logger(debug_flag):
   # log to the console
   console = logging.StreamHandler()

   # default log level - make logger/console match
   logger.setLevel(logging.INFO)
   console.setLevel(logging.INFO)

   # debug - from command line
   if debug_flag:
       logger.setLevel(logging.DEBUG)
       console.setLevel(logging.DEBUG)

   # formatter
   formatter = logging.Formatter("%(asctime)s %(levelname)7s:  %(message)s")
   console.setFormatter(formatter)
   logger.addHandler(console)
   logger.debug("Logger has been configured")

def parse_args():
    # TODO: fix these comments
    parser = argparse.ArgumentParser(
            description="Test tool to parse a cwl workflow using cwl_utils")
    parser.add_argument("cwl_workflow_file_path", help="cwl workflow file")
    parser.add_argument("input_file_spec_path", help="yaml file describing workflow inputs")
    parser.add_argument("output_file_path", help="path to output file")
    return parser.parse_args()

def get_basename(process, name):
    if "#" in process.id:
        return name.replace(process.id + "/", "")
    else:
        return name.replace(process.id + "#", "")


class ReplicaCatalog:
    # TODO: make this more comprehensive
    # TODO: possibly make a catalog type, as the behavior here is almost the
    #       same as ReplicaCatalog
    def __init__(self):
        self.items = set()

    # account for more complex entries into the catalog
    def add_item(self, lfn, pfn, site):

        self.items.add("{0} {1} site={2}".format(lfn.split("#")[1], os.path.abspath(pfn), site))

    def write_catalog(self, filename):
        with open(filename, "w") as rc:
            for item in self.items:
                rc.write(item + "\n")


class TransformationCatalog:
    # TODO: make this more comprehensive
    # TODO: possibly make a catalog type, as the behavior here is almost the
    #       same as ReplicaCatalog

    def __init__(self):
        self.items = set()

    # TODO: account for more complex entries into the catalog
    def add_item(self, name, pfn):
        self.items.add((name, pfn))

    def write_catalog(self, filename):
        with open(filename, "w") as tc:
            for item in self.items:
                tc.write("tr {} {{\n".format(item[0]))
                tc.write("    site condorpool {\n")
                tc.write("        pfn \"{}\"\n".format(item[1]))
                tc.write("    }\n")
                tc.write("}\n")

def main():
    setup_logger(None)
    args = parse_args()

    workflow_file_path = args.cwl_workflow_file_path
    workflow_file_dir = os.path.dirname(workflow_file_path)

    logger.info("Loading {}".format(workflow_file_path))
    workflow = cwl.load_document(workflow_file_path)

    adag = ADAG("dag-generated-from-cwl", auto=True)
    rc = ReplicaCatalog()
    tc = TransformationCatalog()

    # process initial input file(s)
    # TODO: need to account for the different fields for a file class
    # TODO: log warning for the fields that we are skipping
    workflow_input_strings = dict()
    with open(args.input_file_spec_path, "r") as yaml_file:
        input_file_specs = load(yaml_file, Loader=Loader)
        for id, fields in input_file_specs.items():
            if isinstance(fields, dict):
                if fields["class"] == "File":
                    full_name = workflow.id + "#" + id
                    rc.add_item(full_name, fields["path"], "local")
            elif isinstance(fields, str):
                workflow_input_strings[id] = fields

    # process steps, add executables, add jobs, add files
    for step in workflow.steps:

        # convert cwl:CommandLineTool -> pegasus:Executable
        cwl_command_line_tool = cwl.load_document(step.run) if isinstance(step.run, str) else step.run
        dax_executable = Executable(cwl_command_line_tool.baseCommand)

        # add executable to transformation catalog
        tc.add_item(cwl_command_line_tool.baseCommand, cwl_command_line_tool.baseCommand)

        # create job with executable
        dax_job = Job(dax_executable)

        # process input files
        step_inputs = {get_basename(step, input.id) : input.source for input in step.in_}
        print("**step inputs**")
        print(step_inputs)

        for input in cwl_command_line_tool.inputs:
            if input.type == "File":
                print(get_basename(cwl_command_line_tool, input.id))
                if not adag.hasFile(step_inputs[get_basename(cwl_command_line_tool, input.id)]):
                    #file = File(step_inputs[get_basename(cwl_command_line_tool, input.id)])
                    file = File(get_basename(cwl_command_line_tool, input.id))
                    dax_job.uses(file, link=Link.INPUT)
                    adag.addFile(file)



            elif input.type == "File[]":
                for filename in step_inputs[get_basename(cwl_command_line_tool, input.id)]:
                    if not adag.hasFile(filename):
                        file = File(filename)
                        dax_job.uses(file, link=Link.INPUT)
                        adag.addFile(File(filename))

        # process output files
        # ** assuming step.out is a list of strings and not WorkflowStepOutput
        step_outputs = {get_basename(step, output) : output for output in step.out}

        #cwl_command_line_tool_output_types = {

        dax_job_output_files = {filename : File(fileid) for filename, fileid in step_outputs.items()}
        for filename, file in dax_job_output_files.items():
            # TODO: get transfer and register values from pegasus extension
            #dax_job.uses(file, link=Link.OUTPUT, transfer=True, register=True) if not adag.hasFile(file.name):
            dax_job.uses(filename, link=Link.OUTPUT, transfer=True, register=True)
            if not adag.hasFile(filename):
                adag.addFile(File(filename))

        # add arguments to job
        # TODO: place argument building up in a function
        dax_job_args = cwl_command_line_tool.arguments if cwl_command_line_tool.arguments is not None else []

        # process cwl inputBindings if they exist and build up job argument list
        cwl_command_line_tool_inputs = sorted(cwl_command_line_tool.inputs,
            key=lambda input : input.inputBinding.position if input.inputBinding.position is not None else 0 )

        for input in cwl_command_line_tool_inputs:
            # process args
            if input.inputBinding is not None:
                # TODO: account for inputBinding separation
                if input.inputBinding.prefix is not None:
                    dax_job_args.append(input.inputBinding.prefix)

                # TODO: account for separator
                if input.type == "File[]":
                    for filename in step_inputs[get_basename(cwl_command_line_tool, input.id)]:
                        dax_job_args.append(adag.getFile(filename))

                elif input.type == "File":
                    #dax_job_args.append(adag.getFile(step_inputs[get_basename(cwl_command_line_tool, input.id)]))
                    dax_job_args.append(adag.getFile(get_basename(cwl_command_line_tool, input.id)))

                # TODO: take into account string inputs that are outputs of other steps
                #       and not just workflow inputs

                input_string_id = get_basename(
                                    workflow,
                                    step_inputs[get_basename(
                                        cwl_command_line_tool,
                                        input.id
                                        )]
                                    )

                arg_string = ""
                if input.type == "string[]":
                    separator = " " if input.inputBinding.itemSeparator is None \
                                        else input.inputBinding.itemSeparator

                    arg_string += separator.join(
                        workflow_input_strings[input_string_id]
                    )
                elif input.type == "string":
                    arg_string += workflow_input_strings[input_string_id]

                dax_job_args.append(arg_string)

        dax_job.addArguments(*dax_job_args)

        # add executable to DAG
        if not adag.hasExecutable(dax_executable):
            adag.addExecutable(dax_executable)

        # add job to DAG
        adag.addJob(dax_job)

    rc.write_catalog("rc.txt")
    tc.write_catalog("tc.txt")

    with open(args.output_file_path, "w") as f:
        adag.writeXML(f)

if __name__=="__main__":
    sys.exit(main())
