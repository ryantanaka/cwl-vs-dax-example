#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
    initial_input_file_1: File
    initial_input_file_2: File

outputs:
    final_output:
        type: File
        outputSource: finalProcess/output_file

steps:
    initialProcess:
        run: initial-process-param.cwl
        in:
            input_file_1: initial_input_file_1
            input_file_2: initial_input_file_2
        out: [output_file_1, output_file_2, output_file_3]

    Child1:
        run: child-process-param.cwl
        in:
            input_file: initialProcess/output_file_1
        out: [output_file]

    Child2:
        run: child-process-param.cwl
        in:
            input_file: initialProcess/output_file_2
        out: [output_file]

    Child3:
        run: child-process-param.cwl
        in:
            input_file: initialProcess/output_file_3
        out: [output_file]

    finalProcess:
        run: final-process-param.cwl
        in:
            input_files: [Child1/output_file, Child2/output_file, Child3/output_file]
        out: [output_file]

