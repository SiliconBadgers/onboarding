# Setup

[Start here](../README.md) · Document 2 of 10

*Beginner path. Use VS Code to edit files and QuestaSim/ModelSim to simulate them.*

## Get the project from GitHub

1. Create a folder named `SiliconBadgers`. We recommend putting it on your Desktop.
2. Inside it, create a folder named `onboarding_project`.
3. Open [github.com/SiliconBadgers/onboarding](https://github.com/SiliconBadgers/onboarding).
4. Click the green **Code** button, then **Download ZIP**.
5. Find the downloaded ZIP in Downloads. Right-click it and select **Extract All**.
6. Open the extracted folder, usually `onboarding-main`. Copy **its contents** into your `SiliconBadgers/onboarding_project` folder.
7. Check that `README.md`, `docs`, `rtl`, and `tb` are directly inside `onboarding_project`. Don't work inside the ZIP.

## Get VS Code and SystemVerilog support

1. [Download Visual Studio Code](https://code.visualstudio.com/download) for your computer and run the installer. On Windows, choose **User Installer**. If it is already installed on a lab computer, just open it.
2. Open VS Code. Click the **Extensions** icon on the left, or press **Ctrl+Shift+X** on Windows.
3. Search for `eirikpre.systemverilog` and install [SystemVerilog – Language Support](https://marketplace.visualstudio.com/items?itemName=eirikpre.systemverilog).
4. Select **File → Open Folder** and open `SiliconBadgers/onboarding_project`.
5. Open `rtl/calculator.sv`. Its language mode at the bottom right should say **SystemVerilog**.
6. Remember to save your edits with **Ctrl+S** before you compile your code later. Also, to view the Docs files correctly inside of VSCode you press **Ctrl+Shift+V**.

SystemVerilog is the language; the extension provides editor support such as syntax coloring. Installing it doesn't install a simulator. You'll check your circuit in QuestaSim/ModelSim.

## Open QuestaSim/ModelSim

QuestaSim is just an beefier version of ModelSim but we won't need any of its advanced features. For this project, QuestaSim and ModelSim will function the same. On your personal Windows computer you'll use ModelSim; on a CAE computer lab computer you'll use QuestaSim.

**Personal Windows computer**

Use an existing ModelSim installation, or get the Windows installer from the [official ModelSim FPGA 20.1.1 download page](https://www.altera.com/downloads/simulation-tools/modelsim-fpgas-standard-edition-software-version-20-1-1). Download `ModelSimSetup-20.1.1.720-windows.exe`, run it, and select **ModelSim FPGA Starter Edition** when prompted to choose an edition. The vendor download may require an account. This is a legacy release; if installation doesn't work on your device, use the CAE route below and ask Simon for help.

**CAE computer lab**

1. Open the **AppsAnywhere launcher/portal**.
2. Find and open **Quartus** through AppsAnywhere. The first launch can take a few minutes.
3. After Quartus opens, click the Windows button at the bottom left. Search for **QuestaSim** and open it.
4. Once QuestaSim opens, you can close Quartus.

If AppsAnywhere hasn't opened automatically, look for the **AppsAnywhere Portal** desktop shortcut. [CAE's AppsAnywhere guide](https://kb.wisc.edu/cae/153617) has more help. If you're using a Mac or Linux personal computer, use a CAE lab computer for this simulation exercise.

## Create a project

1. When QuestaSim/ModelSim opens, use the **new project** option in the startup popup if one appears. Otherwise select **File → New → Project**.
2. Name the project `onboarding_project`.
3. Set **Project Location** to your `SiliconBadgers/onboarding_project` folder. Keep the default library name `work`.
4. Select **Add Existing File** (or **Add File**, depending on the version).
5. Add all four SystemVerilog files: the two `.sv` files in `rtl` and the two in `tb`. Use **Browse** again to select files from the other folder.
6. Keep their existing locations. You don't need to copy them into another folder. Don't add the README or the downloaded ZIP as source files.
7. Close the Add Items window. You should see the four files in the Project tab.

Keep this project for later. Next, get comfortable with the HDL syntax in [Verilog and SystemVerilog basics](03-verilog-systemverilog-basics.md).

---

[← Previous: Start here](../README.md) · [Start here](../README.md) · [Next: Verilog and SystemVerilog basics →](03-verilog-systemverilog-basics.md)
