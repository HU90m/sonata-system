/**
 * Copyright lowRISC contributors.
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once
#include <debug.hh>
#include <stdint.h>
#include <utils.hh>

/**
 * A driver for Sonata's Pin Multiplexer (Pinmux).
 *
 * This driver can be used to select which block output is placed on a given
 * output pin, and to select which input pin is provided to a given block
 * input. Sonata's pinmux only allows certain selections per output pin / block
 * input, which this driver describes.
 *
 * Rendered documentation is served from:
 * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
 */
class SonataPinmux : private utils::NoCopyNoMove {
  /**
   * Flag to set when debugging the driver for UART log messages.
   */
  static constexpr bool DebugDriver = false;

  /**
   * Helper for conditional debug logs and assertions.
   */
  using Debug = ConditionalDebug<DebugDriver, "Pinmux">;

  /**
   * A pointer/capability to the Pin Multiplexer's registers, where
   * each sequential byte potentially corresponds to some mapped pinmux
   * selector used to select the pin configuration.
   */
  volatile uint8_t *registers;

 public:
  /**
   * The Output Pins defined for the Sonata board. These output pins can be
   * multiplexed, meaning that they can be changed to output the outputs
   * of different blocks (or disabled). The block outputs that can be
   * selected are limited, and vary on a per-pin basis.
   *
   * Documentation sources:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   * https://github.com/lowRISC/sonata-system/blob/4b72d8c07c727846c6ccb27754352388f3b2ac9a/data/pins_sonata.xdc
   * https://github.com/newaetech/sonata-pcb/blob/649b11c2fb758f798966605a07a8b6b68dd434e9/sonata-schematics-r09.pdf
   */
  enum class OutputPin : uint16_t {
    usrled_0          = 0x000,
    usrled_1          = 0x001,
    usrled_2          = 0x002,
    usrled_3          = 0x003,
    usrled_4          = 0x004,
    usrled_5          = 0x005,
    usrled_6          = 0x006,
    usrled_7          = 0x007,
    ser0_tx           = 0x008,
    ser1_tx           = 0x009,
    rs232_tx          = 0x00a,
    scl0              = 0x00b,
    sda0              = 0x00c,
    scl1              = 0x00d,
    sda1              = 0x00e,
    appspi_d0         = 0x00f,
    appspi_clk        = 0x010,
    appspi_cs         = 0x011,
    ethmac_copi       = 0x012,
    ethmac_sclk       = 0x013,
    ethmac_cs         = 0x014,
    ethmac_rst        = 0x015,
    microsd_clk       = 0x016,
    microsd_cmd       = 0x017,
    microsd_dat3      = 0x018,
    lcd_copi          = 0x019,
    lcd_clk           = 0x01a,
    lcd_cs            = 0x01b,
    lcd_rst           = 0x01c,
    lcd_dc            = 0x01d,
    lcd_backlight     = 0x01e,
    rph_g0            = 0x01f,
    rph_g1            = 0x020,
    rph_g2_sda        = 0x021,
    rph_g3_scl        = 0x022,
    rph_g4            = 0x023,
    rph_g5            = 0x024,
    rph_g6            = 0x025,
    rph_g7_spi0_ce1   = 0x026,
    rph_g8_spi0_ce0   = 0x027,
    rph_g9_cipo       = 0x028,
    rph_g10_copi      = 0x029,
    rph_g11_sclk      = 0x02a,
    rph_g12           = 0x02b,
    rph_g13           = 0x02c,
    rph_txd0          = 0x02d,
    rph_rxd0          = 0x02e,
    rph_g16_spi1_ce2  = 0x02f,
    rph_g17_spi1_ce1  = 0x030,
    rph_g18_spi1_ce0  = 0x031,
    rph_g19_spi1_cipo = 0x032,
    rph_g20_spi1_copi = 0x033,
    rph_g21_spi1_sclk = 0x034,
    rph_g22           = 0x035,
    rph_g23           = 0x036,
    rph_g24           = 0x037,
    rph_g25           = 0x038,
    rph_g26           = 0x039,
    rph_g27           = 0x03a,
    ah_tmpio0         = 0x03b,
    ah_tmpio1         = 0x03c,
    ah_tmpio2         = 0x03d,
    ah_tmpio3         = 0x03e,
    ah_tmpio4         = 0x03f,
    ah_tmpio5         = 0x040,
    ah_tmpio6         = 0x041,
    ah_tmpio7         = 0x042,
    ah_tmpio8         = 0x043,
    ah_tmpio9         = 0x044,
    ah_tmpio10        = 0x045,
    ah_tmpio11        = 0x046,
    ah_tmpio12        = 0x047,
    ah_tmpio13        = 0x048,
    mb1               = 0x049,
    mb2               = 0x04a,
    mb4               = 0x04b,
    mb5               = 0x04c,
    mb6               = 0x04d,
    mb7               = 0x04e,
    mb10              = 0x04f,
    pmod0_0           = 0x050,
    pmod0_1           = 0x051,
    pmod0_2           = 0x052,
    pmod0_3           = 0x053,
    pmod0_4           = 0x054,
    pmod0_5           = 0x055,
    pmod0_6           = 0x056,
    pmod0_7           = 0x057,
    pmod1_0           = 0x058,
    pmod1_1           = 0x059,
    pmod1_2           = 0x05a,
    pmod1_3           = 0x05b,
    pmod1_4           = 0x05c,
    pmod1_5           = 0x05d,
    pmod1_6           = 0x05e,
    pmod1_7           = 0x05f,
    pmodc_0           = 0x060,
    pmodc_1           = 0x061,
    pmodc_2           = 0x062,
    pmodc_3           = 0x063,
    pmodc_4           = 0x064,
    pmodc_5           = 0x065,
  };

