add_executable(heartbleed main.c)
target_link_libraries(heartbleed common)

add_custom_command(
  TARGET heartbleed POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary "$<TARGET_FILE:demo>" "$<TARGET_FILE:demo>.bin"
  COMMAND srec_cat "$<TARGET_FILE:demo>.bin" -binary -offset 0x0000 -byte-swap 4 -o "$<TARGET_FILE:demo>.vmem" -vmem
  VERBATIM)
