#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/initialProcessChild
inputs:
    input_file:
        type: File
        
outputs:
    output_file:
        type: File
        outputBinding:
            glob: "output.txt"
