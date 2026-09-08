# Chip design

> [!IMPORTANT]
> If you're viewing this in VS Code, press **Ctrl+Shift+V** to display this document correctly.

[Start here](../README.md) · Document 7 of 10

## Chip design jobs and the ASIC flow

*Everyone continues here.*

Follow one example: a company wants a chip that classifies camera images within a power and latency budget. The main ASIC flow is:

**Specification and architecture → RTL design and verification → Synthesis → Physical design and signoff → Tapeout → Fabrication and packaging → Bring-up and manufacturing test**

That is the main path, but teams do not simply finish one stage and disappear. Design verification continues throughout the project, DFT planning starts early, and analog/mixed-signal blocks are developed alongside the digital design. Teams may also test the RTL on an FPGA before tapeout. The sections below explain what each part means.

### Who does what?

| Stage / role | What they do for our image-classifier example | Names you might see |
| --- | --- | --- |
| **Architecture** | Decide the supported operations, number of multipliers, memory sizes, data widths, and performance targets. “Can we process an image fast enough with four multipliers?” | Chip architect, hardware architect, microarchitect, system architect |
| **RTL design** | Turn those decisions into SystemVerilog: arithmetic, buffers, controllers, and interfaces. Your calculator is a tiny example of this work. | RTL design engineer, digital design engineer, ASIC design engineer, logic design engineer |
| **Design verification** | Try to break the RTL before fabrication. Build testbenches/reference models and check reset, overflow, memory traffic, and combinations of events. | DV engineer, design verification engineer, functional verification engineer |
| **Physical design** | Turn the gate-level design into a physical layout and make it meet timing, power, area, and manufacturing rules. | Physical design engineer, physical implementation engineer, backend engineer, place-and-route engineer |
| **DFT: design for test** | Add ways to test the manufactured chip for defects. Scan chains make internal registers controllable/observable; memory tests look for faulty storage. | DFT engineer, design-for-test engineer, testability engineer |
| **Analog / mixed-signal** | Design circuits that handle continuous voltages or connect analog and digital worlds, such as ADCs, clock PLLs, and high-speed I/O. | Analog IC designer, mixed-signal design engineer, AMS engineer |

An ADC could turn a sensor voltage into a digital pixel value; the digital inference engine then processes those values. Analog blocks use transistor-level design and simulation, so they don't follow exactly the same RTL-to-gates path.

A chip project may have a few architects, a larger RTL team, and a verification team as large as or larger than the RTL team. The balance depends on the company and product; there isn't one fixed staffing ratio. Job titles overlap too, so read the job description.

Software engineers also matter: they develop compilers, drivers, runtimes, firmware, and applications. For our accelerator, someone has to translate the trained model into commands and get data to the hardware.

### What happens between RTL and a working chip?

1. **Specification and verification plan:** agree on behavior and how to test it. For example, does an overflowing sum wrap or saturate?
2. **RTL and functional verification:** build the design and compare it against expected behavior. A testbench passing one image doesn't prove every possible case.
3. **Synthesis:** translate RTL into gates and registers from a technology library. An addition becomes actual adder circuitry. DFT logic is integrated into the implementation flow, with planning starting earlier.
4. **Physical design:** floorplan the blocks, place cells, build the clock distribution network, and route wires. A long wire can make a previously reasonable operation too slow.
5. **Signoff:** check timing, power-related limits, and layout correctness. **STA** checks whether signals reach registers in time. **DRC** checks manufacturing geometry rules; **LVS** checks that the layout implements the intended circuit connections.
6. **Tapeout and fabrication:** deliver the final layout data to the foundry, which makes the silicon. “Tapeout” is the design handoff, not the moment a working chip arrives.
7. **Packaging, bring-up, and test:** connect the die to its package and board, power it up, and test it. Bring-up checks the real chip/system; manufacturing test screens individual chips for defects using features such as DFT.

DV asks, “Did we design the right behavior?” Manufacturing test asks, “Was this particular chip built without defects?” Both are necessary.

Before fabrication, teams may map digital RTL onto an FPGA to test software and system behavior. This is **hardware prototyping**: the logic runs on real FPGA resources. QuestaSim/ModelSim is **software simulation**. An FPGA prototype can expose system bugs, but doesn't prove ASIC timing, analog behavior, or physical layout is correct.

Further reading: [ASIC design](https://www.synopsys.com/glossary/what-is-asic-design.html), [physical design](https://www.synopsys.com/glossary/what-is-physical-design.html), and [DFT](https://www.synopsys.com/glossary/what-is-design-for-test.html).

## FPGA or ASIC?

An FPGA is configurable hardware you buy and reprogram. An ASIC is custom circuitry you design and have manufactured. Both are real chips.

| | FPGA | ASIC |
| --- | --- | --- |
| Changing the design | Load a new configuration | Physical circuit changes usually require another tapeout |
| Upfront cost and schedule | Buy a board/device; start testing quickly | Pay for design, verification, tools/IP, masks, fabrication, packaging, and testing |
| Power, speed, and area | General configurable resources add overhead | A well-designed implementation can be more efficient for the target task |
| Unit cost | Often attractive at low volume | High upfront cost can be spread over many units |
| Common uses | Prototypes, changing telecom systems, industrial controls, aerospace, custom instruments, low-latency trading | Phone SoCs, networking switches, video codecs, storage controllers, high-volume inference chips |

There is overlap: an industry can use both. A telecom company might choose an FPGA for an evolving protocol and an ASIC for a high-volume product with stable requirements.

**Tapeout can be extremely expensive**, particularly for a large chip on a modern process. Finding a hardware bug afterward can mean redesigning, waiting for fabrication again, and paying again. Tiny Tapeout makes small shared-chip projects much more accessible by sharing manufacturing costs; it isn't the cost model of a large standalone ASIC.

For the club, an FPGA lets us fix bugs and experiment repeatedly before committing to a physical design. Our MNIST Tiny Tapeout project is the initial target; the larger AI accelerator is a later FPGA prototype, with an eventual ASIC as the longer-term plan. This onboarding explains the pieces using one concrete example rather than fixing the final chip's area, memory placement, or interface.

---

[← Previous: Simulation and testbenches](06-simulation-testbenches.md) · [Start here](../README.md) · [Next: AI inference fundamentals →](08-ai-inference-fundamentals.md)
