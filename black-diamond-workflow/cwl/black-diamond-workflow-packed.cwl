{
    "$graph": [
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/keg",
            "id": "#analyze.cwl",
            "arguments": [
                "-a",
                "analyze",
                "-T",
                "60",
                "-o",
                "output_file"
            ],
            "inputs": {
                "input_files": {
                    "type": "File[]",
                    "inputBinding": {
                        "prefix": "-i",
                        "itemSeparator": " ",
                        "separate": true,
                        "position": 1
                    }
                }
            },
            "outputs": {
                "analysis_file": {
                    "type": "File"
                }
            },
            "hints": {
                "executable_info": {
                    "namespace": "pegasus",
                    "version": "v4.0",
                    "installed": true,
                    "arch": "helllo",
                    "os": "linux",
                    "pfn": {
                        "url": "file:///usr/bin/keg",
                        "site": "TestCluster"
                    }
                }
            }
        },
        {
            "class": "Workflow",
            "inputs": [
                {
                    "type": "File",
                    "id": "#main/workflow_input_file"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputSource": "#main/j4/analysis_file",
                    "id": "#main/workflow_output_file"
                }
            ],
            "steps": [
                {
                    "id": "#main/j1",
                    "run": "#preprocess.cwl",
                    "in": [
                        {
                            "source": "#main/workflow_input_file",
                            "id": "#main/j1/input_file"
                        }
                    ],
                    "out": [
                        "#main/j1/output_file_1",
                        "#main/j1/output_file_2"
                    ],
                    "hints": [
                        {
                            "start": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "at_end": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/invokes"
                        },
                        {
                            "namespace": "pegasus",
                            "name": "#main/j1/preprocess",
                            "version": 4.0,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/job_fields"
                        },
                        {
                            "time": 60,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/metadata"
                        },
                        {
                            "output_file_1": true,
                            "output_file_2": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/register"
                        },
                        {
                            "output_file_1": true,
                            "output_file_2": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/transfers"
                        }
                    ]
                },
                {
                    "id": "#main/j2",
                    "run": "#findrange.cwl",
                    "in": [
                        {
                            "source": "#main/j1/output_file_1",
                            "id": "#main/j2/input_file"
                        }
                    ],
                    "out": [
                        "#main/j2/output_file"
                    ],
                    "hints": [
                        {
                            "start": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "at_end": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/invokes"
                        },
                        {
                            "namespace": "pegasus",
                            "name": "#main/j2/findrange",
                            "version": 4.0,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/job_fields"
                        },
                        {
                            "time": 60,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/metadata"
                        },
                        {
                            "output_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/registers"
                        },
                        {
                            "output_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/transfers"
                        }
                    ]
                },
                {
                    "id": "#main/j3",
                    "run": "#findrange.cwl",
                    "in": [
                        {
                            "source": "#main/j1/output_file_2",
                            "id": "#main/j3/input_file"
                        }
                    ],
                    "out": [
                        "#main/j3/output_file"
                    ],
                    "hints": [
                        {
                            "start": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "at_end": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/invokes"
                        },
                        {
                            "namespace": "pegasus",
                            "name": "#main/j3/findrange",
                            "version": 4.0,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/job_fields"
                        },
                        {
                            "time": 60,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/metadata"
                        },
                        {
                            "output_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/registers"
                        },
                        {
                            "output_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/transfers"
                        }
                    ]
                },
                {
                    "id": "#main/j4",
                    "run": "#analyze.cwl",
                    "in": [
                        {
                            "source": [
                                "#main/j2/output_file",
                                "#main/j3/output_file"
                            ],
                            "id": "#main/j4/input_files"
                        }
                    ],
                    "out": [
                        "#main/j4/analysis_file"
                    ],
                    "hints": [
                        {
                            "start": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "at_end": [
                                "/pegasus/libexec/notification/email -t notify@example.com"
                            ],
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/invokes"
                        },
                        {
                            "namespace": "pegasus",
                            "name": "#main/j4/analyze",
                            "version": 4.0,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/job_fields"
                        },
                        {
                            "time": 60,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/metadata"
                        },
                        {
                            "analysis_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/registers"
                        },
                        {
                            "analysis_file": true,
                            "class": "file:///Users/ryantanaka/ISI/cwl-vs-dax-example/black-diamond-workflow/cwl/transfers"
                        }
                    ]
                }
            ],
            "id": "#main"
        },
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/keg",
            "id": "#findrange.cwl",
            "arguments": [
                "-a",
                "findrange",
                "-T",
                "60",
                "-o",
                "output_file"
            ],
            "inputs": {
                "input_file": {
                    "type": "File",
                    "inputBinding": {
                        "prefix": "-i",
                        "separate": true,
                        "position": 1
                    }
                }
            },
            "outputs": {
                "output_file": {
                    "type": "File"
                }
            },
            "hints": {
                "executable_info": {
                    "namespace": "pegasus",
                    "version": "v4.0",
                    "installed": true,
                    "arch": "helllo",
                    "os": "linux",
                    "pfn": {
                        "url": "file:///usr/bin/keg",
                        "site": "TestCluster"
                    }
                }
            }
        },
        {
            "class": "CommandLineTool",
            "baseCommand": "/usr/bin/keg",
            "id": "#preprocess.cwl",
            "arguments": [
                "-a",
                "preprocesss",
                "-T",
                "60",
                "-o",
                "output_file_1",
                "output_file_2"
            ],
            "inputs": {
                "input_file": {
                    "type": "File",
                    "inputBinding": {
                        "prefix": "-i",
                        "separate": true,
                        "position": 1
                    }
                }
            },
            "outputs": {
                "output_file_1": {
                    "type": "File"
                },
                "output_file_2": {
                    "type": "File"
                }
            },
            "hints": {
                "executable_info": {
                    "namespace": "pegasus",
                    "version": "v4.0",
                    "installed": true,
                    "arch": "helllo",
                    "os": "linux",
                    "size": 2048,
                    "pfn": {
                        "url": "file:///usr/bin/keg",
                        "site": "TestCluster"
                    }
                }
            }
        }
    ],
    "cwlVersion": "v1.0"
}