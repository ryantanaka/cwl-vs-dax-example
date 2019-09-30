{
    "$graph": [
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/initialProcessChild",
            "inputs": {
                "input_file": {
                    "type": "File"
                }
            },
            "outputs": {
                "output_file": {
                    "type": "File",
                    "outputBinding": {
                        "glob": "output.txt"
                    }
                }
            },
            "id": "#child-process-param.cwl"
        },
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/initialFinalProcess",
            "inputs": {
                "input_files": {
                    "type": "File[]"
                }
            },
            "outputs": {
                "output_file": {
                    "type": "File"
                }
            },
            "id": "#final-process-param.cwl"
        },
        {
            "class": "Workflow",
            "inputs": [
                {
                    "type": "File",
                    "id": "#main/initial_input_file_1"
                },
                {
                    "type": "File",
                    "id": "#main/initial_input_file_2"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputSource": "#main/finalProcess/output_file",
                    "id": "#main/final_output"
                }
            ],
            "steps": [
                {
                    "run": "#child-process-param.cwl",
                    "in": [
                        {
                            "source": "#main/initialProcess/output_file_1",
                            "id": "#main/child1/input_file"
                        }
                    ],
                    "out": [
                        "#main/child1/output_file"
                    ],
                    "id": "#main/child1"
                },
                {
                    "run": "#child-process-param.cwl",
                    "in": [
                        {
                            "source": "#main/initialProcess/output_file_2",
                            "id": "#main/child2/input_file"
                        }
                    ],
                    "out": [
                        "#main/child2/output_file"
                    ],
                    "id": "#main/child2"
                },
                {
                    "run": "#child-process-param.cwl",
                    "in": [
                        {
                            "source": "#main/initialProcess/output_file_3",
                            "id": "#main/child3/input_file"
                        }
                    ],
                    "out": [
                        "#main/child3/output_file"
                    ],
                    "id": "#main/child3"
                },
                {
                    "run": "#final-process-param.cwl",
                    "in": [
                        {
                            "source": [
                                "#main/child1/output_file",
                                "#main/child2/output_file",
                                "#main/child3/output_file"
                            ],
                            "id": "#main/finalProcess/input_files"
                        }
                    ],
                    "out": [
                        "#main/finalProcess/output_file"
                    ],
                    "id": "#main/finalProcess"
                },
                {
                    "run": "#initial-process-param.cwl",
                    "in": [
                        {
                            "source": "#main/initial_input_file_1",
                            "id": "#main/initialProcess/input_file_1"
                        },
                        {
                            "source": "#main/initial_input_file_2",
                            "id": "#main/initialProcess/input_file_2"
                        }
                    ],
                    "out": [
                        "#main/initialProcess/output_file_1",
                        "#main/initialProcess/output_file_2",
                        "#main/initialProcess/output_file_3"
                    ],
                    "id": "#main/initialProcess"
                }
            ],
            "id": "#main"
        },
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/initialProcess",
            "inputs": {
                "input_file_1": {
                    "type": "File",
                    "inputBinding": {
                        "position": 1
                    }
                },
                "input_file_2": {
                    "type": "File",
                    "inputBinding": {
                        "position": 2
                    }
                }
            },
            "outputs": {
                "output_file_1": {
                    "type": "File",
                    "outputBinding": {
                        "glob": "output_file_1.txt"
                    }
                },
                "output_file_2": {
                    "type": "File",
                    "outputBinding": {
                        "glob": "output_file_2.txt"
                    }
                },
                "output_file_3": {
                    "type": "File",
                    "outputBinding": {
                        "glob": "output_file_3.txt"
                    }
                }
            },
            "id": "#initial-process-param.cwl"
        }
    ],
    "cwlVersion": "v1.0"
}