  /**
   * The Block Inputs defined for the Sonata board. These block inputs can
   * be multiplexed, meaning that they can be changed to take the input of
   * different pins (or be disabled). The pin inputs that can be selected
   * are limited, and vary on a per-block-input basis.
   *
   * For reference:
   *   gpio_0 = Raspberry Pi
   *   gpio_1 = ArduinoShield
   *   gpio_2 = Pmod
   *
   * Documentation source:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   * */
  enum class BlockInput : uint16_t {
    gpio_board_0_gpi_0  = 0x800,
    gpio_board_0_gpi_1  = 0x801,
    gpio_board_0_gpi_2  = 0x802,
    gpio_board_0_gpi_3  = 0x803,
    gpio_board_0_gpi_4  = 0x804,
    gpio_board_0_gpi_5  = 0x805,
    gpio_board_0_gpi_6  = 0x806,
    gpio_board_0_gpi_7  = 0x807,
    gpio_board_0_gpi_8  = 0x808,
    gpio_board_0_gpi_9  = 0x809,
    gpio_board_0_gpi_10 = 0x80a,
    gpio_board_0_gpi_11 = 0x80b,
    gpio_board_0_gpi_12 = 0x80c,
    gpio_board_0_gpi_13 = 0x80d,
    gpio_board_0_gpi_14 = 0x80e,
    gpio_board_0_gpi_15 = 0x80f,
    gpio_board_0_gpi_16 = 0x810,
    gpio_rph_0_gpio_0   = 0x811,
    gpio_rph_0_gpio_1   = 0x812,
    gpio_rph_0_gpio_2   = 0x813,
    gpio_rph_0_gpio_3   = 0x814,
    gpio_rph_0_gpio_4   = 0x815,
    gpio_rph_0_gpio_5   = 0x816,
    gpio_rph_0_gpio_6   = 0x817,
    gpio_rph_0_gpio_7   = 0x818,
    gpio_rph_0_gpio_8   = 0x819,
    gpio_rph_0_gpio_9   = 0x81a,
    gpio_rph_0_gpio_10  = 0x81b,
    gpio_rph_0_gpio_11  = 0x81c,
    gpio_rph_0_gpio_12  = 0x81d,
    gpio_rph_0_gpio_13  = 0x81e,
    gpio_rph_0_gpio_14  = 0x81f,
    gpio_rph_0_gpio_15  = 0x820,
    gpio_rph_0_gpio_16  = 0x821,
    gpio_rph_0_gpio_17  = 0x822,
    gpio_rph_0_gpio_18  = 0x823,
    gpio_rph_0_gpio_19  = 0x824,
    gpio_rph_0_gpio_20  = 0x825,
    gpio_rph_0_gpio_21  = 0x826,
    gpio_rph_0_gpio_22  = 0x827,
    gpio_rph_0_gpio_23  = 0x828,
    gpio_rph_0_gpio_24  = 0x829,
    gpio_rph_0_gpio_25  = 0x82a,
    gpio_rph_0_gpio_26  = 0x82b,
    gpio_rph_0_gpio_27  = 0x82c,
    gpio_ah_0_gpio_0    = 0x82d,
    gpio_ah_0_gpio_1    = 0x82e,
    gpio_ah_0_gpio_2    = 0x82f,
    gpio_ah_0_gpio_3    = 0x830,
    gpio_ah_0_gpio_4    = 0x831,
    gpio_ah_0_gpio_5    = 0x832,
    gpio_ah_0_gpio_6    = 0x833,
    gpio_ah_0_gpio_7    = 0x834,
    gpio_ah_0_gpio_8    = 0x835,
    gpio_ah_0_gpio_9    = 0x836,
    gpio_ah_0_gpio_10   = 0x837,
    gpio_ah_0_gpio_11   = 0x838,
    gpio_ah_0_gpio_12   = 0x839,
    gpio_ah_0_gpio_13   = 0x83a,
    gpio_pmod0_0_gpio_0 = 0x83b,
    gpio_pmod0_0_gpio_1 = 0x83c,
    gpio_pmod0_0_gpio_2 = 0x83d,
    gpio_pmod0_0_gpio_3 = 0x83e,
    gpio_pmod0_0_gpio_4 = 0x83f,
    gpio_pmod0_0_gpio_5 = 0x840,
    gpio_pmod0_0_gpio_6 = 0x841,
    gpio_pmod0_0_gpio_7 = 0x842,
    gpio_pmod1_0_gpio_0 = 0x843,
    gpio_pmod1_0_gpio_1 = 0x844,
    gpio_pmod1_0_gpio_2 = 0x845,
    gpio_pmod1_0_gpio_3 = 0x846,
    gpio_pmod1_0_gpio_4 = 0x847,
    gpio_pmod1_0_gpio_5 = 0x848,
    gpio_pmod1_0_gpio_6 = 0x849,
    gpio_pmod1_0_gpio_7 = 0x84a,
    gpio_pmodc_0_gpio_0 = 0x84b,
    gpio_pmodc_0_gpio_1 = 0x84c,
    gpio_pmodc_0_gpio_2 = 0x84d,
    gpio_pmodc_0_gpio_3 = 0x84e,
    gpio_pmodc_0_gpio_4 = 0x84f,
    gpio_pmodc_0_gpio_5 = 0x850,
    uart_0_rx           = 0x851,
    uart_1_rx           = 0x852,
    uart_2_rx           = 0x853,
    spi_0_cipo          = 0x854,
    spi_1_cipo          = 0x855,
    spi_2_cipo          = 0x856,
    spi_3_cipo          = 0x857,
  };

