cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/keg
id: preprocess
arguments: ["-a", "preprocesss", "-T", "60", "-o", "output_file_1", "output_file_2"]
inputs:
    input_file:
        type: File
        inputBinding:
            prefix: -i
            separate: true
            position: 1

outputs:
    output_file_1:
        type: File
    output_file_2:
        type: File

pegasus:executableInfo:
    namespace: pegasus
    version: v4.0
    installed: true
    arch: x86
    os: linux
    size: 2048
    pfn:
        url: file:///usr/bin/keg
        site: TestCluster
