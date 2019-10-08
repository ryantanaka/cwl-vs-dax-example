#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
inputs:
  tarball: File
  name_of_file_to_extract: string

outputs:
  compiled_class:
    type: File
    outputSource: compile/object_file

steps:
  untar:
    run: tar.cwl
    in:
      tar_file: tarball
      extract_file: name_of_file_to_extract
    out: [extracted_file]

  compile:
    run: compile.cwl
    in:
      src: untar/extracted_file
    out: [object_file]
