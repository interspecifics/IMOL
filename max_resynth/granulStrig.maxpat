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
        "rect": [ 1307.0, -926.0, 367.0, 732.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1155.333369731903, 959.0, 29.5, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 261.4457927942276, 910.8434071540833, 29.5, 22.0 ],
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
                    "patching_rect": [ 1185.333369731903, 954.0, 41.0, 32.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 291.56627583503723, 906.0241298675537, 41.0, 32.0 ]
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
                    "patching_rect": [ 1262.333369731903, 959.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1262.333369731903, 931.0, 32.0, 22.0 ],
                    "text": "r st1"
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
                    "patching_rect": [ 1103.333369731903, 959.0, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 209.63856196403503, 910.8434071540833, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 915.0, 1046.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 876.0, 1047.0, 35.0, 22.0 ],
                    "text": "open"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 753.0, 1066.0, 71.5, 22.0 ],
                    "text": "sfrecord~ 6"
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "preset",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "preset", "int", "preset", "int", "" ],
                    "patching_rect": [ 1104.3333622217178, 999.0, 100.0, 40.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 26.506025075912476, 909.6385878324509, 167.46988570690155, 43.37349557876587 ],
                    "preset_data": [
                        {
                            "number": 1,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -22.836116790771484, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 7.530779838562012, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 7.530779838562012, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.423324376344681, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -16.52524185180664, 5, "obj-72", "number", "float", 0.094956375658512, 5, "obj-64", "number", "float", 0.180159986019135, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.243082523345947, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.243082523345947, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 1.115826272076272, 5, "obj-25", "number", "float", 0.155956909060478, 5, "obj-24", "number", "float", 0.098122127354145, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.313070505857468, 5, "obj-15", "number", "float", 0.843451976776123, 5, "obj-324", "umenu", "int", 1, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.619664371013641, 5, "obj-80", "number", "float", 0.211702078580856, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.313070505857468, 5, "obj-67", "number", "float", 0.155956909060478, 5, "obj-117", "live.gain~", "float", -14.629643440246582 ]
                        },
                        {
                            "number": 2,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -16.382047653198242, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 216.05702209472656, 6.579878807067871, 0.564990997314453, 5, "obj-445", "number", "float", 216.05702209472656, 5, "obj-444", "number", "float", 6.579878807067871, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.389410972595215, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -19.381731033325195, 5, "obj-72", "number", "float", 0.157832950353622, 5, "obj-64", "number", "float", 0.179286137223244, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 3.707226514816284, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 3.707226514816284, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.709687506562506, 5, "obj-25", "number", "float", 0.144145205616951, 5, "obj-24", "number", "float", 0.128790974617004, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.382815927267075, 5, "obj-15", "number", "float", 0.463683307170868, 5, "obj-324", "umenu", "int", 1, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.060348935425282, 5, "obj-80", "number", "float", 0.203255772590637, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.382815927267075, 5, "obj-67", "number", "float", 0.144145205616951, 5, "obj-117", "live.gain~", "float", -14.629643440246582 ]
                        },
                        {
                            "number": 3,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -15.95510196685791, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 100.22618103027344, 4.539380073547363, 0.564990997314453, 5, "obj-445", "number", "float", 100.22618103027344, 5, "obj-444", "number", "float", 4.539380073547363, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.222052723169327, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -19.381731033325195, 5, "obj-72", "number", "float", 0.094930611550808, 5, "obj-64", "number", "float", 0.195173308253288, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 2.343648437398437, 5, "obj-25", "number", "float", 0.17094424366951, 5, "obj-24", "number", "float", 0.089120246469975, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.54327666759491, 5, "obj-15", "number", "float", 0.261643946170807, 5, "obj-324", "umenu", "int", 2, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.874671101570129, 5, "obj-80", "number", "float", 0.114380858838558, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.54327666759491, 5, "obj-67", "number", "float", 0.17094424366951, 5, "obj-117", "live.gain~", "float", -14.629643440246582 ]
                        },
                        {
                            "number": 4,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -15.912232398986816, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 5159.30322265625, 4.539380073547363, 0.564990997314453, 5, "obj-445", "number", "float", 5159.30322265625, 5, "obj-444", "number", "float", 4.539380073547363, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.490744531154633, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -19.381731033325195, 5, "obj-72", "number", "float", 0.220706135034561, 5, "obj-64", "number", "float", 0.240229085087776, 5, "obj-62", "umenu", "int", 3, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 6.398994523994523, 5, "obj-25", "number", "float", 0.239306375384331, 5, "obj-24", "number", "float", 0.134360834956169, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.248996421694756, 5, "obj-15", "number", "float", 0.698237776756287, 5, "obj-324", "umenu", "int", 3, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.662839710712433, 5, "obj-80", "number", "float", 0.318626940250397, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.248996421694756, 5, "obj-67", "number", "float", 0.239306375384331, 5, "obj-117", "live.gain~", "float", -15.31380844116211 ]
                        },
                        {
                            "number": 5,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -14.886859893798828, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 173.02500915527344, 4.539380073547363, 0.564990997314453, 5, "obj-445", "number", "float", 173.02500915527344, 5, "obj-444", "number", "float", 4.539380073547363, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.875013470649719, 5, "obj-91", "kslider", "int", 35, 5, "obj-89", "number", "float", 35.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 0.967248201370239, 5, "obj-64", "number", "float", 0.104647606611252, 5, "obj-62", "umenu", "int", 4, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 1.309884513009513, 5, "obj-25", "number", "float", 0.145479932427406, 5, "obj-24", "number", "float", 0.076173573732376, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.094178706407547, 5, "obj-15", "number", "float", 0.376848071813583, 5, "obj-324", "umenu", "int", 3, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.406833112239838, 5, "obj-80", "number", "float", 0.278224974870682, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.094178706407547, 5, "obj-67", "number", "float", 0.145479932427406, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 6,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -19.3313045501709, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 444.95294189453125, 3.665750026702881, 0.564990997314453, 5, "obj-445", "number", "float", 444.95294189453125, 5, "obj-444", "number", "float", 3.665750026702881, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 6.1935956182e-05, 5, "obj-91", "kslider", "int", 35, 5, "obj-89", "number", "float", 35.0, 5, "obj-88", "kslider", "int", 43, 5, "obj-87", "number", "float", 43.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 6.5625514253e-05, 5, "obj-64", "number", "float", 3.722476322e-06, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 59.132999420166016, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 59.132999420166016, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.057816551957177, 5, "obj-25", "number", "float", 4.18108948e-06, 5, "obj-24", "number", "float", 3.847684638e-06, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 3.4582746594e-05, 5, "obj-15", "number", "float", 6.0414236941e-05, 5, "obj-324", "umenu", "int", 5, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.997209072113037, 5, "obj-80", "number", "float", 0.002788376063108, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 3.4582746594e-05, 5, "obj-67", "number", "float", 4.18108948e-06, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 7,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -12.27881145477295, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 4.856359958648682, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 4.856359958648682, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 3.245834932e-06, 5, "obj-91", "kslider", "int", 35, 5, "obj-89", "number", "float", 35.0, 5, "obj-88", "kslider", "int", 41, 5, "obj-87", "number", "float", 41.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 4.92297261e-07, 5, "obj-64", "number", "float", 8.75170429e-07, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 59.132999420166016, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 59.132999420166016, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.075304123155686, 5, "obj-25", "number", "float", 5.33758225e-07, 5, "obj-24", "number", "float", 5.08512869e-07, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 4.130615707e-06, 5, "obj-15", "number", "float", 3.048380449e-06, 5, "obj-324", "umenu", "int", 5, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.99636697769165, 5, "obj-80", "number", "float", 0.003631575964391, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 4.130615707e-06, 5, "obj-67", "number", "float", 5.33758225e-07, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 8,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -12.27881145477295, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 4.856359958648682, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 4.856359958648682, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.429670721292496, 5, "obj-91", "kslider", "int", 38, 5, "obj-89", "number", "float", 38.0, 5, "obj-88", "kslider", "int", 40, 5, "obj-87", "number", "float", 40.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 0.091329529881477, 5, "obj-64", "number", "float", 0.114309571683407, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.327350425006675, 5, "obj-25", "number", "float", 0.094187512993813, 5, "obj-24", "number", "float", 0.058978267014027, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.475380390882492, 5, "obj-15", "number", "float", 0.270400375127792, 5, "obj-324", "umenu", "int", 5, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.396517366170883, 5, "obj-80", "number", "float", 0.069457195699215, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.475380390882492, 5, "obj-67", "number", "float", 0.094187512993813, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 9,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -12.27881145477295, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 4.856359958648682, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 4.856359958648682, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.629101574420929, 5, "obj-91", "kslider", "int", 41, 5, "obj-89", "number", "float", 41.0, 5, "obj-88", "kslider", "int", 38, 5, "obj-87", "number", "float", 38.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 0.136738449335098, 5, "obj-64", "number", "float", 0.222135946154594, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.850624678749679, 5, "obj-25", "number", "float", 0.121684782207012, 5, "obj-24", "number", "float", 0.119184374809265, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.839725494384766, 5, "obj-15", "number", "float", 0.718186020851135, 5, "obj-324", "umenu", "int", 5, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.13400574028492, 5, "obj-80", "number", "float", 0.242100402712822, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.839725494384766, 5, "obj-67", "number", "float", 0.121684782207012, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 10,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -12.27881145477295, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 4.856359958648682, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 4.856359958648682, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.415206968784332, 5, "obj-91", "kslider", "int", 41, 5, "obj-89", "number", "float", 41.0, 5, "obj-88", "kslider", "int", 38, 5, "obj-87", "number", "float", 38.0, 5, "obj-84", "live.gain~", "float", -14.526511192321777, 5, "obj-72", "number", "float", 0.058512773364782, 5, "obj-64", "number", "float", 0.042550522834063, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.51602325039825, 5, "obj-25", "number", "float", 0.048783179372549, 5, "obj-24", "number", "float", 0.026752531528473, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.008875074796379, 5, "obj-15", "number", "float", 0.577390491962433, 5, "obj-324", "umenu", "int", 5, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.974639475345612, 5, "obj-80", "number", "float", 0.02490996196866, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.008875074796379, 5, "obj-67", "number", "float", 0.048783179372549, 5, "obj-117", "live.gain~", "float", -12.407421112060547 ]
                        },
                        {
                            "number": 11,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -21.725006103515625, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 1030.52880859375, 4.802032470703125, 0.564990997314453, 5, "obj-445", "number", "float", 1030.52880859375, 5, "obj-444", "number", "float", 4.802032470703125, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.24984872341156, 5, "obj-91", "kslider", "int", 43, 5, "obj-89", "number", "float", 43.0, 5, "obj-88", "kslider", "int", 40, 5, "obj-87", "number", "float", 40.0, 5, "obj-84", "live.gain~", "float", -20.149702072143555, 5, "obj-72", "number", "float", 0.025217385962605, 5, "obj-64", "number", "float", 0.025667533278465, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 2182.19873046875, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 2182.19873046875, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.101839926058676, 5, "obj-25", "number", "float", 0.013157718814909, 5, "obj-24", "number", "float", 0.010732460767031, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.42390513420105, 5, "obj-15", "number", "float", 0.888877153396606, 5, "obj-324", "umenu", "int", 6, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.994339764118195, 5, "obj-80", "number", "float", 0.004971479531378, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.42390513420105, 5, "obj-67", "number", "float", 0.013157718814909, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 12,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -7.278811454772949, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 501.74462890625, 4.856359958648682, 0.564990997314453, 5, "obj-445", "number", "float", 501.74462890625, 5, "obj-444", "number", "float", 4.856359958648682, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.032302334904671, 5, "obj-91", "kslider", "int", 52, 5, "obj-89", "number", "float", 52.0, 5, "obj-88", "kslider", "int", 52, 5, "obj-87", "number", "float", 52.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.063411347568035, 5, "obj-64", "number", "float", 0.036491528153419, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.26808561964812, 5, "obj-25", "number", "float", 0.040620882064104, 5, "obj-24", "number", "float", 0.023413777351379, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.86119019985199, 5, "obj-15", "number", "float", 0.910473048686981, 5, "obj-324", "umenu", "int", 6, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.013977793976665, 5, "obj-80", "number", "float", 0.106585800647736, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.86119019985199, 5, "obj-67", "number", "float", 0.040620882064104, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 13,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -7.278811454772949, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 253.7613525390625, 6.150440216064453, 0.564990997314453, 5, "obj-445", "number", "float", 253.7613525390625, 5, "obj-444", "number", "float", 6.150440216064453, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.000506365380716, 5, "obj-91", "kslider", "int", 52, 5, "obj-89", "number", "float", 52.0, 5, "obj-88", "kslider", "int", 52, 5, "obj-87", "number", "float", 52.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 4.8480189434e-05, 5, "obj-64", "number", "float", 0.000148787396029, 5, "obj-62", "umenu", "int", 1, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 59.132999420166016, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 59.132999420166016, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.061904236708924, 5, "obj-25", "number", "float", 0.000123134799651, 5, "obj-24", "number", "float", 4.1100262024e-05, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.000704275269527, 5, "obj-15", "number", "float", 0.001247083884664, 5, "obj-324", "umenu", "int", 6, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.995662212371826, 5, "obj-80", "number", "float", 0.002989968284965, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.000704275269527, 5, "obj-67", "number", "float", 0.000123134799651, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 14,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -7.278811454772949, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 253.7613525390625, 6.150440216064453, 0.564990997314453, 5, "obj-445", "number", "float", 253.7613525390625, 5, "obj-444", "number", "float", 6.150440216064453, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.093284472823143, 5, "obj-91", "kslider", "int", 41, 5, "obj-89", "number", "float", 41.0, 5, "obj-88", "kslider", "int", 52, 5, "obj-87", "number", "float", 52.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.021601501852274, 5, "obj-64", "number", "float", 0.040280897170305, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 2435.8505859375, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 2435.8505859375, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.661820896195896, 5, "obj-25", "number", "float", 0.029097497463226, 5, "obj-24", "number", "float", 0.011304958723485, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.436357975006104, 5, "obj-15", "number", "float", 0.110632710158825, 5, "obj-324", "umenu", "int", 7, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.968083500862122, 5, "obj-80", "number", "float", 0.031916484236717, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.436357975006104, 5, "obj-67", "number", "float", 0.029097497463226, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 15,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -7.278811454772949, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 253.7613525390625, 6.150440216064453, 0.564990997314453, 5, "obj-445", "number", "float", 253.7613525390625, 5, "obj-444", "number", "float", 6.150440216064453, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.001286263111979, 5, "obj-91", "kslider", "int", 45, 5, "obj-89", "number", "float", 45.0, 5, "obj-88", "kslider", "int", 47, 5, "obj-87", "number", "float", 47.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 7.0639769547e-05, 5, "obj-64", "number", "float", 0.000161079238751, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 59.132999420166016, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 59.132999420166016, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.060698039213664, 5, "obj-25", "number", "float", 9.3236034445e-05, 5, "obj-24", "number", "float", 3.1665327697e-05, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.005919022485614, 5, "obj-15", "number", "float", 0.002022037981078, 5, "obj-324", "umenu", "int", 7, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.997072815895081, 5, "obj-80", "number", "float", 0.002927178749815, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.005919022485614, 5, "obj-67", "number", "float", 9.3236034445e-05, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 16,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -10.356677055358887, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 253.7613525390625, 6.150440216064453, 0.564990997314453, 5, "obj-445", "number", "float", 253.7613525390625, 5, "obj-444", "number", "float", 6.150440216064453, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 8.18939e-10, 5, "obj-91", "kslider", "int", 45, 5, "obj-89", "number", "float", 45.0, 5, "obj-88", "kslider", "int", 47, 5, "obj-87", "number", "float", 47.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 4.4975e-11, 5, "obj-64", "number", "float", 1.02556e-10, 5, "obj-62", "umenu", "int", 3, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 59.132999420166016, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 59.132999420166016, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.057600057600058, 5, "obj-25", "number", "float", 5.9362e-11, 5, "obj-24", "number", "float", 2.0161e-11, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 3.768527e-09, 5, "obj-15", "number", "float", 1.287392e-09, 5, "obj-324", "umenu", "int", 6, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.997222244739532, 5, "obj-80", "number", "float", 0.00277777784504, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 3.768527e-09, 5, "obj-67", "number", "float", 5.9362e-11, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 17,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -10.356677055358887, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 951.3881225585938, 5.558244228363037, 0.564990997314453, 5, "obj-445", "number", "float", 951.3881225585938, 5, "obj-444", "number", "float", 5.558244228363037, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 0.318074524402618, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 53, 5, "obj-87", "number", "float", 53.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.053914468735456, 5, "obj-64", "number", "float", 0.078039310872555, 5, "obj-62", "umenu", "int", 3, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 1.297718641468641, 5, "obj-25", "number", "float", 0.064415849745274, 5, "obj-24", "number", "float", 0.042225535959005, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.361155062913895, 5, "obj-15", "number", "float", 0.862935662269592, 5, "obj-324", "umenu", "int", 8, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.937417209148407, 5, "obj-80", "number", "float", 0.062582820653915, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.361155062913895, 5, "obj-67", "number", "float", 0.064415849745274, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 18,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -10.356677055358887, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 234.1579132080078, 7.280892372131348, 0.564990997314453, 5, "obj-445", "number", "float", 234.1579132080078, 5, "obj-444", "number", "float", 7.280892372131348, 5, "obj-443", "number", "float", 0.564990997314453, 5, "obj-92", "number", "float", 3.291214307e-05, 5, "obj-91", "kslider", "int", 40, 5, "obj-89", "number", "float", 40.0, 5, "obj-88", "kslider", "int", 53, 5, "obj-87", "number", "float", 53.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.001402697642334, 5, "obj-64", "number", "float", 0.011200617067516, 5, "obj-62", "umenu", "int", 3, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 65.08696746826172, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 65.08696746826172, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.09640951047201, 5, "obj-25", "number", "float", 2.779656143e-06, 5, "obj-24", "number", "float", 1.466562139e-06, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 2.7206655432e-05, 5, "obj-15", "number", "float", 3.8297825085e-05, 5, "obj-324", "umenu", "int", 8, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.99535059928894, 5, "obj-80", "number", "float", 0.004649374168366, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 2.7206655432e-05, 5, "obj-67", "number", "float", 2.779656143e-06, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 19,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -10.356677055358887, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 482.054443359375, 16.364011764526367, 0.347725480794907, 5, "obj-445", "number", "float", 482.054443359375, 5, "obj-444", "number", "float", 16.364011764526367, 5, "obj-443", "number", "float", 0.347725480794907, 5, "obj-92", "number", "float", 0.406276613473892, 5, "obj-91", "kslider", "int", 38, 5, "obj-89", "number", "float", 38.0, 5, "obj-88", "kslider", "int", 60, 5, "obj-87", "number", "float", 60.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.005001457408071, 5, "obj-64", "number", "float", 0.014105929993093, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 311.86285400390625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 311.86285400390625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.064185283911846, 5, "obj-25", "number", "float", 0.005522875115275, 5, "obj-24", "number", "float", 0.002578470623121, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.134532153606415, 5, "obj-15", "number", "float", 0.213162004947662, 5, "obj-324", "umenu", "int", 9, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.996904671192169, 5, "obj-80", "number", "float", 0.003095351858065, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.134532153606415, 5, "obj-67", "number", "float", 0.005522875115275, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 20,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -27.23769187927246, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 482.054443359375, 16.364011764526367, 0.347725480794907, 5, "obj-445", "number", "float", 482.054443359375, 5, "obj-444", "number", "float", 16.364011764526367, 5, "obj-443", "number", "float", 0.347725480794907, 5, "obj-92", "number", "float", 0.292506754398346, 5, "obj-91", "kslider", "int", 38, 5, "obj-89", "number", "float", 38.0, 5, "obj-88", "kslider", "int", 60, 5, "obj-87", "number", "float", 60.0, 5, "obj-84", "live.gain~", "float", -15.50987434387207, 5, "obj-72", "number", "float", 0.008850329555571, 5, "obj-64", "number", "float", 0.010026110336185, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 476.4551086425781, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 476.4551086425781, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.077542338284526, 5, "obj-25", "number", "float", 0.00773975905031, 5, "obj-24", "number", "float", 0.004232947248966, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.76030820608139, 5, "obj-15", "number", "float", 0.550404965877533, 5, "obj-324", "umenu", "int", 0, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.996260523796082, 5, "obj-80", "number", "float", 0.003739499486983, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.76030820608139, 5, "obj-67", "number", "float", 0.00773975905031, 5, "obj-117", "live.gain~", "float", -18.263065338134766 ]
                        },
                        {
                            "number": 21,
                            "data": [ 5, "obj-201", "attrui", "attr", "dampen", 5, "obj-201", "attrui", "float", 0.8, 5, "obj-200", "attrui", "attr", "decayms", 5, "obj-200", "attrui", "float", 6000.0, 5, "obj-199", "attrui", "attr", "lfodepth", 5, "obj-199", "attrui", "float", 0.0, 5, "obj-198", "attrui", "attr", "invert", 5, "obj-198", "attrui", "float", 0.0, 5, "obj-197", "attrui", "attr", "delaytime", 5, "obj-197", "attrui", "float", 700.0, 5, "obj-195", "live.gain~", "float", -27.752126693725586, 5, "obj-193", "attrui", "attr", "drywet", 5, "obj-193", "attrui", "float", 0.4, 5, "obj-192", "attrui", "attr", "lforate", 5, "obj-192", "attrui", "float", 1.0, 6, "obj-186", "number~", "list", 0.0, 0.0, 6, "obj-184", "number~", "list", 0.0, 0.0, 5, "obj-182", "number", "int", -30, 5, "obj-179", "umenu", "int", 0, 5, "obj-175", "number", "float", 500.0, 5, "obj-450", "attrui", "attr", "edit_mode", 5, "obj-450", "attrui", "int", 8, 5, "obj-446", "filtergraph~", "nfilters", 1, 9, "obj-446", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-446", "filtergraph~", "params", 0, 482.054443359375, 16.364011764526367, 0.347725480794907, 5, "obj-445", "number", "float", 482.054443359375, 5, "obj-444", "number", "float", 16.364011764526367, 5, "obj-443", "number", "float", 0.347725480794907, 5, "obj-92", "number", "float", 0.093177013099194, 5, "obj-91", "kslider", "int", 36, 5, "obj-89", "number", "float", 36.0, 5, "obj-88", "kslider", "int", 52, 5, "obj-87", "number", "float", 52.0, 5, "obj-84", "live.gain~", "float", -20.714218139648438, 5, "obj-72", "number", "float", 0.111210130155087, 5, "obj-64", "number", "float", 0.20381473004818, 5, "obj-62", "umenu", "int", 2, 5, "obj-66", "attrui", "attr", "edit_mode", 5, "obj-66", "attrui", "int", 8, 5, "obj-56", "filtergraph~", "nfilters", 1, 9, "obj-56", "filtergraph~", "setoptions", 0, 8, 1, 0, 0, 8, "obj-56", "filtergraph~", "params", 0, 6231.60009765625, 4.695196628570557, 1.029619455337524, 5, "obj-50", "number", "float", 6231.60009765625, 5, "obj-47", "number", "float", 4.695196628570557, 5, "obj-40", "number", "float", 1.029619455337524, 5, "obj-103", "attrui", "attr", "pitchshift", 5, "obj-103", "attrui", "float", 0.447660213285213, 5, "obj-25", "number", "float", 0.168312445282936, 5, "obj-24", "number", "float", 0.086940884590149, 5, "obj-21", "toggle", "int", 1, 5, "obj-17", "number", "float", 0.407608479261398, 5, "obj-15", "number", "float", 0.527732133865356, 5, "obj-324", "umenu", "int", 0, 5, "obj-115", "number", "float", 6000.0, 5, "obj-114", "number", "float", 9000.0, 5, "obj-113", "number", "float", 400.0, 5, "obj-112", "number", "float", 0.300000011920929, 5, "obj-109", "number", "float", 0.800000011920929, 5, "obj-83", "number", "float", 800.0, 5, "obj-58", "number", "float", 0.447650492191315, 5, "obj-80", "number", "float", 0.170019775629044, 5, "obj-52", "number", "float", 1200.0, 5, "obj-69", "number", "float", 0.407608479261398, 5, "obj-67", "number", "float", 0.168312445282936, 5, "obj-117", "live.gain~", "float", -20.78362464904785 ]
                        }
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 400.0, 478.0, 35.0, 22.0 ],
                    "text": "s m1"
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 385.0, 463.0, 35.0, 22.0 ],
                    "text": "s m1"
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 61.333335161209106, 59.0, 123.0, 22.0 ],
                    "text": "scale 0 999999 0. 10."
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 61.333335161209106, 35.0, 29.0, 22.0 ],
                    "text": "r a6"
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 320.3333452939987, 990.0, 29.0, 22.0 ],
                    "text": "r a5"
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 320.3333452939987, 959.0, 29.0, 22.0 ],
                    "text": "r a3"
                }
            },
            {
                "box": {
                    "id": "obj-123",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 453.3333452939987, 970.0, 29.0, 22.0 ],
                    "text": "r e5"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 915.0, 863.0, 87.0, 22.0 ],
                    "text": "mc.receive~ m"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 83.33334529399872, 1089.0, 74.0, 22.0 ],
                    "text": "mc.send~ m"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 215.33334529399872, 1089.0, 74.0, 22.0 ],
                    "text": "mc.send~ m"
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 343.3333452939987, 1089.0, 74.0, 22.0 ],
                    "text": "mc.send~ m"
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 915.0, 986.0, 55.0, 22.0 ],
                    "text": "dac~ 1 4"
                }
            },
            {
                "box": {
                    "coldcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "id": "obj-117",
                    "lastchannelcount": 0,
                    "maxclass": "live.gain~",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "orientation": 1,
                    "outlettype": [ "signal", "signal", "", "float", "list" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 915.0, 898.0, 141.0, 47.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 174.69880163669586, 832.5301512479782, 116.0, 47.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ -70 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.gain~[2]",
                            "parameter_mmax": 6.0,
                            "parameter_mmin": -70.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.gain~",
                            "parameter_type": 0,
                            "parameter_unitstyle": 4
                        }
                    },
                    "varname": "live.gain~[2]"
                }
            },
            {
                "box": {
                    "id": "obj-108",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 453.3333452939987, 939.0, 29.0, 22.0 ],
                    "text": "r e3"
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 496.0, 1051.0, 43.0, 22.0 ],
                    "text": "* 2000"
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 496.0, 1024.0, 29.0, 22.0 ],
                    "text": "r hz"
                }
            },
            {
                "box": {
                    "id": "obj-104",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 552.0, 1055.0, 43.0, 22.0 ],
                    "text": "* 3000"
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 552.0, 1028.0, 29.0, 22.0 ],
                    "text": "r hz"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 603.0, 1084.0, 25.0, 20.0 ],
                    "style": "default",
                    "text": "Hz"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 154.33334529399872, 1001.0, 25.0, 20.0 ],
                    "style": "default",
                    "text": "Hz"
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 444.3333452939987, 1025.0, 32.0, 20.0 ],
                    "style": "default",
                    "text": "pan"
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 423.3333452939987, 999.0, 59.0, 20.0 ],
                    "style": "default",
                    "text": "feedback"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 410.3333452939987, 971.0, 39.0, 20.0 ],
                    "style": "default",
                    "text": "delay"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-67",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 403.3333452939987, 1025.0, 44.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 344.3333452939987, 1055.0, 75.0, 22.0 ],
                    "style": "default",
                    "text": "tap.module~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-69",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 383.3333452939987, 998.0, 44.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-52",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 364.3333452939987, 971.0, 50.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 314.3333452939987, 1025.0, 32.0, 20.0 ],
                    "style": "default",
                    "text": "pan"
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 293.3333452939987, 999.0, 59.0, 20.0 ],
                    "style": "default",
                    "text": "feedback"
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 280.3333452939987, 971.0, 39.0, 20.0 ],
                    "style": "default",
                    "text": "delay"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-80",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 271.3333452939987, 1025.0, 44.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 214.33334529399872, 1055.0, 75.0, 22.0 ],
                    "style": "default",
                    "text": "tap.module~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-58",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 251.33334529399872, 998.0, 44.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-83",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 233.33334529399872, 971.0, 50.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 183.33334529399872, 1025.0, 32.0, 20.0 ],
                    "style": "default",
                    "text": "pan"
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 161.33334529399872, 999.0, 59.0, 20.0 ],
                    "style": "default",
                    "text": "feedback"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 150.33334529399872, 971.0, 39.0, 20.0 ],
                    "style": "default",
                    "text": "delay"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-109",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 140.33334529399872, 1025.0, 40.00000178813934, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "newobj",
                    "numinlets": 3,
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
                        "classnamespace": "box",
                        "rect": [ 134.0, 172.0, 276.0, 226.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-67",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 36.0, 67.0, 36.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-68",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 36.0, 42.0, 41.0, 22.0 ],
                                    "text": "$1 20"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-66",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 91.0, 67.0, 36.0, 22.0 ],
                                    "text": "line~"
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
                                    "patching_rect": [ 91.0, 42.0, 41.0, 22.0 ],
                                    "text": "$1 20"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "signal" ],
                                    "patching_rect": [ 37.0, 121.0, 46.0, 22.0 ],
                                    "text": "cross~"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "signal" ],
                                    "patching_rect": [ 9.0, 94.0, 46.0, 22.0 ],
                                    "text": "cross~"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-21",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 9.0, 4.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-23",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 36.0, 4.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-24",
                                    "index": 3,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 91.0, 4.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-25",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 9.0, 167.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-26",
                                    "index": 2,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 37.0, 167.0, 25.0, 25.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-27",
                                    "index": 3,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 64.0, 167.0, 25.0, 25.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-21", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-23", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-24", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-30", 0 ],
                                    "source": [ "obj-29", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-30", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-30", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-66", 0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-30", 1 ],
                                    "source": [ "obj-66", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 1 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "source": [ "obj-68", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 90.6666693687439, 910.5, 252.0, 22.0 ],
                    "style": "default",
                    "text": "p 3_bands"
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 83.33334529399872, 1055.0, 75.0, 22.0 ],
                    "style": "default",
                    "text": "tap.module~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-112",
                    "maxclass": "flonum",
                    "maximum": 1.0,
                    "minimum": 0.0,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 121.33334529399872, 998.0, 44.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-113",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 101.33334529399872, 971.0, 50.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-114",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 552.0, 1084.0, 53.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-115",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 496.0, 1084.0, 50.0, 22.0 ],
                    "style": "default"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1232.0000367164612, 52.000001549720764, 29.0, 22.0 ],
                    "text": "r b6"
                }
            },
            {
                "box": {
                    "buffername": "che",
                    "id": "obj-6",
                    "maxclass": "waveform~",
                    "numinlets": 5,
                    "numoutlets": 6,
                    "outlettype": [ "float", "float", "float", "float", "list", "" ],
                    "patching_rect": [ 548.0000163316727, 561.3333500623703, 214.0, 64.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 328.9156748056412, 342.1686873435974, 63.85542404651642 ],
                    "waveformcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 696.0000207424164, 132.00000393390656, 31.0, 22.0 ],
                    "text": "s 1d"
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
                    "parameter_enable": 1,
                    "patching_rect": [ 696.0000207424164, 106.66666984558105, 20.0, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 267.4698894023895, 171.0843436717987, 100.00000369548798, 100.00000369548798 ],
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
                    "color": [ 0.0, 0.964705882352941, 0.011764705882353, 1.0 ],
                    "id": "obj-1",
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
                        "rect": [ 356.0, 141.0, 943.0, 769.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 187.66666734218597, 82.0, 29.0, 22.0 ],
                                    "text": "r 1d"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 62.666667342185974, 82.0, 29.0, 22.0 ],
                                    "text": "r ab"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 187.66666734218597, 169.7642907210759, 38.0, 22.0 ],
                                    "text": "s ab1"
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
                                    "patching_rect": [ 187.66666734218597, 141.027782784568, 87.0, 22.0 ],
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
                                    "patching_rect": [ 187.66666734218597, 112.02778278456799, 92.0, 22.0 ],
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
                                    "patching_rect": [ 62.666667342185974, 110.49231269909785, 65.0, 22.0 ],
                                    "text": "replace $1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 61.666667342185974, 164.50000500679016, 23.0, 23.0 ],
                                    "style": "default"
                                }
                            },
                            {
                                "box": {
                                    "fontsize": 12.376596207059658,
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 62.666667342185974, 135.7642907210759, 71.0, 22.0 ],
                                    "style": "default",
                                    "text": "buffer~ che"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 61.666667342185974, 204.0, 69.0, 22.0 ],
                                    "text": "buffer~ che"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 124.16666734218597, 160.50000500679016, 71.16666734218597, 160.50000500679016 ],
                                    "source": [ "obj-1", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-106", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-322", 0 ],
                                    "source": [ "obj-28", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
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
                                    "destination": [ "obj-1", 0 ],
                                    "source": [ "obj-323", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-323", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 68.58279866120908, 7.070706725120544, 108.50107300000005, 22.0 ],
                    "text": "p buffer contents"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 696.0000207424164, 156.0000046491623, 36.0, 22.0 ],
                    "text": "r ab1"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 696.0000207424164, 228.0000067949295, 51.0, 22.0 ],
                    "text": "send ab"
                }
            },
            {
                "box": {
                    "autopopulate": 1,
                    "color": [ 0.309803921568627, 0.996078431372549, 0.0, 1.0 ],
                    "id": "obj-324",
                    "items": [ "a-protest-in-bogota-colombia.wav", ",", "acoustic-mordor-malaga.wav", ",", "anti-austerity-protest-athens-greece.wav", ",", "call-and-response-occupy-la.wav", ",", "cinema-is-truth-24-times-a-second.wav", ",", "democracia-new-york.wav", ",", "edinburgh-climate-protests-the-mound.wav", ",", "kill-the-bill-protest-parliament-square.wav", ",", "manifestants-parade-bogota.wav", ",", "not-my-president.wav", ",", "on-with-the-struggle-istanbul.wav", ",", "protest-in-tahrir-square-cairo.wav", ",", "protest-resolution.wav", ",", "rhythms-of-protest-paris.wav", ",", "serbian-protest.wav", ",", "subterranean-protest-malaga.wav", ",", "the-last-1-000-metres-madrid.wav", ",", "the-last-900-metres-madrid.wav", ",", "the-value-of-noise.wav" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 696.0000207424164, 192.0000057220459, 100.0, 22.0 ],
                    "prefix": "~/Desktop/01_Proyectos/IMOL/audio/processed/",
                    "presentation": 1,
                    "presentation_rect": [ 267.4698894023895, 283.13254058361053, 100.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "a-protest-in-bogota-colombia.wav", "acoustic-mordor-malaga.wav", "anti-austerity-protest-athens-greece.wav", "call-and-response-occupy-la.wav", "cinema-is-truth-24-times-a-second.wav", "democracia-new-york.wav", "edinburgh-climate-protests-the-mound.wav", "kill-the-bill-protest-parliament-square.wav", "manifestants-parade-bogota.wav", "not-my-president.wav", "on-with-the-struggle-istanbul.wav", "protest-in-tahrir-square-cairo.wav", "protest-resolution.wav", "rhythms-of-protest-paris.wav", "serbian-protest.wav", "subterranean-protest-malaga.wav", "the-last-1-000-metres-madrid.wav", "the-last-900-metres-madrid.wav", "the-value-of-noise.wav" ],
                            "parameter_longname": "umenu[6]",
                            "parameter_mmax": 18,
                            "parameter_modmode": 0,
                            "parameter_shortname": "umenu[2]",
                            "parameter_type": 2
                        }
                    },
                    "textcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "varname": "umenu[2]"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 97.33333623409271, 244.00000727176666, 148.0, 22.0 ],
                    "text": "mc.delay~ 44100 22050"
                }
            },
            {
                "box": {
                    "automatic": 1,
                    "bufsize": 60,
                    "calccount": 60,
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-10",
                    "maxclass": "scope~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 552.000016450882, 329.3333431482315, 209.0, 209.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 38.55421829223633, 96.38554573059082, 209.0, 209.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 538.6666827201843, 228.0000067949295, 133.9393949508667, 22.0 ],
                    "text": "mc.scale~ -1. 1. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 538.6666827201843, 169.33333837985992, 133.61359983682632, 22.0 ],
                    "text": "mc.sig~ @chans 10"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 538.6666827201843, 200.00000596046448, 100.0, 22.0 ],
                    "text": "mc.cycle~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-15",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 578.6666839122772, 101.333336353302, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-17",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 637.3333523273468, 104.00000309944153, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 538.6666827201843, 141.3333375453949, 130.08849799633026, 22.0 ],
                    "text": "pak increment 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 217.3333398103714, 144.00000429153442, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 217.3333398103714, 176.00000524520874, 103.98230522871017, 22.0 ],
                    "text": "timestretch $1"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-24",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 215.31564503908157, 91.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-25",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 271.3156450390816, 91.0, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 70.66666877269745, 144.00000429153442, 130.08849799633026, 22.0 ],
                    "text": "pak increment 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patching_rect": [ 94.66666948795319, 329.3333431482315, 100.0, 22.0 ],
                    "text": "mc.unpack~ 2"
                }
            },
            {
                "box": {
                    "id": "obj-27",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 70.66666877269745, 278.6666749715805, 277.0, 22.0 ],
                    "text": "mc.mixdown~ 2 @autogain 1 @pancontrolmode 1"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 70.66666877269745, 176.00000524520874, 127.84810090065002, 22.0 ],
                    "text": "mc.sig~ @chans 10"
                }
            },
            {
                "box": {
                    "id": "obj-102",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "multichannelsignal", "multichannelsignal" ],
                    "patching_rect": [ 70.66666877269745, 210.66667294502258, 242.75793486833572, 22.0 ],
                    "text": "mc.groove~ che @loop 1 @timestretch 0"
                }
            },
            {
                "box": {
                    "attr": "pitchshift",
                    "id": "obj-103",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 61.333335161209106, 91.0, 150.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 271.3156450390816, 59.0, 29.0, 22.0 ],
                    "text": "r e5"
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 215.31564503908157, 59.0, 29.0, 22.0 ],
                    "text": "r e4"
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 637.3333523273468, 68.00000202655792, 29.0, 22.0 ],
                    "text": "r e3"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 578.6666839122772, 68.00000202655792, 29.0, 22.0 ],
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
                    "patching_rect": [ 329.3333431482315, 392.0000116825104, 29.0, 22.0 ],
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
                    "patching_rect": [ 257.3333410024643, 392.0000116825104, 29.0, 22.0 ],
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
                    "patching_rect": [ 401.3333452939987, 386.6666781902313, 29.0, 22.0 ],
                    "text": "r c5"
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
                    "patching_rect": [ 264.0000078678131, 844.0000251531601, 92.0, 23.0 ],
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
                    "patching_rect": [ 364.00001084804535, 844.0000251531601, 92.0, 23.0 ],
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
                    "patching_rect": [ 1213.3333694934845, 286.6666752099991, 238.0, 38.0 ],
                    "text": "0.016345 0. -0.016345 -1.992451 0.99251"
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
                    "patching_rect": [ 1373.333374261856, 206.6666728258133, 48.0, 23.0 ],
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
                    "patching_rect": [ 1308.0000389814377, 212.00000631809235, 48.0, 23.0 ],
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
                    "patching_rect": [ 1228.000036597252, 212.00000631809235, 48.0, 23.0 ],
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
                    "patching_rect": [ 1373.333374261856, 232.0000069141388, 55.0, 23.0 ]
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
                    "patching_rect": [ 1310.6667057275772, 232.0000069141388, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-50",
                    "maxclass": "flonum",
                    "maximum": 6231.6,
                    "minimum": 59.133,
                    "mousefilter": 1,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "outputonclick": 1,
                    "parameter_enable": 0,
                    "patching_rect": [ 1232.0000367164612, 232.0000069141388, 57.0, 23.0 ]
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
                    "patching_rect": [ 1036.000030875206, 97.33333623409271, 176.74999764561653, 164.46825396825398 ],
                    "presentation": 1,
                    "presentation_rect": [ 250.60241889953613, 685.5421940088272, 178.31325960159302, 101.20482301712036 ],
                    "setfilter": [ 0, 8, 1, 0, 0, 59.132999420166016, 4.23911714553833, 1.0296194553375244, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],
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
                    "patching_rect": [ 1233.333370089531, 121.33333694934845, 88.25, 36.0 ],
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
                    "patching_rect": [ 1032.0000307559967, 45.33333468437195, 83.0, 46.0 ],
                    "text_width": 83.0
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 764.0, 986.0, 55.0, 22.0 ],
                    "text": "dac~ 3 4"
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 313.33334267139435, 677.3333535194397, 129.0, 47.0 ],
                    "text": "retune the delay lines and change the network configuration"
                }
            },
            {
                "box": {
                    "id": "obj-100",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 133.33333730697632, 405.333345413208, 100.0, 47.0 ],
                    "text": " different feedback network settings",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-99",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 252.00000751018524, 418.66667914390564, 219.0, 20.0 ],
                    "text": " network and damping interactions",
                    "textcolor": [ 1.0, 0.952941176470588, 0.952941176470588, 1.0 ]
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
                    "patching_rect": [ 133.33333730697632, 490.66668128967285, 61.0, 22.0 ],
                    "text": "feeder $1"
                }
            },
            {
                "box": {
                    "allowdrag": 0,
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-62",
                    "items": [ "off", ",", "self", ",", "other", ",", "self-side", ",", "other-side" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 133.33333730697632, 464.0000138282776, 100.0, 22.0 ],
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
                    "patching_rect": [ 401.3333452939987, 445.3333466053009, 50.0, 22.0 ],
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
                    "patching_rect": [ 401.3333452939987, 472.00001406669617, 64.0, 22.0 ],
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
                    "patching_rect": [ 329.3333431482315, 445.3333466053009, 50.0, 22.0 ],
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
                    "patching_rect": [ 329.3333431482315, 472.00001406669617, 64.0, 22.0 ],
                    "text": "damp2 $1"
                }
            },
            {
                "box": {
                    "coldcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "fontsize": 13.0,
                    "id": "obj-84",
                    "lastchannelcount": 0,
                    "maxclass": "live.gain~",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "orientation": 1,
                    "outlettype": [ "signal", "signal", "", "float", "list" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 617.0, 913.0, 139.0, 41.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 300.0000110864639, 842.1687058210373, 129.0, 41.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ -70 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.gain~[1]",
                            "parameter_mmax": 6.0,
                            "parameter_mmin": -70.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.gain~",
                            "parameter_type": 0,
                            "parameter_unitstyle": 4
                        }
                    },
                    "showname": 0,
                    "varname": "live.gain~[1]"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "local": 1,
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 617.0, 968.0, 44.0, 44.0 ],
                    "prototypename": "helpfile"
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
                    "patching_rect": [ 216.00000643730164, 702.6666876077652, 85.0, 22.0 ],
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
                    "patching_rect": [ 216.00000643730164, 674.6666867733002, 80.0, 22.0 ]
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
                    "patching_rect": [ 216.00000643730164, 630.666685461998, 232.0, 38.0 ],
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
                    "patching_rect": [ 121.33333694934845, 674.6666867733002, 80.0, 22.0 ]
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
                    "patching_rect": [ 121.33333694934845, 702.6666876077652, 85.0, 22.0 ],
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
                    "patching_rect": [ 121.33333694934845, 585.333350777626, 232.0, 38.0 ],
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
                    "patching_rect": [ 257.3333410024643, 445.3333466053009, 50.0, 22.0 ],
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
                    "patching_rect": [ 257.3333410024643, 472.00001406669617, 64.0, 22.0 ],
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
                        "rect": [ 34.0, 100.0, 1440.0, 826.0 ],
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
                    "patching_rect": [ 90.6666693687439, 765.3333561420441, 144.66665375232697, 22.0 ],
                    "text": "gen~"
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
                    "patching_rect": [ 777.3333564996719, 656.0000195503235, 92.0, 23.0 ],
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
                    "patching_rect": [ 876.0000261068344, 656.0000195503235, 92.0, 23.0 ],
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
                    "patching_rect": [ 1380.000041127205, 154.66667127609253, 48.0, 23.0 ],
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
                    "patching_rect": [ 1313.3333724737167, 160.00000476837158, 48.0, 23.0 ],
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
                    "patching_rect": [ 1233.333370089531, 160.00000476837158, 48.0, 23.0 ],
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
                    "patching_rect": [ 849.3333586454391, 296.0000088214874, 283.625, 23.0 ],
                    "text": "0.232414 0. -0.232414 -1.886608 0.89065"
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
                    "patching_rect": [ 1380.000041127205, 130.6666705608368, 73.0, 21.0 ],
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
                    "patching_rect": [ 1380.000041127205, 180.00000536441803, 55.0, 23.0 ]
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
                    "patching_rect": [ 1314.6667058467865, 180.00000536441803, 55.0, 23.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "format": 6,
                    "id": "obj-445",
                    "maxclass": "flonum",
                    "maximum": 6231.6,
                    "minimum": 59.133,
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1238.66670358181, 180.00000536441803, 57.0, 23.0 ]
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
                    "patching_rect": [ 853.3333587646484, 97.33333623409271, 171.00000149011612, 164.46825396825398 ],
                    "presentation": 1,
                    "presentation_rect": [ 36.14457964897156, 685.5421940088272, 198.79518806934357, 101.20482301712036 ],
                    "setfilter": [ 0, 8, 1, 0, 0, 499.6305236816406, 7.523743152618408, 0.5649909973144531, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ],
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
                    "patching_rect": [ 1233.333370089531, 146.66667103767395, 88.25, 36.0 ],
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
                    "patching_rect": [ 1313.3333724737167, 136.00000405311584, 59.0, 21.0 ],
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
                    "patching_rect": [ 1438.6667095422745, 240.00000715255737, 118.0, 21.0 ],
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
                    "patching_rect": [ 849.3333586454391, 45.33333468437195, 83.0, 46.0 ],
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
                    "patching_rect": [ 1221.333369731903, 497.33334815502167, 132.0, 22.0 ],
                    "text": "gen~ @title noise-burst"
                }
            },
            {
                "box": {
                    "id": "obj-170",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1148.000034213066, 650.6666860580444, 81.0, 22.0 ],
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
                    "patching_rect": [ 969.3333622217178, 621.3333518505096, 235.0, 22.0 ],
                    "text": "gen~ @title delaytimes"
                }
            },
            {
                "box": {
                    "automatic": 1,
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "bufsize": 30,
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-172",
                    "maxclass": "scope~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 1125.3333668708801, 338.66667675971985, 270.0, 105.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.53012907505035, 467.4698967933655, 190.0, 74.0 ]
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
                    "patching_rect": [ 850.6666920185089, 338.66667675971985, 270.0, 105.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 467.4698967933655, 190.0, 74.0 ]
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
                    "patching_rect": [ 1333.3333730697632, 445.3333466053009, 83.0, 22.0 ],
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
                    "patching_rect": [ 918.6666940450668, 484.00001442432404, 50.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 151.80723452568054, 440.963871717453, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 969.3333622217178, 461.33334708213806, 54.00000149011612, 20.0 ],
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
                    "patching_rect": [ 1404.0000418424606, 608.000018119812, 181.0, 20.0 ],
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
                    "patching_rect": [ 853.3333587646484, 484.00001442432404, 58.0, 22.0 ],
                    "saved_object_attributes": {
                        "locked_bgcolor": [ 1.0, 1.0, 1.0, 1.0 ]
                    },
                    "text": "p presets"
                }
            },
            {
                "box": {
                    "color": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "elementcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "id": "obj-179",
                    "items": [ "delay", ",", "mad professor", ",", "garagey echo", ",", "slappy echo", ",", "tape flutter", ",", "chorus", ",", "didgerimetal", ",", "flanger", ",", "Karplus Strong", ",", "phaser", ",", "toothpaste zone", ",", "filter wobble" ],
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "", "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 853.3333587646484, 461.33334708213806, 111.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 440.963871717453, 111.0, 22.0 ],
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
                    "textcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "varname": "umenu[3]"
                }
            },
            {
                "box": {
                    "id": "obj-180",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1404.0000418424606, 552.000016450882, 188.0, 20.0 ],
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
                    "patching_rect": [ 1218.0, 679.6666868925095, 66.0, 20.0 ],
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
                    "patching_rect": [ 1148.000034213066, 678.6666868925095, 61.5, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-183",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 969.3333622217178, 674.6666867733002, 105.0, 20.0 ],
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
                    "patching_rect": [ 969.3333622217178, 650.6666860580444, 105.0, 22.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-185",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1072.0000319480896, 674.6666867733002, 105.0, 20.0 ],
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
                    "patching_rect": [ 1077.3333654403687, 650.6666860580444, 58.0, 22.0 ],
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
                    "patching_rect": [ 1036.000030875206, 556.0000165700912, 111.0, 33.0 ],
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
                    "patching_rect": [ 1036.000030875206, 516.0000153779984, 109.0, 20.0 ],
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
                    "patching_rect": [ 1404.0000418424606, 574.6666837930679, 181.0, 20.0 ],
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
                    "patching_rect": [ 1404.0000418424606, 528.0000157356262, 188.0, 20.0 ],
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
                    "patching_rect": [ 969.3333622217178, 485.3333477973938, 158.0, 20.0 ],
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
                    "patching_rect": [ 853.3333587646484, 544.0000162124634, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 586.7470096349716, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
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
                    "patching_rect": [ 1221.333369731903, 608.000018119812, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.53012907505035, 637.3494211435318, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
                }
            },
            {
                "box": {
                    "coldcolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ],
                    "id": "obj-195",
                    "lastchannelcount": 0,
                    "maxclass": "live.gain~",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "orientation": 1,
                    "outlettype": [ "signal", "signal", "", "float", "list" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 764.0, 901.0, 141.0, 47.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 26.506025075912476, 832.5301512479782, 127.0, 47.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ -70 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.gain~[3]",
                            "parameter_mmax": 6.0,
                            "parameter_mmin": -70.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.gain~",
                            "parameter_type": 0,
                            "parameter_unitstyle": 4
                        }
                    },
                    "varname": "live.gain~[3]"
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
                    "patching_rect": [ 850.6666920185089, 597.3333511352539, 328.0, 22.0 ],
                    "text": "gen~ @title multi-effects"
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
                    "patching_rect": [ 853.3333587646484, 516.0000153779984, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 557.8313459157944, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
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
                    "patching_rect": [ 1221.333369731903, 574.6666837930679, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.53012907505035, 604.8192994594574, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
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
                    "patching_rect": [ 853.3333587646484, 568.0000169277191, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 34.93976032733917, 610.8433960676193, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
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
                    "patching_rect": [ 1221.333369731903, 528.0000157356262, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.53012907505035, 557.8313459157944, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
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
                    "patching_rect": [ 1221.333369731903, 552.000016450882, 181.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 232.53012907505035, 581.9277323484421, 181.0, 22.0 ],
                    "tricolor": [ 0.298039215686275, 0.576470588235294, 0.592156862745098, 1.0 ]
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-23",
                    "maxclass": "spectroscope~",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 636.000018954277, 690.6666872501373, 140.0, 111.0 ]
                }
            },
            {
                "box": {
                    "automatic": 1,
                    "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
                    "bufsize": 30,
                    "calccount": 30,
                    "fgcolor": [ 1.0, 1.0, 1.0, 1.0 ],
                    "id": "obj-9",
                    "maxclass": "scope~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 488.0000145435333, 690.6666872501373, 140.0, 111.0 ]
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-27", 0 ],
                    "order": 1,
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "order": 0,
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
                    "midpoints": [ 70.8333351612091, 128.3333135843277, 56.666664242744446, 128.3333135843277, 56.666664242744446, 206.3333135843277, 80.16666877269745, 206.3333135843277 ],
                    "source": [ "obj-103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-114", 0 ],
                    "source": [ "obj-104", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-106", 0 ],
                    "source": [ "obj-105", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-115", 0 ],
                    "source": [ "obj-106", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-69", 0 ],
                    "source": [ "obj-108", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 3 ],
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "midpoints": [ 548.1666827201843, 315.6666604280472, 561.500016450882, 315.6666604280472 ],
                    "order": 0,
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-27", 1 ],
                    "midpoints": [ 548.1666827201843, 244.33333802223206, 338.16666877269745, 244.33333802223206 ],
                    "order": 1,
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 0 ],
                    "midpoints": [ 100.1666693687439, 944.4455137252808, 92.83334529399872, 944.4455137252808 ],
                    "source": [ "obj-110", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-51", 0 ],
                    "midpoints": [ 333.1666693687439, 940.1955137252808, 353.8333452939987, 940.1955137252808 ],
                    "source": [ "obj-110", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 0 ],
                    "midpoints": [ 216.6666693687439, 943.1955137252808, 223.83334529399872, 943.1955137252808 ],
                    "source": [ "obj-110", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-121", 0 ],
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 2 ],
                    "source": [ "obj-112", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 1 ],
                    "source": [ "obj-113", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-110", 2 ],
                    "midpoints": [ 561.5, 905.6955137252808, 333.1666693687439, 905.6955137252808 ],
                    "source": [ "obj-114", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-110", 1 ],
                    "midpoints": [ 505.5, 905.6955137252808, 216.6666693687439, 905.6955137252808 ],
                    "source": [ "obj-115", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 1 ],
                    "order": 0,
                    "source": [ "obj-117", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 0 ],
                    "order": 0,
                    "source": [ "obj-117", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 5 ],
                    "order": 1,
                    "source": [ "obj-117", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 4 ],
                    "order": 1,
                    "source": [ "obj-117", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 0 ],
                    "source": [ "obj-122", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-67", 0 ],
                    "source": [ "obj-123", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-126", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 0 ],
                    "source": [ "obj-132", 0 ]
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
                    "destination": [ "obj-18", 1 ],
                    "source": [ "obj-15", 0 ]
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
                    "midpoints": [ 1230.833369731903, 599.8333436250687, 860.1666920185089, 599.8333436250687 ],
                    "source": [ "obj-168", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-18", 2 ],
                    "source": [ "obj-17", 0 ]
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
                    "midpoints": [ 1342.8333730697632, 468.83334362506866, 1281.6666787862778, 468.83334362506866, 1281.6666787862778, 456.83334362506866, 928.1666940450668, 456.83334362506866 ],
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
                    "midpoints": [ 862.8333587646484, 599.5000131130219, 860.1666920185089, 599.5000131130219 ],
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
                    "destination": [ "obj-12", 0 ],
                    "source": [ "obj-18", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 862.8333587646484, 602.2500102917354, 860.1666920185089, 602.2500102917354 ],
                    "source": [ "obj-192", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1230.833369731903, 600.9166769584019, 860.1666920185089, 600.9166769584019 ],
                    "source": [ "obj-193", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 3 ],
                    "order": 1,
                    "source": [ "obj-195", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 2 ],
                    "order": 0,
                    "source": [ "obj-195", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 1 ],
                    "order": 0,
                    "source": [ "obj-195", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "order": 1,
                    "source": [ "obj-195", 0 ]
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
                    "midpoints": [ 860.1666920185089, 616.7649085521698, 1134.8333668708801, 616.7649085521698 ],
                    "order": 0,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-173", 0 ],
                    "midpoints": [ 860.1666920185089, 634.0833436250687, 860.1666920185089, 634.0833436250687 ],
                    "order": 2,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-32", 0 ],
                    "midpoints": [ 860.1666920185089, 646.8333436250687, 786.8333564996719, 646.8333436250687 ],
                    "order": 3,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-453", 0 ],
                    "midpoints": [ 860.1666920185089, 646.8333436250687, 885.5000261068344, 646.8333436250687 ],
                    "order": 1,
                    "source": [ "obj-196", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 862.8333587646484, 599.8333436250687, 860.1666920185089, 599.8333436250687 ],
                    "source": [ "obj-197", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1230.833369731903, 599.0833436250687, 860.1666920185089, 599.0833436250687 ],
                    "source": [ "obj-198", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 862.8333587646484, 599.6666769584019, 860.1666920185089, 599.6666769584019 ],
                    "source": [ "obj-199", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-80", 0 ],
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-324", 0 ],
                    "source": [ "obj-20", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1230.833369731903, 600.3333436250687, 860.1666920185089, 600.3333436250687 ],
                    "source": [ "obj-200", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 1230.833369731903, 598.5000102917354, 860.1666920185089, 598.5000102917354 ],
                    "source": [ "obj-201", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-21", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
                    "source": [ "obj-22", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 1 ],
                    "midpoints": [ 224.81564503908157, 129.0, 135.71091777086258, 129.0 ],
                    "source": [ "obj-24", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 2 ],
                    "midpoints": [ 280.8156450390816, 129.0, 191.2551667690277, 129.0 ],
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-103", 0 ],
                    "source": [ "obj-26", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-98", 0 ],
                    "midpoints": [ 80.16666877269745, 315.6666604280472, 104.16666948795319, 315.6666604280472 ],
                    "source": [ "obj-27", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
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
                    "destination": [ "obj-58", 0 ],
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
                    "destination": [ "obj-195", 0 ],
                    "midpoints": [ 786.8333564996719, 825.0, 773.5, 825.0 ],
                    "source": [ "obj-32", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-320", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-13", 0 ],
                    "source": [ "obj-324", 1 ]
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
                    "destination": [ "obj-50", 0 ],
                    "source": [ "obj-36", 0 ]
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
                    "destination": [ "obj-26", 0 ],
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 7 ],
                    "midpoints": [ 1382.833374261856, 266.33334362506866, 1221.6666787862778, 266.33334362506866, 1221.6666787862778, 92.33334362506866, 1203.2500285208225, 92.33334362506866 ],
                    "source": [ "obj-40", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-104", 0 ],
                    "source": [ "obj-41", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
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
                    "destination": [ "obj-445", 0 ],
                    "hidden": 1,
                    "source": [ "obj-440", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 7 ],
                    "midpoints": [ 1389.500041127205, 179.33334362506866, 1374.6666787862778, 179.33334362506866, 1374.6666787862778, 32.333343625068665, 1014.8333602547646, 32.333343625068665 ],
                    "source": [ "obj-443", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 6 ],
                    "midpoints": [ 1324.1667058467865, 179.33334362506866, 1221.6666787862778, 179.33334362506866, 1221.6666787862778, 32.333343625068665, 993.1190743276052, 32.333343625068665 ],
                    "source": [ "obj-444", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 5 ],
                    "midpoints": [ 1248.16670358181, 179.33334362506866, 1221.6666787862778, 179.33334362506866, 1221.6666787862778, 32.333343625068665, 971.4047884004457, 32.333343625068665 ],
                    "source": [ "obj-445", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-32", 0 ],
                    "midpoints": [ 862.8333587646484, 282.83334362506866, 834.6666787862778, 282.83334362506866, 834.6666787862778, 600.8333436250687, 786.8333564996719, 600.8333436250687 ],
                    "order": 2,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-435", 0 ],
                    "hidden": 1,
                    "midpoints": [ 938.8333595097065, 272.33334362506866, 1221.6666787862778, 272.33334362506866, 1221.6666787862778, 98.33334362506866, 1389.500041127205, 98.33334362506866 ],
                    "source": [ "obj-446", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-439", 0 ],
                    "hidden": 1,
                    "midpoints": [ 913.5000259280205, 272.33334362506866, 1221.6666787862778, 272.33334362506866, 1221.6666787862778, 98.33334362506866, 1322.8333724737167, 98.33334362506866 ],
                    "source": [ "obj-446", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-440", 0 ],
                    "hidden": 1,
                    "midpoints": [ 888.1666923463345, 272.33334362506866, 1221.6666787862778, 272.33334362506866, 1221.6666787862778, 143.33334362506866, 1323.6666787862778, 143.33334362506866, 1323.6666787862778, 134.33334362506866, 1242.833370089531, 134.33334362506866 ],
                    "source": [ "obj-446", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-441", 1 ],
                    "midpoints": [ 862.8333587646484, 282.83334362506866, 1123.4583586454391, 282.83334362506866 ],
                    "order": 0,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-453", 0 ],
                    "midpoints": [ 862.8333587646484, 281.33334362506866, 834.6666787862778, 281.33334362506866, 834.6666787862778, 626.3333436250687, 885.5000261068344, 626.3333436250687 ],
                    "order": 1,
                    "source": [ "obj-446", 0 ]
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
                    "destination": [ "obj-195", 1 ],
                    "midpoints": [ 885.5000261068344, 825.0, 895.5, 825.0 ],
                    "source": [ "obj-453", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 6 ],
                    "midpoints": [ 1320.1667057275772, 266.33334362506866, 1221.6666787862778, 266.33334362506866, 1221.6666787862778, 83.33334362506866, 1180.7143145714488, 83.33334362506866 ],
                    "source": [ "obj-47", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-27", 0 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 5 ],
                    "midpoints": [ 1241.5000367164612, 257.33334362506866, 1221.6666787862778, 257.33334362506866, 1221.6666787862778, 83.33334362506866, 1158.178600622075, 83.33334362506866 ],
                    "source": [ "obj-50", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-119", 0 ],
                    "source": [ "obj-51", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-51", 1 ],
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-30", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1098.083363423745, 272.33334362506866, 1221.6666787862778, 272.33334362506866, 1221.6666787862778, 179.33334362506866, 1317.5000389814377, 179.33334362506866 ],
                    "source": [ "obj-56", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1071.7916971494753, 272.33334362506866, 1305.6666787862778, 272.33334362506866, 1305.6666787862778, 215.33334362506866, 1326.6666787862778, 215.33334362506866, 1326.6666787862778, 209.33334362506866, 1237.500036597252, 209.33334362506866 ],
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
                    "midpoints": [ 1045.500030875206, 272.33334362506866, 471.66667878627777, 272.33334362506866, 471.66667878627777, 830.3333436250687, 273.5000078678131, 830.3333436250687 ],
                    "order": 2,
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 1045.500030875206, 272.33334362506866, 471.66667878627777, 272.33334362506866, 471.66667878627777, 830.3333436250687, 373.50001084804535, 830.3333436250687 ],
                    "order": 1,
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "hidden": 1,
                    "midpoints": [ 1124.3750296980143, 272.33334362506866, 1368.6666787862778, 272.33334362506866, 1368.6666787862778, 203.33334362506866, 1382.833374261856, 203.33334362506866 ],
                    "source": [ "obj-56", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 2 ],
                    "source": [ "obj-58", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 142.83333730697632, 577.4166845083237, 100.1666693687439, 577.4166845083237 ],
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
                    "midpoints": [ 410.8333452939987, 577.4166845083237, 100.1666693687439, 577.4166845083237 ],
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
                    "destination": [ "obj-51", 3 ],
                    "source": [ "obj-67", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-51", 2 ],
                    "source": [ "obj-69", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-84", 0 ],
                    "midpoints": [ 273.5000078678131, 887.3333436250687, 606.6666787862778, 887.3333436250687, 606.6666787862778, 888.3333436250687, 626.5, 888.3333436250687 ],
                    "source": [ "obj-70", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-84", 1 ],
                    "midpoints": [ 373.50001084804535, 888.3333436250687, 606.6666787862778, 888.3333436250687, 606.6666787862778, 888.3333436250687, 746.5, 888.3333436250687 ],
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
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 338.8333431482315, 577.4166845083237, 100.1666693687439, 577.4166845083237 ],
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-17", 0 ],
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
                    "destination": [ "obj-81", 3 ],
                    "source": [ "obj-80", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-120", 0 ],
                    "source": [ "obj-81", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-25", 0 ],
                    "source": [ "obj-82", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 1 ],
                    "source": [ "obj-83", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 1 ],
                    "order": 0,
                    "source": [ "obj-84", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "order": 0,
                    "source": [ "obj-84", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23", 0 ],
                    "midpoints": [ 656.5, 887.3333436250687, 470.66667878627777, 887.3333436250687, 470.66667878627777, 812.3333436250687, 630.6666787862778, 812.3333436250687, 630.6666787862778, 686.3333436250687, 645.500018954277, 686.3333436250687 ],
                    "order": 2,
                    "source": [ "obj-84", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-85", 1 ],
                    "order": 1,
                    "source": [ "obj-84", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-85", 0 ],
                    "order": 1,
                    "source": [ "obj-84", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9", 0 ],
                    "midpoints": [ 626.5, 889.3333436250687, 471.66667878627777, 889.3333436250687, 471.66667878627777, 686.3333436250687, 497.5000145435333, 686.3333436250687 ],
                    "order": 2,
                    "source": [ "obj-84", 0 ]
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
                    "midpoints": [ 266.8333410024643, 577.4166845083237, 100.1666693687439, 577.4166845083237 ],
                    "source": [ "obj-93", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-110", 0 ],
                    "order": 2,
                    "source": [ "obj-94", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-196", 0 ],
                    "midpoints": [ 100.1666693687439, 812.3333436250687, 786.6666787862778, 812.3333436250687, 786.6666787862778, 668.3333436250687, 771.6666787862778, 668.3333436250687, 771.6666787862778, 593.3333436250687, 860.1666920185089, 593.3333436250687 ],
                    "order": 0,
                    "source": [ "obj-94", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-70", 0 ],
                    "midpoints": [ 100.1666693687439, 830.3333436250687, 273.5000078678131, 830.3333436250687 ],
                    "order": 1,
                    "source": [ "obj-94", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 225.83332312107086, 830.3333436250687, 373.50001084804535, 830.3333436250687 ],
                    "source": [ "obj-94", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 0 ],
                    "source": [ "obj-95", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-28", 0 ],
                    "source": [ "obj-96", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 1 ],
                    "midpoints": [ 185.1666694879532, 390.6666604280472, 106.99999988079071, 390.6666604280472, 106.99999988079071, 750.6666604280472, 142.05555395285288, 750.6666604280472 ],
                    "source": [ "obj-98", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "source": [ "obj-98", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-117": [ "live.gain~[2]", "live.gain~", 0 ],
            "obj-179": [ "umenu[3]", "umenu", 0 ],
            "obj-195": [ "live.gain~[3]", "live.gain~", 0 ],
            "obj-320": [ "button[14]", "button[14]", 0 ],
            "obj-324": [ "umenu[6]", "umenu[2]", 0 ],
            "obj-62": [ "umenu", "umenu", 0 ],
            "obj-64": [ "flonum[2]", "flonum", 0 ],
            "obj-72": [ "flonum[1]", "flonum", 0 ],
            "obj-84": [ "live.gain~[1]", "live.gain~", 0 ],
            "obj-88": [ "kslider[1]", "kslider[1]", 0 ],
            "obj-91": [ "kslider", "kslider", 0 ],
            "obj-92": [ "flonum", "flonum", 0 ],
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
        "bgcolor": [ 0.0, 0.0, 0.0, 1.0 ],
        "editing_bgcolor": [ 0.0, 0.0, 0.0, 1.0 ]
    }
}