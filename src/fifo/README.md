# Namespace `PoC.fifo`

The namespace `PoC.fifo` offers different FIFO implementations.


## Package(s)

The package [`fifo`][fifo.pkg] holds all component declarations for this namespace.

```VHDL
library PoC;
use     PoC.fifo.all;
```


## Entities

PoC offers FIFOs with a `got`-interface. This means, the current read-pointer value
is available on the output. Asserting the `got`-input, acknoledge the processing of
the current output signals and moves the read-pointer to the next value, if available.  

All FIFOs implement a bidirectional flow control (`put`/`full` and `valid`/`got`).
Each FIFO also offers a EmptyState (write-side) and FullState (read-side) to indicate
the current fill-state.

The prefixes `cc_` (common clock), `dc_` (dependent clock) and `ic_` (independent
clock) refer to the write- and read-side clock relationship.

 -  [`fifo_cc_got`][fifo_cc_got] implements a regular FIFO (one common clock,
    got-interface)
 -  [`fifo_cc_got_tempgot`][fifo_cc_got_tempgot] implements a regular FIFO (one common
    clock, got-interface), extended by a transactional `tempgot`-interface
    (read-side). 
 -  [`fifo_cc_got_tempput`][fifo_cc_got_tempput] implements a regular FIFO (one common
    clock, got-interface), extended by a transactional `tempput`-interface
    (write-side). 
 -  [`fifo_dc_got`][fifo_dc_got] implements a cross-clock FIFO (two related clocks,
    got-interface)
 -  [`fifo_ic_got`][fifo_ic_got] implements a cross-clock FIFO (two independent clocks,
    got-interface)
 -  [`fifo_glue`][fifo_glue] implements a two-stage FIFO (one common clock,
    got-interface)
 -  [`fifo_shift`][fifo_shift] implements a regular FIFO (one common clock,
    got-interface, optimized for FPGAs with shifter primitives)



 [fifo.pkg]:			fifo.pkg.vhdl
 [fifo_cc_got]:			fifo_cc_got.vhdl
 [fifo_cc_got_tempgot]:	fifo_cc_got_tempgot.vhdl
 [fifo_cc_got_tempput]:	fifo_cc_got_tempput.vhdl
 [fifo_dc_got]:			fifo_dc_got.vhdl
 [fifo_ic_got]:			fifo_id_got.vhdl
 [fifo_glue]:			fifo_glue.vhdl
 [fifo_shift]:			fifo_shift.vhdl
