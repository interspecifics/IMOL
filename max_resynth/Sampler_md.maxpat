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
        "rect": [ 429.0, -937.0, 425.0, 903.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 989.8461593985558, 965.0, 29.5, 22.0 ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-149",
                    "maxclass": "gswitch",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1027.8461593985558, 960.0, 41.0, 32.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-141",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 997.8461593985558, 924.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 997.8461593985558, 895.0, 32.0, 22.0 ],
                    "text": "r st2"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-132",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1027.8461593985558, 1004.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1465.56, 180.16, 100.0, 22.0 ]
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-136",
                    "inputrangemode": 1,
                    "knobcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1354.7692412436008, 742.0, 20.0, 140.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 368.0, 327.0, 39.0, 82.0 ],
                    "size": 1.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-135",
                    "inputrangemode": 1,
                    "knobcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1321.461543649435, 742.0, 20.0, 140.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 327.0, 327.0, 39.0, 82.0 ],
                    "size": 1.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-134",
                    "inputrangemode": 1,
                    "knobcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1288.9480085670948, 742.0, 20.0, 140.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 287.0, 327.0, 39.0, 82.0 ],
                    "size": 1.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-114",
                    "inputrangemode": 1,
                    "knobcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1252.461543649435, 742.0, 20.0, 140.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 247.0, 327.0, 39.0, 82.0 ],
                    "size": 1.0
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-44",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1159.153854638338, 801.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 368.0, 418.0, 43.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1159.153854638338, 832.0, 56.0, 22.0 ],
                    "text": "Width $1"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-106",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 470.26682886481285, 113.33333218097687, 75.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 238.0, 224.0, 62.0, 20.0 ],
                    "text": "envelop",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-105",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 455.26682886481285, 98.33333218097687, 75.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 223.0, 77.0, 20.0 ],
                    "text": "sample",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-85",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 500.26682886481285, 143.33333218097687, 75.0, 33.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 31.0, 919.0, 147.0, 20.0 ],
                    "text": "osc controller",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-84",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 485.26682886481285, 128.33333218097687, 75.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 31.0, 818.0, 147.0, 20.0 ],
                    "text": "presets",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 35.99999988079071, 77.66666853427887, 68.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 53.0, 69.0, 68.0, 20.0 ],
                    "text": "Selec files",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-128",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1097.0, 801.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 327.0, 418.0, 39.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-129",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1097.0, 829.0, 56.0, 22.0 ],
                    "text": "Width $1"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-123",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1037.0, 801.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 288.5, 418.0, 36.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-124",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1037.0, 832.0, 53.0, 22.0 ],
                    "text": "Feed $1"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-125",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 973.0, 801.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 246.0, 418.0, 40.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 973.0, 832.0, 49.0, 22.0 ],
                    "text": "Mod $1"
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1354.7692412436008, 712.0, 29.0, 22.0 ],
                    "text": "r b7"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1317.7692412436008, 712.0, 29.0, 22.0 ],
                    "text": "r b4"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1280.7692412436008, 712.0, 29.0, 22.0 ],
                    "text": "r b3"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1244.7692412436008, 712.0, 29.0, 22.0 ],
                    "text": "r b2"
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
                    "patching_rect": [ 571.9999998807907, 1100.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 571.9999998807907, 967.0, 169.0, 124.0 ],
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
                    "patching_rect": [ 571.9999998807907, 829.0, 169.0, 124.0 ],
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
                    "id": "obj-118",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Output~.maxpat",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "" ],
                    "patching_rect": [ 761.8461593985558, 834.0, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 227.0, 723.0, 191.0, 84.0 ],
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
                    "patching_rect": [ 393.0, 1062.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 393.0, 967.0, 169.0, 84.0 ],
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
                    "id": "obj-7",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Chorus~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 393.0, 829.0, 169.0, 124.0 ],
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
                    "id": "obj-110",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.Output~.maxpat",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "" ],
                    "patching_rect": [ 761.8461593985558, 940.000028014183, 169.0, 84.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 32.0, 723.0, 191.0, 84.0 ],
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
                    "id": "obj-102",
                    "lockeddragscroll": 0,
                    "lockedsize": 0,
                    "maxclass": "bpatcher",
                    "name": "Abl.ChannelEQ~.maxpat",
                    "numinlets": 4,
                    "numoutlets": 4,
                    "offset": [ 0.0, 0.0 ],
                    "outlettype": [ "multichannelsignal", "signal", "signal", "" ],
                    "patching_rect": [ 33.0, 1020.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 33.0, 829.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 33.0, 925.0, 169.0, 84.0 ],
                    "varname": "Abl.Overdrive~[1]",
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
                    "patching_rect": [ 211.4999998807907, 1020.0, 169.0, 84.0 ],
                    "varname": "Abl.ChannelEQ~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 717.0, 705.0, 92.0, 22.0 ],
                    "text": "mc.mixdown~ 2"
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 816.3461601436138, 706.0, 92.0, 22.0 ],
                    "text": "mc.mixdown~ 2"
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
                    "patching_rect": [ 211.4999998807907, 829.0, 169.0, 84.0 ],
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
                    "patching_rect": [ 211.4999998807907, 921.0, 169.0, 84.0 ],
                    "varname": "Abl.Overdrive~",
                    "viewvisibility": 1
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 417.0, 40.0, 40.0, 22.0 ],
                    "text": "* 100."
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 417.0, 16.0, 29.0, 22.0 ],
                    "text": "r e5"
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 339.0, 48.0, 47.0, 22.0 ],
                    "text": "* 1005."
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 339.0, 24.0, 29.0, 22.0 ],
                    "text": "r e4"
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 286.26682886481285, 48.0, 47.0, 22.0 ],
                    "text": "* 1000."
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 286.26682886481285, 24.0, 29.0, 22.0 ],
                    "text": "r e3"
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 195.26682886481285, 55.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 194.26682886481285, 32.33333218097687, 53.0, 22.0 ],
                    "text": "* 10000."
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 311.0, 292.0, 31.0, 22.0 ],
                    "text": "s e2"
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 228.9999998807907, 279.83333218097687, 31.0, 22.0 ],
                    "text": "s e2"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 194.26682886481285, 8.333332180976868, 29.0, 22.0 ],
                    "text": "r e2"
                }
            },
            {
                "box": {
                    "id": "obj-29",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 253.66666221618652, 405.0, 29.0, 22.0 ],
                    "text": "r c4"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 181.66666221618652, 405.0, 29.0, 22.0 ],
                    "text": "r c3"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 325.6666622161865, 399.5000002384186, 29.0, 22.0 ],
                    "text": "r c5"
                }
            },
            {
                "box": {
                    "id": "obj-212",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 0,
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
                        "rect": [ 739.0, 224.0, 907.0, 1071.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 777.0, 547.0, 34.0, 22.0 ],
                                    "text": "s st2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 777.0, 485.0, 54.0, 22.0 ],
                                    "text": "unpack f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 777.0, 457.0, 118.0, 22.0 ],
                                    "text": "route /system/stateB"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-54",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 534.0, 547.0, 34.0, 22.0 ],
                                    "text": "s st1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 534.0, 485.0, 54.0, 22.0 ],
                                    "text": "unpack f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 534.0, 457.0, 110.0, 22.0 ],
                                    "text": "route /system/state"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1128.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1093.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1060.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1027.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 994.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 961.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 928.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-127",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 895.0, 176.0, 31.0, 22.0 ],
                                    "text": "s e1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-132",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "int", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 941.0, 136.0, 100.0, 22.0 ],
                                    "text": "unpack i f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 740.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-87",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 709.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-88",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 676.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-89",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 643.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-90",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 610.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-91",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 577.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-92",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 544.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 511.0, 183.0, 31.0, 22.0 ],
                                    "text": "s c1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-98",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "int", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 545.0, 141.0, 100.0, 22.0 ],
                                    "text": "unpack i f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 303.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 272.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 239.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 206.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 173.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 140.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 107.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 74.0, 588.0, 31.0, 22.0 ],
                                    "text": "s b1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "int", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 128.0, 543.0, 100.0, 22.0 ],
                                    "text": "unpack i f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 288.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 257.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 224.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 191.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 158.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 125.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 92.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 59.0, 197.0, 31.0, 22.0 ],
                                    "text": "s a1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "int", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 131.0, 141.0, 100.0, 22.0 ],
                                    "text": "unpack i f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 941.0, 106.0, 80.0, 22.0 ],
                                    "text": "route /track/E"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-209",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 545.0, 111.0, 81.0, 22.0 ],
                                    "text": "route /track/C"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-208",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 129.0, 508.0, 80.0, 22.0 ],
                                    "text": "route /track/B"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-313",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 131.0, 110.0, 80.0, 22.0 ],
                                    "text": "route /track/A"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-205",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 421.0, 17.0, 97.0, 22.0 ],
                                    "text": "udpreceive 9001"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-132", 0 ],
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 0 ],
                                    "source": [ "obj-132", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-121", 0 ],
                                    "source": [ "obj-132", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-122", 0 ],
                                    "source": [ "obj-132", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-123", 0 ],
                                    "source": [ "obj-132", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-124", 0 ],
                                    "source": [ "obj-132", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-125", 0 ],
                                    "source": [ "obj-132", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-126", 0 ],
                                    "source": [ "obj-132", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-127", 0 ],
                                    "source": [ "obj-132", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-54", 0 ],
                                    "source": [ "obj-18", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-1", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-10", 0 ],
                                    "midpoints": [ 430.5, 91.0, 950.5, 91.0 ],
                                    "order": 0,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-208", 0 ],
                                    "midpoints": [ 430.5, 468.0, 138.5, 468.0 ],
                                    "order": 5,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-209", 0 ],
                                    "midpoints": [ 430.5, 91.0, 554.5, 91.0 ],
                                    "order": 2,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "midpoints": [ 430.5, 397.46875, 786.5, 397.46875 ],
                                    "order": 1,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-313", 0 ],
                                    "midpoints": [ 430.5, 97.0, 140.5, 97.0 ],
                                    "order": 4,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "midpoints": [ 430.5, 471.61328125, 543.5, 471.61328125 ],
                                    "order": 3,
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "source": [ "obj-208", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 0 ],
                                    "source": [ "obj-209", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "source": [ "obj-26", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "source": [ "obj-26", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "source": [ "obj-26", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 0 ],
                                    "source": [ "obj-26", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "source": [ "obj-26", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-26", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-31", 0 ],
                                    "source": [ "obj-26", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-313", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-45", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "source": [ "obj-45", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "source": [ "obj-45", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "source": [ "obj-45", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-45", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "source": [ "obj-45", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "source": [ "obj-45", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-40", 0 ],
                                    "source": [ "obj-45", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-18", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-86", 0 ],
                                    "source": [ "obj-98", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-87", 0 ],
                                    "source": [ "obj-98", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-88", 0 ],
                                    "source": [ "obj-98", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-89", 0 ],
                                    "source": [ "obj-98", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-90", 0 ],
                                    "source": [ "obj-98", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 0 ],
                                    "source": [ "obj-98", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-92", 0 ],
                                    "source": [ "obj-98", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-93", 0 ],
                                    "source": [ "obj-98", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1362.932908654213, 220.83333218097687, 189.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 31.0, 945.0, 169.0, 22.0 ],
                    "text": "p osc mes"
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 187.26682886481285, 252.80158614923084, 66.0, 22.0 ],
                    "text": "OSC-route"
                }
            },
            {
                "box": {
                    "autopopulate": 1,
                    "bgcolor": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_angle": 270.0,
                    "bgfillcolor_color": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_color1": [ 0.3764705882352941, 0.3843137254901961, 0.4, 1.0 ],
                    "bgfillcolor_color2": [ 0.2901960784313726, 0.30980392156862746, 0.30196078431372547, 1.0 ],
                    "bgfillcolor_proportion": 0.39,
                    "bgfillcolor_type": "color",
                    "color": [ 0.309803921568627, 0.996078431372549, 0.0, 1.0 ],
                    "id": "obj-208",
                    "items": [ "a-protest-in-bogota-colombia.wav", ",", "acoustic-mordor-malaga.wav", ",", "anti-austerity-protest-athens-greece.wav", ",", "call-and-response-occupy-la.wav", ",", "cinema-is-truth-24-times-a-second.wav", ",", "democracia-new-york.wav", ",", "edinburgh-climate-protests-the-mound.wav", ",", "kill-the-bill-protest-parliament-square.wav", ",", "manifestants-parade-bogota.wav", ",", "not-my-president.wav", ",", "on-with-the-struggle-istanbul.wav", ",", "protest-in-tahrir-square-cairo.wav", ",", "protest-resolution.wav", ",", "rhythms-of-protest-paris.wav", ",", "serbian-protest.wav", ",", "subterranean-protest-malaga.wav", ",", "the-last-1-000-metres-madrid.wav", ",", "the-last-900-metres-madrid.wav", ",", "the-value-of-noise.wav" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 411.26682886481285, 315.8333321809769, 168.0, 22.0 ],
                    "prefix": "~/Desktop/01_Proyectos/IMOL/audio/processed/",
                    "presentation": 1,
                    "presentation_rect": [ 26.0, 97.0, 100.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "a-protest-in-bogota-colombia.wav", "acoustic-mordor-malaga.wav", "anti-austerity-protest-athens-greece.wav", "call-and-response-occupy-la.wav", "cinema-is-truth-24-times-a-second.wav", "democracia-new-york.wav", "edinburgh-climate-protests-the-mound.wav", "kill-the-bill-protest-parliament-square.wav", "manifestants-parade-bogota.wav", "not-my-president.wav", "on-with-the-struggle-istanbul.wav", "protest-in-tahrir-square-cairo.wav", "protest-resolution.wav", "rhythms-of-protest-paris.wav", "serbian-protest.wav", "subterranean-protest-malaga.wav", "the-last-1-000-metres-madrid.wav", "the-last-900-metres-madrid.wav", "the-value-of-noise.wav" ],
                            "parameter_longname": "umenu[5]",
                            "parameter_mmax": 18,
                            "parameter_modmode": 0,
                            "parameter_shortname": "umenu[2]",
                            "parameter_type": 2
                        }
                    },
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "varname": "umenu[4]"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-319",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 600.5793288648129, 280.83333218097687, 73.82050794363022, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 118.0, 72.0, 20.0 ],
                    "text": "load tracks",
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "blinkcolor": [ 0.309803921568627, 0.996078431372549, 0.0, 1.0 ],
                    "id": "obj-320",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "outlinecolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "parameter_enable": 1,
                    "patching_rect": [ 600.5793288648129, 301.33333218097687, 69.0208340883255, 69.0208340883255 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 69.0, 20.0, 20.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "off", "on" ],
                            "parameter_longname": "button[14]",
                            "parameter_mmax": 1,
                            "parameter_modmode": 0,
                            "parameter_shortname": "button[14]",
                            "parameter_type": 2
                        }
                    },
                    "varname": "button[14]"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-321",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 600.5793288648129, 396.29786209550684, 87.0, 22.0 ],
                    "text": "prepend prefix"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-322",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "patching_rect": [ 600.5793288648129, 377.8333321809769, 92.0, 22.0 ],
                    "text": "opendialog fold"
                }
            },
            {
                "box": {
                    "id": "obj-323",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 411.26682886481285, 345.33333333333326, 65.0, 22.0 ],
                    "text": "replace $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-70",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 481.6666657924652, 706.0, 92.0, 23.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-71",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 591.489582836628, 704.5, 92.0, 23.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-68",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1136.7692412436008, 299.7500002384186, 238.0, 38.0 ],
                    "text": "0.037535 0. -0.037535 -1.968959 0.969932"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-8",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1296.961543649435, 220.33333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-30",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1232.586543649435, 225.83333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-33",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1151.4615412950516, 225.83333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-40",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1296.961543649435, 245.33333218097687, 55.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 356.0, 693.0, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-47",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1234.961543649435, 245.33333218097687, 55.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 297.0, 693.0, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-50",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1156.4615412950516, 245.33333218097687, 57.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 235.0, 693.0, 57.0, 23.0 ]
                }
            },
            {
                "box": {
                    "curvecolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "fontface": 0,
                    "hcurvecolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-56",
                    "linmarkers": [ 0.0, 11025.0, 16537.5 ],
                    "logmarkers": [ 0.0, 100.0, 1000.0, 10000.0 ],
                    "maxclass": "filtergraph~",
                    "nfilters": 1,
                    "numinlets": 8,
                    "numoutlets": 7,
                    "outlettype": [ "list", "float", "float", "float", "float", "list", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 959.8461593985558, 110.33333218097687, 176.74999764561653, 164.46825396825398 ],
                    "presentation": 1,
                    "presentation_rect": [ 235.0, 622.0, 176.0, 64.0 ],
                    "setfilter": [ 0, 8, 1, 0, 0, 220.6400146484375, 2.424912214279175, 1.0296194553375244, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],
                    "varname": "filtergraph~[1]"
                }
            },
            {
                "box": {
                    "bubbleside": 2,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-57",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1157.2692388892174, 134.30158614923084, 88.25, 36.0 ],
                    "text": "cutoff or center freq",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "edit_mode",
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-66",
                    "lock": 1,
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "orientation": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 955.7692412436008, 59.30158614923084, 83.0, 46.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.0, 566.0, 83.0, 46.0 ],
                    "text_width": 83.0
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 237.72916650772095, 690.3333406448364, 129.0, 47.0 ],
                    "text": "retune the delay lines and change the network configuration"
                }
            },
            {
                "box": {
                    "id": "obj-99",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 176.16666221618652, 431.49999809265137, 219.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 154.0, 219.0, 20.0 ],
                    "text": " network and damping interactions",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "active1": [ 1.0, 1.0, 1.0, 1.0 ],
                    "bubblesize": 18,
                    "id": "obj-59",
                    "maxclass": "preset",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "preset", "int", "preset", "int", "" ],
                    "patching_rect": [ 989.923072680831, 1054.0, 147.1538546383381, 81.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 31.0, 843.0, 243.0, 64.0 ],
                    "preset_data": [
                        {
                            "number": 1,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 601365, 6, "obj-112", "rslider", "list", 3385, 739, 6, "obj-113", "rslider", "list", 96, 3, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 77, 5, "obj-49", "number", "int", 2, 5, "obj-5", "number", "int", 3385, 5, "obj-18", "number", "int", 739, 5, "obj-22", "number", "int", 96, 5, "obj-20", "number", "int", 3, 6, "obj-115", "rslider", "list", 3, 1, 5, "obj-31", "number", "int", 3, 5, "obj-27", "number", "int", 1, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 1144.9078369140625, 1.4445880651474, 0.5649909973144531, 5, "obj-445", "number", "float", 1144.9078369140625, 5, "obj-444", "number", "float", 1.4445880651474, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.0, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.0, 5, "obj-64", "number", "float", 0.0, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 797.4866943359375, 1.4243077039718628, 1.0296194553375244, 5, "obj-50", "number", "float", 797.4866943359375, 5, "obj-47", "number", "float", 1.4243077039718628, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 10, 5, "obj-60", "number", "int", 3385, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.501886785030365, 5, "obj-128", "number", "float", 0.09791667014360428, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.501886785030365, 5, "obj-135", "slider", "float", 0.09791667014360428, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 2,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 440058, 6, "obj-112", "rslider", "list", 3385, 739, 6, "obj-113", "rslider", "list", 96, 3, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 77, 5, "obj-49", "number", "int", 2, 5, "obj-5", "number", "int", 3385, 5, "obj-18", "number", "int", 739, 5, "obj-22", "number", "int", 96, 5, "obj-20", "number", "int", 3, 6, "obj-115", "rslider", "list", 3, 1, 5, "obj-31", "number", "int", 3, 5, "obj-27", "number", "int", 1, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 472.24237060546875, 2.99375319480896, 0.5649909973144531, 5, "obj-445", "number", "float", 472.24237060546875, 5, "obj-444", "number", "float", 2.99375319480896, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.3566037714481354, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.008333333767950535, 5, "obj-64", "number", "float", 0.007547169923782349, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 656.2763671875, 1.576267123222351, 1.0296194553375244, 5, "obj-50", "number", "float", 656.2763671875, 5, "obj-47", "number", "float", 1.576267123222351, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 1, 5, "obj-60", "number", "int", 3385, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09687499701976776, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09687499701976776, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 3,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 440058, 6, "obj-112", "rslider", "list", 4999, 592, 6, "obj-113", "rslider", "list", 21, 12, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 59, 5, "obj-49", "number", "int", 28, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 592, 5, "obj-22", "number", "int", 21, 5, "obj-20", "number", "int", 12, 6, "obj-115", "rslider", "list", 8, 1, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 1, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 166.187255859375, 4.195612907409668, 0.5649909973144531, 5, "obj-445", "number", "float", 166.187255859375, 5, "obj-444", "number", "float", 4.195612907409668, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.15471698343753815, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.01145833358168602, 5, "obj-64", "number", "float", 0.0056603774428367615, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 237.66177368164062, 3.202777147293091, 1.0296194553375244, 5, "obj-50", "number", "float", 237.66177368164062, 5, "obj-47", "number", "float", 3.202777147293091, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 1, 5, "obj-60", "number", "int", 7968, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09270833432674408, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09270833432674408, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 4,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 90213, 6, "obj-112", "rslider", "list", 4999, 590, 6, "obj-113", "rslider", "list", 28, 13, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 59, 5, "obj-49", "number", "int", 28, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 590, 5, "obj-22", "number", "int", 28, 5, "obj-20", "number", "int", 13, 6, "obj-115", "rslider", "list", 8, 4, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 4, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 602.0283813476562, 2.2217700481414795, 0.5649909973144531, 5, "obj-445", "number", "float", 602.0283813476562, 5, "obj-444", "number", "float", 2.2217700481414795, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.0, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.0, 5, "obj-64", "number", "float", 0.0, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 194.16122436523438, 1.2148776054382324, 1.0296194553375244, 5, "obj-50", "number", "float", 194.16122436523438, 5, "obj-47", "number", "float", 1.2148776054382324, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 4, 5, "obj-60", "number", "int", 7906, 5, "obj-125", "number", "float", 0.6208333373069763, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09791667014360428, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6208333373069763, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09791667014360428, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 5,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 514000, 6, "obj-112", "rslider", "list", 0, 0, 6, "obj-113", "rslider", "list", 0, 0, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 48, 5, "obj-49", "number", "int", 15, 5, "obj-5", "number", "int", 0, 5, "obj-18", "number", "int", 0, 5, "obj-22", "number", "int", 0, 5, "obj-20", "number", "int", 0, 6, "obj-115", "rslider", "list", 0, 2, 5, "obj-31", "number", "int", 0, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 64.22879028320312, 2.9229607582092285, 0.5649909973144531, 5, "obj-445", "number", "float", 64.22879028320312, 5, "obj-444", "number", "float", 2.9229607582092285, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.16981132328510284, 5, "obj-91", "kslider", "int", 47, 5, "obj-89", "number", "float", 47.0, 5, "obj-88", "kslider", "int", 38, 5, "obj-87", "number", "float", 38.0, 5, "obj-72", "number", "float", 0.0052083334885537624, 5, "obj-64", "number", "float", 0.009433962404727936, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 1597.6153564453125, 0.8738783001899719, 1.0296194553375244, 5, "obj-50", "number", "float", 1597.6153564453125, 5, "obj-47", "number", "float", 0.8738783001899719, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 5, 5, "obj-60", "number", "int", 0, 5, "obj-125", "number", "float", 0.5572916865348816, 5, "obj-123", "number", "float", 0.2943396270275116, 5, "obj-128", "number", "float", 0.0052083334885537624, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.5572916865348816, 5, "obj-134", "slider", "float", 0.2943396270275116, 5, "obj-135", "slider", "float", 0.0052083334885537624, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 6,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 239961, 6, "obj-112", "rslider", "list", 3229, 739, 6, "obj-113", "rslider", "list", 112, 3, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 48, 5, "obj-49", "number", "int", 15, 5, "obj-5", "number", "int", 3229, 5, "obj-18", "number", "int", 739, 5, "obj-22", "number", "int", 112, 5, "obj-20", "number", "int", 3, 6, "obj-115", "rslider", "list", 3, 5, 5, "obj-31", "number", "int", 3, 5, "obj-27", "number", "int", 5, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 903.856201171875, 2.103156805038452, 0.5649909973144531, 5, "obj-445", "number", "float", 903.856201171875, 5, "obj-444", "number", "float", 2.103156805038452, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.0, 5, "obj-91", "kslider", "int", 47, 5, "obj-89", "number", "float", 47.0, 5, "obj-88", "kslider", "int", 38, 5, "obj-87", "number", "float", 38.0, 5, "obj-72", "number", "float", 0.0, 5, "obj-64", "number", "float", 0.0, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 441.6571044921875, 1.3558495044708252, 1.0296194553375244, 5, "obj-50", "number", "float", 441.6571044921875, 5, "obj-47", "number", "float", 1.3558495044708252, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 11, 5, "obj-60", "number", "int", 3229, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09375, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09375, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 7,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 210207, 6, "obj-112", "rslider", "list", 0, 0, 6, "obj-113", "rslider", "list", 0, 0, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 65, 5, "obj-49", "number", "int", 40, 5, "obj-5", "number", "int", 0, 5, "obj-18", "number", "int", 0, 5, "obj-22", "number", "int", 0, 5, "obj-20", "number", "int", 0, 6, "obj-115", "rslider", "list", 0, 4, 5, "obj-31", "number", "int", 0, 5, "obj-27", "number", "int", 4, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 372.15802001953125, 2.103156805038452, 0.5649909973144531, 5, "obj-445", "number", "float", 372.15802001953125, 5, "obj-444", "number", "float", 2.103156805038452, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.2981131970882416, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.0052083334885537624, 5, "obj-64", "number", "float", 0.016981132328510284, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 265.6922302246094, 2.2217700481414795, 1.0296194553375244, 5, "obj-50", "number", "float", 265.6922302246094, 5, "obj-47", "number", "float", 2.2217700481414795, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 2, 5, "obj-60", "number", "int", 0, 5, "obj-125", "number", "float", 0.4520833194255829, 5, "obj-123", "number", "float", 0.39245283603668213, 5, "obj-128", "number", "float", 0.00937500037252903, 5, "obj-44", "number", "float", 0.20416666567325592, 5, "obj-114", "slider", "float", 0.4520833194255829, 5, "obj-134", "slider", "float", 0.39245283603668213, 5, "obj-135", "slider", "float", 0.00937500037252903, 5, "obj-136", "slider", "float", 0.20416666567325592 ]
                        },
                        {
                            "number": 8,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 690050, 6, "obj-112", "rslider", "list", 4999, 594, 6, "obj-113", "rslider", "list", 23, 12, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 69, 5, "obj-49", "number", "int", 50, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 594, 5, "obj-22", "number", "int", 23, 5, "obj-20", "number", "int", 12, 6, "obj-115", "rslider", "list", 8, 6, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 6, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 559.12158203125, 4.532999515533447, 0.5649909973144531, 5, "obj-445", "number", "float", 559.12158203125, 5, "obj-444", "number", "float", 4.532999515533447, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.30188679695129395, 5, "obj-91", "kslider", "int", 43, 5, "obj-89", "number", "float", 43.0, 5, "obj-88", "kslider", "int", 50, 5, "obj-87", "number", "float", 50.0, 5, "obj-72", "number", "float", 0.004166666883975267, 5, "obj-64", "number", "float", 0.01320754736661911, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 603.4384765625, 2.9229607582092285, 1.0296194553375244, 5, "obj-50", "number", "float", 603.4384765625, 5, "obj-47", "number", "float", 2.9229607582092285, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 12, 5, "obj-60", "number", "int", 7958, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.501886785030365, 5, "obj-128", "number", "float", 0.09583333134651184, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.501886785030365, 5, "obj-135", "slider", "float", 0.09583333134651184, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 9,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 601365, 6, "obj-112", "rslider", "list", 0, 0, 6, "obj-113", "rslider", "list", 0, 0, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 64, 5, "obj-49", "number", "int", 38, 5, "obj-5", "number", "int", 0, 5, "obj-18", "number", "int", 0, 5, "obj-22", "number", "int", 0, 5, "obj-20", "number", "int", 0, 6, "obj-115", "rslider", "list", 0, 2, 5, "obj-31", "number", "int", 0, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 372.15802001953125, 2.6192433834075928, 0.5649909973144531, 5, "obj-445", "number", "float", 372.15802001953125, 5, "obj-444", "number", "float", 2.6192433834075928, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.0, 5, "obj-91", "kslider", "int", 53, 5, "obj-89", "number", "float", 53.0, 5, "obj-88", "kslider", "int", 29, 5, "obj-87", "number", "float", 29.0, 5, "obj-72", "number", "float", 0.0, 5, "obj-64", "number", "float", 0.0, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 349.3828125, 1.0885456800460815, 1.0296194553375244, 5, "obj-50", "number", "float", 349.3828125, 5, "obj-47", "number", "float", 1.0885456800460815, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 10, 5, "obj-60", "number", "int", 0, 5, "obj-125", "number", "float", 0.0, 5, "obj-123", "number", "float", 0.0, 5, "obj-128", "number", "float", 0.0, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.0, 5, "obj-134", "slider", "float", 0.0, 5, "obj-135", "slider", "float", 0.0, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 10,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 1109760, 6, "obj-112", "rslider", "list", 0, 0, 6, "obj-113", "rslider", "list", 0, 0, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 64, 5, "obj-49", "number", "int", 38, 5, "obj-5", "number", "int", 0, 5, "obj-18", "number", "int", 0, 5, "obj-22", "number", "int", 0, 5, "obj-20", "number", "int", 0, 6, "obj-115", "rslider", "list", 0, 2, 5, "obj-31", "number", "int", 0, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 71.96858978271484, 2.6192433834075928, 0.5649909973144531, 5, "obj-445", "number", "float", 71.96858978271484, 5, "obj-444", "number", "float", 2.6192433834075928, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.0, 5, "obj-91", "kslider", "int", 45, 5, "obj-89", "number", "float", 45.0, 5, "obj-88", "kslider", "int", 36, 5, "obj-87", "number", "float", 36.0, 5, "obj-72", "number", "float", 0.0, 5, "obj-64", "number", "float", 0.0, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 1536.642578125, 3.445786714553833, 1.0296194553375244, 5, "obj-50", "number", "float", 1536.642578125, 5, "obj-47", "number", "float", 3.445786714553833, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 9, 5, "obj-60", "number", "int", 0, 5, "obj-125", "number", "float", 0.0, 5, "obj-123", "number", "float", 0.0, 5, "obj-128", "number", "float", 0.0, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.0, 5, "obj-134", "slider", "float", 0.0, 5, "obj-135", "slider", "float", 0.0, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 11,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 287928, 6, "obj-112", "rslider", "list", 4999, 590, 6, "obj-113", "rslider", "list", 23, 12, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 41, 5, "obj-49", "number", "int", 10, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 590, 5, "obj-22", "number", "int", 23, 5, "obj-20", "number", "int", 12, 6, "obj-115", "rslider", "list", 8, 2, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 519.2626953125, 4.291086196899414, 0.5649909973144531, 5, "obj-445", "number", "float", 519.2626953125, 5, "obj-444", "number", "float", 4.291086196899414, 5, "obj-443", "number", "float", 0.5649909973144531, 5, "obj-92", "number", "float", 0.322641521692276, 5, "obj-91", "kslider", "int", 52, 5, "obj-89", "number", "float", 52.0, 5, "obj-88", "kslider", "int", 50, 5, "obj-87", "number", "float", 50.0, 5, "obj-72", "number", "float", 0.0062500000931322575, 5, "obj-64", "number", "float", 0.011320754885673523, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 516.2731323242188, 4.788545608520508, 1.0296194553375244, 5, "obj-50", "number", "float", 516.2731323242188, 5, "obj-47", "number", "float", 4.788545608520508, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 8, 5, "obj-60", "number", "int", 7958, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.505660355091095, 5, "obj-128", "number", "float", 0.09270833432674408, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.505660355091095, 5, "obj-135", "slider", "float", 0.09270833432674408, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 12,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 62249, 6, "obj-112", "rslider", "list", 4999, 596, 6, "obj-113", "rslider", "list", 21, 12, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 71, 5, "obj-49", "number", "int", 57, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 596, 5, "obj-22", "number", "int", 21, 5, "obj-20", "number", "int", 12, 6, "obj-115", "rslider", "list", 8, 2, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 2191.12548828125, 3.6400632858276367, 0.9210535287857056, 5, "obj-445", "number", "float", 2191.12548828125, 5, "obj-444", "number", "float", 3.6400632858276367, 5, "obj-443", "number", "float", 0.9210535287857056, 5, "obj-92", "number", "float", 0.322641521692276, 5, "obj-91", "kslider", "int", 55, 5, "obj-89", "number", "float", 55.0, 5, "obj-88", "kslider", "int", 62, 5, "obj-87", "number", "float", 62.0, 5, "obj-72", "number", "float", 0.0052083334885537624, 5, "obj-64", "number", "float", 0.011320754885673523, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 88.16889190673828, 3.6400632858276367, 1.0296194553375244, 5, "obj-50", "number", "float", 88.16889190673828, 5, "obj-47", "number", "float", 3.6400632858276367, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 7, 5, "obj-60", "number", "int", 7968, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.505660355091095, 5, "obj-128", "number", "float", 0.09270833432674408, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.505660355091095, 5, "obj-135", "slider", "float", 0.09270833432674408, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 13,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 76656, 6, "obj-112", "rslider", "list", 4999, 600, 6, "obj-113", "rslider", "list", 23, 11, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 57, 5, "obj-49", "number", "int", 25, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 600, 5, "obj-22", "number", "int", 23, 5, "obj-20", "number", "int", 11, 6, "obj-115", "rslider", "list", 8, 2, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 345.5799560546875, 0.8271729946136475, 0.9210535287857056, 5, "obj-445", "number", "float", 345.5799560546875, 5, "obj-444", "number", "float", 0.8271729946136475, 5, "obj-443", "number", "float", 0.9210535287857056, 5, "obj-92", "number", "float", 0.322641521692276, 5, "obj-91", "kslider", "int", 35, 5, "obj-89", "number", "float", 35.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-72", "number", "float", 0.0072916666977107525, 5, "obj-64", "number", "float", 0.007547169923782349, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 408.47979736328125, 0.45184850692749023, 1.0296194553375244, 5, "obj-50", "number", "float", 408.47979736328125, 5, "obj-47", "number", "float", 0.45184850692749023, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 6, 5, "obj-60", "number", "int", 7958, 5, "obj-125", "number", "float", 0.6239583492279053, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09270833432674408, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6239583492279053, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09270833432674408, 5, "obj-136", "slider", "float", 0.0 ]
                        },
                        {
                            "number": 14,
                            "data": [ 5, "obj-3", "toggle", "int", 1, 5, "obj-76", "number", "int", 514000, 6, "obj-112", "rslider", "list", 4999, 592, 6, "obj-113", "rslider", "list", 20, 11, 5, "obj-41", "number", "int", 185, 5, "obj-43", "kslider", "int", 62, 5, "obj-49", "number", "int", 33, 5, "obj-5", "number", "int", 4999, 5, "obj-18", "number", "int", 592, 5, "obj-22", "number", "int", 20, 5, "obj-20", "number", "int", 11, 6, "obj-115", "rslider", "list", 8, 2, 5, "obj-31", "number", "int", 8, 5, "obj-27", "number", "int", 2, 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 0.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 345.5799560546875, 0.8271729946136475, 0.9210535287857056, 5, "obj-445", "number", "float", 345.5799560546875, 5, "obj-444", "number", "float", 0.8271729946136475, 5, "obj-443", "number", "float", 0.9210535287857056, 5, "obj-92", "number", "float", 0.3962264060974121, 5, "obj-91", "kslider", "int", 59, 5, "obj-89", "number", "float", 59.0, 5, "obj-88", "kslider", "int", 67, 5, "obj-87", "number", "float", 67.0, 5, "obj-72", "number", "float", 0.03333333507180214, 5, "obj-64", "number", "float", 0.06792452931404114, 5, "obj-62", "umenu", "int", 0, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 408.47979736328125, 0.45184850692749023, 1.0296194553375244, 5, "obj-50", "number", "float", 408.47979736328125, 5, "obj-47", "number", "float", 0.45184850692749023, 5, "obj-40", "number", "float", 1.0296194553375244, 5, "obj-208", "umenu", "int", 5, 5, "obj-60", "number", "int", 7979, 5, "obj-125", "number", "float", 0.6229166388511658, 5, "obj-123", "number", "float", 0.50377357006073, 5, "obj-128", "number", "float", 0.09375, 5, "obj-44", "number", "float", 0.0, 5, "obj-114", "slider", "float", 0.6229166388511658, 5, "obj-134", "slider", "float", 0.50377357006073, 5, "obj-135", "slider", "float", 0.09375, 5, "obj-136", "slider", "float", 0.0 ]
                        }
                    ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-61",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 56.66666662693024, 503.833340883255, 61.0, 22.0 ],
                    "text": "feeder $1"
                }
            },
            {
                "box": {
                    "allowdrag": 0,
                    "bgcolor": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_angle": 270.0,
                    "bgfillcolor_color": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_color1": [ 0.3764705882352941, 0.3843137254901961, 0.4, 1.0 ],
                    "bgfillcolor_color2": [ 0.2901960784313726, 0.30980392156862746, 0.30196078431372547, 1.0 ],
                    "bgfillcolor_proportion": 0.39,
                    "bgfillcolor_type": "color",
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-62",
                    "items": [ "off", ",", "self", ",", "other", ",", "self-side", ",", "other-side" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 56.66666662693024, 476.833340883255, 100.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 179.0, 100.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 1 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "umenu",
                            "parameter_mmax": 4.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "umenu",
                            "parameter_type": 3
                        }
                    },
                    "varname": "umenu"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "format": 6,
                    "id": "obj-64",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 325.6666622161865, 458.0000070333481, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 296.0, 179.0, 50.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 0.25 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "flonum[2]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "flonum",
                            "parameter_type": 3
                        }
                    },
                    "varname": "flonum[2]"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-65",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 325.6666622161865, 485.0000070333481, 64.0, 22.0 ],
                    "text": "damp3 $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "format": 6,
                    "id": "obj-72",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 253.66666221618652, 458.0000070333481, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 224.0, 179.0, 50.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 0.25 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "flonum[1]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "flonum",
                            "parameter_type": 3
                        }
                    },
                    "varname": "flonum[1]"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-75",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 253.66666221618652, 485.0000070333481, 64.0, 22.0 ],
                    "text": "damp2 $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-86",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
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
                        "rect": [ 34.0, 100.0, 237.0, 360.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-33",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 180.0, 41.0, 22.0 ],
                                    "text": "$1 50"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "format": 6,
                                    "id": "obj-32",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 45.0, 150.0, 93.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 45.0, 120.0, 79.0, 22.0 ],
                                    "text": "!/ 44100."
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "int", "float", "int", "int" ],
                                    "patching_rect": [ 90.0, 90.0, 64.0, 22.0 ],
                                    "text": "dspstate~"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 90.0, 35.0, 22.0 ],
                                    "text": "mtof"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 45.0, 210.0, 37.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-38",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 53.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-39",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 45.0, 245.0, 25.0, 25.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 1 ],
                                    "source": [ "obj-25", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-38", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 140.3333202600479, 716.3333406448364, 85.0, 22.0 ],
                    "text": "p midi2period"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "format": 6,
                    "id": "obj-87",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 140.3333202600479, 688.3333406448364, 80.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-88",
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "offset": 24,
                    "outlettype": [ "int", "int" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 140.3333202600479, 643.3333406448364, 232.0, 38.0 ],
                    "range": 49,
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 36 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "kslider[1]",
                            "parameter_modmode": 0,
                            "parameter_shortname": "kslider[1]",
                            "parameter_type": 3
                        }
                    },
                    "varname": "kslider[1]"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "format": 6,
                    "id": "obj-89",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 45.166661739349365, 688.3333406448364, 80.0, 22.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-90",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
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
                        "rect": [ 25.0, 69.0, 237.0, 360.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-33",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 180.0, 41.0, 18.0 ],
                                    "text": "$1 50"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "format": 6,
                                    "id": "obj-32",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 45.0, 150.0, 93.0, 20.0 ]
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 45.0, 120.0, 59.0, 20.0 ],
                                    "text": "!/ 44100."
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "int", "float", "int", "int" ],
                                    "patching_rect": [ 90.0, 90.0, 64.0, 20.0 ],
                                    "text": "dspstate~"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 90.0, 35.0, 20.0 ],
                                    "text": "mtof"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 45.0, 210.0, 37.0, 20.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-38",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 45.0, 30.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-39",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 45.0, 290.0, 25.0, 25.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 1 ],
                                    "source": [ "obj-25", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-38", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 45.166661739349365, 716.3333406448364, 85.0, 22.0 ],
                    "text": "p midi2period"
                }
            },
            {
                "box": {
                    "id": "obj-91",
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "offset": 24,
                    "outlettype": [ "int", "int" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 45.500005739349376, 598.3333406448364, 232.0, 38.0 ],
                    "range": 49,
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 36 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "kslider",
                            "parameter_modmode": 0,
                            "parameter_shortname": "kslider",
                            "parameter_type": 3
                        }
                    },
                    "varname": "kslider"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "format": 6,
                    "id": "obj-92",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 181.66666221618652, 458.0000070333481, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 152.0, 179.0, 50.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 0.25 ],
                            "parameter_initial_enable": 1,
                            "parameter_invisible": 1,
                            "parameter_longname": "flonum",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "flonum",
                            "parameter_type": 3
                        }
                    },
                    "varname": "flonum"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-93",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 181.66666221618652, 485.0000070333481, 64.0, 22.0 ],
                    "text": "damp1 $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-94",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 2,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "dsp.gen",
                        "rect": [ 134.0, 178.0, 1440.0, 826.0 ],
                        "statusbarvisible": 0,
                        "boxes": [
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-49",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 205.0, 63.0, 29.0, 33.0 ],
                                    "text": "R in"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-48",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 427.0, 548.0, 93.0, 20.0 ],
                                    "text": "output damping"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-45",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 684.0, 234.0, 131.5, 33.0 ],
                                    "text": "separate dampling for each delay line pair"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-38",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 306.0, 108.0, 101.5, 20.0 ],
                                    "text": "sets the routing"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-47",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 208.0, 107.0, 92.0, 22.0 ],
                                    "text": "param feeder 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-46",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 571.0, 176.0, 59.5, 22.0 ],
                                    "text": "gate 4"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 435.0, 176.0, 59.5, 22.0 ],
                                    "text": "gate 4"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 208.0, 176.0, 59.5, 22.0 ],
                                    "text": "gate 4"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 317.25, 176.0, 59.5, 22.0 ],
                                    "text": "gate 4"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 684.0, 277.0, 111.0, 22.0 ],
                                    "text": "param damp1 0.25"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 278.0, 583.0, 35.0, 22.0 ],
                                    "text": "* 0.5"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 139.0, 583.0, 35.0, 22.0 ],
                                    "text": "* 0.5"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-32",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 278.0, 684.0, 72.0, 22.0 ],
                                    "text": "history y3 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 278.0, 656.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 427.0, 605.0, 49.0, 22.0 ],
                                    "text": "clip 0 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 427.0, 577.0, 111.0, 22.0 ],
                                    "text": "param damp3 0.25"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 698.5, 360.0, 49.0, 22.0 ],
                                    "text": "clip 0 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 698.5, 331.0, 111.0, 22.0 ],
                                    "text": "param damp2 0.25"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 139.0, 684.0, 72.0, 22.0 ],
                                    "text": "history x3 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 139.0, 656.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 571.0, 381.0, 54.0, 22.0 ],
                                    "text": "fold -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 435.0, 381.0, 54.0, 22.0 ],
                                    "text": "fold -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 317.0, 381.0, 54.0, 22.0 ],
                                    "text": "fold -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 208.0, 381.0, 54.0, 22.0 ],
                                    "text": "fold -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 630.0, 63.0, 30.0, 22.0 ],
                                    "text": "in 4"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-9",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 495.0, 63.0, 30.0, 22.0 ],
                                    "text": "in 3"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 278.0, 755.0, 38.0, 22.0 ],
                                    "text": "out 2"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 139.0, 755.0, 38.0, 22.0 ],
                                    "text": "out 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 571.0, 514.0, 72.0, 22.0 ],
                                    "text": "history y2 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 571.0, 453.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 173.5, 63.0, 30.0, 22.0 ],
                                    "text": "in 2"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-12",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 571.0, 322.0, 78.0, 22.0 ],
                                    "text": "delay 44100"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 435.0, 514.0, 72.0, 22.0 ],
                                    "text": "history x2 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 435.0, 453.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 435.0, 322.0, 78.0, 22.0 ],
                                    "text": "delay 44100"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 317.0, 514.0, 72.0, 22.0 ],
                                    "text": "history y1 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 317.0, 453.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 278.0, 722.0, 53.0, 22.0 ],
                                    "text": "clip -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-39",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 487.0, 41.0, 87.0, 20.0 ],
                                    "text": "period inputs"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-40",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 149.0, 63.0, 26.0, 33.0 ],
                                    "text": "L in"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 119.0, 63.0, 30.0, 22.0 ],
                                    "text": "in 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 684.0, 306.0, 49.0, 22.0 ],
                                    "text": "clip 0 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 139.0, 722.0, 53.0, 22.0 ],
                                    "text": "clip -1 1"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 317.0, 322.0, 78.0, 22.0 ],
                                    "text": "delay 44100"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 208.0, 514.0, 72.0, 22.0 ],
                                    "text": "history x1 0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-15",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 208.0, 453.0, 46.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 208.0, 322.0, 78.0, 22.0 ],
                                    "text": "delay 44100"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "midpoints": [ 183.0, 276.0, 580.5, 276.0 ],
                                    "order": 0,
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 183.0, 277.0, 444.5, 277.0 ],
                                    "order": 1,
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 1 ],
                                    "midpoints": [ 639.5, 309.0, 639.5, 309.0 ],
                                    "order": 0,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 1 ],
                                    "midpoints": [ 639.5, 309.0, 385.5, 309.0 ],
                                    "order": 1,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "midpoints": [ 580.5, 361.0, 580.5, 361.0 ],
                                    "source": [ "obj-12", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 444.5, 400.0, 444.5, 400.0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 1 ],
                                    "midpoints": [ 444.5, 543.0, 513.25, 543.0, 513.25, 443.0, 458.0, 443.0 ],
                                    "order": 1,
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-44", 1 ],
                                    "midpoints": [ 444.5, 543.0, 424.75, 543.0, 424.75, 166.0, 485.0, 166.0 ],
                                    "order": 0,
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "midpoints": [ 217.5, 495.0, 148.5, 495.0 ],
                                    "order": 1,
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "midpoints": [ 217.5, 493.0, 217.5, 493.0 ],
                                    "order": 0,
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "midpoints": [ 444.5, 481.0, 444.5, 481.0 ],
                                    "order": 0,
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "midpoints": [ 444.5, 490.0, 404.0, 490.0, 404.0, 557.0, 148.5, 557.0 ],
                                    "order": 1,
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-20", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-1", 0 ],
                                    "midpoints": [ 217.5, 361.0, 217.5, 361.0 ],
                                    "source": [ "obj-21", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "midpoints": [ 326.5, 361.0, 326.5, 361.0 ],
                                    "source": [ "obj-24", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 1 ],
                                    "midpoints": [ 148.5, 713.0, 217.25, 713.0, 217.25, 646.0, 162.0, 646.0 ],
                                    "order": 0,
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-31", 0 ],
                                    "order": 1,
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "midpoints": [ 148.5, 679.5, 148.5, 679.5 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 2 ],
                                    "midpoints": [ 708.0, 430.0, 353.5, 430.0 ],
                                    "order": 1,
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 2 ],
                                    "midpoints": [ 708.0, 430.0, 607.5, 430.0 ],
                                    "order": 0,
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-28", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 2 ],
                                    "midpoints": [ 436.5, 635.5, 175.5, 635.5 ],
                                    "order": 1,
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 2 ],
                                    "midpoints": [ 436.5, 635.5, 314.5, 635.5 ],
                                    "order": 0,
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 1 ],
                                    "midpoints": [ 326.5, 543.0, 394.25, 543.0, 394.25, 443.0, 340.0, 443.0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 1 ],
                                    "midpoints": [ 326.5, 543.0, 301.375, 543.0, 301.375, 166.0, 367.25, 166.0 ],
                                    "order": 0,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-30", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 0 ],
                                    "source": [ "obj-31", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "order": 1,
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 1 ],
                                    "midpoints": [ 287.5, 713.0, 356.25, 713.0, 356.25, 646.0, 301.0, 646.0 ],
                                    "order": 0,
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "midpoints": [ 287.5, 679.5, 287.5, 679.5 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 2 ],
                                    "midpoints": [ 693.5, 414.5, 244.5, 414.5 ],
                                    "order": 1,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 2 ],
                                    "midpoints": [ 693.5, 414.5, 471.5, 414.5 ],
                                    "order": 0,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "midpoints": [ 326.5, 493.0, 326.5, 493.0 ],
                                    "order": 0,
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "midpoints": [ 326.5, 496.0, 287.5, 496.0 ],
                                    "order": 1,
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "midpoints": [ 353.75, 261.0, 580.5, 261.0 ],
                                    "source": [ "obj-41", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 367.25, 249.0, 444.5, 249.0 ],
                                    "source": [ "obj-41", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 340.25, 225.0, 217.5, 225.0 ],
                                    "source": [ "obj-41", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "midpoints": [ 326.75, 237.0, 326.5, 237.0 ],
                                    "source": [ "obj-41", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 128.5, 288.0, 217.5, 288.0 ],
                                    "order": 1,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "midpoints": [ 128.5, 288.0, 326.5, 288.0 ],
                                    "order": 0,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "midpoints": [ 258.0, 261.0, 580.5, 261.0 ],
                                    "source": [ "obj-43", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 244.5, 249.0, 444.5, 249.0 ],
                                    "source": [ "obj-43", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 217.5, 225.0, 217.5, 225.0 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "midpoints": [ 231.0, 237.0, 326.5, 237.0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "midpoints": [ 458.0, 261.0, 580.5, 261.0 ],
                                    "source": [ "obj-44", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 444.5, 249.0, 444.5, 249.0 ],
                                    "source": [ "obj-44", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 471.5, 225.0, 217.5, 225.0 ],
                                    "source": [ "obj-44", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "midpoints": [ 485.0, 237.0, 326.5, 237.0 ],
                                    "source": [ "obj-44", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "midpoints": [ 580.5, 261.0, 580.5, 261.0 ],
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 594.0, 249.0, 444.5, 249.0 ],
                                    "source": [ "obj-46", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 607.5, 225.0, 217.5, 225.0 ],
                                    "source": [ "obj-46", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "midpoints": [ 621.0, 237.0, 326.5, 237.0 ],
                                    "source": [ "obj-46", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 0 ],
                                    "midpoints": [ 217.5, 142.5, 326.75, 142.5 ],
                                    "order": 2,
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "midpoints": [ 217.5, 142.5, 217.5, 142.5 ],
                                    "order": 3,
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-44", 0 ],
                                    "midpoints": [ 217.5, 142.5, 444.5, 142.5 ],
                                    "order": 1,
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-46", 0 ],
                                    "midpoints": [ 217.5, 142.5, 580.5, 142.5 ],
                                    "order": 0,
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-46", 1 ],
                                    "midpoints": [ 580.5, 543.0, 557.75, 543.0, 557.75, 166.0, 621.0, 166.0 ],
                                    "order": 0,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 1 ],
                                    "midpoints": [ 580.5, 543.0, 654.25, 543.0, 654.25, 443.0, 594.0, 443.0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "midpoints": [ 580.5, 499.0, 412.0, 499.0, 412.0, 566.0, 287.5, 566.0 ],
                                    "order": 1,
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "midpoints": [ 580.5, 481.0, 580.5, 481.0 ],
                                    "order": 0,
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 1 ],
                                    "midpoints": [ 217.5, 543.0, 277.25, 543.0, 277.25, 443.0, 231.0, 443.0 ],
                                    "order": 1,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 1 ],
                                    "midpoints": [ 217.5, 543.0, 197.75, 543.0, 197.75, 166.0, 258.0, 166.0 ],
                                    "order": 0,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 1 ],
                                    "midpoints": [ 504.5, 300.0, 503.5, 300.0 ],
                                    "order": 0,
                                    "source": [ "obj-9", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 1 ],
                                    "midpoints": [ 504.5, 299.0, 276.5, 299.0 ],
                                    "order": 1,
                                    "source": [ "obj-9", 0 ]
                                }
                            }
                        ],
                        "bgcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                    },
                    "patching_rect": [ 14.666666507720947, 753.0, 144.66665375232697, 22.0 ],
                    "text": "gen~",
                    "varname": "gen~_AD"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-32",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 700.8461601436138, 669.0000002384186, 92.0, 23.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-453",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 800.3461593985558, 669.0000002384186, 92.0, 23.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-435",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1303.961543649435, 167.83333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-439",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1236.8942388892174, 173.33333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "hidden": 1,
                    "id": "obj-440",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1157.2692388892174, 173.33333218097687, 48.0, 23.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-441",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 772.8461593985558, 309.33333333333326, 283.625, 23.0 ],
                    "text": "0.078744 0. -0.078744 -1.916366 0.918573"
                }
            },
            {
                "box": {
                    "bubbleside": 2,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-442",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1304.0, 144.0, 73.0, 21.0 ],
                    "text": "set Q or S",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-443",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1303.961543649435, 192.83333218097687, 55.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 157.0, 693.0, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-444",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1239.2692388892174, 192.83333218097687, 55.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 97.0, 693.0, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-445",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1162.2692388892174, 192.83333218097687, 57.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 35.0, 693.0, 57.0, 23.0 ]
                }
            },
            {
                "box": {
                    "curvecolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "fontface": 0,
                    "hcurvecolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-446",
                    "linmarkers": [ 0.0, 11025.0, 16537.5 ],
                    "logmarkers": [ 0.0, 100.0, 1000.0, 10000.0 ],
                    "maxclass": "filtergraph~",
                    "nfilters": 1,
                    "numinlets": 8,
                    "numoutlets": 7,
                    "outlettype": [ "list", "float", "float", "float", "float", "list", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 776.8461593985558, 110.33333218097687, 171.00000149011612, 164.46825396825398 ],
                    "presentation": 1,
                    "presentation_rect": [ 35.0, 622.0, 185.0, 64.0 ],
                    "setfilter": [ 0, 8, 1, 0, 0, 336.73187255859375, 3.423248291015625, 0.5649909973144531, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],
                    "varname": "filtergraph~"
                }
            },
            {
                "box": {
                    "bubbleside": 2,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-447",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1157.2692388892174, 160.33333218097687, 88.25, 36.0 ],
                    "text": "cutoff or center freq",
                    "textcolor": [ 0.0, 0.0, 0.0, 1.0 ]
                }
            },
            {
                "box": {
                    "bubbleside": 2,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-448",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1237.2692388892174, 149.30158614923084, 59.0, 21.0 ],
                    "text": "set gain",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "bubbleside": 2,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-449",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1362.932908654213, 247.33333218097687, 118.0, 21.0 ],
                    "text": "filter response",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "edit_mode",
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-450",
                    "lock": 1,
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "orientation": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 772.8461593985558, 59.30158614923084, 83.0, 46.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 35.0, 565.0, 83.0, 46.0 ],
                    "text_width": 83.0
                }
            },
            {
                "box": {
                    "id": "obj-168",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 2,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "dsp.gen",
                        "rect": [ 346.0, 140.0, 264.0, 226.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 104.0, 26.0, 22.0 ],
                                    "text": "!- 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 77.0, 47.0, 22.0 ],
                                    "text": "clip 0 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 51.0, 71.0, 22.0 ],
                                    "text": "accum 0.01"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 143.0, 129.0, 22.0 ],
                                    "text": "*"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 160.0, 104.0, 37.0, 22.0 ],
                                    "text": "noise"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 14.0, 28.0, 22.0 ],
                                    "text": "in 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 50.0, 174.0, 35.0, 22.0 ],
                                    "text": "out 1"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 1 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-8", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1144.692692399025, 511.1731642484665, 132.0, 22.0 ],
                    "text": "gen~ @title noise-burst",
                    "varname": "gen~_AC"
                }
            },
            {
                "box": {
                    "id": "obj-170",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1071.3461593985558, 664.0, 81.0, 22.0 ],
                    "text": "snapshot~ 25"
                }
            },
            {
                "box": {
                    "id": "obj-171",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "signal", "signal", "signal" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 2,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "dsp.gen",
                        "rect": [ 59.0, 106.0, 369.0, 231.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 199.0, 104.0, 32.0, 22.0 ],
                                    "text": "ftom"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 30.0, 96.0, 55.0, 22.0 ],
                                    "text": "out 1 ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 30.0, 72.0, 70.0, 22.0 ],
                                    "text": "sampstoms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 114.0, 119.0, 53.0, 22.0 ],
                                    "text": "out 2 Hz"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 114.0, 72.0, 78.0, 22.0 ],
                                    "text": "!/ samplerate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 30.0, 24.0, 134.0, 22.0 ],
                                    "text": "in 1 delaytime_samples"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 197.5, 137.0, 84.0, 22.0 ],
                                    "text": "out 3 midinote"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "order": 0,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-44", 0 ],
                                    "order": 1,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "order": 1,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "order": 0,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "source": [ "obj-44", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 893.3461593985558, 635.0, 235.0, 22.0 ],
                    "text": "gen~ @title delaytimes",
                    "varname": "gen~_AB"
                }
            },
            {
                "box": {
                    "automatic": 1,
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-172",
                    "maxclass": "scope~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 1049.153854638338, 351.61537450551987, 270.0, 105.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 38.0, 383.0, 187.0, 49.0 ]
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "domain": [ 0.0, 24000.0 ],
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-173",
                    "markercolor": [ 0.349019607843137, 0.349019607843137, 0.349019607843137, 0.0 ],
                    "maxclass": "spectroscope~",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 774.1538546383381, 351.61537450551987, 270.0, 105.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 37.0, 331.0, 182.0, 36.0 ]
                }
            },
            {
                "box": {
                    "hidden": 1,
                    "id": "obj-174",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1257.4480085670948, 459.2178590297699, 83.0, 22.0 ],
                    "text": "loadmess 500"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-175",
                    "maxclass": "flonum",
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 842.3461593985558, 497.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 148.0, 456.0, 56.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 893.8461593985558, 474.0, 54.00000149011612, 20.0 ],
                    "text": "presets",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-177",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1327.932908654213, 621.2290258407593, 181.0, 20.0 ],
                    "text": "mix of original and delay",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-178",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
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
                        "rect": [ 689.0, 141.0, 957.0, 519.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 14.090909090909008, 222.95962276870853, 113.0, 20.0 ],
                                    "text": "metallic didgeridoo",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 199.95962276870853, 435.0, 22.0 ],
                                    "text": "drywet 0.6, delaytime 20, invert 0, dampen 1, lforate 4, lfodepth 0.03, decayms 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 40.09090909090901, 245.95962276870853, 87.0, 20.0 ],
                                    "text": "flanger",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 245.95962276870853, 439.0, 22.0 ],
                                    "text": "drywet 0.5, delaytime 5, invert 1, dampen 1, lforate 0.1, lfodepth 0.8, decayms 50"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 652.0, 57.5, 113.0, 22.0 ],
                                    "text": "prepend morph_ms"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-5",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 652.0, 16.5, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 47.09090909090901, 339.6835313998629, 81.0, 20.0 ],
                                    "text": "fliter wobble",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 31.09090909090901, 316.738749673632, 97.0, 20.0 ],
                                    "text": "toothpaste zone ",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 83.09090909090901, 293.79396794740114, 45.0, 20.0 ],
                                    "text": "phaser",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 40.09090909090901, 270.84918622117027, 88.0, 20.0 ],
                                    "text": "Karplus Strong",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 65.09090909090901, 200.95962276870853, 62.0, 20.0 ],
                                    "text": "chorus",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 62.09090909090901, 178.01484104247766, 65.0, 20.0 ],
                                    "text": "tape flutter",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 54.09090909090901, 155.07005931624678, 73.0, 20.0 ],
                                    "text": "slappy echo",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 46.09090909090901, 132.1252775900159, 81.0, 20.0 ],
                                    "text": "garagey echo",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 42.09090909090901, 109.18049586378504, 85.0, 20.0 ],
                                    "text": "mad professor",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 40.09090909090901, 86.23571413755417, 87.0, 20.0 ],
                                    "text": "standard delay",
                                    "textjustification": 2
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-3",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 136.90909090909088, 16.5, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 123.0, 374.1428586244584, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "hidden": 1,
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 13,
                                    "numoutlets": 13,
                                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                                    "patching_rect": [ 136.90909090909088, 48.5, 336.0, 22.0 ],
                                    "text": "route 0 1 2 3 4 5 6 7 8 9 10 11"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 85.23571413755417, 459.0, 22.0 ],
                                    "text": "drywet 0.4, delaytime 700, invert 0, dampen 0.8, lforate 1, lfodepth 0., decayms 6000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 314.7387496736321, 429.0, 22.0 ],
                                    "text": "drywet 1, delaytime 0.3, invert 1, dampen 1, lforate 1, lfodepth 0.6, decayms 12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 177.01484104247754, 425.0, 22.0 ],
                                    "text": "drywet 1, delaytime 30, invert 0, dampen 1, lforate 3, lfodepth 0.1, decayms 10"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 337.683531399863, 422.0, 22.0 ],
                                    "text": "drywet 1, delaytime 0.1, invert 1, dampen 0.5, lforate 5, lfodepth 1, decayms 2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 108.18049586378504, 462.0, 22.0 ],
                                    "text": "drywet 0.8, delaytime 300, invert 1, dampen 1, lforate 1, lfodepth 0.03, decayms 4000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 154.07005931624673, 455.0, 22.0 ],
                                    "text": "drywet 0.3, delaytime 60, invert 1, dampen 0.5, lforate 10, lfodepth 0, decayms 1000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 268.84918622117027, 462.0, 22.0 ],
                                    "text": "drywet 1, delaytime 3, invert 0, dampen 0.75, lforate 7, lfodepth 0.001, decayms 1000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 222.95962276870853, 469.0, 22.0 ],
                                    "text": "drywet 1, delaytime 10, invert 1, dampen 0.15, lforate 99, lfodepth 0.01, decayms 2000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 131.12527759001586, 462.0, 22.0 ],
                                    "text": "drywet 0.3, delaytime 150, invert 0, dampen 0.5, lforate 10, lfodepth 0, decayms 1000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 136.90909090909088, 291.79396794740126, 432.0, 22.0 ],
                                    "text": "drywet 0.5, delaytime 1.5, invert 0, dampen 1, lforate 0.1, lfodepth 1, decayms 1"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 9 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 8 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 11 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 10 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 0 ],
                                    "hidden": 1,
                                    "source": [ "obj-1", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 314.76428586244594, 132.5, 314.76428586244594 ],
                                    "source": [ "obj-24", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 151.55714344978333, 132.5, 151.55714344978333 ],
                                    "source": [ "obj-29", 0 ]
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
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 244.6607146561147, 132.5, 244.6607146561147 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 291.39642879366886, 132.5, 291.39642879366886 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 174.9250005185604, 132.5, 174.9250005185604 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 271.0512406965835, 132.5, 271.0512406965835 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 198.2928575873375, 132.5, 198.2928575873375 ],
                                    "source": [ "obj-48", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 128.18928638100624, 132.5, 128.18928638100624 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 361.5000000000001, 132.5, 361.5000000000001 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 338.13214293122303, 132.5, 338.13214293122303 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 104.82142931222916, 132.5, 104.82142931222916 ],
                                    "source": [ "obj-57", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "hidden": 1,
                                    "midpoints": [ 661.5, 340.85714396834373, 132.5, 340.85714396834373 ],
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 146.40909090909088, 224.55124069658348, 132.5, 224.55124069658348 ],
                                    "source": [ "obj-9", 0 ]
                                }
                            }
                        ],
                        "bgcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                    },
                    "patching_rect": [ 776.8461593985558, 497.0, 58.0, 22.0 ],
                    "saved_object_attributes": {
                        "locked_bgcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                    },
                    "text": "p presets"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_angle": 270.0,
                    "bgfillcolor_color": [ 0.0, 0.0, 0.0, 0.0 ],
                    "bgfillcolor_color1": [ 0.3764705882352941, 0.3843137254901961, 0.4, 1.0 ],
                    "bgfillcolor_color2": [ 0.2901960784313726, 0.30980392156862746, 0.30196078431372547, 1.0 ],
                    "bgfillcolor_proportion": 0.39,
                    "bgfillcolor_type": "color",
                    "color": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "elementcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "id": "obj-179",
                    "items": [ "delay", ",", "mad professor", ",", "garagey echo", ",", "slappy echo", ",", "tape flutter", ",", "chorus", ",", "didgerimetal", ",", "flanger", ",", "Karplus Strong", ",", "phaser", ",", "toothpaste zone", ",", "filter wobble" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 776.8461593985558, 474.0, 111.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 31.0, 456.0, 117.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "delay", "mad professor", "garagey echo", "slappy echo", "tape flutter", "chorus", "didgerimetal", "flanger", "Karplus Strong", "phaser", "toothpaste zone", "filter wobble" ],
                            "parameter_initial": [ 0.0 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "umenu[3]",
                            "parameter_mmax": 11,
                            "parameter_modmode": 0,
                            "parameter_shortname": "umenu",
                            "parameter_type": 2
                        }
                    },
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "varname": "umenu[3]"
                }
            },
            {
                "box": {
                    "id": "obj-180",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1327.932908654213, 565.3631062507629, 188.0, 20.0 ],
                    "text": "one-pole filter in the feedback",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-181",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 997.3461593985558, 707.0, 66.0, 20.0 ],
                    "text": "MIDI Note:"
                }
            },
            {
                "box": {
                    "format": 5,
                    "id": "obj-182",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1071.3461593985558, 692.3333406448364, 61.5, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-183",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 893.3461593985558, 688.0, 105.0, 20.0 ],
                    "text": "Delay as ms"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-184",
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 893.3461593985558, 664.0, 105.0, 22.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-185",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 995.8461593985558, 688.0, 105.0, 20.0 ],
                    "text": "Delay as Hz"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-186",
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 1001.3461593985558, 664.0, 58.0, 22.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-187",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 959.8461593985558, 568.8333333333333, 111.0, 33.0 ],
                    "text": "LFO modulation of delay time",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-188",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 959.8461593985558, 528.8333353598912, 109.0, 20.0 ],
                    "text": "delay time in ms",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-189",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1327.932908654213, 588.2681332826614, 181.0, 20.0 ],
                    "text": "feedback invert",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-190",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1327.932908654213, 541.3407608270645, 188.0, 20.0 ],
                    "text": "decay duration (feedback)",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-191",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 893.8461593985558, 498.0, 158.0, 20.0 ],
                    "text": "morph ms between presets",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "lforate",
                    "id": "obj-192",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 776.8461593985558, 557.8333333333335, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 32.0, 510.0, 187.0, 22.0 ],
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "drywet",
                    "id": "obj-193",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1144.692692399025, 621.2290258407593, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 224.0, 532.0, 187.0, 22.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-196",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 2,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "dsp.gen",
                        "rect": [ 116.0, 168.0, 656.0, 576.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 220.16666132211685, 226.0, 90.0, 22.0 ],
                                    "text": "out 2 delaytime"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 244.75, 196.5, 122.0, 20.0 ],
                                    "text": "minimum 1 sample"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 61.0, 274.0, 34.5, 22.0 ],
                                    "text": "*"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "linecount": 2,
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 516.0, 47.25, 106.0, 35.0 ],
                                    "text": "param morph_ms 500 @min 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 423.0, 168.0, 22.0 ],
                                    "text": "param invert @min 0 @max 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 447.0, 66.0, 22.0 ],
                                    "text": "switch -1 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 224.0, 164.75, 56.0, 20.0 ],
                                    "text": "add LFO"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 287.0, 164.75, 37.5, 22.0 ],
                                    "text": "*"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 46.0, 385.0, 68.0, 22.0 ],
                                    "text": "go.onepole"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-68",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 8.0, 25.5, 51.0, 20.0 ],
                                    "text": "audio in"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 385.0, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 353.0, 182.0, 22.0 ],
                                    "text": "param dampen @min 0 @max 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 510.0, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 76.5, 93.25, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 201.0, 93.25, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 305.5, 93.25, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 399.5, 93.25, 63.0, 22.0 ],
                                    "text": "go.line.ms"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 528.0, 93.25, 71.0, 47.0 ],
                                    "text": "interpolate parameter changes"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 77.0, 25.5, 119.0, 20.0 ],
                                    "text": "ms to fade away"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 306.0, 25.5, 117.0, 20.0 ],
                                    "text": "LFO for delay length"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 201.5, 25.5, 102.5, 20.0 ],
                                    "text": "delay length (ms)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 105.0, 226.0, 98.0, 47.0 ],
                                    "text": "decay : delay \nratio determines feedback mix"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 76.5, 116.75, 70.0, 22.0 ],
                                    "text": "mstosamps"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 201.0, 195.5, 41.0, 22.0 ],
                                    "text": "max 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 46.0, 298.0, 34.0, 22.0 ],
                                    "text": "+"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 76.5, 226.0, 29.5, 22.0 ],
                                    "text": "/"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "linecount": 2,
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 77.0, 47.25, 121.0, 35.0 ],
                                    "text": "param decayms 250 @min 0.001"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 76.5, 250.0, 25.0, 22.0 ],
                                    "text": "t60"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "linecount": 2,
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 400.0, 47.25, 106.67741870880127, 35.0 ],
                                    "text": "param lfodepth 0 @min 0 @max 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 305.5, 140.75, 53.0, 22.0 ],
                                    "text": "*"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 306.0, 47.25, 89.0, 22.0 ],
                                    "text": "param lforate 8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 305.5, 116.75, 36.0, 22.0 ],
                                    "text": "cycle"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 46.0, 444.0, 36.0, 22.0 ],
                                    "text": "*"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 157.0, 482.0, 194.0, 22.0 ],
                                    "text": "param drywet 0.5 @min 0 @max 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 8.0, 510.0, 95.0, 22.0 ],
                                    "text": "mix"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 201.0, 116.75, 70.0, 22.0 ],
                                    "text": "mstosamps"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 8.0, 47.25, 61.0, 22.0 ],
                                    "text": "in 1 audio"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "linecount": 2,
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 201.5, 47.25, 101.0, 35.0 ],
                                    "text": "param delaytime @min 0"
                                }
                            },
                            {
                                "box": {
                                    "fontsize": 14.0,
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 46.0, 322.0, 174.0, 24.0 ],
                                    "text": "delay"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 8.0, 534.0, 68.0, 22.0 ],
                                    "text": "out 1 audio"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "midpoints": [ 17.5, 135.5, 55.5, 135.5 ],
                                    "order": 0,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "order": 1,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 1 ],
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 1 ],
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 1 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "source": [ "obj-18", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-11", 1 ],
                                    "source": [ "obj-19", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 1 ],
                                    "midpoints": [ 409.0, 137.5, 349.0, 137.5 ],
                                    "source": [ "obj-20", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-21", 0 ]
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
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-23", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "source": [ "obj-24", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.0, 0.0, 0.0, 1.0 ],
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-28", 0 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 1 ],
                                    "midpoints": [ 210.5, 221.75, 96.5, 221.75 ],
                                    "order": 2,
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 1 ],
                                    "order": 1,
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "midpoints": [ 210.5, 221.25, 229.66666132211685, 221.25 ],
                                    "order": 0,
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "source": [ "obj-28", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 2 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.0, 0.0, 0.0, 1.0 ],
                                    "destination": [ "obj-30", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.0, 0.0, 0.0, 1.0 ],
                                    "destination": [ "obj-9", 0 ],
                                    "source": [ "obj-30", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "midpoints": [ 296.5, 192.625, 210.5, 192.625 ],
                                    "source": [ "obj-41", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-20", 1 ],
                                    "midpoints": [ 525.5, 87.25, 453.0, 87.25 ],
                                    "order": 0,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-21", 1 ],
                                    "midpoints": [ 525.5, 87.25, 359.0, 87.25 ],
                                    "order": 1,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-23", 1 ],
                                    "midpoints": [ 525.5, 87.25, 254.5, 87.25 ],
                                    "order": 2,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-26", 1 ],
                                    "midpoints": [ 525.5, 87.25, 130.0, 87.25 ],
                                    "order": 5,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-29", 1 ],
                                    "midpoints": [ 525.5, 507.125, 210.5, 507.125 ],
                                    "order": 3,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.847058823529412, 0.847058823529412, 0.847058823529412, 1.0 ],
                                    "destination": [ "obj-49", 1 ],
                                    "midpoints": [ 525.5, 380.125, 210.5, 380.125 ],
                                    "order": 4,
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-49", 0 ],
                                    "source": [ "obj-48", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-30", 1 ],
                                    "source": [ "obj-49", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 0 ],
                                    "midpoints": [ 210.5, 151.25, 296.5, 151.25 ],
                                    "order": 0,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "color": [ 0.0, 0.0, 0.0, 1.0 ],
                                    "destination": [ "obj-11", 0 ],
                                    "midpoints": [ 55.5, 475.51612877845764, 34.45161294937134, 475.51612877845764, 34.45161294937134, 261.0, 70.5, 261.0 ],
                                    "order": 0,
                                    "source": [ "obj-9", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 1 ],
                                    "order": 1,
                                    "source": [ "obj-9", 0 ]
                                }
                            }
                        ],
                        "bgcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                    },
                    "patching_rect": [ 774.1538546383381, 611.0000002384186, 328.0, 22.0 ],
                    "text": "gen~ @title multi-effects",
                    "varname": "gen~_AA"
                }
            },
            {
                "box": {
                    "attr": "delaytime",
                    "id": "obj-197",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 776.8461593985558, 528.8333353598912, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 32.0, 485.0, 187.0, 22.0 ],
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "invert",
                    "displaymode": 8,
                    "id": "obj-198",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1144.692692399025, 588.2681332826614, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 224.0, 508.0, 187.0, 22.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "lfodepth",
                    "id": "obj-199",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 776.8461593985558, 581.8333333333335, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 32.0, 534.0, 187.0, 22.0 ],
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "decayms",
                    "id": "obj-200",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1144.692692399025, 541.3407608270645, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 224.0, 461.0, 187.0, 22.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "attr": "dampen",
                    "id": "obj-201",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1144.692692399025, 565.3631062507629, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 224.0, 485.0, 187.0, 22.0 ],
                    "tricolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 20.99999988079071, 62.66666853427887, 68.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 59.0, 40.0, 41.99999988079071, 20.0 ],
                    "text": "start",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 413.6666657924652, 669.0000002384186, 228.0, 20.0 ],
                    "text": "waveform~ @buffername #0-grainEnv ",
                    "textcolor": [ 0.082352941176471, 0.250980392156863, 0.537254901960784, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-63",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 413.6666657924652, 474.0, 228.0, 20.0 ],
                    "text": "waveform~ @buffername #0-grain-Buffer",
                    "textcolor": [ 0.082352941176471, 0.250980392156863, 0.537254901960784, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 547.5793288648129, 77.66666853427887, 193.0, 20.0 ],
                    "text": "< -- selecionar puntos de partida ",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-27",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 500.26682886481285, 142.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 441.26682886481285, 142.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-2",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 440.26682886481285, 83.33333218097687, 75.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 220.0, 39.0, 45.0, 20.0 ],
                    "text": "pitch",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "bordercolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-115",
                    "maxclass": "rslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 440.26682886481285, 110.33333218097687, 110.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 221.0, 61.0, 68.0, 23.0 ],
                    "size": 9.0
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 376.26682886481285, 154.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 317.26682886481285, 154.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 254.26682886481285, 154.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 195.26682886481285, 154.33333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 571.9999998807907, 239.30158614923084, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 571.9999998807907, 213.30158614923084, 100.0, 22.0 ],
                    "text": "transratio"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 571.9999998807907, 182.30158614923084, 29.5, 22.0 ],
                    "text": "- 1"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-55",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 316.26682886481285, 83.33333218097687, 75.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 130.5, 92.0, 75.0, 20.0 ],
                    "text": "time",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-54",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 195.26682886481285, 83.33333218097687, 105.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 131.0, 39.0, 66.0, 20.0 ],
                    "text": "position",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 571.9999998807907, 124.30158614923084, 196.0, 34.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 222.0, 104.0, 196.0, 34.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 101.99999988079071, 92.83333218097687, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "bordercolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-113",
                    "maxclass": "rslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 316.26682886481285, 110.33333218097687, 110.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 130.5, 114.0, 79.0, 23.0 ],
                    "size": 3000.0
                }
            },
            {
                "box": {
                    "bordercolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-112",
                    "maxclass": "rslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 195.26682886481285, 110.33333218097687, 110.0, 23.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 130.0, 61.0, 67.0, 23.0 ],
                    "size": 5000.0
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 445.26682886481285, 208.33333218097687, 111.0, 22.0 ],
                    "text": "s #0-grainPitchLow"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 316.26682886481285, 212.33333218097687, 105.0, 22.0 ],
                    "text": "s #0-grainDurLow"
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 190.26682886481285, 212.33333218097687, 109.0, 22.0 ],
                    "text": "s #0-grainStartLow"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 445.26682886481285, 181.33333218097687, 100.0, 22.0 ],
                    "text": "s #0-grainPitchHi"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 317.26682886481285, 187.33333218097687, 100.0, 22.0 ],
                    "text": "s #0-grainDurHi"
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 195.26682886481285, 187.33333218097687, 100.0, 22.0 ],
                    "text": "s #0-grainStartHi"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 20.99999988079071, 181.33333218097687, 50.0, 22.0 ],
                    "text": "60"
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 36.99999988079071, 299.83333218097687, 115.0, 22.0 ],
                    "text": "steal 1, parallel 1"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 413.6666657924652, 619.5000002384186, 180.0, 22.0 ],
                    "text": "fill 1 512, apply hamming"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 413.6666657924652, 645.0000002384186, 180.0, 22.0 ],
                    "text": "buffer~ #0-grainEnv 512"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 413.6666657924652, 590.5000002384186, 100.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "buffername": "#0-grainEnv",
                    "id": "obj-15",
                    "maxclass": "waveform~",
                    "numinlets": 5,
                    "numoutlets": 6,
                    "outlettype": [ "float", "float", "float", "float", "list", "" ],
                    "patching_rect": [ 612.9791657924652, 588.8333406448364, 72.0, 57.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 238.0, 250.0, 139.0, 57.0 ],
                    "waveformcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 567.2668288648129, 371.5000002384186, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 545.9791657924652, 427.4999979734421, 139.0, 35.0 ],
                    "text": "anti-austerity-protest-athens-greece.wav"
                }
            },
            {
                "box": {
                    "id": "obj-76",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 411.6666657924652, 440.9999979734421, 118.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 409.26682886481285, 399.5000002384186, 125.0, 22.0 ],
                    "text": "info~ #0-grain-Buffer"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "buffername": "#0-grain-Buffer",
                    "id": "obj-17",
                    "maxclass": "waveform~",
                    "numinlets": 5,
                    "numoutlets": 6,
                    "outlettype": [ "float", "float", "float", "float", "list", "" ],
                    "patching_rect": [ 413.6666657924652, 493.5000002384186, 271.0, 92.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 32.0, 247.0, 177.0, 63.0 ],
                    "waveformcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 409.26682886481285, 372.5000002384186, 145.0, 22.0 ],
                    "text": "buffer~ #0-grain-Buffer"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "float", "float" ],
                    "patching_rect": [ 20.99999988079071, 208.33333218097687, 139.0, 22.0 ],
                    "text": "makenote 60 100"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 20.99999988079071, 149.33333218097687, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 20.99999988079071, 237.33333218097687, 48.0, 22.0 ],
                    "text": "pack"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 20.99999988079071, 266.33333218097687, 135.0, 22.0 ],
                    "text": "midinote $1 $1"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 20.99999988079071, 122.33333218097687, 100.0, 22.0 ],
                    "text": "metro 20"
                }
            },
            {
                "box": {
                    "checkedcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-3",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 20.99999988079071, 86.33333218097687, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 29.0, 38.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patching_rect": [ 20.99999988079071, 346.83333218097687, 221.0, 22.0 ],
                    "text": "poly~ grains 16 args #0",
                    "varname": "poly~_AA"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-94", 1 ],
                    "midpoints": [ 232.4999998807907, 402.0, 40.0, 402.0, 40.0, 760.0, 66.05555109182993, 760.0 ],
                    "source": [ "obj-1", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 42.5, 1107.0, 18.0, 1107.0, 18.0, 816.0, 402.5, 816.0 ],
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
                    "destination": [ "obj-110", 0 ],
                    "midpoints": [ 402.5, 1194.0, 756.0, 1194.0, 756.0, 927.0, 771.3461593985558, 927.0 ],
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
                    "destination": [ "obj-7", 3 ],
                    "midpoints": [ 1168.653854638338, 864.0, 942.0, 864.0, 942.0, 816.0, 552.5, 816.0 ],
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 0 ],
                    "midpoints": [ 581.4999998807907, 1194.0, 756.0, 1194.0, 756.0, 831.0, 771.3461593985558, 831.0 ],
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-18", 0 ],
                    "midpoints": [ 295.76682886481285, 135.3650782127229, 263.76682886481285, 135.3650782127229 ],
                    "source": [ "obj-112", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "source": [ "obj-112", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20", 0 ],
                    "midpoints": [ 416.76682886481285, 135.3650782127229, 385.76682886481285, 135.3650782127229 ],
                    "source": [ "obj-113", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-113", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-125", 0 ],
                    "midpoints": [ 1261.961543649435, 885.0, 1227.0, 885.0, 1227.0, 786.0, 982.5, 786.0 ],
                    "source": [ "obj-114", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-27", 0 ],
                    "source": [ "obj-115", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-31", 0 ],
                    "source": [ "obj-115", 0 ]
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
                    "destination": [ "obj-136", 0 ],
                    "source": [ "obj-119", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-80", 0 ],
                    "midpoints": [ 544.7668288648129, 390.5000002384186, 560.7668288648129, 390.5000002384186, 560.7668288648129, 360.5000002384186, 576.7668288648129, 360.5000002384186 ],
                    "source": [ "obj-12", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-120", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "source": [ "obj-121", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-114", 0 ],
                    "source": [ "obj-122", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-124", 0 ],
                    "source": [ "obj-123", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 3 ],
                    "midpoints": [ 1046.5, 864.0, 942.0, 864.0, 942.0, 816.0, 731.4999998807907, 816.0 ],
                    "source": [ "obj-124", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-127", 0 ],
                    "source": [ "obj-125", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-53", 0 ],
                    "source": [ "obj-126", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 3 ],
                    "midpoints": [ 982.5, 855.0, 942.0, 855.0, 942.0, 816.0, 731.4999998807907, 816.0 ],
                    "source": [ "obj-127", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-129", 0 ],
                    "source": [ "obj-128", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 3 ],
                    "midpoints": [ 1106.5, 864.0, 942.0, 864.0, 942.0, 816.0, 731.4999998807907, 816.0 ],
                    "source": [ "obj-129", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 0 ],
                    "order": 0,
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-28", 0 ],
                    "order": 1,
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-59", 0 ],
                    "source": [ "obj-132", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-123", 0 ],
                    "midpoints": [ 1298.4480085670948, 894.0, 1227.0, 894.0, 1227.0, 786.0, 1046.5, 786.0 ],
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-128", 0 ],
                    "midpoints": [ 1330.961543649435, 894.0, 1227.0, 894.0, 1227.0, 786.0, 1106.5, 786.0 ],
                    "source": [ "obj-135", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 0 ],
                    "midpoints": [ 1364.2692412436008, 894.0, 1227.0, 894.0, 1227.0, 786.0, 1168.653854638338, 786.0 ],
                    "source": [ "obj-136", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 0 ],
                    "source": [ "obj-139", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-11", 0 ],
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-149", 1 ],
                    "source": [ "obj-141", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-132", 0 ],
                    "source": [ "obj-149", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-149", 2 ],
                    "source": [ "obj-151", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-64", 0 ],
                    "source": [ "obj-16", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1154.192692399025, 612.5, 783.6538546383381, 612.5 ],
                    "source": [ "obj-168", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-182", 0 ],
                    "source": [ "obj-170", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-170", 0 ],
                    "source": [ "obj-171", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-184", 0 ],
                    "source": [ "obj-171", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-186", 0 ],
                    "source": [ "obj-171", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-175", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1266.9480085670948, 481.5, 1206.0, 481.5, 1206.0, 469.5, 851.8461593985558, 469.5 ],
                    "source": [ "obj-174", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-178", 1 ],
                    "source": [ "obj-175", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 786.3461593985558, 612.1666694879532, 783.6538546383381, 612.1666694879532 ],
                    "source": [ "obj-178", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-178", 0 ],
                    "source": [ "obj-179", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "midpoints": [ 263.76682886481285, 177.3650782127229, 191.26682886481285, 177.3650782127229, 191.26682886481285, 207.3650782127229, 199.76682886481285, 207.3650782127229 ],
                    "source": [ "obj-18", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 786.3461593985558, 614.9166666666667, 783.6538546383381, 614.9166666666667 ],
                    "source": [ "obj-192", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1154.192692399025, 613.5833333333333, 783.6538546383381, 613.5833333333333 ],
                    "source": [ "obj-193", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-171", 0 ],
                    "source": [ "obj-196", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-172", 0 ],
                    "hidden": 1,
                    "midpoints": [ 783.6538546383381, 629.4315649271011, 1058.653854638338, 629.4315649271011 ],
                    "order": 0,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-173", 0 ],
                    "midpoints": [ 783.6538546383381, 646.75, 783.6538546383381, 646.75 ],
                    "order": 2,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-32", 0 ],
                    "midpoints": [ 783.6538546383381, 659.5, 710.3461601436138, 659.5 ],
                    "order": 3,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-453", 0 ],
                    "midpoints": [ 783.6538546383381, 659.5, 809.8461593985558, 659.5 ],
                    "order": 1,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 786.3461593985558, 612.5, 783.6538546383381, 612.5 ],
                    "source": [ "obj-197", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1154.192692399025, 611.75, 783.6538546383381, 611.75 ],
                    "source": [ "obj-198", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 786.3461593985558, 612.3333333333333, 783.6538546383381, 612.3333333333333 ],
                    "source": [ "obj-199", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 0 ],
                    "midpoints": [ 385.76682886481285, 177.3650782127229, 311.26682886481285, 177.3650782127229, 311.26682886481285, 204.3650782127229, 325.76682886481285, 204.3650782127229 ],
                    "source": [ "obj-20", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1154.192692399025, 613.0, 783.6538546383381, 613.0 ],
                    "source": [ "obj-200", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1154.192692399025, 611.1666666666667, 783.6538546383381, 611.1666666666667 ],
                    "source": [ "obj-201", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-323", 0 ],
                    "source": [ "obj-208", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-25", 0 ],
                    "source": [ "obj-21", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 0 ],
                    "source": [ "obj-22", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-26", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-34", 0 ],
                    "midpoints": [ 509.76682886481285, 169.3650782127229, 433.26682886481285, 169.3650782127229, 433.26682886481285, 204.3650782127229, 454.76682886481285, 204.3650782127229 ],
                    "source": [ "obj-27", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "source": [ "obj-28", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-72", 0 ],
                    "source": [ "obj-29", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-3", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-47", 0 ],
                    "hidden": 1,
                    "source": [ "obj-30", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 0 ],
                    "midpoints": [ 450.76682886481285, 174.3650782127229, 454.76682886481285, 174.3650782127229 ],
                    "source": [ "obj-31", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 0 ],
                    "midpoints": [ 710.3461601436138, 731.22265625, 825.8461601436138, 731.22265625 ],
                    "source": [ "obj-32", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-322", 0 ],
                    "source": [ "obj-320", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-208", 0 ],
                    "source": [ "obj-321", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-321", 0 ],
                    "source": [ "obj-322", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 0 ],
                    "source": [ "obj-323", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-50", 0 ],
                    "hidden": 1,
                    "source": [ "obj-33", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-92", 0 ],
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 7 ],
                    "midpoints": [ 1306.461543649435, 279.0, 1146.0, 279.0, 1146.0, 105.0, 1127.0961570441723, 105.0 ],
                    "source": [ "obj-40", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 1 ],
                    "source": [ "obj-41", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-45", 0 ],
                    "source": [ "obj-43", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-443", 0 ],
                    "hidden": 1,
                    "source": [ "obj-435", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-444", 0 ],
                    "hidden": 1,
                    "source": [ "obj-439", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-109", 0 ],
                    "source": [ "obj-44", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-445", 0 ],
                    "hidden": 1,
                    "source": [ "obj-440", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 7 ],
                    "midpoints": [ 1313.461543649435, 192.0, 1299.0, 192.0, 1299.0, 45.0, 938.3461608886719, 45.0 ],
                    "source": [ "obj-443", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 6 ],
                    "midpoints": [ 1248.7692388892174, 192.0, 1146.0, 192.0, 1146.0, 45.0, 916.6318749615125, 45.0 ],
                    "source": [ "obj-444", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 5 ],
                    "midpoints": [ 1171.7692388892174, 192.0, 1146.0, 192.0, 1146.0, 45.0, 894.917589034353, 45.0 ],
                    "source": [ "obj-445", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-32", 0 ],
                    "midpoints": [ 786.3461593985558, 295.5, 759.0, 295.5, 759.0, 613.5, 710.3461601436138, 613.5 ],
                    "order": 2,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-435", 0 ],
                    "hidden": 1,
                    "midpoints": [ 862.3461601436138, 285.0, 1146.0, 285.0, 1146.0, 111.0, 1313.461543649435, 111.0 ],
                    "source": [ "obj-446", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-439", 0 ],
                    "hidden": 1,
                    "midpoints": [ 837.0128265619278, 285.0, 1146.0, 285.0, 1146.0, 111.0, 1246.3942388892174, 111.0 ],
                    "source": [ "obj-446", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-440", 0 ],
                    "hidden": 1,
                    "midpoints": [ 811.6794929802418, 285.0, 1146.0, 285.0, 1146.0, 156.0, 1248.0, 156.0, 1248.0, 147.0, 1166.7692388892174, 147.0 ],
                    "source": [ "obj-446", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-441", 1 ],
                    "midpoints": [ 786.3461593985558, 295.5, 1046.9711593985558, 295.5 ],
                    "order": 0,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-453", 0 ],
                    "midpoints": [ 786.3461593985558, 294.0, 759.0, 294.0, 759.0, 639.0, 809.8461593985558, 639.0 ],
                    "order": 1,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-46", 0 ],
                    "source": [ "obj-45", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 0 ],
                    "source": [ "obj-450", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 1 ],
                    "midpoints": [ 809.8461593985558, 731.74609375, 898.8461601436138, 731.74609375 ],
                    "source": [ "obj-453", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-49", 0 ],
                    "source": [ "obj-46", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 6 ],
                    "midpoints": [ 1244.461543649435, 279.0, 1146.0, 279.0, 1146.0, 96.0, 1104.5604430947985, 96.0 ],
                    "source": [ "obj-47", 0 ]
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
                    "destination": [ "obj-36", 0 ],
                    "midpoints": [ 581.4999998807907, 262.33333218097687, 438.9999998807907, 262.33333218097687, 438.9999998807907, 142.33333218097687, 454.76682886481285, 142.33333218097687 ],
                    "source": [ "obj-49", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 0 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 5 ],
                    "midpoints": [ 1165.9615412950516, 270.0, 1146.0, 270.0, 1146.0, 96.0, 1082.0247291454248, 96.0 ],
                    "source": [ "obj-50", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-60", 0 ],
                    "source": [ "obj-53", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-30", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1021.9294919470946, 285.0, 1146.0, 285.0, 1146.0, 192.0, 1242.086543649435, 192.0 ],
                    "source": [ "obj-56", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "hidden": 1,
                    "midpoints": [ 995.6378256728252, 285.0, 1230.0, 285.0, 1230.0, 228.0, 1251.0, 228.0, 1251.0, 222.0, 1160.9615412950516, 222.0 ],
                    "source": [ "obj-56", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-68", 1 ],
                    "order": 0,
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-70", 0 ],
                    "midpoints": [ 969.3461593985558, 294.0, 702.0, 294.0, 702.0, 654.0, 687.0, 654.0, 687.0, 690.0, 492.0, 690.0, 492.0, 702.0, 491.1666657924652, 702.0 ],
                    "order": 2,
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 969.3461593985558, 294.0, 702.0, 294.0, 702.0, 654.0, 687.0, 654.0, 687.0, 690.0, 600.989582836628, 690.0 ],
                    "order": 1,
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1048.221158221364, 285.0, 1293.0, 285.0, 1293.0, 216.0, 1306.461543649435, 216.0 ],
                    "source": [ "obj-56", 3 ]
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
                    "destination": [ "obj-13", 0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-112", 0 ],
                    "source": [ "obj-60", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 66.16666662693024, 590.083340883255, 24.166666507720947, 590.083340883255 ],
                    "source": [ "obj-61", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-61", 0 ],
                    "source": [ "obj-62", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-65", 0 ],
                    "source": [ "obj-64", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 335.1666622161865, 590.083340883255, 24.166666507720947, 590.083340883255 ],
                    "source": [ "obj-65", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 0 ],
                    "source": [ "obj-66", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-108", 0 ],
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-97", 0 ],
                    "midpoints": [ 491.1666657924652, 741.0, 702.0, 741.0, 702.0, 702.0, 726.5, 702.0 ],
                    "source": [ "obj-70", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-97", 1 ],
                    "midpoints": [ 600.989582836628, 738.0, 810.0, 738.0, 810.0, 702.0, 799.5, 702.0 ],
                    "source": [ "obj-71", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-75", 0 ],
                    "source": [ "obj-72", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-112", 1 ],
                    "source": [ "obj-73", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-76", 0 ],
                    "midpoints": [ 489.43349553147954, 402.0000002384186, 423.6666657924652, 402.0000002384186, 423.6666657924652, 408.0000002384186, 421.1666657924652, 408.0000002384186 ],
                    "source": [ "obj-74", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-78", 1 ],
                    "midpoints": [ 501.2112733092573, 402.0000002384186, 540.6666657924652, 402.0000002384186, 540.6666657924652, 378.0000002384186, 675.4791657924652, 378.0000002384186 ],
                    "source": [ "obj-74", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 263.1666622161865, 590.083340883255, 24.166666507720947, 590.083340883255 ],
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-73", 0 ],
                    "source": [ "obj-77", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 0 ],
                    "hidden": 1,
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-74", 0 ],
                    "midpoints": [ 576.7668288648129, 399.0000002384186, 418.76682886481285, 399.0000002384186 ],
                    "source": [ "obj-80", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-113", 1 ],
                    "order": 1,
                    "source": [ "obj-81", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-115", 0 ],
                    "order": 0,
                    "source": [ "obj-81", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 0 ],
                    "source": [ "obj-82", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-113", 0 ],
                    "source": [ "obj-83", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 3 ],
                    "source": [ "obj-86", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-86", 0 ],
                    "source": [ "obj-87", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-87", 0 ],
                    "source": [ "obj-88", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-90", 0 ],
                    "source": [ "obj-89", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 2 ],
                    "source": [ "obj-90", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-89", 0 ],
                    "source": [ "obj-91", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 0 ],
                    "source": [ "obj-92", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 191.16666221618652, 590.083340883255, 24.166666507720947, 590.083340883255 ],
                    "source": [ "obj-93", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 24.166666507720947, 786.0, 696.0, 786.0, 696.0, 606.0, 783.6538546383381, 606.0 ],
                    "order": 0,
                    "source": [ "obj-94", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-70", 0 ],
                    "midpoints": [ 24.166666507720947, 786.0, 468.0, 786.0, 468.0, 702.0, 491.1666657924652, 702.0 ],
                    "order": 1,
                    "source": [ "obj-94", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 149.8333202600479, 777.0, 588.0, 777.0, 588.0, 699.0, 600.989582836628, 699.0 ],
                    "source": [ "obj-94", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 0 ],
                    "source": [ "obj-95", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "midpoints": [ 825.8461601436138, 816.0, 220.9999998807907, 816.0 ],
                    "source": [ "obj-96", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-103", 0 ],
                    "midpoints": [ 726.5, 816.0, 42.5, 816.0 ],
                    "source": [ "obj-97", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 0 ],
                    "midpoints": [ 220.9999998807907, 1116.0, 390.0, 1116.0, 390.0, 816.0, 581.4999998807907, 816.0 ],
                    "source": [ "obj-98", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-102::obj-112": [ "HighPass", "HighPass", 0 ],
            "obj-102::obj-154": [ "Abl.ChannelEQ", "Abl.ChannelEQ", 0 ],
            "obj-102::obj-167": [ "ModOutB[5]", "ModOutB", -1 ],
            "obj-102::obj-45": [ "ModInALed[5]", "ModInALed", 0 ],
            "obj-102::obj-47": [ "ModInBLed[5]", "ModInBLed", 0 ],
            "obj-102::obj-49": [ "ModInA[5]", "ModInA", -1 ],
            "obj-102::obj-50": [ "ModInB[5]", "ModInB", -1 ],
            "obj-102::obj-52": [ "ModOutA[5]", "ModOutA", -1 ],
            "obj-102::obj-59": [ "ModOutALed[5]", "ModOutALed", 0 ],
            "obj-102::obj-6": [ "Mid[3]", "Mid", 0 ],
            "obj-102::obj-60": [ "ModOutBLed[5]", "ModOutBLed", 0 ],
            "obj-102::obj-8": [ "MidF", "MidF", 0 ],
            "obj-102::obj-81": [ "Low", "Low", 0 ],
            "obj-102::obj-82": [ "Gain[5]", "Gain", 0 ],
            "obj-102::obj-9": [ "High", "High", 0 ],
            "obj-102::obj-99": [ "Active[5]", "Active", 0 ],
            "obj-103::obj-154": [ "Abl.Compressor", "Abl.Compressor", 0 ],
            "obj-103::obj-167": [ "ModOutB", "ModOutB", -1 ],
            "obj-103::obj-45": [ "ModInALed", "ModInALed", 0 ],
            "obj-103::obj-47": [ "ModInBLed", "ModInBLed", 0 ],
            "obj-103::obj-49": [ "ModInA", "ModInA", -1 ],
            "obj-103::obj-50": [ "ModInB", "ModInB", -1 ],
            "obj-103::obj-52": [ "ModOutA", "ModOutA", -1 ],
            "obj-103::obj-59": [ "ModOutALed", "ModOutALed", 0 ],
            "obj-103::obj-6": [ "Rel", "Rel", 0 ],
            "obj-103::obj-60": [ "ModOutBLed", "ModOutBLed", 0 ],
            "obj-103::obj-8": [ "Thresh", "Thresh", 0 ],
            "obj-103::obj-81": [ "Att", "Att", 0 ],
            "obj-103::obj-82": [ "Gain[4]", "Gain", 0 ],
            "obj-103::obj-9": [ "Ratio", "Ratio", 0 ],
            "obj-103::obj-99": [ "Active", "Active", 0 ],
            "obj-104::obj-112": [ "Sub", "Sub", 0 ],
            "obj-104::obj-116": [ "MidRange", "MidRange", 0 ],
            "obj-104::obj-154": [ "Abl.Overdrive", "Abl.Overdrive", 0 ],
            "obj-104::obj-167": [ "ModOutB[20]", "ModOutB", -1 ],
            "obj-104::obj-45": [ "ModInALed[20]", "ModInALed", 0 ],
            "obj-104::obj-47": [ "ModInBLed[20]", "ModInBLed", 0 ],
            "obj-104::obj-49": [ "ModInA[20]", "ModInA", -1 ],
            "obj-104::obj-50": [ "ModInB[20]", "ModInB", -1 ],
            "obj-104::obj-52": [ "ModOutA[20]", "ModOutA", -1 ],
            "obj-104::obj-59": [ "ModOutALed[20]", "ModOutALed", 0 ],
            "obj-104::obj-6": [ "Bass", "Bass", 0 ],
            "obj-104::obj-60": [ "ModOutBLed[20]", "ModOutBLed", 0 ],
            "obj-104::obj-8": [ "Mid", "Mid", 0 ],
            "obj-104::obj-81": [ "Gain", "Gain", 0 ],
            "obj-104::obj-82": [ "Mix[5]", "Mix", 0 ],
            "obj-104::obj-9": [ "Treble", "Treble", 0 ],
            "obj-104::obj-99": [ "Active[20]", "Active", 0 ],
            "obj-107::obj-112": [ "AutoRelease", "AutoRelease", 0 ],
            "obj-107::obj-116": [ "Lookahead", "Lookahead", 0 ],
            "obj-107::obj-154": [ "Abl.Limiter", "Abl.Limiter", 0 ],
            "obj-107::obj-167": [ "ModOutB[11]", "ModOutB", -1 ],
            "obj-107::obj-45": [ "ModInALed[11]", "ModInALed", 0 ],
            "obj-107::obj-47": [ "ModInBLed[11]", "ModInBLed", 0 ],
            "obj-107::obj-49": [ "ModInA[11]", "ModInA", -1 ],
            "obj-107::obj-50": [ "ModInB[11]", "ModInB", -1 ],
            "obj-107::obj-52": [ "ModOutA[11]", "ModOutA", -1 ],
            "obj-107::obj-59": [ "ModOutALed[11]", "ModOutALed", 0 ],
            "obj-107::obj-6": [ "Gain[10]", "Gain", 0 ],
            "obj-107::obj-60": [ "ModOutBLed[11]", "ModOutBLed", 0 ],
            "obj-107::obj-8": [ "Ceil", "Ceil", 0 ],
            "obj-107::obj-9": [ "Rel[2]", "Rel", 0 ],
            "obj-107::obj-99": [ "Active[12]", "Active", 0 ],
            "obj-108::obj-154": [ "Abl.PlateReverb", "Abl.PlateReverb", 0 ],
            "obj-108::obj-167": [ "ModOutB[10]", "ModOutB", -1 ],
            "obj-108::obj-4": [ "Mix", "Mix", 0 ],
            "obj-108::obj-45": [ "ModInALed[10]", "ModInALed", 0 ],
            "obj-108::obj-47": [ "ModInBLed[10]", "ModInBLed", 0 ],
            "obj-108::obj-49": [ "ModInA[10]", "ModInA", -1 ],
            "obj-108::obj-50": [ "ModInB[10]", "ModInB", -1 ],
            "obj-108::obj-52": [ "ModOutA[10]", "ModOutA", -1 ],
            "obj-108::obj-59": [ "ModOutALed[10]", "ModOutALed", 0 ],
            "obj-108::obj-6": [ "PreDel", "PreDel", 0 ],
            "obj-108::obj-60": [ "ModOutBLed[10]", "ModOutBLed", 0 ],
            "obj-108::obj-8": [ "Decay", "Decay", 0 ],
            "obj-108::obj-81": [ "DampF", "DampF", 0 ],
            "obj-108::obj-99": [ "Active[11]", "Active", 0 ],
            "obj-110::obj-154": [ "Abl.Output", "Abl.Output", 0 ],
            "obj-110::obj-17": [ "Dac", "Dac", 0 ],
            "obj-110::obj-44": [ "Limiter", "Limiter", 0 ],
            "obj-110::obj-49": [ "ModIn", "ModIn", -1 ],
            "obj-110::obj-60": [ "ModOutLed", "ModOutLed", 0 ],
            "obj-110::obj-69": [ "ModOut", "ModOut", -1 ],
            "obj-110::obj-71": [ "ModInLed", "ModInLed", 0 ],
            "obj-110::obj-8": [ "Gain[8]", "Gain", 0 ],
            "obj-110::obj-99": [ "Active[8]", "Active", 0 ],
            "obj-111::obj-112": [ "AutoRelease[1]", "AutoRelease", 0 ],
            "obj-111::obj-116": [ "Lookahead[1]", "Lookahead", 0 ],
            "obj-111::obj-154": [ "Abl.Limiter[1]", "Abl.Limiter", 0 ],
            "obj-111::obj-167": [ "ModOutB[15]", "ModOutB", -1 ],
            "obj-111::obj-45": [ "ModInALed[15]", "ModInALed", 0 ],
            "obj-111::obj-47": [ "ModInBLed[15]", "ModInBLed", 0 ],
            "obj-111::obj-49": [ "ModInA[15]", "ModInA", -1 ],
            "obj-111::obj-50": [ "ModInB[15]", "ModInB", -1 ],
            "obj-111::obj-52": [ "ModOutA[15]", "ModOutA", -1 ],
            "obj-111::obj-59": [ "ModOutALed[15]", "ModOutALed", 0 ],
            "obj-111::obj-6": [ "Gain[13]", "Gain", 0 ],
            "obj-111::obj-60": [ "ModOutBLed[15]", "ModOutBLed", 0 ],
            "obj-111::obj-8": [ "Ceil[1]", "Ceil", 0 ],
            "obj-111::obj-9": [ "Rel[3]", "Rel", 0 ],
            "obj-111::obj-99": [ "Active[17]", "Active", 0 ],
            "obj-116::obj-112": [ "Filter[1]", "Filter", 0 ],
            "obj-116::obj-116": [ "Smooth[1]", "Smooth", 0 ],
            "obj-116::obj-154": [ "Abl.Delay", "Abl.Delay", 0 ],
            "obj-116::obj-167": [ "ModOutB[13]", "ModOutB", -1 ],
            "obj-116::obj-19": [ "Freeze[1]", "Freeze", 0 ],
            "obj-116::obj-23": [ "PingPong[1]", "PingPong", 0 ],
            "obj-116::obj-44": [ "Eco[1]", "Eco", 0 ],
            "obj-116::obj-45": [ "ModInALed[13]", "ModInALed", 0 ],
            "obj-116::obj-47": [ "ModInBLed[13]", "ModInBLed", 0 ],
            "obj-116::obj-49": [ "ModInA[13]", "ModInA", -1 ],
            "obj-116::obj-50": [ "ModInB[13]", "ModInB", -1 ],
            "obj-116::obj-51": [ "MFreq[1]", "MFreq", 0 ],
            "obj-116::obj-52": [ "ModOutA[13]", "ModOutA", -1 ],
            "obj-116::obj-53": [ "Mix[10]", "Mix", 0 ],
            "obj-116::obj-54": [ "MFilt[1]", "MFilt", 0 ],
            "obj-116::obj-55": [ "MTime[1]", "MTime", 0 ],
            "obj-116::obj-58": [ "Link[1]", "Link", -1 ],
            "obj-116::obj-59": [ "ModOutALed[13]", "ModOutALed", 0 ],
            "obj-116::obj-6": [ "DelR[1]", "DelR", 0 ],
            "obj-116::obj-60": [ "ModOutBLed[13]", "ModOutBLed", 0 ],
            "obj-116::obj-8": [ "Feed[4]", "Feed", 0 ],
            "obj-116::obj-81": [ "DelL[1]", "DelL", 0 ],
            "obj-116::obj-82": [ "Width[4]", "Width", 0 ],
            "obj-116::obj-9": [ "Freq[1]", "Freq", 0 ],
            "obj-116::obj-99": [ "Active[15]", "Active", 0 ],
            "obj-117::obj-112": [ "Invert[1]", "Invert", 0 ],
            "obj-117::obj-154": [ "Abl.Chorus[1]", "Abl.Chorus", 0 ],
            "obj-117::obj-167": [ "ModOutB[12]", "ModOutB", -1 ],
            "obj-117::obj-4": [ "Mix[9]", "Mix", 0 ],
            "obj-117::obj-45": [ "ModInALed[12]", "ModInALed", 0 ],
            "obj-117::obj-47": [ "ModInBLed[12]", "ModInBLed", 0 ],
            "obj-117::obj-49": [ "ModInA[12]", "ModInA", -1 ],
            "obj-117::obj-50": [ "ModInB[12]", "ModInB", -1 ],
            "obj-117::obj-52": [ "ModOutA[12]", "ModOutA", -1 ],
            "obj-117::obj-59": [ "ModOutALed[12]", "ModOutALed", 0 ],
            "obj-117::obj-6": [ "Rate[1]", "Rate", 0 ],
            "obj-117::obj-60": [ "ModOutBLed[12]", "ModOutBLed", 0 ],
            "obj-117::obj-8": [ "Feed[3]", "Feed", 0 ],
            "obj-117::obj-81": [ "Mod[1]", "Mod", 0 ],
            "obj-117::obj-82": [ "Gain[12]", "Gain", 0 ],
            "obj-117::obj-9": [ "Width[3]", "Width", 0 ],
            "obj-117::obj-99": [ "Active[14]", "Active", 0 ],
            "obj-118::obj-154": [ "Abl.Output[1]", "Abl.Output", 0 ],
            "obj-118::obj-17": [ "Dac[1]", "Dac", 0 ],
            "obj-118::obj-44": [ "Limiter[1]", "Limiter", 0 ],
            "obj-118::obj-49": [ "ModIn[1]", "ModIn", -1 ],
            "obj-118::obj-60": [ "ModOutLed[1]", "ModOutLed", 0 ],
            "obj-118::obj-69": [ "ModOut[1]", "ModOut", -1 ],
            "obj-118::obj-71": [ "ModInLed[1]", "ModInLed", 0 ],
            "obj-118::obj-8": [ "Gain[11]", "Gain", 0 ],
            "obj-118::obj-99": [ "Active[13]", "Active", 0 ],
            "obj-179": [ "umenu[3]", "umenu", 0 ],
            "obj-208": [ "umenu[5]", "umenu[2]", 0 ],
            "obj-320": [ "button[14]", "button[14]", 0 ],
            "obj-48::obj-154": [ "Abl.Compressor[1]", "Abl.Compressor", 0 ],
            "obj-48::obj-167": [ "ModOutB[22]", "ModOutB", -1 ],
            "obj-48::obj-45": [ "ModInALed[22]", "ModInALed", 0 ],
            "obj-48::obj-47": [ "ModInBLed[22]", "ModInBLed", 0 ],
            "obj-48::obj-49": [ "ModInA[22]", "ModInA", -1 ],
            "obj-48::obj-50": [ "ModInB[22]", "ModInB", -1 ],
            "obj-48::obj-52": [ "ModOutA[22]", "ModOutA", -1 ],
            "obj-48::obj-59": [ "ModOutALed[22]", "ModOutALed", 0 ],
            "obj-48::obj-6": [ "Rel[5]", "Rel", 0 ],
            "obj-48::obj-60": [ "ModOutBLed[22]", "ModOutBLed", 0 ],
            "obj-48::obj-8": [ "Thresh[1]", "Thresh", 0 ],
            "obj-48::obj-81": [ "Att[1]", "Att", 0 ],
            "obj-48::obj-82": [ "Gain[17]", "Gain", 0 ],
            "obj-48::obj-9": [ "Ratio[1]", "Ratio", 0 ],
            "obj-48::obj-99": [ "Active[23]", "Active", 0 ],
            "obj-58::obj-112": [ "Sub[1]", "Sub", 0 ],
            "obj-58::obj-116": [ "MidRange[1]", "MidRange", 0 ],
            "obj-58::obj-154": [ "Abl.Overdrive[1]", "Abl.Overdrive", 0 ],
            "obj-58::obj-167": [ "ModOutB[23]", "ModOutB", -1 ],
            "obj-58::obj-45": [ "ModInALed[23]", "ModInALed", 0 ],
            "obj-58::obj-47": [ "ModInBLed[23]", "ModInBLed", 0 ],
            "obj-58::obj-49": [ "ModInA[23]", "ModInA", -1 ],
            "obj-58::obj-50": [ "ModInB[21]", "ModInB", -1 ],
            "obj-58::obj-52": [ "ModOutA[21]", "ModOutA", -1 ],
            "obj-58::obj-59": [ "ModOutALed[23]", "ModOutALed", 0 ],
            "obj-58::obj-6": [ "Bass[1]", "Bass", 0 ],
            "obj-58::obj-60": [ "ModOutBLed[23]", "ModOutBLed", 0 ],
            "obj-58::obj-8": [ "Mid[4]", "Mid", 0 ],
            "obj-58::obj-81": [ "Gain[16]", "Gain", 0 ],
            "obj-58::obj-82": [ "Mix[6]", "Mix", 0 ],
            "obj-58::obj-9": [ "Treble[1]", "Treble", 0 ],
            "obj-58::obj-99": [ "Active[24]", "Active", 0 ],
            "obj-62": [ "umenu", "umenu", 0 ],
            "obj-64": [ "flonum[2]", "flonum", 0 ],
            "obj-72": [ "flonum[1]", "flonum", 0 ],
            "obj-7::obj-112": [ "Invert", "Invert", 0 ],
            "obj-7::obj-154": [ "Abl.Chorus", "Abl.Chorus", 0 ],
            "obj-7::obj-167": [ "ModOutB[8]", "ModOutB", -1 ],
            "obj-7::obj-4": [ "Mix[8]", "Mix", 0 ],
            "obj-7::obj-45": [ "ModInALed[8]", "ModInALed", 0 ],
            "obj-7::obj-47": [ "ModInBLed[8]", "ModInBLed", 0 ],
            "obj-7::obj-49": [ "ModInA[8]", "ModInA", -1 ],
            "obj-7::obj-50": [ "ModInB[8]", "ModInB", -1 ],
            "obj-7::obj-52": [ "ModOutA[8]", "ModOutA", -1 ],
            "obj-7::obj-59": [ "ModOutALed[8]", "ModOutALed", 0 ],
            "obj-7::obj-6": [ "Rate", "Rate", 0 ],
            "obj-7::obj-60": [ "ModOutBLed[8]", "ModOutBLed", 0 ],
            "obj-7::obj-8": [ "Feed", "Feed", 0 ],
            "obj-7::obj-81": [ "Mod", "Mod", 0 ],
            "obj-7::obj-82": [ "Gain[15]", "Gain", 0 ],
            "obj-7::obj-9": [ "Width", "Width", 0 ],
            "obj-7::obj-99": [ "Active[9]", "Active", 0 ],
            "obj-88": [ "kslider[1]", "kslider[1]", 0 ],
            "obj-91": [ "kslider", "kslider", 0 ],
            "obj-92": [ "flonum", "flonum", 0 ],
            "obj-98::obj-112": [ "HighPass[1]", "HighPass", 0 ],
            "obj-98::obj-154": [ "Abl.ChannelEQ[1]", "Abl.ChannelEQ", 0 ],
            "obj-98::obj-167": [ "ModOutB[21]", "ModOutB", -1 ],
            "obj-98::obj-45": [ "ModInALed[21]", "ModInALed", 0 ],
            "obj-98::obj-47": [ "ModInBLed[21]", "ModInBLed", 0 ],
            "obj-98::obj-49": [ "ModInA[21]", "ModInA", -1 ],
            "obj-98::obj-50": [ "ModInB[23]", "ModInB", -1 ],
            "obj-98::obj-52": [ "ModOutA[23]", "ModOutA", -1 ],
            "obj-98::obj-59": [ "ModOutALed[21]", "ModOutALed", 0 ],
            "obj-98::obj-6": [ "Mid[5]", "Mid", 0 ],
            "obj-98::obj-60": [ "ModOutBLed[21]", "ModOutBLed", 0 ],
            "obj-98::obj-8": [ "MidF[1]", "MidF", 0 ],
            "obj-98::obj-81": [ "Low[1]", "Low", 0 ],
            "obj-98::obj-82": [ "Gain[18]", "Gain", 0 ],
            "obj-98::obj-9": [ "High[1]", "High", 0 ],
            "obj-98::obj-99": [ "Active[21]", "Active", 0 ],
            "parameter_overrides": {
                "obj-102::obj-45": {
                    "parameter_longname": "ModInALed[5]"
                },
                "obj-102::obj-47": {
                    "parameter_longname": "ModInBLed[5]"
                },
                "obj-102::obj-59": {
                    "parameter_longname": "ModOutALed[5]"
                },
                "obj-102::obj-6": {
                    "parameter_longname": "Mid[3]"
                },
                "obj-102::obj-60": {
                    "parameter_longname": "ModOutBLed[5]"
                },
                "obj-102::obj-82": {
                    "parameter_longname": "Gain[5]"
                },
                "obj-102::obj-99": {
                    "parameter_longname": "Active[5]"
                },
                "obj-103::obj-82": {
                    "parameter_longname": "Gain[4]"
                },
                "obj-104::obj-45": {
                    "parameter_longname": "ModInALed[20]"
                },
                "obj-104::obj-47": {
                    "parameter_longname": "ModInBLed[20]"
                },
                "obj-104::obj-59": {
                    "parameter_longname": "ModOutALed[20]"
                },
                "obj-104::obj-60": {
                    "parameter_longname": "ModOutBLed[20]"
                },
                "obj-104::obj-82": {
                    "parameter_longname": "Mix[5]"
                },
                "obj-104::obj-99": {
                    "parameter_longname": "Active[20]"
                },
                "obj-107::obj-45": {
                    "parameter_longname": "ModInALed[11]"
                },
                "obj-107::obj-47": {
                    "parameter_longname": "ModInBLed[11]"
                },
                "obj-107::obj-59": {
                    "parameter_longname": "ModOutALed[11]"
                },
                "obj-107::obj-6": {
                    "parameter_longname": "Gain[10]"
                },
                "obj-107::obj-60": {
                    "parameter_longname": "ModOutBLed[11]"
                },
                "obj-107::obj-9": {
                    "parameter_longname": "Rel[2]"
                },
                "obj-107::obj-99": {
                    "parameter_longname": "Active[12]"
                },
                "obj-108::obj-45": {
                    "parameter_longname": "ModInALed[10]"
                },
                "obj-108::obj-47": {
                    "parameter_longname": "ModInBLed[10]"
                },
                "obj-108::obj-59": {
                    "parameter_longname": "ModOutALed[10]"
                },
                "obj-108::obj-60": {
                    "parameter_longname": "ModOutBLed[10]"
                },
                "obj-108::obj-99": {
                    "parameter_longname": "Active[11]"
                },
                "obj-110::obj-8": {
                    "parameter_longname": "Gain[8]"
                },
                "obj-110::obj-99": {
                    "parameter_longname": "Active[8]"
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
                    "parameter_longname": "ModInALed[15]"
                },
                "obj-111::obj-47": {
                    "parameter_longname": "ModInBLed[15]"
                },
                "obj-111::obj-59": {
                    "parameter_longname": "ModOutALed[15]"
                },
                "obj-111::obj-6": {
                    "parameter_longname": "Gain[13]"
                },
                "obj-111::obj-60": {
                    "parameter_longname": "ModOutBLed[15]"
                },
                "obj-111::obj-8": {
                    "parameter_longname": "Ceil[1]"
                },
                "obj-111::obj-9": {
                    "parameter_longname": "Rel[3]"
                },
                "obj-111::obj-99": {
                    "parameter_longname": "Active[17]"
                },
                "obj-116::obj-112": {
                    "parameter_longname": "Filter[1]"
                },
                "obj-116::obj-116": {
                    "parameter_longname": "Smooth[1]"
                },
                "obj-116::obj-19": {
                    "parameter_longname": "Freeze[1]"
                },
                "obj-116::obj-23": {
                    "parameter_longname": "PingPong[1]"
                },
                "obj-116::obj-44": {
                    "parameter_longname": "Eco[1]"
                },
                "obj-116::obj-45": {
                    "parameter_longname": "ModInALed[13]"
                },
                "obj-116::obj-47": {
                    "parameter_longname": "ModInBLed[13]"
                },
                "obj-116::obj-51": {
                    "parameter_longname": "MFreq[1]"
                },
                "obj-116::obj-53": {
                    "parameter_longname": "Mix[10]"
                },
                "obj-116::obj-54": {
                    "parameter_longname": "MFilt[1]"
                },
                "obj-116::obj-55": {
                    "parameter_longname": "MTime[1]"
                },
                "obj-116::obj-58": {
                    "parameter_longname": "Link[1]"
                },
                "obj-116::obj-59": {
                    "parameter_longname": "ModOutALed[13]"
                },
                "obj-116::obj-6": {
                    "parameter_longname": "DelR[1]"
                },
                "obj-116::obj-60": {
                    "parameter_longname": "ModOutBLed[13]"
                },
                "obj-116::obj-8": {
                    "parameter_longname": "Feed[4]"
                },
                "obj-116::obj-81": {
                    "parameter_longname": "DelL[1]"
                },
                "obj-116::obj-82": {
                    "parameter_longname": "Width[4]"
                },
                "obj-116::obj-9": {
                    "parameter_longname": "Freq[1]"
                },
                "obj-116::obj-99": {
                    "parameter_longname": "Active[15]"
                },
                "obj-117::obj-112": {
                    "parameter_longname": "Invert[1]"
                },
                "obj-117::obj-154": {
                    "parameter_longname": "Abl.Chorus[1]"
                },
                "obj-117::obj-4": {
                    "parameter_longname": "Mix[9]"
                },
                "obj-117::obj-45": {
                    "parameter_longname": "ModInALed[12]"
                },
                "obj-117::obj-47": {
                    "parameter_longname": "ModInBLed[12]"
                },
                "obj-117::obj-59": {
                    "parameter_longname": "ModOutALed[12]"
                },
                "obj-117::obj-6": {
                    "parameter_longname": "Rate[1]"
                },
                "obj-117::obj-60": {
                    "parameter_longname": "ModOutBLed[12]"
                },
                "obj-117::obj-8": {
                    "parameter_longname": "Feed[3]"
                },
                "obj-117::obj-81": {
                    "parameter_longname": "Mod[1]"
                },
                "obj-117::obj-82": {
                    "parameter_longname": "Gain[12]"
                },
                "obj-117::obj-9": {
                    "parameter_longname": "Width[3]"
                },
                "obj-117::obj-99": {
                    "parameter_longname": "Active[14]"
                },
                "obj-118::obj-154": {
                    "parameter_longname": "Abl.Output[1]"
                },
                "obj-118::obj-44": {
                    "parameter_longname": "Limiter[1]"
                },
                "obj-118::obj-60": {
                    "parameter_longname": "ModOutLed[1]"
                },
                "obj-118::obj-71": {
                    "parameter_longname": "ModInLed[1]"
                },
                "obj-118::obj-8": {
                    "parameter_longname": "Gain[11]"
                },
                "obj-118::obj-99": {
                    "parameter_longname": "Active[13]"
                },
                "obj-48::obj-154": {
                    "parameter_longname": "Abl.Compressor[1]"
                },
                "obj-48::obj-45": {
                    "parameter_longname": "ModInALed[22]"
                },
                "obj-48::obj-47": {
                    "parameter_longname": "ModInBLed[22]"
                },
                "obj-48::obj-59": {
                    "parameter_longname": "ModOutALed[22]"
                },
                "obj-48::obj-6": {
                    "parameter_longname": "Rel[5]"
                },
                "obj-48::obj-60": {
                    "parameter_longname": "ModOutBLed[22]"
                },
                "obj-48::obj-8": {
                    "parameter_longname": "Thresh[1]"
                },
                "obj-48::obj-81": {
                    "parameter_longname": "Att[1]"
                },
                "obj-48::obj-82": {
                    "parameter_longname": "Gain[17]"
                },
                "obj-48::obj-9": {
                    "parameter_longname": "Ratio[1]"
                },
                "obj-48::obj-99": {
                    "parameter_longname": "Active[23]"
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
                    "parameter_longname": "ModInALed[23]"
                },
                "obj-58::obj-47": {
                    "parameter_longname": "ModInBLed[23]"
                },
                "obj-58::obj-59": {
                    "parameter_longname": "ModOutALed[23]"
                },
                "obj-58::obj-6": {
                    "parameter_longname": "Bass[1]"
                },
                "obj-58::obj-60": {
                    "parameter_longname": "ModOutBLed[23]"
                },
                "obj-58::obj-8": {
                    "parameter_longname": "Mid[4]"
                },
                "obj-58::obj-81": {
                    "parameter_longname": "Gain[16]"
                },
                "obj-58::obj-82": {
                    "parameter_longname": "Mix[6]"
                },
                "obj-58::obj-9": {
                    "parameter_longname": "Treble[1]"
                },
                "obj-58::obj-99": {
                    "parameter_longname": "Active[24]"
                },
                "obj-7::obj-4": {
                    "parameter_longname": "Mix[8]"
                },
                "obj-7::obj-45": {
                    "parameter_longname": "ModInALed[8]"
                },
                "obj-7::obj-47": {
                    "parameter_longname": "ModInBLed[8]"
                },
                "obj-7::obj-59": {
                    "parameter_longname": "ModOutALed[8]"
                },
                "obj-7::obj-60": {
                    "parameter_longname": "ModOutBLed[8]"
                },
                "obj-7::obj-82": {
                    "parameter_longname": "Gain[15]"
                },
                "obj-7::obj-99": {
                    "parameter_longname": "Active[9]"
                },
                "obj-98::obj-112": {
                    "parameter_longname": "HighPass[1]"
                },
                "obj-98::obj-154": {
                    "parameter_longname": "Abl.ChannelEQ[1]"
                },
                "obj-98::obj-45": {
                    "parameter_longname": "ModInALed[21]"
                },
                "obj-98::obj-47": {
                    "parameter_longname": "ModInBLed[21]"
                },
                "obj-98::obj-59": {
                    "parameter_longname": "ModOutALed[21]"
                },
                "obj-98::obj-6": {
                    "parameter_longname": "Mid[5]"
                },
                "obj-98::obj-60": {
                    "parameter_longname": "ModOutBLed[21]"
                },
                "obj-98::obj-8": {
                    "parameter_longname": "MidF[1]"
                },
                "obj-98::obj-81": {
                    "parameter_longname": "Low[1]"
                },
                "obj-98::obj-82": {
                    "parameter_longname": "Gain[18]"
                },
                "obj-98::obj-9": {
                    "parameter_longname": "High[1]"
                },
                "obj-98::obj-99": {
                    "parameter_longname": "Active[21]"
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0,
        "styles": [
            {
                "name": "newobjYellow-1",
                "default": {
                    "accentcolor": [ 0.82517, 0.78181, 0.059545, 1.0 ],
                    "fontsize": [ 12.059008 ]
                },
                "parentstyle": "",
                "multi": 0
            },
            {
                "name": "numberGold-1",
                "default": {
                    "accentcolor": [ 0.764706, 0.592157, 0.101961, 1.0 ]
                },
                "parentstyle": "",
                "multi": 0
            }
        ],
        "toolbaradditions": [ "BEAP", "packagemanager" ],
        "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
        "editing_bgcolor": [ 0.0, 0.0, 0.0, 1.0 ]
    }
}