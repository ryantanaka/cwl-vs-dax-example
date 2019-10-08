#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: clang++
arguments: ["-std=c++11"]
inputs:
    src:
        type: File
        inputBinding:
            prefix: -c
            separate: true
            position: 1

outputs:
    object_file:
        type: File
        outputBinding:
            glob: "HelloC.o"
