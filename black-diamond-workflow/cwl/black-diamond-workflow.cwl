cwlVersion: v1.0
class: Workflow
inputs:
    workflow_input_file: File

outputs:
    workflow_output_file:
        type: File
        outputSource: j4/analysis_file

steps:
    j1:
        id: j1
        run: preprocess.cwl 
        in:
            input_file: workflow_input_file
        out: [output_file_1, output_file_2]
        hints:
            job_fields:
                namespace: pegasus
                name: preprocess
                version: 4.0
            metadata:
                time: 60
            transfers:
                output_file_1: true
                output_file_2: true
            register:
                output_file_1: true
                output_file_2: true
            invokes:
                start:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
                at_end:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
    
    j2:
        id: j2
        run: findrange.cwl
        in:
            input_file: j1/output_file_1
        out: [output_file]
        hints:
            job_fields:
                namespace: pegasus
                name: findrange
                version: 4.0
            metadata:
                time: 60
            transfers:
                output_file: true
            registers:
                output_file: true
            invokes:
                start:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
                at_end:
                    - "/pegasus/libexec/notification/email -t notify@example.com"

    j3:
        id: j3
        run: findrange.cwl
        in: 
            input_file: j1/output_file_2
        out: [output_file]
        hints:
            job_fields:
                namespace: pegasus
                name: findrange
                version: 4.0
            metadata:
                time: 60
            transfers:
                output_file: true
            registers:
                output_file: true
            invokes:
                start:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
                at_end:
                    - "/pegasus/libexec/notification/email -t notify@example.com"

    j4:
        id: j4
        run: analyze.cwl 
        in: 
            input_files: [j2/output_file, j3/output_file]
        out: 
            [analysis_file]
        hints:
            job_fields:
                namespace: pegasus
                name: analyze 
                version: 4.0
            metadata:
                time: 60
            transfers:
               analysis_file: true
            registers:
                analysis_file: true
            invokes:
                start:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
                at_end:
                    - "/pegasus/libexec/notification/email -t notify@example.com"
