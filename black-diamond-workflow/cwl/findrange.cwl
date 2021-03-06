cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/keg
id: findrange
arguments: ["-a", "findrange", "-T", "60", "-o", "output_file"]
inputs:
    input_file:
        type: File
        inputBinding:
            prefix: -i
            separate: true
            position: 1

outputs:
    output_file:
        type: File

pegasus:executableInfo:
    namespace: pegasus
    version: v4.0
    installed: true
    arch: x86
    os: linux
    pfn:
        url: file:///usr/bin/keg
        site: TestCluster
