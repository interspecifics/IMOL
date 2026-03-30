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
        "rect": [ 1337.0, -937.0, 330.0, 902.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 926.0, 18.0, 82.0, 22.0 ],
                    "text": "setnorepeat 1"
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 874.0, 18.0, 43.0, 22.0 ],
                    "text": "sweep"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "linecount": 4,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 24.5, 313.0, 224.0, 62.0 ],
                    "presentation": 1,
                    "presentation_linecount": 6,
                    "presentation_rect": [ 7.0, 637.0, 169.0, 89.0 ],
                    "text": "file tan_acoustic-mordor-malaga.txt startPartial 135124 partialsCount 157814 bankSize 83 event autobank_skip"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 187.5, 276.0, 49.0, 22.0 ],
                    "text": "route ui"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 412.0, 22.0, 57.0, 22.0 ],
                    "text": "nextbank"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 577.5, 33.5, 171.0, 22.0 ],
                    "text": "setautonextmode window_end"
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 577.5, 8.5, 81.0, 22.0 ],
                    "text": "setautonext 1"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 798.0, 196.0, 74.0, 22.0 ],
                    "text": "print jit_note"
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "linecount": 4,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 248.4943903684616, 2.0, 142.01121926307678, 62.0 ],
                    "presentation": 1,
                    "presentation_linecount": 4,
                    "presentation_rect": [ 7.0, 74.0, 170.0, 62.0 ],
                    "text": "autoplay /Users/microhm/Desktop/01_Proyectos/IMOL/max_resynth .txt"
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
                    "patching_rect": [ 48.0, 183.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 48.0, 235.0, 192.0, 22.0 ],
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
                    "patching_rect": [ 1014.0, 1101.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 1014.0, 969.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 1014.0, 831.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 1014.0, 1202.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 7.0, 543.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 820.0, 1020.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 820.0, 829.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 820.0, 922.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 616.0, 1101.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 616.0, 969.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 616.0, 829.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 616.0, 1202.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 7.0, 447.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 423.0, 1020.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 423.0, 828.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 423.0, 922.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 217.0, 1164.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 7.0, 351.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 217.0, 1063.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 217.0, 969.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 217.0, 829.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 23.0, 1027.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 23.0, 836.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 23.0, 932.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 721.0, 99.0, 42.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 6.0, 180.0, 76.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 721.0, 71.0, 54.0, 22.0 ],
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
                    "patching_rect": [ 721.0, 47.0, 110.0, 22.0 ],
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
                    "patching_rect": [ 721.0, 22.0, 97.0, 22.0 ],
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
                    "patching_rect": [ 721.0, 137.0, 133.0, 22.0 ],
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
                    "patching_rect": [ 354.0, 137.0, 39.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 110.0, 155.0, 60.0, 22.0 ],
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
                    "patching_rect": [ 301.0, 137.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 119.0, 141.0, 35.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 7.0, 155.0, 35.0, 22.0 ],
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
                    "patching_rect": [ 115.0, 102.0, 53.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 47.0, 155.0, 53.0, 22.0 ],
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
                    "patching_rect": [ 65.5, 8.5, 172.0, 49.0 ],
                    "presentation": 1,
                    "presentation_linecount": 3,
                    "presentation_rect": [ 8.0, 17.0, 168.0, 49.0 ],
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
                    "patching_rect": [ 290.0, 102.0, 145.0, 22.0 ],
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
                    "patching_rect": [ 656.0, 772.0, 164.0, 22.0 ],
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
                    "patching_rect": [ 476.0, 772.0, 164.0, 22.0 ],
                    "text": "mc.mixdown~ 2 @autogain 0"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 345.0, 329.0, 36.0, 20.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 450.0, 330.0, 36.0, 20.0 ],
                    "text": "freq"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 546.0, 330.0, 36.0, 20.0 ],
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
                    "patching_rect": [ 538.0, 711.0, 71.0, 22.0 ],
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
                    "patching_rect": [ 478.0, 89.0, 135.0, 33.0 ],
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
                    "patching_rect": [ 501.0, 640.0, 29.5, 22.0 ],
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
                    "patching_rect": [ 459.0, 89.0, 18.0, 34.0 ],
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
                    "patching_rect": [ 501.0, 664.0, 97.0, 22.0 ],
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
                    "patching_rect": [ 803.0, 520.0, 162.0, 22.0 ],
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
                    "patching_rect": [ 803.0, 491.0, 114.0, 22.0 ],
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
                    "patching_rect": [ 803.0, 259.0, 87.0, 22.0 ],
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
                    "patching_rect": [ 831.0, 416.0, 311.00002455711365, 62.0 ],
                    "presentation": 1,
                    "presentation_linecount": 6,
                    "presentation_rect": [ 7.0, 724.0, 205.0, 89.0 ],
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
                    "patching_rect": [ 803.0, 296.0, 41.0, 22.0 ],
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
                    "patching_rect": [ 1089.0, 71.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 89.0, 210.0, 101.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-230",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1089.0, 113.0, 87.0, 22.0 ],
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
                    "patching_rect": [ 961.0, 76.0, 76.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 6.0, 210.0, 76.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-226",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 961.0, 113.0, 114.0, 22.0 ],
                    "text": "offset $1 0. 0., bang"
                }
            },
            {
                "box": {
                    "id": "obj-224",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1052.0, 213.0, 87.0, 20.0 ],
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
                    "patching_rect": [ 903.0, 255.0, 232.0, 121.59257709980011 ],
                    "presentation": 1,
                    "presentation_rect": [ -10.0, 240.0, 193.0, 94.0 ],
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
                    "patching_rect": [ 903.0, 89.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-219",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "jit_matrix", "" ],
                    "patching_rect": [ 903.0, 204.0, 119.0, 22.0 ],
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
                    "patching_rect": [ 903.0, 156.0, 243.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 646.0, 110.0, 22.0 ],
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
                    "patching_rect": [ 325.0, 199.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-209",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "setvalue", "int" ],
                    "patching_rect": [ 540.0, 522.0, 59.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 527.0, 59.0, 22.0 ],
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
                    "patching_rect": [ 287.0, 772.0, 164.0, 22.0 ],
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
                    "patching_rect": [ 540.0, 498.0, 181.0, 22.0 ],
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
                    "patching_rect": [ 3410.0, 3518.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-199",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 540.0, 475.0, 156.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 498.0, 156.0, 22.0 ],
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
                    "patching_rect": [ 540.0, 446.0, 103.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 465.0, 103.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 227.0, 333.56401085853577, 22.0 ],
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
                    "patching_rect": [ 290.0, 359.0, 47.0, 22.0 ],
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
                    "patching_rect": [ 301.0, 421.0, 64.03785294294357, 22.0 ],
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
                    "patching_rect": [ 290.0, 387.0, 29.5, 22.0 ],
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
                    "patching_rect": [ 501.0, 327.0, 50.0, 22.0 ]
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
                    "patching_rect": [ 394.0, 329.0, 50.0, 22.0 ]
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
                    "patching_rect": [ 290.0, 328.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "float", "float", "float" ],
                    "patching_rect": [ 290.0, 296.0, 227.51425296068192, 22.0 ],
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
                    "patching_rect": [ 290.0, 263.0, 166.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 607.0, 103.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 583.0, 45.0, 22.0 ],
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
                    "patching_rect": [ 540.0, 547.0, 218.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 553.0, 218.0, 22.0 ],
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
                    "patching_rect": [ 290.0, 170.0, 124.0, 22.0 ],
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
                    "midpoints": [ 510.5, 689.8536541461945, 498.1219344139099, 689.8536541461945, 498.1219344139099, 629.8536541461945, 519.1219344139099, 629.8536541461945, 519.1219344139099, 602.8536541461945, 383.5, 602.8536541461945 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "midpoints": [ 32.5, 1113.6462352275848, 6.348527451349156, 1113.6462352275848, 6.348527451349156, 822.6462352275848, 226.5, 822.6462352275848 ],
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
                    "midpoints": [ 75.0, 95.85365414619446, 299.5, 95.85365414619446 ],
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
                    "midpoints": [ 124.5, 125.85365414619446, 276.1219344139099, 125.85365414619446, 276.1219344139099, 98.85365414619446, 299.5, 98.85365414619446 ],
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
                    "midpoints": [ 403.5, 460.353679060936, 299.5, 460.353679060936 ],
                    "source": [ "obj-180", 0 ]
                }
            },
            {
                "patchline": {
                    "color": [ 0.461506187915802, 0.0, 0.308563560247421, 1.0 ],
                    "destination": [ "obj-193", 0 ],
                    "midpoints": [ 510.5, 495.873210310936, 549.5, 495.873210310936 ],
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
                    "midpoints": [ 299.5, 451.353679060936, 355.5378529429436, 451.353679060936 ],
                    "source": [ "obj-183", 0 ]
                }
            },
            {
                "patchline": {
                    "color": [ 0.0, 0.336027532815933, 0.426819026470184, 1.0 ],
                    "destination": [ "obj-190", 1 ],
                    "midpoints": [ 310.5, 446.85365414619446, 383.5, 446.85365414619446 ],
                    "order": 1,
                    "source": [ "obj-184", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-193", 1 ],
                    "midpoints": [ 310.5, 446.85365414619446, 525.1219344139099, 446.85365414619446, 525.1219344139099, 431.85365414619446, 633.5, 431.85365414619446 ],
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
                    "midpoints": [ 614.0640108585358, 407.85365414619446, 355.5378529429436, 407.85365414619446 ],
                    "source": [ "obj-188", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 299.5, 251.85365414619446, 276.1219344139099, 251.85365414619446, 276.1219344139099, 494.85365414619446, 299.5, 494.85365414619446 ],
                    "order": 1,
                    "source": [ "obj-188", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-199", 0 ],
                    "midpoints": [ 299.5, 251.85365414619446, 276.1219344139099, 251.85365414619446, 276.1219344139099, 383.85365414619446, 330.1219344139099, 383.85365414619446, 330.1219344139099, 404.85365414619446, 525.1219344139099, 404.85365414619446, 525.1219344139099, 470.85365414619446, 549.5, 470.85365414619446 ],
                    "order": 0,
                    "source": [ "obj-188", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "midpoints": [ 485.5, 814.8649852275848, 432.5, 814.8649852275848 ],
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
                    "midpoints": [ 468.5, 212.85365414619446, 633.1219344139099, 212.85365414619446, 633.1219344139099, 431.85365414619446, 519.1219344139099, 431.85365414619446, 519.1219344139099, 635.8536541461945, 510.5, 635.8536541461945 ],
                    "order": 1,
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 468.5, 202.40296149719507, 789.0249569416046, 202.40296149719507, 789.0249569416046, 833.2971382141113, 547.5, 833.2971382141113 ],
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
                    "midpoints": [ 296.5, 814.8649852275848, 91.47032260894775, 814.8649852275848, 91.47032260894775, 832.8649852275848, 32.5, 832.8649852275848 ],
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
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-21", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-208", 1 ],
                    "midpoints": [ 334.5, 224.85365414619446, 276.1219344139099, 224.85365414619446, 276.1219344139099, 524.8536541461945, 339.5, 524.8536541461945 ],
                    "order": 1,
                    "source": [ "obj-211", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-209", 1 ],
                    "midpoints": [ 334.5, 224.85365414619446, 276.1219344139099, 224.85365414619446, 276.1219344139099, 383.85365414619446, 330.1219344139099, 383.85365414619446, 330.1219344139099, 404.85365414619446, 732.1219344139099, 404.85365414619446, 732.1219344139099, 530.8536541461945, 600.1219344139099, 530.8536541461945, 600.1219344139099, 521.8536541461945, 589.5, 521.8536541461945 ],
                    "order": 0,
                    "source": [ "obj-211", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "midpoints": [ 345.0, 902.8536541461945, 485.5, 902.8536541461945 ],
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
                    "midpoints": [ 390.5, 902.8536541461945, 665.5, 902.8536541461945 ],
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
                    "destination": [ "obj-4", 0 ],
                    "source": [ "obj-22", 1 ]
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
                    "destination": [ "obj-8", 0 ],
                    "source": [ "obj-23", 0 ]
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
                    "midpoints": [ 812.5, 361.5370975616388, 1132.5000245571136, 361.5370975616388 ],
                    "order": 0,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-237", 0 ],
                    "midpoints": [ 812.5, 671.6869835853577, 812.5, 671.6869835853577 ],
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
                    "midpoints": [ 812.5, 650.8536541461945, 588.5, 650.8536541461945 ],
                    "source": [ "obj-238", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-43", 0 ],
                    "midpoints": [ 665.5, 814.8649852275848, 829.5, 814.8649852275848 ],
                    "source": [ "obj-24", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 128.5, 173.85365414619446, 276.1219344139099, 173.85365414619446, 276.1219344139099, 98.85365414619446, 299.5, 98.85365414619446 ],
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
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
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-32", 0 ]
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
                    "destination": [ "obj-18", 1 ],
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-39", 0 ],
                    "midpoints": [ 829.5, 1116.8649852275848, 985.2481976350157, 1116.8649852275848, 985.2481976350157, 816.8649852275848, 1023.5, 816.8649852275848 ],
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
                    "midpoints": [ 425.5, 155.85365414619446, 165.1219344139099, 155.85365414619446, 165.1219344139099, 221.85365414619446, 93.12193441390991, 221.85365414619446, 93.12193441390991, 230.85365414619446, 57.5, 230.85365414619446 ],
                    "order": 1,
                    "source": [ "obj-6", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 1 ],
                    "midpoints": [ 425.5, 135.0, 708.0, 135.0, 708.0, 123.0, 844.5, 123.0 ],
                    "order": 0,
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
                    "destination": [ "obj-10", 0 ],
                    "midpoints": [ 844.5, 171.0, 624.0, 171.0, 624.0, 66.0, 480.0, 66.0, 480.0, 9.0, 421.5, 9.0 ],
                    "source": [ "obj-8", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-228", 0 ],
                    "midpoints": [ 730.5, 184.25516624609008, 888.1219344139099, 184.25516624609008, 888.1219344139099, 71.85365414619446, 970.5, 71.85365414619446 ],
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-232", 0 ],
                    "midpoints": [ 787.5, 168.8935077157803, 878.6679308498278, 168.8935077157803, 878.6679308498278, 62.85365414619446, 1074.12193441391, 62.85365414619446, 1074.12193441391, 68.85365414619446, 1098.5, 68.85365414619446 ],
                    "source": [ "obj-8", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-9", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 0 ],
                    "midpoints": [ 432.5, 1116.3024852275848, 588.1267477019001, 1116.3024852275848, 588.1267477019001, 816.3024852275848, 625.5, 816.3024852275848 ],
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
        "toolbaradditions": [ "packagemanager" ],
        "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ]
    }
}