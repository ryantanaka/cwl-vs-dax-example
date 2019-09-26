#!/usr/bin/env python
import argparse
import sys

import cwl_utils.parser_v1_0 as cwl

def parse_args():
    parser = argparse.ArgumentParser(
            description="Test tool to parse a cwl workflow using cwl_utils")
    parser.add_argument("cwl_workflow_file_path", help="cwl workflow file")
    return parser.parse_args()

def main():
    args = parse_args()
    workflow = cwl.load_document(args.cwl_workflow_file_path)
    for step in workflow.steps:
        # see if I can drill down and get all the information from the steps 
        print(5 * "*************************")
        print("RUN: {}".format(step.run))
        command = cwl.load_document(step.run)
        print(command.baseCommand)
        print("INPUTS")
        print(*[(input_file.source,  for input_file in step.in_], sep="\n")
        print("OUTPUTS")
        print(*step.out, sep="\n")




if __name__=="__main__":
    sys.exit(main())
    