  /**
   * A helper function that returns the number of block outputs that can be
   * selected from in the pin multiplexer for a given output pin. This will
   * always be at least 2, as option 0 represents 'OFF' i.e. no connection,
   * and option 1 represents the default connection.
   *
   * @param output_pin The output pin to query
   * @returns The number of selections available for that output pin
   *
   * The meanings of these selections can be found in the documentation:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   */
  static constexpr uint8_t output_pin_options(OutputPin output_pin) {
    switch (output_pin) {
      case OutputPin::pmod0_1:
      case OutputPin::pmod1_1:
        return 5;
      case OutputPin::rph_g18_spi1_ce0:
      case OutputPin::rph_g20_spi1_copi:
      case OutputPin::rph_g21_spi1_sclk:
      case OutputPin::ah_tmpio10:
      case OutputPin::ah_tmpio11:
      case OutputPin::pmod0_3:
      case OutputPin::pmod1_3:
        return 4;
      case OutputPin::lcd_backlight:
      case OutputPin::rph_g0:
      case OutputPin::rph_g1:
      case OutputPin::rph_g2_sda:
      case OutputPin::rph_g3_scl:
      case OutputPin::rph_g7_spi0_ce1:
      case OutputPin::rph_g8_spi0_ce0:
      case OutputPin::rph_g10_copi:
      case OutputPin::rph_g11_sclk:
      case OutputPin::rph_g12:
      case OutputPin::rph_g13:
      case OutputPin::rph_txd0:
      case OutputPin::rph_g16_spi1_ce2:
      case OutputPin::rph_g17_spi1_ce1:
      case OutputPin::rph_g19_spi1_cipo:
      case OutputPin::ah_tmpio1:
      case OutputPin::ah_tmpio3:
      case OutputPin::ah_tmpio5:
      case OutputPin::ah_tmpio6:
      case OutputPin::ah_tmpio9:
      case OutputPin::ah_tmpio13:
      case OutputPin::pmod0_0:
      case OutputPin::pmod0_2:
      case OutputPin::pmod0_5:
      case OutputPin::pmod0_6:
      case OutputPin::pmod0_7:
      case OutputPin::pmod1_0:
      case OutputPin::pmod1_2:
      case OutputPin::pmod1_5:
      case OutputPin::pmod1_6:
      case OutputPin::pmod1_7:
        return 3;
      default:
        return 2;
    }
  }

