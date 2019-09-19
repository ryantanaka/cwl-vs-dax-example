#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/initialFinalProcess
inputs:
    input_files:
        type: File[]
        
outputs:
    output_file:
        type: File
