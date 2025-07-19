# SoC Memory Map View from DIE0 P550 (MCPU)
| MMIO address | size | device | comment |
| -------- | ------- | --------- | ----- |
| 40000000 |  800000 | **PCIe Config Space** |
| 40800000 |  800000 | **PCIe MMIO Space** |
| 41000000 | f000000 | **PCIe Mem Space** |
|          |         | *PCIe Controller Mgmt* | `50000000-50100000 pcie wrapper cfg space` |
| 50000000 |  100000 | **PCIe Controller Mgmt** |
|          |         | *Video Codec* | `50100000-50200000 vc cfg space` |
| 50100000 |   10000 | **Video Decoder** |
| 50110000 |   10000 | **Video Encoder** |
| 50120000 |   10000 | **JPEG Decoder** |
| 50130000 |   10000 | **JPEG Encoder** |
| 50140000 |   40000 | **gc820 core2d** |
| 50180000 |   40000 | **gc820 core2d1** |
| 501c0000 |    1000 | **VC CSR** |
|          |         | *Video Output* | `50200000-50400000 vo cfg space` |
| 50200000 |   10000 | **I2S0** |
| 50210000 |   10000 | **I2S1** |
| 50220000 |   10000 | **I2S2** |
| 50270000 |   10000 | **DW DSI Controller** |
| 50280000 |   10000 | **VO CSR** |
| 50290000 |   10000 | **DW HDMI HDCP2** |
| 502a0000 |   20000 | **DW HDMI** |
| 502c0000 |   10000 | **DC (DC8200?)** |
|          |         | *High Speed peripherals* | `50400000-50800000 hsp cfg space` |
| 50400000 |   10000 | **GMAC0** |
| 50410000 |   10000 | **GMAC1** |
| 50420000 |   10000 | **SATA** |
| 50430000 |   10000 | **DMA0** |
| 50440000 |    2000 | **HSP SP CSR** |
| 50450000 |   10000 | **SDHCI eMMC** |
| 50460000 |   10000 | **SDIO0** |
| 50470000 |   10000 | **SDIO1** |
| 50480000 |   10000 | **usbdrd3_0** |
| 50490000 |   10000 | **usbdrd3_1** |
|          |         | *Low Speed peripherals apb2*  | `50800000-50900000 lsp cfg space apb2` |
| 50800000 |    4000 | **watchdog0** |
| 50804000 |    4000 | **watchdog1** |
| 50808000 |    4000 | **watchdog2** |
| 5080c000 |    4000 | **watchdog3** |
| 50810000 |    4000 | **SPI0** |
| 50814000 |    4000 | **SPI1** |
| 50818000 |    4000 | **PWM** |
|          |         | *Low Speed peripherals apb3*  | `50900000-50a00000 lsp cfg space apb3` |
| 50900000 |   10000 | **UART0** |
| 50910000 |   10000 | **UART1** |
| 50920000 |   10000 | **UART2** |
| 50930000 |   10000 | **UART3** |
| 50940000 |   10000 | **UART4** |
| 50950000 |   10000 | **I2C0** |
| 50960000 |   10000 | **I2C1** |
| 50970000 |   10000 | **I2C2** |
| 50980000 |   10000 | **I2C3** |
| 50990000 |   10000 | **I2C4** |
| 509a0000 |   10000 | **I2C5** |
| 509b0000 |   10000 | **I2C6** |
| 509c0000 |   10000 | **I2C7** |
| 509d0000 |   10000 | **I2C8** |
| 509e0000 |   10000 | **I2C9** |
|          |         | *Low Speed peripherals apb4*  | `50a00000-50b00000 lsp cfg space apb4` |
| 50a00000 |   10000 | **MBOX** | U84 -> SCPU |
| 50a10000 |   10000 | **MBOX** | SCPU -> U84 |
| 50a20000 |   10000 | **MBOX** | U84 -> LCPU |
| 50a30000 |   10000 | **MBOX** | LCPU -> U84 |
| 50a40000 |   10000 | **MBOX** | U84 -> NPU0 |
| 50a50000 |   10000 | **MBOX** | NPU0 -> U84 |
| 50a60000 |   10000 | **MBOX** | U84 -> NPU1 |
| 50a70000 |   10000 | **MBOX** | NPU1 -> U84 |
| 50a80000 |   10000 | **MBOX** | U84 -> DSP0 |
| 50a90000 |   10000 | **MBOX** | DSP0 -> U84 |
| 50aa0000 |   10000 | **MBOX** | U84 -> DSP1 |
| 50ab0000 |   10000 | **MBOX** | DSP1 -> U84 |
| 50ac0000 |   10000 | **MBOX** | U84 -> DSP2 |
| 50ad0000 |   10000 | **MBOX** | DSP2 -> U84 |
| 50ae0000 |   10000 | **MBOX** | U84 -> DSP3 |
| 50af0000 |   10000 | **MBOX** | DSP3 -> U84 |
|          |         | *Low Speed peripherals apb6*  | `50b00000-50c00000 lsp cfg space apb6` |
| 50b00000 |   10000 | **PVT0** |
| 50b50000 |   10000 | **FAN Control** |
|          |         | *SMMU*   | `50c00000-51000000 smmu cfg space` |
| 50c00000 |  100000 | **SMMU** |
|          |         | *Video Input* | `51000000-51200000 vi cfg space` |
| 51000000 |   10000 | **ISP0** |
| 51010000 |   10000 | **ISP1** |
| 51020000 |   10000 | **dewrap** |
| 51030000 |   10000 | **VI Top CSR** |
| 51050000 |   10000 | **CSI2_0** |
| 51060000 |   10000 | **CSI2_1** |
| 51070000 |   10000 | **CSI2_2** |
| 51080000 |   10000 | **CSI2_3** |
| 51090000 |   10000 | **CSI2_4** |
| 510a0000 |   10000 | **CSI2_5** |
| 510c0000 |   20000 | **CSI2_DPHY_HW0** |
| 510e0000 |   20000 | **CSI2_DPHY_HW1** |
| 51100000 |   20000 | **CSI2_DPHY_HW2** |
| 51120000 |   20000 | **CSI2_DPHY_HW3** |
| 51140000 |   20000 | **CSI2_DPHY_HW4** |
| 51160000 |   20000 | **CSI2_DPHY_HW5** |
|          |         | *Reserved* | `51200000-51400000 reserved` |
|          |         | *GPU* | `51400000-51600000 gpu cfg space` |
| 51400000 |  100000 | **GPU** |
|          |         | *Pinctrl* | `51600000-51800000 clmm cfg space` |
| 51600000 |  200000 | **PINCTRL** |
|          |         | *Always ON* | `51800000-51c00000 aon cfg space` |
| 51800000 |    8000 | **bootspi** |
| 51808000 |    8000 | **PMU** |
| 51810000 |    8000 | **SYSCON** |
| 51818000 |    1000 | **RTC** |
| 51828000 |    8000 | **SYSCRG** |
| 51830000 |    8000 | **AON I2C0** |
| 51838000 |    8000 | **AON I2C1** |
| 51840000 |    8000 | **TIMER0** |
| 51848000 |    8000 | **TIMER1** |
| 51850000 |    8000 | **TIMER2** |
| 51858000 |    8000 | **TIMER3** |
| 51900000 |    1000 | **SPAcc** | Synopsys Security Protocol Accelerator  |
| 51b00000 |    1000 | **PKA** | Synopsys Public Key Accelerator |
| 51b04000 |    4000 | **PKA Instruction SRAM** | SRAM to hold PKA Instructions |
| 51b08000 |    1000 | **TRNG** | Synopsys True Random Number Generator |
|          |         | *NPU* | `51c00000-52000000 npu cfg space` |
| 51c00000 |  200000 | **NPU** | Many components combined. 0x1000 each |
| 51d88000 |    1000 | **NPU LLC0** | CodaCache LLC |
| 51d89000 |    1000 | **NPU LLC1** | CodaCache LLC |
|          |         | *NoC* | `52000000-52100000 noc cfg space` |
| 52000000 |     800 | **noc-packet-probe** | sysnoc_packet_ddr0_p1_req_probe |
| 52000800 |     800 | **noc-packet-probe** | sysnoc_packet_ddr0_p2_req_probe |
| 52001000 |     800 | **noc-packet-probe** | sysnoc_packet_ddr1_p1_req_probe |
| 52001800 |     800 | **noc-packet-probe** | sysnoc_packet_ddr1_p2_req_probe |
| 52002000 |     400 | **noc-trans-probe** | sysnoc_trans_probe_0 |
| 52002400 |     400 | **noc-trans-probe** | sysnoc_trans_probe_1 |
| 52002800 |     400 | **noc-trans-probe** | sysnoc_trans_probe_2 |
| 52002c00 |      80 | **noc** | d0_sys_noc |
| 52002c80 |      80 | **qos-settings** | DSPT |
| 52002d00 |      80 | **qos-settings** | NPU |
| 52002d80 |      80 | **qos-settings** | SPISLV_TBU3 |
| 52002e00 |      80 | **noc-trans-filter** | sysnoc_trans_dspt_filter |
| 52002e80 |      80 | **noc-trans-filter** | sysnoc_trans_mcput_mp_filter | 
| 52002f00 |      80 | **noc-trans-filter** | sysnoc_trans_mcput_sp1_filter | 
| 52002f80 |      80 | **noc-trans-filter** | sysnoc_trans_npu_sp1_filter | 
| 52003000 |      80 | **noc-trans-filter** | sysnoc_trans_spislv_tbu3_filter `pcie subsys` |
| 52003080 |      80 | **noc-trans-filter** | sysnoc_trans_tbu4_filter `aon subsys` |
| 52003100 |      80 | **noc-trans-filter** | sysnoc_trans_tcu_filter |
| 52003180 |      80 | **noc-trans-filter** | sysnoc_trans_profiler |
| 52003200 |      80 | **noc-trans-filter** | sysnoc_trans_profiler |
| 52003280 |      80 | **noc-trans-filter** | sysnoc_trans_profiler |
| 52004000 |      10 | **noc-sideband-manager** | sideband_manager |
| 52020000 |     800 | **noc-packet-probe** | mnoc_packet_ddr0_p3_req_probe |
| 52020800 |     800 | **noc-packet-probe** | mnoc_packet_ddr1_p3_req_probe |
| 52021000 |     400 | **noc-trans-probe** | mnoc_trans_probe |
| 52021400 |      80 | **noc** | d0_media_noc |
| 52021480 |      80 | **qos-settings** | GPU |
| 52021500 |      80 | **qos-settings** | TBU2 |
| 52021580 |      80 | **qos-settings** | VC |
| 52021600 |      80 | **noc-trans-filter** | mnoc_trans_gpu_filter |
| 52021680 |      80 | **noc-trans-filter** | mnoc_trans_tbu2_filter `hsp subsys` |
| 52021700 |      80 | **noc-trans-filter** | mnoc_trans_vc_filter |
| 52021780 |      80 | **noc-trans-filter** | mnoc_trans_profiler |
| 52022000 |      10 | **noc-sideband-manager** | sideband_manager |
| 52040000 |     800 | **noc-packet-probe** | rnoc_packet_ddr0_p4_req_probe |
| 52040800 |     800 | **noc-packet-probe** | rnoc_packet_ddr1_p4_req_probe |
| 52041000 |     400 | **noc-trans-probe** | rnoc_trans_probe |
| 52041400 |      80 | **noc** | d0_realtime_noc |
| 52041480 |      80 | **qos-settings** | TBU0 |
| 52041500 |      80 | **qos-settings** | VO |
| 52041580 |      80 | **noc-trans-filter** | rnoc_trans_tbu0_filter |
| 52041600 |      80 | **noc-trans-filter** | rnoc_trans_vo_filter |
| 52041680 |      80 | **noc-trans-filter** | rnoc_trans_profiler |
| 52042000 |      10 | **noc-sideband-manager** | sideband_manager |
| 52060000 |      80 | **noc** | d0_cfg_noc |
| 52061000 |      10 | **noc-sideband-manager** | sideband_manager |
| 52080000 |     800 | **noc-packet-probe** | llcnoc_packet_ddr0_p0_req_probe |
| 52080800 |     800 | **noc-packet-probe** | llcnoc_packet_ddr1_p0_req_probe |
| 52081000 |     400 | **noc-trans-probe** | llcnoc_trans_probe |
| 52081400 |      80 | **noc** | d0_llc_noc |
| 52081480 |      80 | **noc-trans-filter** | llcnoc_trans_npu_llc0_filter |
| 52081500 |      80 | **noc-trans-filter** | llcnoc_trans_npu_llc1_filter |
| 52081580 |      80 | **noc-trans-filter** | llcnoc_trans_profiler |
| 52082000 |      10 | **noc-sideband-manager** | sideband_manager |
|          |         | *Die-to-Die* | `52100000-52200000 d2d cfg space` |
| 52100000 |   50000 | **eic7x-d2d** | die-to-die |
|          |         | *DSP* | `52200000-52300000 dsp cfg space` |
| 52200000 |   10000 | **es-dsp-subsys** |
| 52300000 |   40000 | **DDR CTRL0** | `52300000-52380000 ddrc0 cfg space` |
| 52380000 |   40000 | **DDR CTRL1** | `52380000-52400000 ddrc1 cfg space` |
|          |         | *Reserved* | `52400000-53000000 reserved` |
| 53000000 |   ????  | **DDR PHY0** | `53000000-53800000 ddrphy0 cfg space` |
| 53800000 |   ????  | **DDR PHY1** | `53800000-54000000 ddrphy1 cfg space` |
|          |         | *PCIe Controller* | `54000000-58000000 pcie dbi cfg space` |
| 54000000 | 4000000 | **PCIe IP registers** |
| 58000000 |   20000 | **ROM** | Masked ROM. Not accessible from P550 (MCPU) SCPU only |
| 58500000 |   10000 | **SCPU TIM** | SCPU TIM `@0x30000000` remapped |
| 58800000 |   ????  | **AON TIM** |
| 59000000 |   4M?   | **CodaCache0** | Used by SCPU to load bootchain components |
| 5a000000 |   4M?   | **CodaCache1** | Used by NPU to load program |
| 5b000000 |   ????  | **DSP SRAM** |
| 5c000000 | 4000000 | **nor-flash** | SPI nor-flash direct map area |
