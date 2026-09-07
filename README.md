# Silicon Badgers onboarding

> [!IMPORTANT]
> **Viewing these docs in VS Code? Press Ctrl+Shift+V!** Open a README or Docs `.md` file, then press **Ctrl+Shift+V** to view it with the formatting displayed correctly instead of raw Markdown text.

Welcome! Silicon Badgers is a student organization where we learn chip design by building real hardware together. This onboarding gives you the background to understand what we're making and start contributing.

Our first Tiny Tapeout project is aimed at MNIST handwritten-digit inference. In the future, we plan to build a larger FPGA prototype for AI inference, including LLMs, with the longer-term goal of an ASIC. Here, you'll learn how the model, compiler, instructions, and hardware fit together.

We assume you already know binary, logic gates, registers, and state machines. There are **no Python assignments** in this onboarding.

## Start here

| Your background | What to do |
| --- | --- |
| Haven't completed ECE 551 | Read documents 2–10 in order, including HDLBits, the calculator, and your own small testbench. |
| Completed ECE 551 | Read this introduction, then documents **4 → 7 → 8 → 9 → 10** below. Skip the HDLBits and coding exercises; optionally revisit them. |

Submit the Google Form **at the end**, after finishing your path.

**Stuck? Message Simon Richter, our Onboarding Chair, on Slack.** Include what you tried and a screenshot or error message when useful.

This onboarding is really important to the club, and we've put a ton of effort into making it useful. Please tell us how we can improve it, whether that's one confusing sentence or feedback about the whole thing. There's a required feedback section in the final form.

### Using AI

We strongly recommend using AI to explain things when you're confused. It's extremely useful for learning SystemVerilog and understanding the AI concepts in this onboarding. Ask follow-up questions, request simpler examples, and keep going until things make sense.

For the coding exercises, try to use minimal AI and write most of the code yourself. Having AI write everything might get you through onboarding, but you'll struggle when we start building the actual project. We can't control how you use it, but if you want to be an active member, contribute to the club, and eventually join leadership, it's to your advantage to understand what you're building and why it works.

## Reading order

| # | Document | Who reads it? |
| --- | --- | --- |
| 1 | Start here (this README) | Everyone |
| 2 | [Setup](docs/02-setup.md) | Beginner path |
| 3 | [Verilog and SystemVerilog basics](docs/03-verilog-systemverilog-basics.md) | Beginner path |
| 4 | [ISA refresher](docs/04-isa-refresher.md) | Everyone |
| 5 | [Calculator project](docs/05-calculator-project.md) | Beginner path |
| 6 | [Simulation and testbenches](docs/06-simulation-testbenches.md) | Beginner path |
| 7 | [Chip design](docs/07-chip-design.md) | Everyone |
| 8 | [AI inference fundamentals](docs/08-ai-inference-fundamentals.md) | Everyone |
| 9 | [Accelerator full stack](docs/09-accelerator-full-stack.md) | Everyone |
| 10 | [Submission](docs/10-submission.md) | Everyone |

**Beginner path:** start with [Setup](docs/02-setup.md), then use the Next link at the bottom of each document.

**ECE 551 path:** [ISA refresher](docs/04-isa-refresher.md) → [Chip design](docs/07-chip-design.md) → [AI inference fundamentals](docs/08-ai-inference-fundamentals.md) → [Accelerator full stack](docs/09-accelerator-full-stack.md) → [Submission](docs/10-submission.md).

The lesson documents are in `docs/`; starter RTL is in `rtl/`, and testbenches are in `tb/`. File paths in the lessons are relative to your `onboarding_project` folder unless stated otherwise. The submission document explains the Google Form and required uploads.

[Next: Setup →](docs/02-setup.md)
