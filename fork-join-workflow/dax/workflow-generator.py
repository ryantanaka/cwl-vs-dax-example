#!/usr/bin/env python

from Pegasus.DAX3 import *

dax = ADAG("forkJoin", auto=True)

executables = {
        "initialProcess": Executable(name="initialProcess"),
        "child": Executable(name="child"),
        "finalProcess": Executable(name="finalProcess")
    }

files = {
        "initial_input_file_1": File("initial_input_file_1"),
        "initial_input_file_2": File("initial_input_file_2"),
        "parent_output_file_1": File("parent_output_file_1"),
        "parent_output_file_2": File("parent_output_file_2"),
        "parent_output_file_3": File("parent_output_file_3"),
        "child_1_output_file": File("child_1_output_file"),
        "child_2_output_file": File("child_2_output_file"),
        "child_3_output_file": File("child_3_output_file"),
        "final_output_file": File("final_output_file")
    }

for exename, exe in executables.items():
    dax.addExecutable(exe)

for filename, file in files.items():
    dax.addFile(file)

initial_job = Job(executables["initialProcess"])
initial_job.uses(files["initial_input_file_1"], link=Link.INPUT)
initial_job.uses(files["initial_input_file_2"], link=Link.INPUT)
initial_job.uses(files["parent_output_file_1"], link=Link.OUTPUT)
initial_job.uses(files["parent_output_file_2"], link=Link.OUTPUT)
initial_job.uses(files["parent_output_file_3"], link=Link.OUTPUT)
dax.addJob(initial_job)

child_1_job = Job(executables["child"])
child_1_job.uses(files["parent_output_file_1"], link=Link.INPUT)
child_1_job.uses(files["child_1_output_file"], link=Link.OUTPUT)
dax.addJob(child_1_job)

child_2_job = Job(executables["child"])
child_2_job.uses(files["parent_output_file_2"], link=Link.INPUT)
child_2_job.uses(files["child_2_output_file"], link=Link.OUTPUT)
dax.addJob(child_2_job)

child_3_job = Job(executables["child"])
child_3_job.uses(files["parent_output_file_3"], link=Link.INPUT)
child_3_job.uses(files["child_3_output_file"], link=Link.OUTPUT)
dax.addJob(child_3_job)

final_job = Job(executables["finalProcess"])
final_job.uses(files["child_1_output_file"], link=Link.INPUT)
final_job.uses(files["child_2_output_file"], link=Link.INPUT)
final_job.uses(files["child_3_output_file"], link=Link.INPUT)
final_job.uses(files["final_output_file"], link=Link.OUTPUT)
dax.addJob(final_job)

with open("fork-join-workflow.xml", "w") as f:
    dax.writeXML(f)

