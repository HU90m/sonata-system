#define CHERIOT_NO_AMBIENT_MALLOC
#define CHERIOT_NO_NEW_DELETE
#define CHERIOT_PLATFORM_CUSTOM_UART

#include <cheri.hh>
#include <platform-uart.hh>
#include <stdint.h>

using namespace CHERI;

#define GPIO_VALUE  (0xFFFFFFFF)
#define CPU_FREQ_HZ (50'000'000)
//#define NCO (((1 << 20) * BAUD_RATE) / CPU_FREQ)

/**
 * OpenTitan UART
 */
class OpenTitanUart
{
  typedef uint32_t RegisterType;

  RegisterType intrState;
  RegisterType intrEnable;
  RegisterType intrTest;
  RegisterType alertTest;
  RegisterType ctrl;
  RegisterType status;
  RegisterType rData;
  RegisterType wData;
  RegisterType fifoCtrl;
  RegisterType fifoStatus;
  RegisterType ovrd;
  RegisterType val;
  RegisterType timeoutCtrl;

  public:
  void init(uint32_t baudRate = 115'200) volatile
  {
    // nco = 2^20 * baud rate / cpu frequency
    const uint32_t nco = ((baudRate << 20) / CPU_FREQ_HZ);
    ctrl = (nco << 16) | 0b11;
  };

  bool can_write() volatile
  {
    return (fifoStatus & 0xff) < 32;
  };

  /**
   * Write one byte, blocking until the byte is written.
   */
  void blocking_write(uint8_t byte) volatile
  {
    while (!can_write()) {}
    wData = byte;
  }
};


/**
 * C++ entry point for the loader.  This is called from assembly, with the
 * read-write root in the first argument.
 */
extern "C" uint32_t rom_loader_entry(void *rwRoot)
{
	Capability<void> root{rwRoot};

	// Create a bounded capability to the UART
	Capability<volatile OpenTitanUart> uart = root.cast<volatile OpenTitanUart>();
	uart.address() = 0x80001000;
	uart.bounds()  = 0x100;

    uart->init();
    uart->blocking_write('h');
    uart->blocking_write('i');
    while (true) {}
}
