// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <string.h>
#include <stdbool.h>

#include "sonata_system.h"
#include "gpio.h"

#define CONTENT_TYPE_HEART_BEAT 0x18
#define MESSAGE_TYPE_REQUEST 0x01
#define MESSAGE_TYPE_RESPONSE 0x02
#define PAD_LEN 16

const struct {
  uint8_t good_record[26];
  uint8_t bad_record[8];
  char secrets[];
} heap = {
  .good_record = {
    CONTENT_TYPE_HEART_BEAT,        // Content Type
    0x03, 0x03,                     // TLS Version (1.2)
    0x00,   21,                     // Record Length
    MESSAGE_TYPE_REQUEST,           // Heartbeat Message Type
    0x00, 0x02,                     // Payload Length
    'a', 'b',                       // Payload
    [10 ... 10 + PAD_LEN - 1] = 'P' // 16 bytes of padding
  },
  .bad_record = {
    CONTENT_TYPE_HEART_BEAT, // Content Type
    0x03, 0x03,              // TLS Version (1.2)
    0x00, 0x03,              // Record Length
    MESSAGE_TYPE_REQUEST,    // Heartbeat Message Type
    0x00,   23               // Payload length
  },
  .secrets = "Secrets! More secrets."
};

static uint8_t response_buffer[128];

uint16_t into_uint16(const uint8_t in[2]) {
  return (((uint16_t) in[0]) << 8) | in[1];
}

void from_uint16(uint8_t out[2], uint16_t in) {
  out[0] = in >> 8;
  out[1] = in & 0xFF;
}

//void print_num(uint16_t n) {
//  puthexn(n, 16);
//  putchar('\n');
//}

void get_response_protocol_message(uint8_t response[], const uint8_t request[]) {
  uint16_t payload_len = into_uint16(request + 6);
  uint16_t record_len = 1 + 2 + payload_len + PAD_LEN;

  // Content Type, TLS Version, and record length
  *response++ = CONTENT_TYPE_HEART_BEAT;
  *response++ = 0x03;
  *response++ = 0x03;
  from_uint16(response, record_len);
  response += 2;

  // Protocol Message starts here
  *response++ = MESSAGE_TYPE_RESPONSE;
  from_uint16(response, payload_len);
  response += 2;
  memcpy(response, request + 8, payload_len);
  response += payload_len;

  // Response Padding
  for (int i = 0; i < PAD_LEN; ++i) {
    *response++ = 'p';
  };
}

void print_payload(uint8_t response[]) {
  uint16_t payload_len = into_uint16(response + 6);
  for (int i = 0; i < payload_len; ++i) {
    putchar(response[8 + i]);
  }
  putchar('\n');
};

__attribute__((noreturn))
int main(void) {

  uart_init(DEFAULT_UART);
  //puts("Hello There!");

  get_response_protocol_message(response_buffer, heap.bad_record);
  print_payload(response_buffer);

  get_response_protocol_message(response_buffer, heap.good_record);
  print_payload(response_buffer);

  while (true) {};
}
