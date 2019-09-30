cwlVersion: v1.0
class: CommandLineTool
baseCommand: hello
inputs:
    input_file:
        type: File
outputs:
    fb1:
        type: File
hints:
    what:
        hint: this
        hint2: this again 
        