  /**
   * A helper function that returns the number of input pins that can be
   * selected from in the pin multiplexer for a given block input. This will
   * always be at least 2, as option 0 represents 'OFF' i.e. no connection,
   * and option 1 represents the default connection.
   *
   * @param block_input The block input to query.
   * @returns The number of selections available for that block input.
   *
   * The meanings of these selections can be found in the documentation:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   */
  static constexpr uint8_t block_input_options(BlockInput block_input) {
    switch (block_input) {
      case BlockInput::uart_1_rx:
        return 6;
      case BlockInput::spi_0_cipo:
      case BlockInput::spi_2_cipo:
      case BlockInput::spi_3_cipo:
        return 4;
      case BlockInput::uart_2_rx:
        return 3;
      default:
        return 2;
    }
  }

  /**
   * For a given output pin, selects a given block output to use for that pin
   * via the pin multiplexer.
   *
   * @param output_pin The output pin to pinmux.
   * @param option The option to select for that pin. This value should be
   * less than the value returned by `output_pin_options` for the given pin.
   *
   * The meanings of these selections can be found in the documentation:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   */
  bool output_pin_select(OutputPin output_pin, uint8_t option) {
    if (option >= output_pin_options(output_pin)) {
      Debug::log("Selected option is not valid for this pin.");
      return false;
    }
    uint16_t registerOffset   = static_cast<uint16_t>(output_pin);
    registers[registerOffset] = (1 << option);
    return true;
  }

  /**
   * For a given block input, selects a pin to use for that input via the pin
   * multiplexer.
   *
   * @param block_input The block input to pinmux.
   * @param option The option to select for that block input. This value
   * should be less than the value returned by `block_input_options` for the
   * given block input.
   *
   * The meanings of these selections can be found in the documentation:
   * https://lowrisc.github.io/sonata-system/doc/ip/pinmux.html
   */
  bool block_input_select(BlockInput block_input, uint8_t option) {
    if (option >= block_input_options(block_input)) {
      Debug::log("Selected option is not valid for this block.");
      return false;
    }
    uint16_t registerOffset   = static_cast<uint16_t>(block_input);
    registers[registerOffset] = (1 << option);
    return true;
  }

  /**
   * A constructor for the SonataPinmux driver, which takes a bounded
   * capability to the pinmux registers. This should be replaced with
   * an appropriate `MMIO_CAPABILITY` call in the version of the driver
   * that runs in CHERIoT RTOS, rather than baremetal.
   */
  SonataPinmux(volatile uint8_t *registers) : registers(registers) {}
};
