# FSK and PSK Modulators

Disclaimer: Some aspects of the code are not perfect and need optimization.



## Hardware

The hardware used in this project was a PYNQ-Z2 with a Xilinx FPGA, a ZYNQ7020.

<p align="center">
  <img width="300" src="https://github.com/saulcarvalho/CE_Modulator_FSK_PSK/blob/main/img/pynq_z2.png"/>
</p>


## Programmable Logic (PL)

Only partial files in Verilog and VHDL have been provided in PL folder, as the full project is too big to be added to GitHub. 


## Processing System (PS)

Full code used in Jupyter Notebook, inside the SD card running with the FPGA, has been provided in PS folder.


## Improvements / To do

The data transfer from the PS to PL was done with the GPIO and needs to be properly done with the DMA by defining and accessing the addresses.
