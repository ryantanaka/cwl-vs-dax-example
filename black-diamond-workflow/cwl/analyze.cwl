cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/keg
id: analyze 
arguments: ["-a", "analyze", "-T", "60", "-o", "output_file"]
inputs:
    input_files:
        type: File[]
        inputBinding:
            prefix: -i
            itemSeparator: " " 
            separate: true
            position: 1

outputs:
    analysis_file:
        type: File
        
hints:
    executable_info: # this is for all the dax Executable info (these aren't cwl fields)
        namespace: pegasus
        version: v4.0
        installed: true
        arch: helllo 
        os: linux
        pfn: 
            url: file:///usr/bin/keg
            site: TestCluster
