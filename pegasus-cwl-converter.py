#!/usr/bin/env python3

import logging
import argparse
import sys
import os

from yaml import Loader, load

sys.path.insert(0, "/Users/ryantanaka/ISI/cwl-utils")
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
    # fix these comments
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

def main():
    setup_logger(None)
    args = parse_args()

    workflow_file_path = args.cwl_workflow_file_path
    workflow_file_dir = os.path.dirname(workflow_file_path)

    logger.info("Loading {}".format(workflow_file_path))
    workflow = cwl.load_document(workflow_file_path)
    adag = ADAG("dag-generated-from-cwl", auto=True)

    # ****** process steps, add executables, add jobs, add files ******
    for step in workflow.steps:
        print(step.id)

        # convert cwl:CommandLineTool -> pegasus:Executable
        cwl_command_line_tool = cwl.load_document(step.run) if isinstance(step.run, str) else step.run
        dax_executable = Executable(cwl_command_line_tool.baseCommand)

        # create job with executable
        dax_job = Job(dax_executable)

        # process input files
        step_inputs = {get_basename(step, input.id) : input.source for input in step.in_}

        for id, value in step_inputs.items():
            if isinstance(value, list):
                for filename in value:
                    file = File(filename)
                    # may need to add pegasus extensions here
                    # TODO: get transfer and resiter values from pegasus extension
                    dax_job.uses(file, link=Link.INPUT)
                    print(id, file.name)

                    if not adag.hasFile(file.name):
                        adag.addFile(file)
            else:
                file = File(value)
                # may need to add pegasus extensions here
                dax_job.uses(file, link=Link.INPUT)
                print(id, file.name)

                if not adag.hasFile(file.name):
                    adag.addFile(file)

        # process output files
        # ** assuming step.out is a list of strings and not WorkflowStepOutput
        step_outputs = {get_basename(step, output) : output for output in step.out}
        dax_job_output_files = {filename : File(fileid) for filename, fileid in step_outputs.items()}
        for filename, file in dax_job_output_files.items():
            # TODO: get transfer and register values from pegasus extension
            dax_job.uses(file, link=Link.OUTPUT, transfer=True, register=True)
            if not adag.hasFile(file.name):
                adag.addFile(file)

        # add arguments to job
        dax_job_args = cwl_command_line_tool.arguments if cwl_command_line_tool.arguments is not None else []

        # process cwl inputBindings if they exist and build up job argument list
        cwl_command_line_tool_inputs = sorted(cwl_command_line_tool.inputs,
            key=lambda input : input.inputBinding.position if input.inputBinding.position is not None else 0 )

        for input in cwl_command_line_tool_inputs:
            arg_string = ""
            if input.inputBinding is not None:
                if input.inputBinding.prefix is not None:
                    arg_string += input.inputBinding.prefix

                if input.inputBinding.separate == True:
                    arg_string += " "

                if (isinstance(step_inputs[get_basename(cwl_command_line_tool, input.id)], list)):
                    if input.inputBinding.itemSeparator is not None:
                        arg_string += input.inputBinding.itemSeparator.join(
                            step_inputs[get_basename(cwl_command_line_tool, input.id)])
                else:
                    arg_string += step_inputs[get_basename(cwl_command_line_tool, input.id)]

                dax_job_args.append(arg_string)

        dax_job.addArguments(*dax_job_args)

        # add executable to DAG
        if not adag.hasExecutable(dax_executable):
            adag.addExecutable(dax_executable)

        # add job to DAG
        adag.addJob(dax_job)

    with open(args.output_file_path, "w") as f:
        adag.writeXML(f)

if __name__=="__main__":
    sys.exit(main())
