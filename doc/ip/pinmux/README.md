# Pin multiplexer

This allows software to dynamically switch FPGA pins between input and output as well as reassign them for SPI, I2C, UART, etc.
The block also allows pad control.

To see the possible mappings, please refer to [the top configuration](https://github.com/lowRISC/sonata-system/blob/main/data/top_config.toml).
All selectors are byte addressable, this means that you can write four selectors at a time with a 32-bit write.

There are output pin selectors, which select which block output is connected to a particular FPGA pin.
The selector is one-hot, so you need to write `8'b100` if you want to select input 3 for example.
The default value for all of these selectors is `'b10`.

| Address | Pin output | Possible block outputs |
|---------|------------|------------------------|
| 0x000 | `ser0_tx` | 0, `uart[0].tx` |
| 0x001 | `ser1_tx` | 0, `uart[1].tx` |
| 0x002 | `rs232_tx` | 0, `uart[4].tx` |
| 0x003 | `scl0` | 0, `i2c[0].scl` |
| 0x004 | `sda0` | 0, `i2c[0].sda` |
| 0x005 | `scl1` | 0, `i2c[1].scl` |
| 0x006 | `sda1` | 0, `i2c[1].sda` |
| 0x007 | `appspi_d0` | 0, `spi[0].tx` |
| 0x008 | `appspi_clk` | 0, `spi[0].sck` |
| 0x009 | `appspi_cs` | 0, `spi[0].cs[0]` |
| 0x00a | `lcd_copi` | 0, `spi[1].tx` |
| 0x00b | `lcd_clk` | 0, `spi[1].sck` |
| 0x00c | `lcd_cs` | 0, `spi[1].cs[0]` |
| 0x00d | `ethmac_copi` | 0, `spi[2].tx` |
| 0x00e | `ethmac_sclk` | 0, `spi[2].sck` |
| 0x00f | `ethmac_cs` | 0, `spi[2].cs[0]` |
| 0x010 | `rph_g0` | 0, `i2c[0].sda`, `gpio_rph[0].gpio[0]` |
| 0x011 | `rph_g1` | 0, `i2c[0].scl`, `gpio_rph[0].gpio[1]` |
| 0x012 | `rph_g2_sda` | 0, `i2c[1].sda`, `gpio_rph[0].gpio[2]` |
| 0x013 | `rph_g3_scl` | 0, `i2c[1].scl`, `gpio_rph[0].gpio[3]` |
| 0x014 | `rph_g4` | 0, `gpio_rph[0].gpio[4]` |
| 0x015 | `rph_g5` | 0, `gpio_rph[0].gpio[5]` |
| 0x016 | `rph_g6` | 0, `gpio_rph[0].gpio[6]` |
| 0x017 | `rph_g7_ce1` | 0, `spi[3].cs[1]`, `gpio_rph[0].gpio[7]` |
| 0x018 | `rph_g8_ce0` | 0, `spi[3].cs[0]`, `gpio_rph[0].gpio[8]` |
| 0x019 | `rph_g9_cipo` | 0, `gpio_rph[0].gpio[9]` |
| 0x01a | `rph_g10_copi` | 0, `spi[3].tx`, `gpio_rph[0].gpio[10]` |
| 0x01b | `rph_g11_sclk` | 0, `spi[3].sck`, `gpio_rph[0].gpio[11]` |
| 0x01c | `rph_g12` | 0, `gpio_rph[0].gpio[12]` |
| 0x01d | `rph_g13` | 0, `gpio_rph[0].gpio[13]` |
| 0x01e | `rph_txd0` | 0, `uart[2].tx`, `gpio_rph[0].gpio[14]` |
| 0x01f | `rph_rxd0` | 0, `gpio_rph[0].gpio[15]` |
| 0x020 | `rph_g16_ce2` | 0, `spi[4].cs[2]`, `gpio_rph[0].gpio[16]` |
| 0x021 | `rph_g17` | 0, `spi[4].cs[1]`, `gpio_rph[0].gpio[17]` |
| 0x022 | `rph_g18` | 0, `spi[4].cs[0]`, `gpio_rph[0].gpio[18]` |
| 0x023 | `rph_g19_cipo` | 0, `gpio_rph[0].gpio[19]` |
| 0x024 | `rph_g20_copi` | 0, `spi[4].tx`, `gpio_rph[0].gpio[20]` |
| 0x025 | `rph_g21_sclk` | 0, `spi[4].sck`, `gpio_rph[0].gpio[21]` |
| 0x026 | `rph_g22` | 0, `gpio_rph[0].gpio[22]` |
| 0x027 | `rph_g23` | 0, `gpio_rph[0].gpio[23]` |
| 0x028 | `rph_g24` | 0, `gpio_rph[0].gpio[24]` |
| 0x029 | `rph_g25` | 0, `gpio_rph[0].gpio[25]` |
| 0x02a | `rph_g26` | 0, `gpio_rph[0].gpio[26]` |
| 0x02b | `rph_g27` | 0, `gpio_rph[0].gpio[27]` |
| 0x02c | `ah_tmpio0` | 0, `gpio_ah[0].gpio[0]` |
| 0x02d | `ah_tmpio1` | 0, `gpio_ah[0].gpio[1]`, `uart[3].tx` |
| 0x02e | `ah_tmpio2` | 0, `gpio_ah[0].gpio[2]` |
| 0x02f | `ah_tmpio3` | 0, `gpio_ah[0].gpio[3]` |
| 0x030 | `ah_tmpio4` | 0, `gpio_ah[0].gpio[4]` |
| 0x031 | `ah_tmpio5` | 0, `gpio_ah[0].gpio[5]` |
| 0x032 | `ah_tmpio6` | 0, `gpio_ah[0].gpio[6]` |
| 0x033 | `ah_tmpio7` | 0, `gpio_ah[0].gpio[7]` |
| 0x034 | `ah_tmpio8` | 0, `gpio_ah[0].gpio[8]` |
| 0x035 | `ah_tmpio9` | 0, `gpio_ah[0].gpio[9]` |
| 0x036 | `ah_tmpio10` | 0, `spi[3].cs[2]`, `gpio_ah[0].gpio[10]` |
| 0x037 | `ah_tmpio11` | 0, `spi[3].tx`, `gpio_ah[0].gpio[11]` |
| 0x038 | `ah_tmpio12` | 0, `gpio_ah[0].gpio[12]` |
| 0x039 | `ah_tmpio13` | 0, `spi[3].sck`, `gpio_ah[0].gpio[13]` |
| 0x03a | `mb1` | 0, `spi[4].cs[3]` |
| 0x03b | `mb2` | 0, `spi[4].sck` |
| 0x03c | `mb4` | 0, `spi[4].tx` |
| 0x03d | `mb5` | 0, `i2c[1].sda` |
| 0x03e | `mb6` | 0, `i2c[1].scl` |
| 0x03f | `mb7` | 0, `uart[3].tx` |
| 0x040 | `mb10` | 0, `pwm[0].pwm[0]` |
| 0x041 | `pmod0_0` | 0, `gpio_pmod0[0].gpio[0]` |
| 0x042 | `pmod0_1` | 0, `gpio_pmod0[0].gpio[1]`, `spi[3].tx`, `uart[2].tx` |
| 0x043 | `pmod0_2` | 0, `gpio_pmod0[0].gpio[2]`, `i2c[0].scl` |
| 0x044 | `pmod0_3` | 0, `gpio_pmod0[0].gpio[3]`, `i2c[0].sda`, `spi[3].sck` |
| 0x045 | `pmod0_4` | 0, `gpio_pmod0[0].gpio[4]` |
| 0x046 | `pmod0_5` | 0, `gpio_pmod0[0].gpio[5]` |
| 0x047 | `pmod0_6` | 0, `gpio_pmod0[0].gpio[6]` |
| 0x048 | `pmod0_7` | 0, `gpio_pmod0[0].gpio[7]` |
| 0x049 | `pmod1_0` | 0, `gpio_pmod1[0].gpio[0]` |
| 0x04a | `pmod1_1` | 0, `gpio_pmod1[0].gpio[1]`, `spi[4].tx`, `uart[3].tx` |
| 0x04b | `pmod1_2` | 0, `gpio_pmod1[0].gpio[2]`, `i2c[1].scl` |
| 0x04c | `pmod1_3` | 0, `gpio_pmod1[0].gpio[3]`, `i2c[1].sda`, `spi[4].sck` |
| 0x04d | `pmod1_4` | 0, `gpio_pmod1[0].gpio[4]` |
| 0x04e | `pmod1_5` | 0, `gpio_pmod1[0].gpio[5]` |
| 0x04f | `pmod1_6` | 0, `gpio_pmod1[0].gpio[6]` |
| 0x050 | `pmod1_7` | 0, `gpio_pmod1[0].gpio[7]` |
| 0x051 | `microsd_clk` | 0, `spi[3].sck` |
| 0x052 | `microsd_cmd` | 0, `spi[3].tx` |
| 0x053 | `microsd_dat3` | 0, `spi[3].cs[3]` |
| 0x054 | `usrled[0]` | 0, `gpio_board[0].gpo[0]` |
| 0x055 | `usrled[1]` | 0, `gpio_board[0].gpo[1]` |
| 0x056 | `usrled[2]` | 0, `gpio_board[0].gpo[2]` |
| 0x057 | `usrled[3]` | 0, `gpio_board[0].gpo[3]` |
| 0x058 | `usrled[4]` | 0, `gpio_board[0].gpo[4]` |
| 0x059 | `usrled[5]` | 0, `gpio_board[0].gpo[5]` |
| 0x05a | `usrled[6]` | 0, `gpio_board[0].gpo[6]` |
| 0x05b | `usrled[7]` | 0, `gpio_board[0].gpo[7]` |

Besides the output pin selectors, there are also selectors for which pin should drive block inputs:

| Address | Block input | Possible pin inputs |
|---------|-------------|---------------------|
| 0x800 | `gpio_board[0].gpi[0]` | 0, `usrsw[0]` |
| 0x801 | `gpio_board[0].gpi[1]` | 0, `usrsw[1]` |
| 0x802 | `gpio_board[0].gpi[2]` | 0, `usrsw[2]` |
| 0x803 | `gpio_board[0].gpi[3]` | 0, `usrsw[3]` |
| 0x804 | `gpio_board[0].gpi[4]` | 0, `usrsw[4]` |
| 0x805 | `gpio_board[0].gpi[5]` | 0, `usrsw[5]` |
| 0x806 | `gpio_board[0].gpi[6]` | 0, `usrsw[6]` |
| 0x807 | `gpio_board[0].gpi[7]` | 0, `usrsw[7]` |
| 0x808 | `gpio_board[0].gpi[8]` | 0, `navsw[0]` |
| 0x809 | `gpio_board[0].gpi[9]` | 0, `navsw[1]` |
| 0x80a | `gpio_board[0].gpi[10]` | 0, `navsw[2]` |
| 0x80b | `gpio_board[0].gpi[11]` | 0, `navsw[3]` |
| 0x80c | `gpio_board[0].gpi[12]` | 0, `navsw[4]` |
| 0x80d | `gpio_board[0].gpi[13]` | 0, `microsd_det` |
| 0x80e | `gpio_board[0].gpi[14]` | 0, `selsw[0]` |
| 0x80f | `gpio_board[0].gpi[15]` | 0, `selsw[1]` |
| 0x810 | `gpio_board[0].gpi[16]` | 0, `selsw[2]` |
| 0x811 | `gpio_rph[0].gpio[0]` | 0, `rph_g0` |
| 0x812 | `gpio_rph[0].gpio[1]` | 0, `rph_g1` |
| 0x813 | `gpio_rph[0].gpio[2]` | 0, `rph_g2_sda` |
| 0x814 | `gpio_rph[0].gpio[3]` | 0, `rph_g3_scl` |
| 0x815 | `gpio_rph[0].gpio[4]` | 0, `rph_g4` |
| 0x816 | `gpio_rph[0].gpio[5]` | 0, `rph_g5` |
| 0x817 | `gpio_rph[0].gpio[6]` | 0, `rph_g6` |
| 0x818 | `gpio_rph[0].gpio[7]` | 0, `rph_g7_ce1` |
| 0x819 | `gpio_rph[0].gpio[8]` | 0, `rph_g8_ce0` |
| 0x81a | `gpio_rph[0].gpio[9]` | 0, `rph_g9_cipo` |
| 0x81b | `gpio_rph[0].gpio[10]` | 0, `rph_g10_copi` |
| 0x81c | `gpio_rph[0].gpio[11]` | 0, `rph_g11_sclk` |
| 0x81d | `gpio_rph[0].gpio[12]` | 0, `rph_g12` |
| 0x81e | `gpio_rph[0].gpio[13]` | 0, `rph_g13` |
| 0x81f | `gpio_rph[0].gpio[14]` | 0, `rph_txd0` |
| 0x820 | `gpio_rph[0].gpio[15]` | 0, `rph_rxd0` |
| 0x821 | `gpio_rph[0].gpio[16]` | 0, `rph_g16_ce2` |
| 0x822 | `gpio_rph[0].gpio[17]` | 0, `rph_g17` |
| 0x823 | `gpio_rph[0].gpio[18]` | 0, `rph_g18` |
| 0x824 | `gpio_rph[0].gpio[19]` | 0, `rph_g19_cipo` |
| 0x825 | `gpio_rph[0].gpio[20]` | 0, `rph_g20_copi` |
| 0x826 | `gpio_rph[0].gpio[21]` | 0, `rph_g21_sclk` |
| 0x827 | `gpio_rph[0].gpio[22]` | 0, `rph_g22` |
| 0x828 | `gpio_rph[0].gpio[23]` | 0, `rph_g23` |
| 0x829 | `gpio_rph[0].gpio[24]` | 0, `rph_g24` |
| 0x82a | `gpio_rph[0].gpio[25]` | 0, `rph_g25` |
| 0x82b | `gpio_rph[0].gpio[26]` | 0, `rph_g26` |
| 0x82c | `gpio_rph[0].gpio[27]` | 0, `rph_g27` |
| 0x82d | `gpio_ah[0].gpio[0]` | 0, `ah_tmpio0` |
| 0x82e | `gpio_ah[0].gpio[1]` | 0, `ah_tmpio1` |
| 0x82f | `gpio_ah[0].gpio[2]` | 0, `ah_tmpio2` |
| 0x830 | `gpio_ah[0].gpio[3]` | 0, `ah_tmpio3` |
| 0x831 | `gpio_ah[0].gpio[4]` | 0, `ah_tmpio4` |
| 0x832 | `gpio_ah[0].gpio[5]` | 0, `ah_tmpio5` |
| 0x833 | `gpio_ah[0].gpio[6]` | 0, `ah_tmpio6` |
| 0x834 | `gpio_ah[0].gpio[7]` | 0, `ah_tmpio7` |
| 0x835 | `gpio_ah[0].gpio[8]` | 0, `ah_tmpio8` |
| 0x836 | `gpio_ah[0].gpio[9]` | 0, `ah_tmpio9` |
| 0x837 | `gpio_ah[0].gpio[10]` | 0, `ah_tmpio10` |
| 0x838 | `gpio_ah[0].gpio[11]` | 0, `ah_tmpio11` |
| 0x839 | `gpio_ah[0].gpio[12]` | 0, `ah_tmpio12` |
| 0x83a | `gpio_ah[0].gpio[13]` | 0, `ah_tmpio13` |
| 0x83b | `gpio_pmod0[0].gpio[0]` | 0, `pmod0_0` |
| 0x83c | `gpio_pmod0[0].gpio[1]` | 0, `pmod0_1` |
| 0x83d | `gpio_pmod0[0].gpio[2]` | 0, `pmod0_2` |
| 0x83e | `gpio_pmod0[0].gpio[3]` | 0, `pmod0_3` |
| 0x83f | `gpio_pmod0[0].gpio[4]` | 0, `pmod0_4` |
| 0x840 | `gpio_pmod0[0].gpio[5]` | 0, `pmod0_5` |
| 0x841 | `gpio_pmod0[0].gpio[6]` | 0, `pmod0_6` |
| 0x842 | `gpio_pmod0[0].gpio[7]` | 0, `pmod0_7` |
| 0x843 | `gpio_pmod1[0].gpio[0]` | 0, `pmod1_0` |
| 0x844 | `gpio_pmod1[0].gpio[1]` | 0, `pmod1_1` |
| 0x845 | `gpio_pmod1[0].gpio[2]` | 0, `pmod1_2` |
| 0x846 | `gpio_pmod1[0].gpio[3]` | 0, `pmod1_3` |
| 0x847 | `gpio_pmod1[0].gpio[4]` | 0, `pmod1_4` |
| 0x848 | `gpio_pmod1[0].gpio[5]` | 0, `pmod1_5` |
| 0x849 | `gpio_pmod1[0].gpio[6]` | 0, `pmod1_6` |
| 0x84a | `gpio_pmod1[0].gpio[7]` | 0, `pmod1_7` |
| 0x84b | `uart[0].rx` | 1, `ser0_rx` |
| 0x84c | `uart[1].rx` | 1, `ser1_rx` |
| 0x84d | `uart[2].rx` | 1, `rph_rxd0`, `pmod0_2` |
| 0x84e | `uart[3].rx` | 1, `ah_tmpio0`, `mb8`, `pmod1_2` |
| 0x84f | `uart[4].rx` | 1, `rs232_rx` |
| 0x850 | `spi[0].rx` | 0, `appspi_d1` |
| 0x851 | `spi[1].rx` | 0, 0 |
| 0x852 | `spi[2].rx` | 0, `ethmac_cipo` |
| 0x853 | `spi[3].rx` | 0, `rph_g9_cipo`, `ah_tmpio12`, `pmod0_2`, `microsd_dat0` |
| 0x854 | `spi[4].rx` | 0, `rph_g19_cipo`, `mb3`, `pmod1_2` |

## Regeneration

If any changes are made to the top configuration, the templates or the bus, you must regenerate the top.
You can do so using the top generation utility, which regenerates the pinmux, the bus and the sonata package which is used by the SystemVerilog generate statements throughout the project.

```sh
./util/top_gen.py
```
