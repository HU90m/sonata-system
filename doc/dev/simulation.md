# Simulation

The Sonata simulation environment uses Verilator.

## Building

Use the following command to build the simulator binary.
The resulting executable will be available at `./result/bin/sonata-simulator`.

```sh
nix build .#sonata-simulator
```


If you'd like more control over the build, you can manually invoke FuseSoC with the following.
The resulting executable can be found at `./build/lowrisc_sonata_system_0/sim-verilator/Vtop_verilator`.

```sh
NUM_CORES=4
fusesoc --cores-root=. run \
  --target=sim --tool=verilator --setup \
  --build lowrisc:sonata:system \
  --verilator_options="-j $NUM_CORES" \
  --make_options="-j $NUM_CORES"
```

*To enable tracing append, `--verilator_options='+define+RVFI'` to the command above.*

## Running baremetal

Running the simulator can be accomplished with the following command, where you can change the `meminit` argument to a different program if you wish:
```sh
./build/lowrisc_sonata_system_0/sim-verilator/Vtop_verilator -t --meminit=ram,./sw/cheri/cheri_sanity/boot.elf
```

I recommend that you make the following change to the sanity check to see quicker changes in simulation:
```diff
diff --git a/sw/cheri/cheri_sanity/boot.cc b/sw/cheri/cheri_sanity/boot.cc
index 547abb3..7f7781d 100644
--- a/sw/cheri/cheri_sanity/boot.cc
+++ b/sw/cheri/cheri_sanity/boot.cc
@@ -32,7 +32,7 @@ extern "C" uint32_t rom_loader_entry(void *rwRoot)
        uint32_t switchValue = 0;
        while (true) {
                gpioValue ^= GPIO_VALUE;
-               for (int i = 0; i < 5000000; i++) {
+               for (int i = 0; i < 5; i++) {
                        switchValue = *((volatile uint32_t *) gpi);
                        switchValue <<= 4; // shift input onto LEDs and skipping LCD pins
                        *((volatile uint32_t *) gpo) = gpioValue ^ switchValue;
```

## Running with boot stub

The [Sonata software repository](https://github.com/lowRISC/sonata-software) assumes you have a boot loader that jumps to `0x00101000`.
To help with this we have a `sim_boot_stub`, which you can build as follows assuming you have access to CHERIoT LLVM:
```sh
make -C sw/cheri/sim_boot_stub
```

You can then run your example code through the simulator as follows:
```sh
./build/lowrisc_sonata_system_0/sim-verilator/Vtop_verilator -t -E sw/cheri/sim_boot_stub/sim_boot_stub -E /path/to/sonata-software/build/cheriot/cheriot/release/sonata_simple_demo
```

## Debugging

If you want to look at the internal design in more details, you can explore the waveforms produced by the simulation using [GTKWave](http://gtkwave.sourceforge.net/):
```sh
gtkwave sim.fst data/pc_and_gpo.gtkw
```
