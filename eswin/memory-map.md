# Memory Map View from P550 (MCPU)
| MMIO address | size | device | comment |
| -------- | ------- | --------- | ----- |
| _______0 |    1000 | **Debug** |
| ____1000 |    3000 | Error Device |
| ____4000 |    1000 | **Test Status** |
| ____5000 |   13000 | Error Device |
| ___18000 |    1000 | **Trace Funnel** |
| ___19000 |   e7000 | Error Device |
| __100000 |    1000 | **Hart 0 Trace Encoder** |
| __101000 |    1000 | **Hart 1 Trace Encoder** |
| __102000 |    1000 | **Hart 2 Trace Encoder** |
| __103000 |    1000 | **Hart 3 Trace Encoder** |
| __104000 |    4000 | **Hart 0 Private L2** |
| __108000 |    4000 | **Hart 1 Private L2** |
| __10c000 |    4000 | **Hart 2 Private L2** |
| __110000 |    4000 | **Hart 3 Private L2** |
| __114000 |   ec000 | Error Device |
| __200000 |    1000 | **Bus Blocker on TL64D2D_Out (TL-UH master)** |
| __201000 |    1000 | Error Device |
| __202000 |    1000 | **Bus Blocker on TL256D2D_Out (TL-C master)** |
| __203000 |    1000 | Error Device |
| __204000 |    1000 | **Bus Blocker on TL256D2D_In (TL-C slave)** |
| __205000 | 14fb000 | Error Device |
| _1700000 |    1000 | **Hart 0 Bus Error Unit** |
| _1701000 |    1000 | **Hart 1 Bus Error Unit** |
| _1702000 |    1000 | **Hart 2 Bus Error Unit** |
| _1703000 |    1000 | **Hart 3 Bus Error Unit** |
| _1704000 |  8fc000 | Error Device |
| _2000000 |   10000 | **CLINT** |
| _2010000 |    4000 | **Shared L3 Cache**   |
| _2014000 | 5fec000 | Error Device |
| _8000000 |  400000 | **L3 LIM** |
| _8400000 | 3c00000 | Error Deviec |
| _c000000 | 4000000 | **PLIC** |
| 10000000 |    3000 | Error Device |
| 10003000 |    1000 | Error Device |
| 10004000 |    c000 | Error Device |
| 10010000 |    1000 | **Burst Bundler on Front Port** |
| 10011000 |   1f000 | Error Device |
| 10030000 |    4000 | **TL-UH to TL-C Adapter** |
| 10034000 | 9fcc000 | Error Device |
| 1a000000 |  400000 | **L3 Zero Device** |
| 1a400000 | 5c00000 | Error Device |
| 20000000 | 20000000 | **Die 1 EIC7700X MCPU Internals** |
| 40000000 | 40000000 | **System Port 0 (1GB)** |
| 80000000 | 7f_80000000 | **Memory Port 0 (512GB)** |
| 80_00000000 | 180_00000000 | **System Port 1 (1.5TB)** |
