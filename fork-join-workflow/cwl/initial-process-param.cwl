#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/initialProcess
inputs:
    input_file_1:
        type: File 
        inputBinding:
            position: 1

    input_file_2:
        type: File 
        inputBinding:
            position: 2
outputs:
    output_file_1:
        type: File
        outputBinding:
           glob: "output_file_1.txt"

    output_file_2:
        type: File
        outputBinding:
           glob: "output_file_2.txt"

    output_file_3:
        type: File
        outputBinding:
           glob: "output_file_3.txt"
hints:
    hint1:
        what: whatisthis 
        another: another key
