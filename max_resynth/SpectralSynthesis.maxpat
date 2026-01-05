{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 2,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 434.0, -448.0, 834.0, 558.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-29",
                    "maxclass": "dict.view",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ -39.0, 516.0, 207.0, 356.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 665.3333531618118, 46.66666805744171, 218.0, 391.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ -30.0, 335.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "outlettype": [ "dictionary", "", "", "", "" ],
                    "patching_rect": [ -30.5, 454.0, 148.0, 22.0 ],
                    "saved_object_attributes": {
                        "legacy": 0,
                        "parameter_enable": 0,
                        "parameter_mappable": 0
                    },
                    "text": "dict partials_loader_status"
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ -30.0, 417.0, 192.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "partials_loader_status_to_dict.js",
                        "parameter_enable": 0
                    },
                    "text": "js partials_loader_status_to_dict.js"
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-36",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Limiter~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 923.0, 1235.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 473.33334743976593, 578.6666839122772, 169.0, 84.0 ],
                    "varname": "Abl.Limiter~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-37",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Delay~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 923.0, 1102.0, 169.0, 124.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 473.33334743976593, 445.3333466053009, 169.0, 124.0 ],
                    "varname": "Abl.Delay~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-39",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Chorus~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 923.0, 964.0, 169.0, 124.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 296.0000088214874, 729.3333550691605, 169.0, 124.0 ],
                    "varname": "Abl.Chorus~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-40",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Output~.maxpat",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "" ],
                    "patching_rect": [ 923.0, 1336.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 473.33334743976593, 676.0000201463699, 169.0, 84.0 ],
                    "varname": "Abl.Output~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-42",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.ChannelEQ~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 729.0, 1154.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 296.0000088214874, 636.000018954277, 169.0, 84.0 ],
                    "varname": "Abl.ChannelEQ~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-43",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Compressor~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 729.0, 963.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 296.0000088214874, 445.3333466053009, 169.0, 84.0 ],
                    "varname": "Abl.Compressor~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-44",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Overdrive~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 729.0, 1055.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 296.0000088214874, 537.3333493471146, 169.0, 84.0 ],
                    "varname": "Abl.Overdrive~[2]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-111",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Limiter~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 525.0, 1234.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 577.3333505392075, 169.0, 84.0 ],
                    "varname": "Abl.Limiter~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-116",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Delay~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 525.0, 1102.0, 169.0, 124.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 445.3333466053009, 169.0, 124.0 ],
                    "varname": "Abl.Delay~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-117",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Chorus~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 525.0, 963.0, 169.0, 124.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 729.3333550691605, 169.0, 124.0 ],
                    "varname": "Abl.Chorus~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-110",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Output~.maxpat",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "" ],
                    "patching_rect": [ 525.0, 1336.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 670.6666866540909, 169.0, 84.0 ],
                    "varname": "Abl.Output~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-98",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.ChannelEQ~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 332.0, 1154.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 636.000018954277, 169.0, 84.0 ],
                    "varname": "Abl.ChannelEQ~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-48",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Compressor~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 332.0, 962.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 445.3333466053009, 169.0, 84.0 ],
                    "varname": "Abl.Compressor~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-58",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Overdrive~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 332.0, 1055.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 537.3333493471146, 169.0, 84.0 ],
                    "varname": "Abl.Overdrive~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-118",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Output~.maxpat",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "" ],
                    "patching_rect": [ 126.0, 1297.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 208.00000619888306, 169.0, 84.0 ],
                    "varname": "Abl.Output~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-107",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Limiter~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 126.0, 1196.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 116.0000034570694, 169.0, 84.0 ],
                    "varname": "Abl.Limiter~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-108",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.PlateReverb~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 126.0, 1102.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 108.00000321865082, 22.666667342185974, 169.0, 84.0 ],
                    "varname": "Abl.PlateReverb~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-35",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Chorus~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 126.0, 963.0, 169.0, 124.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 300.0000089406967, 169.0, 124.0 ],
                    "varname": "Abl.Chorus~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-102",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.ChannelEQ~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ -68.0, 1160.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 208.00000619888306, 169.0, 84.0 ],
                    "varname": "Abl.ChannelEQ~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-103",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Compressor~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ -68.0, 969.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 22.666667342185974, 169.0, 84.0 ],
                    "varname": "Abl.Compressor~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "bgmode": 0,
                    "border": 0,
                    "clickthrough": 0,
                    "enablehscroll": 0,
                    "enablevscroll": 0,
                    "id": "obj-104",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Overdrive~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ -68.0, 1065.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ -68.00000202655792, 112.00000333786011, 169.0, 84.0 ],
                    "varname": "Abl.Overdrive~[1]",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-50",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 628.0, 67.0, 42.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 284.00000846385956, 270.6666747331619, 76.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 628.0, 39.0, 54.0, 22.0 ],
                    "text": "unpack f"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 628.0, 15.0, 110.0, 22.0 ],
                    "text": "route /system/state"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 628.0, -18.0, 97.0, 22.0 ],
                    "text": "udpreceive 9001"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "" ],
                    "patching_rect": [ 628.0, 103.0, 133.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "osc_to_jitter_notes.js",
                        "parameter_enable": 0
                    },
                    "text": "js osc_to_jitter_notes.js"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 261.0, 120.0, 39.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 570.6666836738586, 66.66666865348816, 60.0, 22.0 ],
                    "text": "dump"
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 209.0, 120.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 26.0, 130.0, 35.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 473.33334743976593, 66.66666865348816, 35.0, 22.0 ],
                    "text": "jump"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 22.0, 91.0, 53.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 513.3333486318588, 66.66666865348816, 53.0, 22.0 ],
                    "text": "scan .txt"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "linecount": 3,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 22.0, 25.5, 172.0, 49.0 ],
                    "presentation": 1,
                    "presentation_linecount": 3,
                    "presentation_rect": [ 289.3333419561386, 40.000001192092896, 172.0, 49.0 ],
                    "text": "setfolder /Users/microhm/Desktop/01_Proyectos/IMOL/max_resynth"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 197.0, 91.0, 145.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "partials_bank_to_coll.js",
                        "parameter_enable": 0
                    },
                    "text": "js partials_bank_to_coll.js"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 565.0, 905.0, 164.0, 22.0 ],
                    "text": "mc.mixdown~ 2 @autogain 0"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 385.0, 905.0, 164.0, 22.0 ],
                    "text": "mc.mixdown~ 2 @autogain 0"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 252.0, 318.0, 36.0, 20.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 357.0, 319.0, 36.0, 20.0 ],
                    "text": "freq"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 453.0, 319.0, 36.0, 20.0 ],
                    "text": "amp"
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 447.0, 845.0, 71.0, 22.0 ],
                    "text": "autogain $1"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 385.0, 91.0, 135.0, 33.0 ],
                    "text": "Partial amplitude\nCustom Jitter amplitude"
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 408.0, 629.0, 29.5, 22.0 ],
                    "text": "+ 1"
                }
            },
            {
                "box": {
                    "disabled": [ 0, 0 ],
                    "id": "obj-2",
                    "itemtype": 0,
                    "maxclass": "radiogroup",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 365.0, 91.0, 18.0, 34.0 ],
                    "size": 2,
                    "value": 1
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 408.0, 653.0, 97.0, 22.0 ],
                    "text": "mc.selector~ 2 1"
                }
            },
            {
                "box": {
                    "id": "obj-238",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 710.0, 509.0, 162.0, 22.0 ],
                    "text": "mc.rampsmooth~ 8800 8800"
                }
            },
            {
                "box": {
                    "id": "obj-237",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 710.0, 480.0, 114.0, 22.0 ],
                    "text": "mc.list~ @chans 83"
                }
            },
            {
                "box": {
                    "id": "obj-236",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "jit_matrix", "" ],
                    "patching_rect": [ 710.0, 248.0, 87.0, 22.0 ],
                    "text": "jit.clip @min 0."
                }
            },
            {
                "box": {
                    "id": "obj-235",
                    "linecount": 4,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 738.0, 405.0, 315.00002455711365, 62.0 ],
                    "presentation": 1,
                    "presentation_linecount": 4,
                    "presentation_rect": [ 284.00000846385956, 116.0000034570694, 346.6666769981384, 62.0 ],
                    "text": "0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-233",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 710.0, 285.0, 41.0, 22.0 ],
                    "text": "jit.spill"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-232",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 996.0, 60.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 461.33334708213806, 270.6666747331619, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-230",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 996.0, 102.0, 87.0, 22.0 ],
                    "text": "scale $1, bang"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-228",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 868.0, 65.0, 76.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 373.3333444595337, 270.6666747331619, 76.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-226",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 868.0, 102.0, 114.0, 22.0 ],
                    "text": "offset $1 0. 0., bang"
                }
            },
            {
                "box": {
                    "id": "obj-224",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 959.0, 202.0, 87.0, 20.0 ],
                    "text": "jit.pwindow"
                }
            },
            {
                "box": {
                    "bordercolor": [ 0.396078431372549, 0.396078431372549, 0.396078431372549, 1.0 ],
                    "id": "obj-222",
                    "maxclass": "jit.pwindow",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "jit_matrix", "" ],
                    "patching_rect": [ 810.0, 244.0, 232.0, 121.59257709980011 ],
                    "presentation": 1,
                    "presentation_rect": [ 121.33333694934845, 305.33334243297577, 521.0000104904175, 118.66667020320892 ],
                    "sync": 1
                }
            },
            {
                "box": {
                    "id": "obj-221",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 810.0, 78.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-219",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "jit_matrix", "" ],
                    "patching_rect": [ 810.0, 193.0, 119.0, 22.0 ],
                    "text": "jit.matrix 1 float32 83"
                }
            },
            {
                "box": {
                    "id": "obj-218",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "jit_matrix", "" ],
                    "patching_rect": [ 810.0, 145.0, 243.0, 22.0 ],
                    "text": "jit.bfg 1 float32 83 2 2 @basis noise.simplex"
                }
            },
            {
                "box": {
                    "id": "obj-212",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "multichannelsignal", "multichannelsignal", "multichannelsignal" ],
                    "patching_rect": [ 197.0, 635.0, 110.0, 22.0 ],
                    "text": "mc.deinterleave~ 3"
                }
            },
            {
                "box": {
                    "id": "obj-211",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 232.0, 188.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-209",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "setvalue", "int" ],
                    "patching_rect": [ 447.0, 511.0, 59.0, 22.0 ],
                    "text": "mc.target"
                }
            },
            {
                "box": {
                    "id": "obj-208",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "setvalue", "int" ],
                    "patching_rect": [ 197.0, 516.0, 59.0, 22.0 ],
                    "text": "mc.target"
                }
            },
            {
                "box": {
                    "id": "obj-206",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 197.0, 905.0, 164.0, 22.0 ],
                    "text": "mc.mixdown~ 2 @autogain 0"
                }
            },
            {
                "box": {
                    "id": "obj-205",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 447.0, 487.0, 181.0, 22.0 ],
                    "text": "zl.join 0. 100 @zlmaxsize 99999"
                }
            },
            {
                "box": {
                    "id": "obj-201",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3317.0, 3507.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-199",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 447.0, 464.0, 156.0, 22.0 ],
                    "text": "zl.group @zlmaxsize 99999"
                }
            },
            {
                "box": {
                    "id": "obj-196",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 197.0, 487.0, 156.0, 22.0 ],
                    "text": "zl.group @zlmaxsize 99999"
                }
            },
            {
                "box": {
                    "id": "obj-193",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 447.0, 435.0, 103.0, 22.0 ],
                    "text": "join 2 @triggers 1"
                }
            },
            {
                "box": {
                    "id": "obj-190",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 197.0, 454.0, 103.0, 22.0 ],
                    "text": "join 2 @triggers 1"
                }
            },
            {
                "box": {
                    "id": "obj-188",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "", "float" ],
                    "patching_rect": [ 197.0, 216.0, 333.56401085853577, 22.0 ],
                    "text": "t b l 0."
                }
            },
            {
                "box": {
                    "id": "obj-185",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 197.0, 348.0, 47.0, 22.0 ],
                    "text": "* 1000."
                }
            },
            {
                "box": {
                    "id": "obj-184",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 207.5, 410.0, 64.03785294294357, 22.0 ],
                    "text": "- 0."
                }
            },
            {
                "box": {
                    "id": "obj-183",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "float" ],
                    "patching_rect": [ 197.0, 376.0, 29.5, 22.0 ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-182",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 408.0, 316.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-180",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 301.0, 318.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-178",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 197.0, 317.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "float", "float", "float" ],
                    "patching_rect": [ 196.74287351965904, 285.0, 227.51425296068192, 22.0 ],
                    "text": "unpack 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-174",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 197.0, 252.0, 166.0, 22.0 ],
                    "text": "zl.group 3 @zlmaxsize 99999"
                }
            },
            {
                "box": {
                    "id": "obj-173",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 197.0, 596.0, 103.0, 22.0 ],
                    "text": "mc.*~"
                }
            },
            {
                "box": {
                    "id": "obj-172",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 197.0, 572.0, 45.0, 22.0 ],
                    "text": "mc.tri~"
                }
            },
            {
                "box": {
                    "id": "obj-167",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 3,
                    "outlettype": [ "multichannelsignal", "", "" ],
                    "patching_rect": [ 447.0, 536.0, 218.0, 22.0 ],
                    "text": "mc.line~ @chans 82 @maxpoints 9999"
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 3,
                    "outlettype": [ "multichannelsignal", "", "" ],
                    "patching_rect": [ 197.0, 542.0, 218.0, 22.0 ],
                    "text": "mc.line~ @chans 82 @maxpoints 9999"
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 197.0, 159.0, 124.0, 22.0 ],
                    "saved_object_attributes": {
                        "embed": 0,
                        "precision": 6
                    },
                    "text": "coll my_partials_bank"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-173", 1 ],
                    "midpoints": [ 417.5, 678.0, 405.0, 678.0, 405.0, 618.0, 426.0, 618.0, 426.0, 591.0, 290.5, 591.0 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "midpoints": [ -58.5, 1246.78125, -85.1217951575986, 1246.78125, -85.1217951575986, 955.78125, 135.5, 955.78125 ],
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-104", 0 ],
                    "source": [ "obj-103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
                    "source": [ "obj-104", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 0 ],
                    "source": [ "obj-107", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-107", 0 ],
                    "source": [ "obj-108", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 31.5, 84.0, 206.5, 84.0 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-110", 0 ],
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 0 ],
                    "source": [ "obj-116", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-116", 0 ],
                    "source": [ "obj-117", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-188", 0 ],
                    "source": [ "obj-135", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-211", 0 ],
                    "source": [ "obj-135", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-172", 0 ],
                    "source": [ "obj-154", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 31.5, 114.0, 183.0, 114.0, 183.0, 87.0, 206.5, 87.0 ],
                    "source": [ "obj-16", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 1 ],
                    "source": [ "obj-167", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-173", 0 ],
                    "source": [ "obj-172", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-212", 0 ],
                    "source": [ "obj-173", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-176", 0 ],
                    "source": [ "obj-174", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-178", 0 ],
                    "source": [ "obj-176", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-180", 0 ],
                    "source": [ "obj-176", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-182", 0 ],
                    "source": [ "obj-176", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-185", 0 ],
                    "source": [ "obj-178", 0 ]
                }
            },
            {
                "patchline": {
                    "color": [ 0.0, 0.435617208480835, 0.30309396982193, 1.0 ],
                    "destination": [ "obj-190", 0 ],
                    "midpoints": [ 310.5, 448.5000249147415, 206.5, 448.5000249147415 ],
                    "source": [ "obj-180", 0 ]
                }
            },
            {
                "patchline": {
                    "color": [ 0.461506187915802, 0.0, 0.308563560247421, 1.0 ],
                    "destination": [ "obj-193", 0 ],
                    "midpoints": [ 417.5, 484.0195561647415, 456.5, 484.0195561647415 ],
                    "source": [ "obj-182", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-184", 0 ],
                    "source": [ "obj-183", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-184", 1 ],
                    "midpoints": [ 206.5, 439.5000249147415, 262.0378529429436, 439.5000249147415 ],
                    "source": [ "obj-183", 0 ]
                }
            },
            {
                "patchline": {
                    "color": [ 0.0, 0.336027532815933, 0.426819026470184, 1.0 ],
                    "destination": [ "obj-190", 1 ],
                    "midpoints": [ 217.0, 435.0, 290.5, 435.0 ],
                    "order": 1,
                    "source": [ "obj-184", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-193", 1 ],
                    "midpoints": [ 217.0, 435.0, 432.0, 435.0, 432.0, 420.0, 540.5, 420.0 ],
                    "order": 0,
                    "source": [ "obj-184", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-183", 0 ],
                    "source": [ "obj-185", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-174", 0 ],
                    "source": [ "obj-188", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-184", 1 ],
                    "midpoints": [ 521.0640108585358, 396.0, 262.0378529429436, 396.0 ],
                    "source": [ "obj-188", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 206.5, 240.0, 183.0, 240.0, 183.0, 483.0, 206.5, 483.0 ],
                    "order": 1,
                    "source": [ "obj-188", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-199", 0 ],
                    "midpoints": [ 206.5, 240.0, 183.0, 240.0, 183.0, 372.0, 237.0, 372.0, 237.0, 393.0, 432.0, 393.0, 432.0, 459.0, 456.5, 459.0 ],
                    "order": 0,
                    "source": [ "obj-188", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "source": [ "obj-19", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "source": [ "obj-190", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-199", 0 ],
                    "source": [ "obj-193", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-208", 0 ],
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-205", 0 ],
                    "source": [ "obj-199", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "midpoints": [ 374.5, 201.0, 540.0, 201.0, 540.0, 420.0, 426.0, 420.0, 426.0, 624.0, 417.5, 624.0 ],
                    "order": 1,
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 374.5, 147.86145281791687, 695.9030225276947, 147.86145281791687, 695.9030225276947, 821.4434840679169, 456.5, 821.4434840679169 ],
                    "order": 0,
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-50", 0 ],
                    "source": [ "obj-20", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-209", 0 ],
                    "source": [ "obj-205", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-103", 0 ],
                    "source": [ "obj-206", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-154", 0 ],
                    "source": [ "obj-208", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-167", 0 ],
                    "source": [ "obj-209", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-208", 1 ],
                    "midpoints": [ 241.5, 213.0, 183.0, 213.0, 183.0, 513.0, 246.5, 513.0 ],
                    "order": 1,
                    "source": [ "obj-211", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-209", 1 ],
                    "midpoints": [ 241.5, 213.0, 183.0, 213.0, 183.0, 372.0, 237.0, 372.0, 237.0, 393.0, 639.0, 393.0, 639.0, 519.0, 507.0, 519.0, 507.0, 510.0, 496.5, 510.0 ],
                    "order": 0,
                    "source": [ "obj-211", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "source": [ "obj-212", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-206", 0 ],
                    "source": [ "obj-212", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 0 ],
                    "source": [ "obj-212", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-219", 0 ],
                    "source": [ "obj-218", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-222", 0 ],
                    "order": 0,
                    "source": [ "obj-219", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-236", 0 ],
                    "order": 1,
                    "source": [ "obj-219", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 0 ],
                    "source": [ "obj-22", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-218", 0 ],
                    "source": [ "obj-221", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-218", 0 ],
                    "source": [ "obj-226", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-226", 0 ],
                    "source": [ "obj-228", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-218", 0 ],
                    "source": [ "obj-230", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230", 0 ],
                    "source": [ "obj-232", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-235", 1 ],
                    "midpoints": [ 719.5, 391.79633301496506, 1043.5000245571136, 391.79633301496506 ],
                    "order": 0,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-237", 0 ],
                    "midpoints": [ 719.5, 659.8333294391632, 719.5, 659.8333294391632 ],
                    "order": 2,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 1 ],
                    "midpoints": [ 719.5, 309.0, 696.0, 309.0, 696.0, 144.0, 768.0, 144.0, 768.0, 105.0, 751.5, 105.0 ],
                    "order": 1,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-233", 0 ],
                    "source": [ "obj-236", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-238", 0 ],
                    "source": [ "obj-237", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 2 ],
                    "midpoints": [ 719.5, 760.5000249147415, 495.5, 760.5000249147415 ],
                    "source": [ "obj-238", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-43", 0 ],
                    "source": [ "obj-24", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 35.5, 162.0, 183.0, 162.0, 183.0, 87.0, 206.5, 87.0 ],
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-29", 0 ],
                    "source": [ "obj-26", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-28", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-3", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20", 0 ],
                    "source": [ "obj-33", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-34", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-108", 0 ],
                    "source": [ "obj-35", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 0 ],
                    "source": [ "obj-36", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 0 ],
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 0 ],
                    "source": [ "obj-39", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-39", 0 ],
                    "midpoints": [ 738.5, 1250.0, 893.7778750260679, 1250.0, 893.7778750260679, 950.0, 932.5, 950.0 ],
                    "source": [ "obj-42", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 0 ],
                    "source": [ "obj-43", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-42", 0 ],
                    "source": [ "obj-44", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-58", 0 ],
                    "source": [ "obj-48", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "source": [ "obj-50", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-98", 0 ],
                    "source": [ "obj-58", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-6", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "order": 1,
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-206", 0 ],
                    "order": 2,
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 0 ],
                    "order": 0,
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-228", 0 ],
                    "midpoints": [ 637.5, 144.0, 795.0, 144.0, 795.0, 60.0, 877.5, 60.0 ],
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-232", 0 ],
                    "midpoints": [ 694.5, 144.0, 795.0, 144.0, 795.0, 51.0, 981.0, 51.0, 981.0, 57.0, 1005.5, 57.0 ],
                    "source": [ "obj-8", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 0 ],
                    "midpoints": [ 341.5, 1249.4375, 496.65642509295236, 1249.4375, 496.65642509295236, 949.4375, 534.5, 949.4375 ],
                    "source": [ "obj-98", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-102::obj-112": [ "HighPass", "HighPass", 0 ],
            "obj-102::obj-154": [ "Abl.ChannelEQ", "Abl.ChannelEQ", 0 ],
            "obj-102::obj-167": [ "ModOutB[2]", "ModOutB", -1 ],
            "obj-102::obj-45": [ "ModInALed[2]", "ModInALed", 0 ],
            "obj-102::obj-47": [ "ModInBLed[2]", "ModInBLed", 0 ],
            "obj-102::obj-49": [ "ModInA[2]", "ModInA", -1 ],
            "obj-102::obj-50": [ "ModInB[2]", "ModInB", -1 ],
            "obj-102::obj-52": [ "ModOutA[2]", "ModOutA", -1 ],
            "obj-102::obj-59": [ "ModOutALed[2]", "ModOutALed", 0 ],
            "obj-102::obj-6": [ "Mid[1]", "Mid", 0 ],
            "obj-102::obj-60": [ "ModOutBLed[2]", "ModOutBLed", 0 ],
            "obj-102::obj-8": [ "MidF", "MidF", 0 ],
            "obj-102::obj-81": [ "Low", "Low", 0 ],
            "obj-102::obj-82": [ "Gain[2]", "Gain", 0 ],
            "obj-102::obj-9": [ "High", "High", 0 ],
            "obj-102::obj-99": [ "Active[2]", "Active", 0 ],
            "obj-103::obj-154": [ "Abl.Compressor", "Abl.Compressor", 0 ],
            "obj-103::obj-167": [ "ModOutB[1]", "ModOutB", -1 ],
            "obj-103::obj-45": [ "ModInALed[1]", "ModInALed", 0 ],
            "obj-103::obj-47": [ "ModInBLed[1]", "ModInBLed", 0 ],
            "obj-103::obj-49": [ "ModInA[1]", "ModInA", -1 ],
            "obj-103::obj-50": [ "ModInB[1]", "ModInB", -1 ],
            "obj-103::obj-52": [ "ModOutA[1]", "ModOutA", -1 ],
            "obj-103::obj-59": [ "ModOutALed[1]", "ModOutALed", 0 ],
            "obj-103::obj-6": [ "Rel", "Rel", 0 ],
            "obj-103::obj-60": [ "ModOutBLed[1]", "ModOutBLed", 0 ],
            "obj-103::obj-8": [ "Thresh", "Thresh", 0 ],
            "obj-103::obj-81": [ "Att", "Att", 0 ],
            "obj-103::obj-82": [ "Gain[1]", "Gain", 0 ],
            "obj-103::obj-9": [ "Ratio", "Ratio", 0 ],
            "obj-103::obj-99": [ "Active[1]", "Active", 0 ],
            "obj-104::obj-112": [ "Sub", "Sub", 0 ],
            "obj-104::obj-116": [ "MidRange", "MidRange", 0 ],
            "obj-104::obj-154": [ "Abl.Overdrive", "Abl.Overdrive", 0 ],
            "obj-104::obj-167": [ "ModOutB", "ModOutB", -1 ],
            "obj-104::obj-45": [ "ModInALed", "ModInALed", 0 ],
            "obj-104::obj-47": [ "ModInBLed", "ModInBLed", 0 ],
            "obj-104::obj-49": [ "ModInA", "ModInA", -1 ],
            "obj-104::obj-50": [ "ModInB", "ModInB", -1 ],
            "obj-104::obj-52": [ "ModOutA", "ModOutA", -1 ],
            "obj-104::obj-59": [ "ModOutALed", "ModOutALed", 0 ],
            "obj-104::obj-6": [ "Bass", "Bass", 0 ],
            "obj-104::obj-60": [ "ModOutBLed", "ModOutBLed", 0 ],
            "obj-104::obj-8": [ "Mid", "Mid", 0 ],
            "obj-104::obj-81": [ "Gain", "Gain", 0 ],
            "obj-104::obj-82": [ "Mix", "Mix", 0 ],
            "obj-104::obj-9": [ "Treble", "Treble", 0 ],
            "obj-104::obj-99": [ "Active", "Active", 0 ],
            "obj-107::obj-112": [ "AutoRelease", "AutoRelease", 0 ],
            "obj-107::obj-116": [ "Lookahead", "Lookahead", 0 ],
            "obj-107::obj-154": [ "Abl.Limiter", "Abl.Limiter", 0 ],
            "obj-107::obj-167": [ "ModOutB[5]", "ModOutB", -1 ],
            "obj-107::obj-45": [ "ModInALed[5]", "ModInALed", 0 ],
            "obj-107::obj-47": [ "ModInBLed[5]", "ModInBLed", 0 ],
            "obj-107::obj-49": [ "ModInA[5]", "ModInA", -1 ],
            "obj-107::obj-50": [ "ModInB[5]", "ModInB", -1 ],
            "obj-107::obj-52": [ "ModOutA[5]", "ModOutA", -1 ],
            "obj-107::obj-59": [ "ModOutALed[5]", "ModOutALed", 0 ],
            "obj-107::obj-6": [ "Gain[4]", "Gain", 0 ],
            "obj-107::obj-60": [ "ModOutBLed[5]", "ModOutBLed", 0 ],
            "obj-107::obj-8": [ "Ceil", "Ceil", 0 ],
            "obj-107::obj-9": [ "Rel[1]", "Rel", 0 ],
            "obj-107::obj-99": [ "Active[5]", "Active", 0 ],
            "obj-108::obj-154": [ "Abl.PlateReverb", "Abl.PlateReverb", 0 ],
            "obj-108::obj-167": [ "ModOutB[4]", "ModOutB", -1 ],
            "obj-108::obj-4": [ "Mix[2]", "Mix", 0 ],
            "obj-108::obj-45": [ "ModInALed[4]", "ModInALed", 0 ],
            "obj-108::obj-47": [ "ModInBLed[4]", "ModInBLed", 0 ],
            "obj-108::obj-49": [ "ModInA[4]", "ModInA", -1 ],
            "obj-108::obj-50": [ "ModInB[4]", "ModInB", -1 ],
            "obj-108::obj-52": [ "ModOutA[4]", "ModOutA", -1 ],
            "obj-108::obj-59": [ "ModOutALed[4]", "ModOutALed", 0 ],
            "obj-108::obj-6": [ "PreDel", "PreDel", 0 ],
            "obj-108::obj-60": [ "ModOutBLed[4]", "ModOutBLed", 0 ],
            "obj-108::obj-8": [ "Decay", "Decay", 0 ],
            "obj-108::obj-81": [ "DampF", "DampF", 0 ],
            "obj-108::obj-99": [ "Active[4]", "Active", 0 ],
            "obj-110::obj-154": [ "Abl.Output[1]", "Abl.Output", 0 ],
            "obj-110::obj-17": [ "Dac[1]", "Dac", 0 ],
            "obj-110::obj-44": [ "Limiter[1]", "Limiter", 0 ],
            "obj-110::obj-49": [ "ModIn[1]", "ModIn", -1 ],
            "obj-110::obj-60": [ "ModOutLed[1]", "ModOutLed", 0 ],
            "obj-110::obj-69": [ "ModOut[1]", "ModOut", -1 ],
            "obj-110::obj-71": [ "ModInLed[1]", "ModInLed", 0 ],
            "obj-110::obj-8": [ "Gain[9]", "Gain", 0 ],
            "obj-110::obj-99": [ "Active[10]", "Active", 0 ],
            "obj-111::obj-112": [ "AutoRelease[1]", "AutoRelease", 0 ],
            "obj-111::obj-116": [ "Lookahead[1]", "Lookahead", 0 ],
            "obj-111::obj-154": [ "Abl.Limiter[1]", "Abl.Limiter", 0 ],
            "obj-111::obj-167": [ "ModOutB[11]", "ModOutB", -1 ],
            "obj-111::obj-45": [ "ModInALed[11]", "ModInALed", 0 ],
            "obj-111::obj-47": [ "ModInBLed[11]", "ModInBLed", 0 ],
            "obj-111::obj-49": [ "ModInA[11]", "ModInA", -1 ],
            "obj-111::obj-50": [ "ModInB[11]", "ModInB", -1 ],
            "obj-111::obj-52": [ "ModOutA[11]", "ModOutA", -1 ],
            "obj-111::obj-59": [ "ModOutALed[11]", "ModOutALed", 0 ],
            "obj-111::obj-6": [ "Gain[11]", "Gain", 0 ],
            "obj-111::obj-60": [ "ModOutBLed[11]", "ModOutBLed", 0 ],
            "obj-111::obj-8": [ "Ceil[1]", "Ceil", 0 ],
            "obj-111::obj-9": [ "Rel[3]", "Rel", 0 ],
            "obj-111::obj-99": [ "Active[13]", "Active", 0 ],
            "obj-116::obj-112": [ "Filter", "Filter", 0 ],
            "obj-116::obj-116": [ "Smooth", "Smooth", 0 ],
            "obj-116::obj-154": [ "Abl.Delay", "Abl.Delay", 0 ],
            "obj-116::obj-167": [ "ModOutB[10]", "ModOutB", -1 ],
            "obj-116::obj-19": [ "Freeze", "Freeze", 0 ],
            "obj-116::obj-23": [ "PingPong", "PingPong", 0 ],
            "obj-116::obj-44": [ "Eco", "Eco", 0 ],
            "obj-116::obj-45": [ "ModInALed[10]", "ModInALed", 0 ],
            "obj-116::obj-47": [ "ModInBLed[10]", "ModInBLed", 0 ],
            "obj-116::obj-49": [ "ModInA[10]", "ModInA", -1 ],
            "obj-116::obj-50": [ "ModInB[10]", "ModInB", -1 ],
            "obj-116::obj-51": [ "MFreq", "MFreq", 0 ],
            "obj-116::obj-52": [ "ModOutA[10]", "ModOutA", -1 ],
            "obj-116::obj-53": [ "Mix[5]", "Mix", 0 ],
            "obj-116::obj-54": [ "MFilt", "MFilt", 0 ],
            "obj-116::obj-55": [ "MTime", "MTime", 0 ],
            "obj-116::obj-58": [ "Link", "Link", -1 ],
            "obj-116::obj-59": [ "ModOutALed[10]", "ModOutALed", 0 ],
            "obj-116::obj-6": [ "DelR", "DelR", 0 ],
            "obj-116::obj-60": [ "ModOutBLed[10]", "ModOutBLed", 0 ],
            "obj-116::obj-8": [ "Feed[2]", "Feed", 0 ],
            "obj-116::obj-81": [ "DelL", "DelL", 0 ],
            "obj-116::obj-82": [ "Width[2]", "Width", 0 ],
            "obj-116::obj-9": [ "Freq", "Freq", 0 ],
            "obj-116::obj-99": [ "Active[12]", "Active", 0 ],
            "obj-117::obj-112": [ "Invert[1]", "Invert", 0 ],
            "obj-117::obj-154": [ "Abl.Chorus[1]", "Abl.Chorus", 0 ],
            "obj-117::obj-167": [ "ModOutB[9]", "ModOutB", -1 ],
            "obj-117::obj-4": [ "Mix[4]", "Mix", 0 ],
            "obj-117::obj-45": [ "ModInALed[9]", "ModInALed", 0 ],
            "obj-117::obj-47": [ "ModInBLed[9]", "ModInBLed", 0 ],
            "obj-117::obj-49": [ "ModInA[9]", "ModInA", -1 ],
            "obj-117::obj-50": [ "ModInB[9]", "ModInB", -1 ],
            "obj-117::obj-52": [ "ModOutA[9]", "ModOutA", -1 ],
            "obj-117::obj-59": [ "ModOutALed[9]", "ModOutALed", 0 ],
            "obj-117::obj-6": [ "Rate[1]", "Rate", 0 ],
            "obj-117::obj-60": [ "ModOutBLed[9]", "ModOutBLed", 0 ],
            "obj-117::obj-8": [ "Feed[1]", "Feed", 0 ],
            "obj-117::obj-81": [ "Mod[1]", "Mod", 0 ],
            "obj-117::obj-82": [ "Gain[10]", "Gain", 0 ],
            "obj-117::obj-9": [ "Width[1]", "Width", 0 ],
            "obj-117::obj-99": [ "Active[11]", "Active", 0 ],
            "obj-118::obj-154": [ "Abl.Output", "Abl.Output", 0 ],
            "obj-118::obj-17": [ "Dac", "Dac", 0 ],
            "obj-118::obj-44": [ "Limiter", "Limiter", 0 ],
            "obj-118::obj-49": [ "ModIn", "ModIn", -1 ],
            "obj-118::obj-60": [ "ModOutLed", "ModOutLed", 0 ],
            "obj-118::obj-69": [ "ModOut", "ModOut", -1 ],
            "obj-118::obj-71": [ "ModInLed", "ModInLed", 0 ],
            "obj-118::obj-8": [ "Gain[5]", "Gain", 0 ],
            "obj-118::obj-99": [ "Active[6]", "Active", 0 ],
            "obj-35::obj-112": [ "Invert", "Invert", 0 ],
            "obj-35::obj-154": [ "Abl.Chorus", "Abl.Chorus", 0 ],
            "obj-35::obj-167": [ "ModOutB[3]", "ModOutB", -1 ],
            "obj-35::obj-4": [ "Mix[1]", "Mix", 0 ],
            "obj-35::obj-45": [ "ModInALed[3]", "ModInALed", 0 ],
            "obj-35::obj-47": [ "ModInBLed[3]", "ModInBLed", 0 ],
            "obj-35::obj-49": [ "ModInA[3]", "ModInA", -1 ],
            "obj-35::obj-50": [ "ModInB[3]", "ModInB", -1 ],
            "obj-35::obj-52": [ "ModOutA[3]", "ModOutA", -1 ],
            "obj-35::obj-59": [ "ModOutALed[3]", "ModOutALed", 0 ],
            "obj-35::obj-6": [ "Rate", "Rate", 0 ],
            "obj-35::obj-60": [ "ModOutBLed[3]", "ModOutBLed", 0 ],
            "obj-35::obj-8": [ "Feed", "Feed", 0 ],
            "obj-35::obj-81": [ "Mod", "Mod", 0 ],
            "obj-35::obj-82": [ "Gain[3]", "Gain", 0 ],
            "obj-35::obj-9": [ "Width", "Width", 0 ],
            "obj-35::obj-99": [ "Active[3]", "Active", 0 ],
            "obj-36::obj-112": [ "AutoRelease[2]", "AutoRelease", 0 ],
            "obj-36::obj-116": [ "Lookahead[2]", "Lookahead", 0 ],
            "obj-36::obj-154": [ "Abl.Limiter[2]", "Abl.Limiter", 0 ],
            "obj-36::obj-167": [ "ModOutB[17]", "ModOutB", -1 ],
            "obj-36::obj-45": [ "ModInALed[17]", "ModInALed", 0 ],
            "obj-36::obj-47": [ "ModInBLed[17]", "ModInBLed", 0 ],
            "obj-36::obj-49": [ "ModInA[17]", "ModInA", -1 ],
            "obj-36::obj-50": [ "ModInB[17]", "ModInB", -1 ],
            "obj-36::obj-52": [ "ModOutA[17]", "ModOutA", -1 ],
            "obj-36::obj-59": [ "ModOutALed[17]", "ModOutALed", 0 ],
            "obj-36::obj-6": [ "Gain[17]", "Gain", 0 ],
            "obj-36::obj-60": [ "ModOutBLed[17]", "ModOutBLed", 0 ],
            "obj-36::obj-8": [ "Ceil[2]", "Ceil", 0 ],
            "obj-36::obj-9": [ "Rel[5]", "Rel", 0 ],
            "obj-36::obj-99": [ "Active[20]", "Active", 0 ],
            "obj-37::obj-112": [ "Filter[1]", "Filter", 0 ],
            "obj-37::obj-116": [ "Smooth[1]", "Smooth", 0 ],
            "obj-37::obj-154": [ "Abl.Delay[1]", "Abl.Delay", 0 ],
            "obj-37::obj-167": [ "ModOutB[16]", "ModOutB", -1 ],
            "obj-37::obj-19": [ "Freeze[1]", "Freeze", 0 ],
            "obj-37::obj-23": [ "PingPong[1]", "PingPong", 0 ],
            "obj-37::obj-44": [ "Eco[1]", "Eco", 0 ],
            "obj-37::obj-45": [ "ModInALed[16]", "ModInALed", 0 ],
            "obj-37::obj-47": [ "ModInBLed[16]", "ModInBLed", 0 ],
            "obj-37::obj-49": [ "ModInA[16]", "ModInA", -1 ],
            "obj-37::obj-50": [ "ModInB[16]", "ModInB", -1 ],
            "obj-37::obj-51": [ "MFreq[1]", "MFreq", 0 ],
            "obj-37::obj-52": [ "ModOutA[16]", "ModOutA", -1 ],
            "obj-37::obj-53": [ "Mix[8]", "Mix", 0 ],
            "obj-37::obj-54": [ "MFilt[1]", "MFilt", 0 ],
            "obj-37::obj-55": [ "MTime[1]", "MTime", 0 ],
            "obj-37::obj-58": [ "Link[1]", "Link", -1 ],
            "obj-37::obj-59": [ "ModOutALed[16]", "ModOutALed", 0 ],
            "obj-37::obj-6": [ "DelR[1]", "DelR", 0 ],
            "obj-37::obj-60": [ "ModOutBLed[16]", "ModOutBLed", 0 ],
            "obj-37::obj-8": [ "Feed[4]", "Feed", 0 ],
            "obj-37::obj-81": [ "DelL[1]", "DelL", 0 ],
            "obj-37::obj-82": [ "Width[4]", "Width", 0 ],
            "obj-37::obj-9": [ "Freq[1]", "Freq", 0 ],
            "obj-37::obj-99": [ "Active[19]", "Active", 0 ],
            "obj-39::obj-112": [ "Invert[2]", "Invert", 0 ],
            "obj-39::obj-154": [ "Abl.Chorus[2]", "Abl.Chorus", 0 ],
            "obj-39::obj-167": [ "ModOutB[15]", "ModOutB", -1 ],
            "obj-39::obj-4": [ "Mix[7]", "Mix", 0 ],
            "obj-39::obj-45": [ "ModInALed[15]", "ModInALed", 0 ],
            "obj-39::obj-47": [ "ModInBLed[15]", "ModInBLed", 0 ],
            "obj-39::obj-49": [ "ModInA[15]", "ModInA", -1 ],
            "obj-39::obj-50": [ "ModInB[15]", "ModInB", -1 ],
            "obj-39::obj-52": [ "ModOutA[15]", "ModOutA", -1 ],
            "obj-39::obj-59": [ "ModOutALed[15]", "ModOutALed", 0 ],
            "obj-39::obj-6": [ "Rate[2]", "Rate", 0 ],
            "obj-39::obj-60": [ "ModOutBLed[15]", "ModOutBLed", 0 ],
            "obj-39::obj-8": [ "Feed[3]", "Feed", 0 ],
            "obj-39::obj-81": [ "Mod[2]", "Mod", 0 ],
            "obj-39::obj-82": [ "Gain[16]", "Gain", 0 ],
            "obj-39::obj-9": [ "Width[3]", "Width", 0 ],
            "obj-39::obj-99": [ "Active[18]", "Active", 0 ],
            "obj-40::obj-154": [ "Abl.Output[2]", "Abl.Output", 0 ],
            "obj-40::obj-17": [ "Dac[2]", "Dac", 0 ],
            "obj-40::obj-44": [ "Limiter[2]", "Limiter", 0 ],
            "obj-40::obj-49": [ "ModIn[2]", "ModIn", -1 ],
            "obj-40::obj-60": [ "ModOutLed[2]", "ModOutLed", 0 ],
            "obj-40::obj-69": [ "ModOut[2]", "ModOut", -1 ],
            "obj-40::obj-71": [ "ModInLed[2]", "ModInLed", 0 ],
            "obj-40::obj-8": [ "Gain[15]", "Gain", 0 ],
            "obj-40::obj-99": [ "Active[17]", "Active", 0 ],
            "obj-42::obj-112": [ "HighPass[2]", "HighPass", 0 ],
            "obj-42::obj-154": [ "Abl.ChannelEQ[2]", "Abl.ChannelEQ", 0 ],
            "obj-42::obj-167": [ "ModOutB[14]", "ModOutB", -1 ],
            "obj-42::obj-45": [ "ModInALed[14]", "ModInALed", 0 ],
            "obj-42::obj-47": [ "ModInBLed[14]", "ModInBLed", 0 ],
            "obj-42::obj-49": [ "ModInA[14]", "ModInA", -1 ],
            "obj-42::obj-50": [ "ModInB[14]", "ModInB", -1 ],
            "obj-42::obj-52": [ "ModOutA[14]", "ModOutA", -1 ],
            "obj-42::obj-59": [ "ModOutALed[14]", "ModOutALed", 0 ],
            "obj-42::obj-6": [ "Mid[5]", "Mid", 0 ],
            "obj-42::obj-60": [ "ModOutBLed[14]", "ModOutBLed", 0 ],
            "obj-42::obj-8": [ "MidF[2]", "MidF", 0 ],
            "obj-42::obj-81": [ "Low[2]", "Low", 0 ],
            "obj-42::obj-82": [ "Gain[14]", "Gain", 0 ],
            "obj-42::obj-9": [ "High[2]", "High", 0 ],
            "obj-42::obj-99": [ "Active[16]", "Active", 0 ],
            "obj-43::obj-154": [ "Abl.Compressor[2]", "Abl.Compressor", 0 ],
            "obj-43::obj-167": [ "ModOutB[13]", "ModOutB", -1 ],
            "obj-43::obj-45": [ "ModInALed[13]", "ModInALed", 0 ],
            "obj-43::obj-47": [ "ModInBLed[13]", "ModInBLed", 0 ],
            "obj-43::obj-49": [ "ModInA[13]", "ModInA", -1 ],
            "obj-43::obj-50": [ "ModInB[13]", "ModInB", -1 ],
            "obj-43::obj-52": [ "ModOutA[13]", "ModOutA", -1 ],
            "obj-43::obj-59": [ "ModOutALed[13]", "ModOutALed", 0 ],
            "obj-43::obj-6": [ "Rel[4]", "Rel", 0 ],
            "obj-43::obj-60": [ "ModOutBLed[13]", "ModOutBLed", 0 ],
            "obj-43::obj-8": [ "Thresh[2]", "Thresh", 0 ],
            "obj-43::obj-81": [ "Att[2]", "Att", 0 ],
            "obj-43::obj-82": [ "Gain[13]", "Gain", 0 ],
            "obj-43::obj-9": [ "Ratio[2]", "Ratio", 0 ],
            "obj-43::obj-99": [ "Active[15]", "Active", 0 ],
            "obj-44::obj-112": [ "Sub[2]", "Sub", 0 ],
            "obj-44::obj-116": [ "MidRange[2]", "MidRange", 0 ],
            "obj-44::obj-154": [ "Abl.Overdrive[2]", "Abl.Overdrive", 0 ],
            "obj-44::obj-167": [ "ModOutB[12]", "ModOutB", -1 ],
            "obj-44::obj-45": [ "ModInALed[12]", "ModInALed", 0 ],
            "obj-44::obj-47": [ "ModInBLed[12]", "ModInBLed", 0 ],
            "obj-44::obj-49": [ "ModInA[12]", "ModInA", -1 ],
            "obj-44::obj-50": [ "ModInB[12]", "ModInB", -1 ],
            "obj-44::obj-52": [ "ModOutA[12]", "ModOutA", -1 ],
            "obj-44::obj-59": [ "ModOutALed[12]", "ModOutALed", 0 ],
            "obj-44::obj-6": [ "Bass[2]", "Bass", 0 ],
            "obj-44::obj-60": [ "ModOutBLed[12]", "ModOutBLed", 0 ],
            "obj-44::obj-8": [ "Mid[4]", "Mid", 0 ],
            "obj-44::obj-81": [ "Gain[12]", "Gain", 0 ],
            "obj-44::obj-82": [ "Mix[6]", "Mix", 0 ],
            "obj-44::obj-9": [ "Treble[2]", "Treble", 0 ],
            "obj-44::obj-99": [ "Active[14]", "Active", 0 ],
            "obj-48::obj-154": [ "Abl.Compressor[1]", "Abl.Compressor", 0 ],
            "obj-48::obj-167": [ "ModOutB[7]", "ModOutB", -1 ],
            "obj-48::obj-45": [ "ModInALed[7]", "ModInALed", 0 ],
            "obj-48::obj-47": [ "ModInBLed[7]", "ModInBLed", 0 ],
            "obj-48::obj-49": [ "ModInA[7]", "ModInA", -1 ],
            "obj-48::obj-50": [ "ModInB[7]", "ModInB", -1 ],
            "obj-48::obj-52": [ "ModOutA[7]", "ModOutA", -1 ],
            "obj-48::obj-59": [ "ModOutALed[7]", "ModOutALed", 0 ],
            "obj-48::obj-6": [ "Rel[2]", "Rel", 0 ],
            "obj-48::obj-60": [ "ModOutBLed[7]", "ModOutBLed", 0 ],
            "obj-48::obj-8": [ "Thresh[1]", "Thresh", 0 ],
            "obj-48::obj-81": [ "Att[1]", "Att", 0 ],
            "obj-48::obj-82": [ "Gain[7]", "Gain", 0 ],
            "obj-48::obj-9": [ "Ratio[1]", "Ratio", 0 ],
            "obj-48::obj-99": [ "Active[8]", "Active", 0 ],
            "obj-58::obj-112": [ "Sub[1]", "Sub", 0 ],
            "obj-58::obj-116": [ "MidRange[1]", "MidRange", 0 ],
            "obj-58::obj-154": [ "Abl.Overdrive[1]", "Abl.Overdrive", 0 ],
            "obj-58::obj-167": [ "ModOutB[6]", "ModOutB", -1 ],
            "obj-58::obj-45": [ "ModInALed[6]", "ModInALed", 0 ],
            "obj-58::obj-47": [ "ModInBLed[6]", "ModInBLed", 0 ],
            "obj-58::obj-49": [ "ModInA[6]", "ModInA", -1 ],
            "obj-58::obj-50": [ "ModInB[6]", "ModInB", -1 ],
            "obj-58::obj-52": [ "ModOutA[6]", "ModOutA", -1 ],
            "obj-58::obj-59": [ "ModOutALed[6]", "ModOutALed", 0 ],
            "obj-58::obj-6": [ "Bass[1]", "Bass", 0 ],
            "obj-58::obj-60": [ "ModOutBLed[6]", "ModOutBLed", 0 ],
            "obj-58::obj-8": [ "Mid[2]", "Mid", 0 ],
            "obj-58::obj-81": [ "Gain[6]", "Gain", 0 ],
            "obj-58::obj-82": [ "Mix[3]", "Mix", 0 ],
            "obj-58::obj-9": [ "Treble[1]", "Treble", 0 ],
            "obj-58::obj-99": [ "Active[7]", "Active", 0 ],
            "obj-98::obj-112": [ "HighPass[1]", "HighPass", 0 ],
            "obj-98::obj-154": [ "Abl.ChannelEQ[1]", "Abl.ChannelEQ", 0 ],
            "obj-98::obj-167": [ "ModOutB[8]", "ModOutB", -1 ],
            "obj-98::obj-45": [ "ModInALed[8]", "ModInALed", 0 ],
            "obj-98::obj-47": [ "ModInBLed[8]", "ModInBLed", 0 ],
            "obj-98::obj-49": [ "ModInA[8]", "ModInA", -1 ],
            "obj-98::obj-50": [ "ModInB[8]", "ModInB", -1 ],
            "obj-98::obj-52": [ "ModOutA[8]", "ModOutA", -1 ],
            "obj-98::obj-59": [ "ModOutALed[8]", "ModOutALed", 0 ],
            "obj-98::obj-6": [ "Mid[3]", "Mid", 0 ],
            "obj-98::obj-60": [ "ModOutBLed[8]", "ModOutBLed", 0 ],
            "obj-98::obj-8": [ "MidF[1]", "MidF", 0 ],
            "obj-98::obj-81": [ "Low[1]", "Low", 0 ],
            "obj-98::obj-82": [ "Gain[8]", "Gain", 0 ],
            "obj-98::obj-9": [ "High[1]", "High", 0 ],
            "obj-98::obj-99": [ "Active[9]", "Active", 0 ],
            "parameter_overrides": {
                "obj-102::obj-45": {
                    "parameter_longname": "ModInALed[2]"
                },
                "obj-102::obj-47": {
                    "parameter_longname": "ModInBLed[2]"
                },
                "obj-102::obj-59": {
                    "parameter_longname": "ModOutALed[2]"
                },
                "obj-102::obj-6": {
                    "parameter_longname": "Mid[1]"
                },
                "obj-102::obj-60": {
                    "parameter_longname": "ModOutBLed[2]"
                },
                "obj-102::obj-82": {
                    "parameter_longname": "Gain[2]"
                },
                "obj-102::obj-99": {
                    "parameter_longname": "Active[2]"
                },
                "obj-103::obj-45": {
                    "parameter_longname": "ModInALed[1]"
                },
                "obj-103::obj-47": {
                    "parameter_longname": "ModInBLed[1]"
                },
                "obj-103::obj-59": {
                    "parameter_longname": "ModOutALed[1]"
                },
                "obj-103::obj-60": {
                    "parameter_longname": "ModOutBLed[1]"
                },
                "obj-103::obj-82": {
                    "parameter_longname": "Gain[1]"
                },
                "obj-103::obj-99": {
                    "parameter_longname": "Active[1]"
                },
                "obj-107::obj-45": {
                    "parameter_longname": "ModInALed[5]"
                },
                "obj-107::obj-47": {
                    "parameter_longname": "ModInBLed[5]"
                },
                "obj-107::obj-59": {
                    "parameter_longname": "ModOutALed[5]"
                },
                "obj-107::obj-6": {
                    "parameter_longname": "Gain[4]"
                },
                "obj-107::obj-60": {
                    "parameter_longname": "ModOutBLed[5]"
                },
                "obj-107::obj-9": {
                    "parameter_longname": "Rel[1]"
                },
                "obj-107::obj-99": {
                    "parameter_longname": "Active[5]"
                },
                "obj-108::obj-4": {
                    "parameter_longname": "Mix[2]"
                },
                "obj-108::obj-45": {
                    "parameter_longname": "ModInALed[4]"
                },
                "obj-108::obj-47": {
                    "parameter_longname": "ModInBLed[4]"
                },
                "obj-108::obj-59": {
                    "parameter_longname": "ModOutALed[4]"
                },
                "obj-108::obj-60": {
                    "parameter_longname": "ModOutBLed[4]"
                },
                "obj-108::obj-99": {
                    "parameter_longname": "Active[4]"
                },
                "obj-110::obj-154": {
                    "parameter_longname": "Abl.Output[1]"
                },
                "obj-110::obj-44": {
                    "parameter_longname": "Limiter[1]"
                },
                "obj-110::obj-60": {
                    "parameter_longname": "ModOutLed[1]"
                },
                "obj-110::obj-71": {
                    "parameter_longname": "ModInLed[1]"
                },
                "obj-110::obj-8": {
                    "parameter_longname": "Gain[9]"
                },
                "obj-110::obj-99": {
                    "parameter_longname": "Active[10]"
                },
                "obj-111::obj-112": {
                    "parameter_longname": "AutoRelease[1]"
                },
                "obj-111::obj-116": {
                    "parameter_longname": "Lookahead[1]"
                },
                "obj-111::obj-154": {
                    "parameter_longname": "Abl.Limiter[1]"
                },
                "obj-111::obj-45": {
                    "parameter_longname": "ModInALed[11]"
                },
                "obj-111::obj-47": {
                    "parameter_longname": "ModInBLed[11]"
                },
                "obj-111::obj-59": {
                    "parameter_longname": "ModOutALed[11]"
                },
                "obj-111::obj-6": {
                    "parameter_longname": "Gain[11]"
                },
                "obj-111::obj-60": {
                    "parameter_longname": "ModOutBLed[11]"
                },
                "obj-111::obj-8": {
                    "parameter_longname": "Ceil[1]"
                },
                "obj-111::obj-9": {
                    "parameter_longname": "Rel[3]"
                },
                "obj-111::obj-99": {
                    "parameter_longname": "Active[13]"
                },
                "obj-116::obj-45": {
                    "parameter_longname": "ModInALed[10]"
                },
                "obj-116::obj-47": {
                    "parameter_longname": "ModInBLed[10]"
                },
                "obj-116::obj-53": {
                    "parameter_longname": "Mix[5]"
                },
                "obj-116::obj-59": {
                    "parameter_longname": "ModOutALed[10]"
                },
                "obj-116::obj-60": {
                    "parameter_longname": "ModOutBLed[10]"
                },
                "obj-116::obj-8": {
                    "parameter_longname": "Feed[2]"
                },
                "obj-116::obj-82": {
                    "parameter_longname": "Width[2]"
                },
                "obj-116::obj-99": {
                    "parameter_longname": "Active[12]"
                },
                "obj-117::obj-112": {
                    "parameter_longname": "Invert[1]"
                },
                "obj-117::obj-154": {
                    "parameter_longname": "Abl.Chorus[1]"
                },
                "obj-117::obj-4": {
                    "parameter_longname": "Mix[4]"
                },
                "obj-117::obj-45": {
                    "parameter_longname": "ModInALed[9]"
                },
                "obj-117::obj-47": {
                    "parameter_longname": "ModInBLed[9]"
                },
                "obj-117::obj-59": {
                    "parameter_longname": "ModOutALed[9]"
                },
                "obj-117::obj-6": {
                    "parameter_longname": "Rate[1]"
                },
                "obj-117::obj-60": {
                    "parameter_longname": "ModOutBLed[9]"
                },
                "obj-117::obj-8": {
                    "parameter_longname": "Feed[1]"
                },
                "obj-117::obj-81": {
                    "parameter_longname": "Mod[1]"
                },
                "obj-117::obj-82": {
                    "parameter_longname": "Gain[10]"
                },
                "obj-117::obj-9": {
                    "parameter_longname": "Width[1]"
                },
                "obj-117::obj-99": {
                    "parameter_longname": "Active[11]"
                },
                "obj-118::obj-8": {
                    "parameter_longname": "Gain[5]"
                },
                "obj-118::obj-99": {
                    "parameter_longname": "Active[6]"
                },
                "obj-35::obj-4": {
                    "parameter_longname": "Mix[1]"
                },
                "obj-35::obj-45": {
                    "parameter_longname": "ModInALed[3]"
                },
                "obj-35::obj-47": {
                    "parameter_longname": "ModInBLed[3]"
                },
                "obj-35::obj-59": {
                    "parameter_longname": "ModOutALed[3]"
                },
                "obj-35::obj-60": {
                    "parameter_longname": "ModOutBLed[3]"
                },
                "obj-35::obj-82": {
                    "parameter_longname": "Gain[3]"
                },
                "obj-35::obj-99": {
                    "parameter_longname": "Active[3]"
                },
                "obj-36::obj-112": {
                    "parameter_longname": "AutoRelease[2]"
                },
                "obj-36::obj-116": {
                    "parameter_longname": "Lookahead[2]"
                },
                "obj-36::obj-154": {
                    "parameter_longname": "Abl.Limiter[2]"
                },
                "obj-36::obj-45": {
                    "parameter_longname": "ModInALed[17]"
                },
                "obj-36::obj-47": {
                    "parameter_longname": "ModInBLed[17]"
                },
                "obj-36::obj-59": {
                    "parameter_longname": "ModOutALed[17]"
                },
                "obj-36::obj-6": {
                    "parameter_longname": "Gain[17]"
                },
                "obj-36::obj-60": {
                    "parameter_longname": "ModOutBLed[17]"
                },
                "obj-36::obj-8": {
                    "parameter_longname": "Ceil[2]"
                },
                "obj-36::obj-9": {
                    "parameter_longname": "Rel[5]"
                },
                "obj-36::obj-99": {
                    "parameter_longname": "Active[20]"
                },
                "obj-37::obj-112": {
                    "parameter_longname": "Filter[1]"
                },
                "obj-37::obj-116": {
                    "parameter_longname": "Smooth[1]"
                },
                "obj-37::obj-154": {
                    "parameter_longname": "Abl.Delay[1]"
                },
                "obj-37::obj-19": {
                    "parameter_longname": "Freeze[1]"
                },
                "obj-37::obj-23": {
                    "parameter_longname": "PingPong[1]"
                },
                "obj-37::obj-44": {
                    "parameter_longname": "Eco[1]"
                },
                "obj-37::obj-45": {
                    "parameter_longname": "ModInALed[16]"
                },
                "obj-37::obj-47": {
                    "parameter_longname": "ModInBLed[16]"
                },
                "obj-37::obj-51": {
                    "parameter_longname": "MFreq[1]"
                },
                "obj-37::obj-53": {
                    "parameter_longname": "Mix[8]"
                },
                "obj-37::obj-54": {
                    "parameter_longname": "MFilt[1]"
                },
                "obj-37::obj-55": {
                    "parameter_longname": "MTime[1]"
                },
                "obj-37::obj-58": {
                    "parameter_longname": "Link[1]"
                },
                "obj-37::obj-59": {
                    "parameter_longname": "ModOutALed[16]"
                },
                "obj-37::obj-6": {
                    "parameter_longname": "DelR[1]"
                },
                "obj-37::obj-60": {
                    "parameter_longname": "ModOutBLed[16]"
                },
                "obj-37::obj-8": {
                    "parameter_longname": "Feed[4]"
                },
                "obj-37::obj-81": {
                    "parameter_longname": "DelL[1]"
                },
                "obj-37::obj-82": {
                    "parameter_longname": "Width[4]"
                },
                "obj-37::obj-9": {
                    "parameter_longname": "Freq[1]"
                },
                "obj-37::obj-99": {
                    "parameter_longname": "Active[19]"
                },
                "obj-39::obj-112": {
                    "parameter_longname": "Invert[2]"
                },
                "obj-39::obj-154": {
                    "parameter_longname": "Abl.Chorus[2]"
                },
                "obj-39::obj-4": {
                    "parameter_longname": "Mix[7]"
                },
                "obj-39::obj-45": {
                    "parameter_longname": "ModInALed[15]"
                },
                "obj-39::obj-47": {
                    "parameter_longname": "ModInBLed[15]"
                },
                "obj-39::obj-59": {
                    "parameter_longname": "ModOutALed[15]"
                },
                "obj-39::obj-6": {
                    "parameter_longname": "Rate[2]"
                },
                "obj-39::obj-60": {
                    "parameter_longname": "ModOutBLed[15]"
                },
                "obj-39::obj-8": {
                    "parameter_longname": "Feed[3]"
                },
                "obj-39::obj-81": {
                    "parameter_longname": "Mod[2]"
                },
                "obj-39::obj-82": {
                    "parameter_longname": "Gain[16]"
                },
                "obj-39::obj-9": {
                    "parameter_longname": "Width[3]"
                },
                "obj-39::obj-99": {
                    "parameter_longname": "Active[18]"
                },
                "obj-40::obj-154": {
                    "parameter_longname": "Abl.Output[2]"
                },
                "obj-40::obj-44": {
                    "parameter_longname": "Limiter[2]"
                },
                "obj-40::obj-60": {
                    "parameter_longname": "ModOutLed[2]"
                },
                "obj-40::obj-71": {
                    "parameter_longname": "ModInLed[2]"
                },
                "obj-40::obj-8": {
                    "parameter_longname": "Gain[15]"
                },
                "obj-40::obj-99": {
                    "parameter_longname": "Active[17]"
                },
                "obj-42::obj-112": {
                    "parameter_longname": "HighPass[2]"
                },
                "obj-42::obj-154": {
                    "parameter_longname": "Abl.ChannelEQ[2]"
                },
                "obj-42::obj-45": {
                    "parameter_longname": "ModInALed[14]"
                },
                "obj-42::obj-47": {
                    "parameter_longname": "ModInBLed[14]"
                },
                "obj-42::obj-59": {
                    "parameter_longname": "ModOutALed[14]"
                },
                "obj-42::obj-6": {
                    "parameter_longname": "Mid[5]"
                },
                "obj-42::obj-60": {
                    "parameter_longname": "ModOutBLed[14]"
                },
                "obj-42::obj-8": {
                    "parameter_longname": "MidF[2]"
                },
                "obj-42::obj-81": {
                    "parameter_longname": "Low[2]"
                },
                "obj-42::obj-82": {
                    "parameter_longname": "Gain[14]"
                },
                "obj-42::obj-9": {
                    "parameter_longname": "High[2]"
                },
                "obj-42::obj-99": {
                    "parameter_longname": "Active[16]"
                },
                "obj-43::obj-154": {
                    "parameter_longname": "Abl.Compressor[2]"
                },
                "obj-43::obj-45": {
                    "parameter_longname": "ModInALed[13]"
                },
                "obj-43::obj-47": {
                    "parameter_longname": "ModInBLed[13]"
                },
                "obj-43::obj-59": {
                    "parameter_longname": "ModOutALed[13]"
                },
                "obj-43::obj-6": {
                    "parameter_longname": "Rel[4]"
                },
                "obj-43::obj-60": {
                    "parameter_longname": "ModOutBLed[13]"
                },
                "obj-43::obj-8": {
                    "parameter_longname": "Thresh[2]"
                },
                "obj-43::obj-81": {
                    "parameter_longname": "Att[2]"
                },
                "obj-43::obj-82": {
                    "parameter_longname": "Gain[13]"
                },
                "obj-43::obj-9": {
                    "parameter_longname": "Ratio[2]"
                },
                "obj-43::obj-99": {
                    "parameter_longname": "Active[15]"
                },
                "obj-44::obj-112": {
                    "parameter_longname": "Sub[2]"
                },
                "obj-44::obj-116": {
                    "parameter_longname": "MidRange[2]"
                },
                "obj-44::obj-154": {
                    "parameter_longname": "Abl.Overdrive[2]"
                },
                "obj-44::obj-45": {
                    "parameter_longname": "ModInALed[12]"
                },
                "obj-44::obj-47": {
                    "parameter_longname": "ModInBLed[12]"
                },
                "obj-44::obj-59": {
                    "parameter_longname": "ModOutALed[12]"
                },
                "obj-44::obj-6": {
                    "parameter_longname": "Bass[2]"
                },
                "obj-44::obj-60": {
                    "parameter_longname": "ModOutBLed[12]"
                },
                "obj-44::obj-8": {
                    "parameter_longname": "Mid[4]"
                },
                "obj-44::obj-81": {
                    "parameter_longname": "Gain[12]"
                },
                "obj-44::obj-82": {
                    "parameter_longname": "Mix[6]"
                },
                "obj-44::obj-9": {
                    "parameter_longname": "Treble[2]"
                },
                "obj-44::obj-99": {
                    "parameter_longname": "Active[14]"
                },
                "obj-48::obj-154": {
                    "parameter_longname": "Abl.Compressor[1]"
                },
                "obj-48::obj-45": {
                    "parameter_longname": "ModInALed[7]"
                },
                "obj-48::obj-47": {
                    "parameter_longname": "ModInBLed[7]"
                },
                "obj-48::obj-59": {
                    "parameter_longname": "ModOutALed[7]"
                },
                "obj-48::obj-6": {
                    "parameter_longname": "Rel[2]"
                },
                "obj-48::obj-60": {
                    "parameter_longname": "ModOutBLed[7]"
                },
                "obj-48::obj-8": {
                    "parameter_longname": "Thresh[1]"
                },
                "obj-48::obj-81": {
                    "parameter_longname": "Att[1]"
                },
                "obj-48::obj-82": {
                    "parameter_longname": "Gain[7]"
                },
                "obj-48::obj-9": {
                    "parameter_longname": "Ratio[1]"
                },
                "obj-48::obj-99": {
                    "parameter_longname": "Active[8]"
                },
                "obj-58::obj-112": {
                    "parameter_longname": "Sub[1]"
                },
                "obj-58::obj-116": {
                    "parameter_longname": "MidRange[1]"
                },
                "obj-58::obj-154": {
                    "parameter_longname": "Abl.Overdrive[1]"
                },
                "obj-58::obj-45": {
                    "parameter_longname": "ModInALed[6]"
                },
                "obj-58::obj-47": {
                    "parameter_longname": "ModInBLed[6]"
                },
                "obj-58::obj-59": {
                    "parameter_longname": "ModOutALed[6]"
                },
                "obj-58::obj-6": {
                    "parameter_longname": "Bass[1]"
                },
                "obj-58::obj-60": {
                    "parameter_longname": "ModOutBLed[6]"
                },
                "obj-58::obj-8": {
                    "parameter_longname": "Mid[2]"
                },
                "obj-58::obj-81": {
                    "parameter_longname": "Gain[6]"
                },
                "obj-58::obj-82": {
                    "parameter_longname": "Mix[3]"
                },
                "obj-58::obj-9": {
                    "parameter_longname": "Treble[1]"
                },
                "obj-58::obj-99": {
                    "parameter_longname": "Active[7]"
                },
                "obj-98::obj-112": {
                    "parameter_longname": "HighPass[1]"
                },
                "obj-98::obj-154": {
                    "parameter_longname": "Abl.ChannelEQ[1]"
                },
                "obj-98::obj-45": {
                    "parameter_longname": "ModInALed[8]"
                },
                "obj-98::obj-47": {
                    "parameter_longname": "ModInBLed[8]"
                },
                "obj-98::obj-59": {
                    "parameter_longname": "ModOutALed[8]"
                },
                "obj-98::obj-6": {
                    "parameter_longname": "Mid[3]"
                },
                "obj-98::obj-60": {
                    "parameter_longname": "ModOutBLed[8]"
                },
                "obj-98::obj-8": {
                    "parameter_longname": "MidF[1]"
                },
                "obj-98::obj-81": {
                    "parameter_longname": "Low[1]"
                },
                "obj-98::obj-82": {
                    "parameter_longname": "Gain[8]"
                },
                "obj-98::obj-9": {
                    "parameter_longname": "High[1]"
                },
                "obj-98::obj-99": {
                    "parameter_longname": "Active[9]"
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0,
        "boxgroups": [
            {
                "boxes": [ "obj-118", "obj-107", "obj-108", "obj-102", "obj-104", "obj-35", "obj-103" ]
            },
            {
                "boxes": [ "obj-48", "obj-58", "obj-98", "obj-116", "obj-117", "obj-111", "obj-110" ]
            },
            {
                "boxes": [ "obj-43", "obj-39", "obj-44", "obj-37", "obj-42", "obj-36", "obj-40" ]
            }
        ],
        "toolbaradditions": [ "packagemanager" ],
        "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ]
    }
}