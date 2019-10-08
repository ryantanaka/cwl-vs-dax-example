#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
# not yet supporting arguments in baseCommand
# baseCommand: [tar --extract]
baseCommand: tar
arguments: ["--extract"]
inputs:
  tar_file:
    type: File
    inputBinding:
      prefix: --file
  extract_file:
    type: string
    inputBinding:
      position: 1
outputs:
  extracted_file:
    type: File
    outputBinding:
      # not supporting inline javascript at the moment
      #glob: $(inputs.extractfile)
      glob: "HelloC.cpp"
