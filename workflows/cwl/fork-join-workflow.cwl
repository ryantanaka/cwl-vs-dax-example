#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
    input_file_1: File
    input_file_2: File

outputs:
    output_file: File
    outputSource: join/joinedFile

steps:
    initialProcess:
        run: /usr/bin/initialProcess
        in:
            input_1: input_file_1
            input_2: input_file_2
        out: [initial_process_out_1, initial_process_out_2, initial_processs_out_3]

    initialProcessChild1:
        run: /usr/bin/initialProcessChild
        in:
            src: initialProcess/initial_process_out_1
        out: [initial_child_1_out]

    initialProcessChild2:
        run: /usr/bin/initialProcessChild
        in:
            src: initialProcess/initial_process_out_2
        out: [initial_child_2_out]

    initialProcessChild3:
        run: /usr/bin/initialProcessChild
        in:
            src: initialProcess/initial_process_out_3
        out: [initial_child_3_out]

    finalProcess:
        run: /usr/bin/finalProcess
        in:
            src: [initialProcessChild1/initial_child_1_out, initialProcessChild2/initial_child_2__out, initialProcessChild3/initial_child_3_out]
        out: [final_process_out]

