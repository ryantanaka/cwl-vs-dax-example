$namespaces:
    pegasus: "https://pegasus.isi.edu#"
cwlVersion: v1.0
class: Workflow

pegasus:workflowMetadata:
    name: diamond
    createdBy: Karan Vahi

pegasus:invokes:
    start:
        - "/pegasus/libexec/notification/email -t notify@example.com"
    at_end:
        - "/pegasus/libexec/notification/email -t notify@example.com"

inputs:
    workflow_input_file: File

outputs:
    workflow_output_file:
        type: File
        outputSource: j4/analysis_file

steps:
    j1:
        pegasus:invokes:
            start:
                - "/pegasus/libexec/notification/email -t notify@example.com"
            at_end:
                - "/pegasus/libexec/notification/email -t notify@example.com"

        pegasus:jobInfo:
            namespace: pegasus
            name: preprocess
            version: 4.0

        pegasus:jobMetadata:
            time: 60

        pegasus:fileTransfer:
            - output_file_1
            - output_file_2

        pegasus:fileRegister:
            - output_file_1
            - output_file_2

        id: j1
        run: preprocess.cwl
        in:
            input_file: workflow_input_file
        out: [output_file_1, output_file_2]

    j2:
        pegasus:invokes:
            start:
                - "/pegasus/libexec/notification/email -t notify@example.com"
            at_end:
                - "/pegasus/libexec/notification/email -t notify@example.com"

        pegasus:jobInfo:
            namespace: pegasus
            name: findrange
            version: 4.0

        pegasus:jobMetadata:
            time: 60

        pegasus:fileTransfer:
            - output_file

        pegasus:fileRegister:
            - output_file

        id: j2
        run: findrange.cwl
        in:
            input_file: j1/output_file_1
        out: [output_file]

    j3:
        pegasus:invokes:
            start:
                - "/pegasus/libexec/notification/email -t notify@example.com"
            at_end:
                - "/pegasus/libexec/notification/email -t notify@example.com"

        pegasus:jobInfo:
            namespace: pegasus
            name: findrange
            version: 4.0

        pegasus:jobMetadata:
            time: 60

        pegasus:fileTransfer:
            - output_file

        pegasus:fileRegister:
            - output_file

        id: j3
        run: findrange.cwl
        in:
            input_file: j1/output_file_2
        out: [output_file]


    j4:
        pegasus:invokes:
            start:
                - "/pegasus/libexec/notification/email -t notify@example.com"
            at_end:
                - "/pegasus/libexec/notification/email -t notify@example.com"

        pegasus:jobInfo:
            namespace: pegasus
            name: analyze
            version: 4.0

        pegasus:jobMetadata:
            time: 60

        pegasus:fileTransfer:
            - analysis_file

        pegasus:fileRegister:
            - analysis_file

        id: j4
        run: analyze.cwl
        in:
            input_files: [j2/output_file, j3/output_file]
        out:
            [analysis_file]
