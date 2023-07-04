
################################################################
# This is a generated script based on design: Design1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source Design1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# fsk_mapper, psk_mapper, random_bitstream_generator, random_bitstream_generator, DA2RefComp, monsterplexer, clock_divider, gain_scaler, divider, divider

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART tul.com.tw:pynq-z2:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name Design1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:mult_gen:12.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:fir_compiler:7.2\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:dds_compiler:6.0\
xilinx.com:ip:ila:6.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
fsk_mapper\
psk_mapper\
random_bitstream_generator\
random_bitstream_generator\
DA2RefComp\
monsterplexer\
clock_divider\
gain_scaler\
divider\
divider\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: psk_modulator
proc create_hier_cell_psk_modulator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_psk_modulator() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk clk45M
  create_bd_pin -dir I -from 15 -to 0 freq_in2
  create_bd_pin -dir O -from 15 -to 0 mod_psk_out
  create_bd_pin -dir I -from 15 -to 0 phase_in
  create_bd_pin -dir O -from 15 -to 0 psk_out

  # Create instance: dds_compiler, and set properties
  set dds_compiler [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler ]
  set_property -dict [ list \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.DDS_Clock_Rate {45.160455} \
   CONFIG.Has_Phase_Out {false} \
   CONFIG.Latency {8} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Noise_Shaping {None} \
   CONFIG.Output_Frequency1 {0} \
   CONFIG.Output_Selection {Sine} \
   CONFIG.Output_Width {16} \
   CONFIG.PINC1 {0} \
   CONFIG.POFF1 {0} \
   CONFIG.Parameter_Entry {Hardware_Parameters} \
   CONFIG.PartsPresent {Phase_Generator_and_SIN_COS_LUT} \
   CONFIG.Phase_Increment {Programmable} \
   CONFIG.Phase_Offset_Angles1 {0} \
   CONFIG.Phase_Width {16} \
   CONFIG.Phase_offset {Streaming} \
   CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler

  # Create instance: divider_0, and set properties
  set block_name divider
  set block_cell_name divider_0
  if { [catch {set divider_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $divider_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]

  # Create port connections
  connect_bd_net -net clk100M_1 [get_bd_pins clk45M] [get_bd_pins dds_compiler/aclk] [get_bd_pins divider_0/clk]
  connect_bd_net -net divider_0_sig_gain_out [get_bd_pins psk_out] [get_bd_pins divider_0/sig_gain_out]
  connect_bd_net -net frequency_selector_m_axis_data_tdata [get_bd_pins mod_psk_out] [get_bd_pins dds_compiler/m_axis_data_tdata] [get_bd_pins divider_0/signal_in]
  connect_bd_net -net s_axis_config_tdata_1 [get_bd_pins freq_in2] [get_bd_pins dds_compiler/s_axis_config_tdata]
  connect_bd_net -net s_axis_phase_tdata_1 [get_bd_pins phase_in] [get_bd_pins dds_compiler/s_axis_phase_tdata]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins dds_compiler/s_axis_config_tvalid] [get_bd_pins dds_compiler/s_axis_phase_tvalid] [get_bd_pins xlconstant_3/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ila_monitoring
proc create_hier_cell_ila_monitoring { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ila_monitoring() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 channel_out
  create_bd_pin -dir I -from 0 -to 0 clk125M_assert
  create_bd_pin -dir I -type clk clk90M
  create_bd_pin -dir I -from 10 -to 0 clockdiv
  create_bd_pin -dir I -from 1 -to 0 fsk_bitstream_out
  create_bd_pin -dir I -from 31 -to 0 fsk_gain_out
  create_bd_pin -dir I -from 8 -to 0 fsk_gain_set
  create_bd_pin -dir I -from 15 -to 0 fsk_out
  create_bd_pin -dir I -from 31 -to 0 fsk_psk_add
  create_bd_pin -dir I -from 15 -to 0 fsk_set_f
  create_bd_pin -dir I -from 0 -to 0 mode_fsk
  create_bd_pin -dir I -from 0 -to 0 mode_psk
  create_bd_pin -dir I -from 11 -to 0 mux_out1
  create_bd_pin -dir I -from 11 -to 0 mux_out2
  create_bd_pin -dir I -from 2 -to 0 mux_sel
  create_bd_pin -dir I -from 15 -to 0 out_mod_fsk
  create_bd_pin -dir I -from 15 -to 0 out_mod_psk
  create_bd_pin -dir I -from 0 -to 0 probe4
  create_bd_pin -dir I -from 0 -to 0 probe5
  create_bd_pin -dir I -from 0 -to 0 probe6
  create_bd_pin -dir I -from 1 -to 0 psk_bitstream_out
  create_bd_pin -dir I -from 31 -to 0 psk_gain_out
  create_bd_pin -dir I -from 8 -to 0 psk_gain_set
  create_bd_pin -dir I -from 15 -to 0 psk_out
  create_bd_pin -dir I -from 15 -to 0 psk_set_f
  create_bd_pin -dir I -from 0 -to 0 start_conversion
  create_bd_pin -dir I -type clk sys_clock

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {4} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {3} \
   CONFIG.C_PROBE0_MU_CNT {4} \
   CONFIG.C_PROBE0_WIDTH {16} \
   CONFIG.C_PROBE1_MU_CNT {4} \
   CONFIG.C_PROBE1_WIDTH {16} \
   CONFIG.C_PROBE2_MU_CNT {4} \
   CONFIG.C_PROBE2_WIDTH {11} \
   CONFIG.C_PROBE3_MU_CNT {4} \
   CONFIG.C_PROBE3_WIDTH {1} \
   CONFIG.C_PROBE4_MU_CNT {4} \
   CONFIG.C_PROBE4_WIDTH {1} \
   CONFIG.C_PROBE5_MU_CNT {4} \
   CONFIG.C_PROBE5_WIDTH {1} \
   CONFIG.C_PROBE6_MU_CNT {4} \
   CONFIG.C_PROBE6_WIDTH {1} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_0

  # Create instance: ila_125M, and set properties
  set ila_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_125M ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {4} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {8} \
   CONFIG.C_PROBE0_MU_CNT {4} \
   CONFIG.C_PROBE0_WIDTH {16} \
   CONFIG.C_PROBE1_MU_CNT {4} \
   CONFIG.C_PROBE1_WIDTH {16} \
   CONFIG.C_PROBE2_MU_CNT {4} \
   CONFIG.C_PROBE2_WIDTH {9} \
   CONFIG.C_PROBE3_MU_CNT {4} \
   CONFIG.C_PROBE3_WIDTH {9} \
   CONFIG.C_PROBE4_MU_CNT {4} \
   CONFIG.C_PROBE4_WIDTH {1} \
   CONFIG.C_PROBE5_MU_CNT {4} \
   CONFIG.C_PROBE5_WIDTH {1} \
   CONFIG.C_PROBE6_MU_CNT {4} \
   CONFIG.C_PROBE6_WIDTH {3} \
   CONFIG.C_PROBE7_MU_CNT {4} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_125M

  # Create instance: ila_1M411, and set properties
  set ila_1M411 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1M411 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {4} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {6} \
   CONFIG.C_PROBE0_MU_CNT {4} \
   CONFIG.C_PROBE0_WIDTH {16} \
   CONFIG.C_PROBE1_MU_CNT {4} \
   CONFIG.C_PROBE1_WIDTH {16} \
   CONFIG.C_PROBE2_MU_CNT {4} \
   CONFIG.C_PROBE2_WIDTH {32} \
   CONFIG.C_PROBE3_MU_CNT {4} \
   CONFIG.C_PROBE3_WIDTH {32} \
   CONFIG.C_PROBE4_MU_CNT {4} \
   CONFIG.C_PROBE4_WIDTH {32} \
   CONFIG.C_PROBE5_MU_CNT {4} \
   CONFIG.C_PROBE5_WIDTH {11} \
   CONFIG.C_PROBE6_MU_CNT {4} \
   CONFIG.C_PROBE6_WIDTH {1} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_1M411

  # Create instance: ila_2M822, and set properties
  set ila_2M822 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_2M822 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {4} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {8} \
   CONFIG.C_PROBE0_MU_CNT {4} \
   CONFIG.C_PROBE0_WIDTH {32} \
   CONFIG.C_PROBE1_MU_CNT {4} \
   CONFIG.C_PROBE1_WIDTH {12} \
   CONFIG.C_PROBE2_MU_CNT {4} \
   CONFIG.C_PROBE2_WIDTH {1} \
   CONFIG.C_PROBE3_MU_CNT {4} \
   CONFIG.C_PROBE3_WIDTH {12} \
   CONFIG.C_PROBE4_MU_CNT {4} \
   CONFIG.C_PROBE4_WIDTH {1} \
   CONFIG.C_PROBE5_MU_CNT {4} \
   CONFIG.C_PROBE5_WIDTH {1} \
   CONFIG.C_PROBE6_MU_CNT {4} \
   CONFIG.C_PROBE6_WIDTH {1} \
   CONFIG.C_PROBE7_MU_CNT {4} \
   CONFIG.C_PROBE7_WIDTH {11} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_2M822

  # Create instance: ila_44k1, and set properties
  set ila_44k1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_44k1 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {4} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {3} \
   CONFIG.C_PROBE0_MU_CNT {4} \
   CONFIG.C_PROBE0_WIDTH {2} \
   CONFIG.C_PROBE1_MU_CNT {4} \
   CONFIG.C_PROBE1_WIDTH {2} \
   CONFIG.C_PROBE2_MU_CNT {4} \
   CONFIG.C_PROBE2_WIDTH {11} \
   CONFIG.C_PROBE3_MU_CNT {4} \
   CONFIG.C_PROBE3_WIDTH {1} \
   CONFIG.C_PROBE4_MU_CNT {4} \
   CONFIG.C_PROBE4_WIDTH {1} \
   CONFIG.C_PROBE5_MU_CNT {4} \
   CONFIG.C_PROBE5_WIDTH {1} \
   CONFIG.C_PROBE6_MU_CNT {4} \
   CONFIG.C_PROBE6_WIDTH {1} \
   CONFIG.C_TRIGIN_EN {false} \
 ] $ila_44k1

  # Create port connections
  connect_bd_net -net PS_to_PL_Dout [get_bd_pins fsk_set_f] [get_bd_pins ila_125M/probe0]
  connect_bd_net -net PS_to_PL_Dout1 [get_bd_pins psk_set_f] [get_bd_pins ila_125M/probe1]
  connect_bd_net -net PS_to_PL_Dout4 [get_bd_pins mux_sel] [get_bd_pins ila_125M/probe6]
  connect_bd_net -net PS_to_PL_Dout5 [get_bd_pins mode_fsk] [get_bd_pins ila_125M/probe4]
  connect_bd_net -net PS_to_PL_FCLK_CLK0 [get_bd_pins sys_clock] [get_bd_pins ila_125M/clk]
  connect_bd_net -net PS_to_PL_dout2 [get_bd_pins fsk_gain_set] [get_bd_pins ila_125M/probe2]
  connect_bd_net -net PS_to_PL_dout3 [get_bd_pins psk_gain_set] [get_bd_pins ila_125M/probe3]
  connect_bd_net -net c_addsub_0_S [get_bd_pins fsk_psk_add] [get_bd_pins ila_1M411/probe4]
  connect_bd_net -net channel_emulator_channel_out [get_bd_pins channel_out] [get_bd_pins ila_2M822/probe0]
  connect_bd_net -net clk_1 [get_bd_pins clk90M] [get_bd_pins ila_0/clk] [get_bd_pins ila_1M411/clk] [get_bd_pins ila_2M822/clk] [get_bd_pins ila_44k1/clk]
  connect_bd_net -net clock_generator_Q [get_bd_pins clk125M_assert] [get_bd_pins ila_125M/probe7]
  connect_bd_net -net clock_generator_clockdiv [get_bd_pins clockdiv] [get_bd_pins ila_0/probe2] [get_bd_pins ila_1M411/probe5] [get_bd_pins ila_2M822/probe7] [get_bd_pins ila_44k1/probe2]
  connect_bd_net -net fsk_modulator_fsk_out [get_bd_pins fsk_out] [get_bd_pins ila_1M411/probe0]
  connect_bd_net -net mode_psk_1 [get_bd_pins mode_psk] [get_bd_pins ila_125M/probe5]
  connect_bd_net -net mult_gen_1_P [get_bd_pins psk_gain_out] [get_bd_pins ila_1M411/probe3]
  connect_bd_net -net multiplier_0_fsk_gain_out [get_bd_pins fsk_gain_out] [get_bd_pins ila_1M411/probe2]
  connect_bd_net -net probe0_1 [get_bd_pins out_mod_fsk] [get_bd_pins ila_0/probe0]
  connect_bd_net -net probe1_1 [get_bd_pins mux_out1] [get_bd_pins ila_2M822/probe1]
  connect_bd_net -net probe2_1 [get_bd_pins start_conversion] [get_bd_pins ila_2M822/probe2]
  connect_bd_net -net probe2_2 [get_bd_pins out_mod_psk] [get_bd_pins ila_0/probe1]
  connect_bd_net -net probe3_1 [get_bd_pins mux_out2] [get_bd_pins ila_2M822/probe3]
  connect_bd_net -net probe4_1 [get_bd_pins probe4] [get_bd_pins ila_2M822/probe4]
  connect_bd_net -net probe5_1 [get_bd_pins probe5] [get_bd_pins ila_2M822/probe5]
  connect_bd_net -net probe6_1 [get_bd_pins probe6] [get_bd_pins ila_2M822/probe6]
  connect_bd_net -net psk_modulator_psk_out [get_bd_pins psk_out] [get_bd_pins ila_1M411/probe1]
  connect_bd_net -net random_bitstream_gen_0_data_out [get_bd_pins fsk_bitstream_out] [get_bd_pins ila_44k1/probe0]
  connect_bd_net -net random_bitstream_gen_psk_data_out [get_bd_pins psk_bitstream_out] [get_bd_pins ila_44k1/probe1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fsk_modulator
proc create_hier_cell_fsk_modulator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_fsk_modulator() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk clk45M
  create_bd_pin -dir I -from 15 -to 0 freq_in1
  create_bd_pin -dir O -from 15 -to 0 fsk_out
  create_bd_pin -dir O -from 15 -to 0 mod_fsk_out

  # Create instance: dds_compiler, and set properties
  set dds_compiler [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler ]
  set_property -dict [ list \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.DDS_Clock_Rate {45.160455} \
   CONFIG.Frequency_Resolution {0.4} \
   CONFIG.Has_Phase_Out {false} \
   CONFIG.Latency {7} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Noise_Shaping {None} \
   CONFIG.Output_Frequency1 {0} \
   CONFIG.Output_Selection {Sine} \
   CONFIG.Output_Width {16} \
   CONFIG.PINC1 {0} \
   CONFIG.Parameter_Entry {Hardware_Parameters} \
   CONFIG.Phase_Increment {Programmable} \
   CONFIG.Phase_Width {16} \
   CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler

  # Create instance: divider_0, and set properties
  set block_name divider
  set block_cell_name divider_0
  if { [catch {set divider_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $divider_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant, and set properties
  set xlconstant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant ]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk45M] [get_bd_pins dds_compiler/aclk] [get_bd_pins divider_0/clk]
  connect_bd_net -net dds_compiler_0_m_axis_data_tdata [get_bd_pins mod_fsk_out] [get_bd_pins dds_compiler/m_axis_data_tdata] [get_bd_pins divider_0/signal_in]
  connect_bd_net -net divider_0_sig_gain_out [get_bd_pins fsk_out] [get_bd_pins divider_0/sig_gain_out]
  connect_bd_net -net s_axis_config_tdata_1 [get_bd_pins freq_in1] [get_bd_pins dds_compiler/s_axis_config_tdata]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins dds_compiler/s_axis_config_tvalid] [get_bd_pins xlconstant/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clock_generator
proc create_hier_cell_clock_generator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clock_generator() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 -type data clk125M_assert
  create_bd_pin -dir O -from 0 -to 0 -type clk clk2M8224
  create_bd_pin -dir O -from 0 -to 0 -type clk clk44k1
  create_bd_pin -dir O -from 0 -to 0 -type clk clk45M159
  create_bd_pin -dir O -type clk clk90M3168
  create_bd_pin -dir O -from 10 -to 0 -type data clockdiv
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type clk sys_clock

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Output_Width {11} \
 ] $c_counter_binary_0

  # Create instance: c_counter_binary_1, and set properties
  set c_counter_binary_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_1 ]
  set_property -dict [ list \
   CONFIG.CE {false} \
   CONFIG.Output_Width {1} \
 ] $c_counter_binary_1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {329.662} \
   CONFIG.CLKOUT1_PHASE_ERROR {351.309} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {90.3168} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {251.378} \
   CONFIG.CLKOUT2_PHASE_ERROR {263.402} \
   CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.000} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {90.3168} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.CLK_OUT1_PORT {clk90M3168} \
   CONFIG.CLK_OUT2_PORT {clk_out2} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {43.625} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.625} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {7} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_IN_FREQ {125.000} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
 ] $clk_wiz_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RST_WIDTH {1} \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $proc_sys_reset_0

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_1

  # Create instance: util_ds_buf_3, and set properties
  set util_ds_buf_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_3 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_3

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create port connections
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins clockdiv] [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net c_counter_binary_1_Q [get_bd_pins clk125M_assert] [get_bd_pins c_counter_binary_1/Q]
  connect_bd_net -net clk_wiz_0_clk90M3168 [get_bd_pins clk90M3168] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins clk_wiz_0/clk90M3168]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins c_counter_binary_0/CE] [get_bd_pins clk_wiz_0/locked]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins peripheral_reset] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net sys_clock_1 [get_bd_pins sys_clock] [get_bd_pins c_counter_binary_1/CLK] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins clk44k1] [get_bd_pins util_ds_buf_0/BUFG_O]
  connect_bd_net -net util_ds_buf_1_BUFG_O [get_bd_pins clk45M159] [get_bd_pins util_ds_buf_1/BUFG_O]
  connect_bd_net -net util_ds_buf_3_BUFG_O [get_bd_pins clk2M8224] [get_bd_pins util_ds_buf_3/BUFG_O]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins util_ds_buf_0/BUFG_I] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins util_ds_buf_1/BUFG_I] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins util_ds_buf_3/BUFG_I] [get_bd_pins xlslice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: channel_emulator
proc create_hier_cell_channel_emulator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_channel_emulator() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 channel_in
  create_bd_pin -dir O -from 31 -to 0 channel_out
  create_bd_pin -dir I -type clk clk90

  # Create instance: fir_compiler_0, and set properties
  set fir_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {false} \
   CONFIG.Channel_Sequence {Basic} \
   CONFIG.Clock_Frequency {100} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_Buffer_Type {Distributed} \
   CONFIG.Coefficient_File {../../../../imports/Project_CE_V17/coefs_LP.coe} \
   CONFIG.Coefficient_Fractional_Bits {1} \
   CONFIG.Coefficient_Reload {false} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Unsigned} \
   CONFIG.Coefficient_Structure {Symmetric} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {35} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Data_Buffer_Type {Automatic} \
   CONFIG.Data_Fractional_Bits {0} \
   CONFIG.Data_Width {32} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Single_Rate} \
   CONFIG.Input_Buffer_Type {Distributed} \
   CONFIG.Inter_Column_Pipe_Length {4} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Multi_Column_Support {Automatic} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Optimization_Goal {Area} \
   CONFIG.Output_Buffer_Type {Distributed} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {32} \
   CONFIG.Passband_Max {0.5} \
   CONFIG.Preference_For_Other_Storage {Automatic} \
   CONFIG.Quantization {Maximize_Dynamic_Range} \
   CONFIG.RateSpecification {Input_Sample_Period} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.SamplePeriod {1} \
   CONFIG.Sample_Frequency {45.159} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_0

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins clk90] [get_bd_pins fir_compiler_0/aclk]
  connect_bd_net -net c_addsub_0_S [get_bd_pins channel_in] [get_bd_pins fir_compiler_0/s_axis_data_tdata]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins channel_out] [get_bd_pins fir_compiler_0/m_axis_data_tdata]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins fir_compiler_0/s_axis_data_tvalid] [get_bd_pins xlconstant_4/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PS_to_PL
proc create_hier_cell_PS_to_PL { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_PS_to_PL() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO


  # Create pins
  create_bd_pin -dir O -type clk FCLK_CLK0
  create_bd_pin -dir O -from 0 -to 0 -type rst FCLK_RESET0_N
  create_bd_pin -dir I -from 3 -to 0 buttons
  create_bd_pin -dir O -from 15 -to 0 fsk_out
  create_bd_pin -dir O -from 8 -to 0 gain_fsk
  create_bd_pin -dir O -from 8 -to 0 gain_fsk_scaled
  create_bd_pin -dir O -from 8 -to 0 gain_psk
  create_bd_pin -dir O -from 8 -to 0 gain_psk_scaled
  create_bd_pin -dir O -from 3 -to 0 leds
  create_bd_pin -dir O -from 0 -to 0 mode_fsk
  create_bd_pin -dir O -from 0 -to 0 mode_psk
  create_bd_pin -dir O -from 2 -to 0 mux_sel
  create_bd_pin -dir O -from 15 -to 0 psk_out
  create_bd_pin -dir O -from 5 -to 0 rgbleds1
  create_bd_pin -dir I -from 1 -to 0 sw

  # Create instance: clock_divider_0, and set properties
  set block_name clock_divider
  set block_cell_name clock_divider_0
  if { [catch {set clock_divider_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clock_divider_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fsk_out, and set properties
  set fsk_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 fsk_out ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {16} \
 ] $fsk_out

  # Create instance: gain_fsk, and set properties
  set gain_fsk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gain_fsk ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {34} \
   CONFIG.DIN_TO {32} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gain_fsk

  # Create instance: gain_psk, and set properties
  set gain_psk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gain_psk ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {37} \
   CONFIG.DIN_TO {35} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gain_psk

  # Create instance: gain_scaler_0, and set properties
  set block_name gain_scaler
  set block_cell_name gain_scaler_0
  if { [catch {set gain_scaler_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gain_scaler_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: leds, and set properties
  set leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 leds ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {46} \
   CONFIG.DIN_TO {43} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {4} \
 ] $leds

  # Create instance: mode_fsk, and set properties
  set mode_fsk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mode_fsk ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {41} \
   CONFIG.DIN_TO {41} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mode_fsk

  # Create instance: mode_psk, and set properties
  set mode_psk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mode_psk ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {42} \
   CONFIG.DIN_TO {42} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mode_psk

  # Create instance: mux_sel, and set properties
  set mux_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mux_sel ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {40} \
   CONFIG.DIN_TO {38} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {3} \
 ] $mux_sel

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {125000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_ENET0 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_USB0 {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {64} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {inout} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {inout} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {inout} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {inout} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {inout} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {inout} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {inout} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {inout} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {inout} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {inout} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {inout} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {inout} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {inout} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {inout} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {inout} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {inout} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {inout} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {inout} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#gpio[1]#gpio[2]#gpio[3]#gpio[4]#gpio[5]#gpio[6]#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#gpio[16]#gpio[17]#gpio[18]#gpio[19]#gpio[20]#gpio[21]#gpio[22]#gpio[23]#gpio[24]#gpio[25]#gpio[26]#gpio[27]#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#gpio[40]#gpio[41]#gpio[42]#gpio[43]#gpio[44]#gpio[45]#gpio[46]#gpio[47]#gpio[48]#gpio[49]#gpio[50]#gpio[51]#gpio[52]#gpio[53]} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USE_M_AXI_GP0 {0} \
 ] $processing_system7_0

  # Create instance: psk_out, and set properties
  set psk_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 psk_out ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {16} \
 ] $psk_out

  # Create instance: rgbleds, and set properties
  set rgbleds [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 rgbleds ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {52} \
   CONFIG.DIN_TO {47} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {6} \
 ] $rgbleds

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {53} \
   CONFIG.IN1_WIDTH {4} \
   CONFIG.IN2_WIDTH {2} \
   CONFIG.IN3_WIDTH {5} \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {3} \
   CONFIG.IN1_WIDTH {6} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {3} \
   CONFIG.IN1_WIDTH {6} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {2} \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_3

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {53} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_1

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {5} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {2} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

  # Create port connections
  connect_bd_net -net buttons_1 [get_bd_pins buttons] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net clock_divider_0_clock_out [get_bd_pins clock_divider_0/clock_out] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net fsk_out_Dout [get_bd_pins fsk_out] [get_bd_pins fsk_out/Dout]
  connect_bd_net -net gain_fsk_Dout [get_bd_pins gain_fsk/Dout] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net gain_psk_Dout [get_bd_pins gain_psk/Dout] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net gain_scaler_0_scaled_gain_fsk [get_bd_pins gain_fsk_scaled] [get_bd_pins gain_scaler_0/scaled_gain_fsk]
  connect_bd_net -net gain_scaler_0_scaled_gain_psk [get_bd_pins gain_psk_scaled] [get_bd_pins gain_scaler_0/scaled_gain_psk]
  connect_bd_net -net leds_Dout [get_bd_pins leds/Dout] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net mode_fsk_Dout [get_bd_pins mode_fsk] [get_bd_pins mode_fsk/Dout]
  connect_bd_net -net mode_psk_Dout [get_bd_pins mode_psk] [get_bd_pins mode_psk/Dout]
  connect_bd_net -net mux_sel_Dout [get_bd_pins mux_sel] [get_bd_pins mux_sel/Dout]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins fsk_out/Din] [get_bd_pins gain_fsk/Din] [get_bd_pins gain_psk/Din] [get_bd_pins leds/Din] [get_bd_pins mode_fsk/Din] [get_bd_pins mode_psk/Din] [get_bd_pins mux_sel/Din] [get_bd_pins processing_system7_0/GPIO_O] [get_bd_pins psk_out/Din] [get_bd_pins rgbleds/Din]
  connect_bd_net -net psk_out_Dout [get_bd_pins psk_out] [get_bd_pins psk_out/Dout]
  connect_bd_net -net rgbleds_Dout [get_bd_pins rgbleds1] [get_bd_pins rgbleds/Dout]
  connect_bd_net -net sw_1 [get_bd_pins sw] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net sys_clock_1 [get_bd_pins FCLK_CLK0] [get_bd_pins clock_divider_0/clk] [get_bd_pins gain_scaler_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/GPIO_I] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins gain_psk] [get_bd_pins gain_scaler_0/gain_psk] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins gain_fsk] [get_bd_pins gain_scaler_0/gain_fsk] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins leds] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_2/In1] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins FCLK_RESET0_N] [get_bd_pins clock_divider_0/reset] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins xlconcat_3/In1] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_3/In2] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Output_selector
proc create_hier_cell_Output_selector { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Output_selector() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O CLK_OUT
  create_bd_pin -dir O D1
  create_bd_pin -dir O D2
  create_bd_pin -dir O DONE
  create_bd_pin -dir I -from 0 -to 0 -type rst RST
  create_bd_pin -dir I -from 31 -to 0 channel_out
  create_bd_pin -dir I -type clk clk2M8224
  create_bd_pin -dir I -type clk clk45M159
  create_bd_pin -dir I -from 1 -to 0 fsk_bitstream
  create_bd_pin -dir I -from 31 -to 0 fsk_gain_out
  create_bd_pin -dir I -from 15 -to 0 fsk_out
  create_bd_pin -dir I -from 31 -to 0 fsk_psk_sig
  create_bd_pin -dir I mode_fsk
  create_bd_pin -dir I mode_psk
  create_bd_pin -dir O -from 11 -to 0 mux_out1
  create_bd_pin -dir O -from 11 -to 0 mux_out2
  create_bd_pin -dir O nSYNC
  create_bd_pin -dir I -from 1 -to 0 psk_bitstream
  create_bd_pin -dir I -from 31 -to 0 psk_gain_out
  create_bd_pin -dir I -from 15 -to 0 psk_out
  create_bd_pin -dir I -from 2 -to 0 sel
  create_bd_pin -dir O -from 0 -to 0 start_conversion

  # Create instance: DA2RefComp_0, and set properties
  set block_name DA2RefComp
  set block_cell_name DA2RefComp_0
  if { [catch {set DA2RefComp_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DA2RefComp_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: monsterplexer_0, and set properties
  set block_name monsterplexer
  set block_cell_name monsterplexer_0
  if { [catch {set monsterplexer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $monsterplexer_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: start_gen_0, and set properties
  set start_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 start_gen_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {16} \
   CONFIG.MemInitFile {start.coe} \
   CONFIG.ReadMifFile {true} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $start_gen_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins clk45M159] [get_bd_pins DA2RefComp_0/CLK] [get_bd_pins start_gen_0/CLK]
  connect_bd_net -net DA2RefComp_0_CLK_OUT [get_bd_pins CLK_OUT] [get_bd_pins DA2RefComp_0/CLK_OUT]
  connect_bd_net -net DA2RefComp_0_D1 [get_bd_pins D1] [get_bd_pins DA2RefComp_0/D1]
  connect_bd_net -net DA2RefComp_0_D2 [get_bd_pins D2] [get_bd_pins DA2RefComp_0/D2]
  connect_bd_net -net DA2RefComp_0_DONE [get_bd_pins DONE] [get_bd_pins DA2RefComp_0/DONE]
  connect_bd_net -net DA2RefComp_0_nSYNC [get_bd_pins nSYNC] [get_bd_pins DA2RefComp_0/nSYNC]
  connect_bd_net -net RST_1 [get_bd_pins RST] [get_bd_pins DA2RefComp_0/RST]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins start_conversion] [get_bd_pins DA2RefComp_0/START] [get_bd_pins start_gen_0/D] [get_bd_pins start_gen_0/Q]
  connect_bd_net -net channel_out_1 [get_bd_pins channel_out] [get_bd_pins monsterplexer_0/data_in5]
  connect_bd_net -net clk5M64_1 [get_bd_pins clk2M8224] [get_bd_pins monsterplexer_0/clk]
  connect_bd_net -net fsk_bitstream_1 [get_bd_pins fsk_bitstream] [get_bd_pins monsterplexer_0/data_in6]
  connect_bd_net -net fsk_gain_out_1 [get_bd_pins fsk_gain_out] [get_bd_pins monsterplexer_0/data_in2]
  connect_bd_net -net fsk_out_1 [get_bd_pins fsk_out] [get_bd_pins monsterplexer_0/data_in0]
  connect_bd_net -net fsk_psk_sig_1 [get_bd_pins fsk_psk_sig] [get_bd_pins monsterplexer_0/data_in4]
  connect_bd_net -net mode_fsk_1 [get_bd_pins mode_fsk] [get_bd_pins monsterplexer_0/mode_fsk]
  connect_bd_net -net mode_psk_1 [get_bd_pins mode_psk] [get_bd_pins monsterplexer_0/mode_psk]
  connect_bd_net -net psk_bitstream_1 [get_bd_pins psk_bitstream] [get_bd_pins monsterplexer_0/data_in7]
  connect_bd_net -net psk_gain_out_1 [get_bd_pins psk_gain_out] [get_bd_pins monsterplexer_0/data_in3]
  connect_bd_net -net psk_out_1 [get_bd_pins psk_out] [get_bd_pins monsterplexer_0/data_in1]
  connect_bd_net -net sel_1 [get_bd_pins sel] [get_bd_pins monsterplexer_0/sel]
  connect_bd_net -net special_mux_0_data_out1 [get_bd_pins mux_out1] [get_bd_pins DA2RefComp_0/DATA1] [get_bd_pins monsterplexer_0/data_out1]
  connect_bd_net -net special_mux_0_data_out2 [get_bd_pins mux_out2] [get_bd_pins DA2RefComp_0/DATA2] [get_bd_pins monsterplexer_0/data_out2]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set CLK_OUT [ create_bd_port -dir O CLK_OUT ]
  set D1 [ create_bd_port -dir O D1 ]
  set D2 [ create_bd_port -dir O D2 ]
  set DONE [ create_bd_port -dir O DONE ]
  set buttons [ create_bd_port -dir I -from 3 -to 0 buttons ]
  set leds [ create_bd_port -dir O -from 3 -to 0 leds ]
  set nSYNC [ create_bd_port -dir O nSYNC ]
  set rgbleds [ create_bd_port -dir O -from 5 -to 0 rgbleds ]
  set sw [ create_bd_port -dir I -from 1 -to 0 sw ]

  # Create instance: Output_selector
  create_hier_cell_Output_selector [current_bd_instance .] Output_selector

  # Create instance: PS_to_PL
  create_hier_cell_PS_to_PL [current_bd_instance .] PS_to_PL

  # Create instance: adder, and set properties
  set adder [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 adder ]
  set_property -dict [ list \
   CONFIG.A_Width {32} \
   CONFIG.B_Value {00000000000000000000000000000000} \
   CONFIG.B_Width {32} \
   CONFIG.CE {false} \
   CONFIG.Latency {3} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {32} \
 ] $adder

  # Create instance: channel_emulator
  create_hier_cell_channel_emulator [current_bd_instance .] channel_emulator

  # Create instance: clock_generator
  create_hier_cell_clock_generator [current_bd_instance .] clock_generator

  # Create instance: fsk_mapper_0, and set properties
  set block_name fsk_mapper
  set block_cell_name fsk_mapper_0
  if { [catch {set fsk_mapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fsk_mapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fsk_modulator
  create_hier_cell_fsk_modulator [current_bd_instance .] fsk_modulator

  # Create instance: ila_monitoring
  create_hier_cell_ila_monitoring [current_bd_instance .] ila_monitoring

  # Create instance: mult_fsk, and set properties
  set mult_fsk [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_fsk ]
  set_property -dict [ list \
   CONFIG.OutputWidthHigh {31} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {16} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {9} \
   CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_fsk

  # Create instance: mult_psk, and set properties
  set mult_psk [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_psk ]
  set_property -dict [ list \
   CONFIG.OutputWidthHigh {31} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {16} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {9} \
   CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_psk

  # Create instance: psk_mapper_0, and set properties
  set block_name psk_mapper
  set block_cell_name psk_mapper_0
  if { [catch {set psk_mapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $psk_mapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: psk_modulator
  create_hier_cell_psk_modulator [current_bd_instance .] psk_modulator

  # Create instance: random_bitstream_gen_fsk, and set properties
  set block_name random_bitstream_generator
  set block_cell_name random_bitstream_gen_fsk
  if { [catch {set random_bitstream_gen_fsk [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $random_bitstream_gen_fsk eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.seed_arrangement {1} \
   CONFIG.seed_value {475} \
   CONFIG.simulation {0} \
 ] $random_bitstream_gen_fsk

  # Create instance: random_bitstream_gen_psk, and set properties
  set block_name random_bitstream_generator
  set block_cell_name random_bitstream_gen_psk
  if { [catch {set random_bitstream_gen_psk [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $random_bitstream_gen_psk eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.seed_arrangement {0} \
   CONFIG.seed_value {472} \
   CONFIG.simulation {0} \
 ] $random_bitstream_gen_psk

  # Create interface connections
  connect_bd_intf_net -intf_net PS_to_PL_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins PS_to_PL/DDR]
  connect_bd_intf_net -intf_net PS_to_PL_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins PS_to_PL/FIXED_IO]

  # Create port connections
  connect_bd_net -net Output_selector_CLK_OUT [get_bd_ports CLK_OUT] [get_bd_pins Output_selector/CLK_OUT] [get_bd_pins ila_monitoring/probe4]
  connect_bd_net -net Output_selector_D1 [get_bd_ports D1] [get_bd_pins Output_selector/D1]
  connect_bd_net -net Output_selector_D2 [get_bd_ports D2] [get_bd_pins Output_selector/D2]
  connect_bd_net -net Output_selector_DONE [get_bd_ports DONE] [get_bd_pins Output_selector/DONE] [get_bd_pins ila_monitoring/probe6]
  connect_bd_net -net Output_selector_data_out [get_bd_pins Output_selector/mux_out1] [get_bd_pins ila_monitoring/mux_out1]
  connect_bd_net -net Output_selector_data_out2 [get_bd_pins Output_selector/mux_out2] [get_bd_pins ila_monitoring/mux_out2]
  connect_bd_net -net Output_selector_nSYNC [get_bd_ports nSYNC] [get_bd_pins Output_selector/nSYNC] [get_bd_pins ila_monitoring/probe5]
  connect_bd_net -net Output_selector_output_signal [get_bd_pins Output_selector/start_conversion] [get_bd_pins ila_monitoring/start_conversion]
  connect_bd_net -net PS_to_PL_Dout [get_bd_pins PS_to_PL/fsk_out] [get_bd_pins fsk_mapper_0/start_f] [get_bd_pins ila_monitoring/fsk_set_f]
  connect_bd_net -net PS_to_PL_Dout1 [get_bd_pins PS_to_PL/psk_out] [get_bd_pins ila_monitoring/psk_set_f] [get_bd_pins psk_mapper_0/freq_in]
  connect_bd_net -net PS_to_PL_Dout4 [get_bd_pins Output_selector/sel] [get_bd_pins PS_to_PL/mux_sel] [get_bd_pins ila_monitoring/mux_sel]
  connect_bd_net -net PS_to_PL_Dout5 [get_bd_pins Output_selector/mode_psk] [get_bd_pins PS_to_PL/mode_psk] [get_bd_pins ila_monitoring/mode_psk] [get_bd_pins psk_mapper_0/mode] [get_bd_pins random_bitstream_gen_psk/mode]
  connect_bd_net -net PS_to_PL_FCLK_CLK0 [get_bd_pins PS_to_PL/FCLK_CLK0] [get_bd_pins clock_generator/sys_clock] [get_bd_pins ila_monitoring/sys_clock]
  connect_bd_net -net PS_to_PL_FCLK_RESET0_N [get_bd_pins PS_to_PL/FCLK_RESET0_N] [get_bd_pins clock_generator/reset]
  connect_bd_net -net PS_to_PL_dout2 [get_bd_pins PS_to_PL/gain_fsk_scaled] [get_bd_pins mult_fsk/B]
  connect_bd_net -net PS_to_PL_dout3 [get_bd_pins PS_to_PL/gain_psk_scaled] [get_bd_pins mult_psk/B]
  connect_bd_net -net PS_to_PL_leds1 [get_bd_ports leds] [get_bd_pins PS_to_PL/leds]
  connect_bd_net -net PS_to_PL_mode_fsk [get_bd_pins Output_selector/mode_fsk] [get_bd_pins PS_to_PL/mode_fsk] [get_bd_pins ila_monitoring/mode_fsk] [get_bd_pins random_bitstream_gen_fsk/mode]
  connect_bd_net -net PS_to_PL_rgbleds1 [get_bd_ports rgbleds] [get_bd_pins PS_to_PL/rgbleds1]
  connect_bd_net -net buttons_1 [get_bd_ports buttons] [get_bd_pins PS_to_PL/buttons]
  connect_bd_net -net c_addsub_0_S [get_bd_pins Output_selector/fsk_psk_sig] [get_bd_pins adder/S] [get_bd_pins channel_emulator/channel_in] [get_bd_pins ila_monitoring/fsk_psk_add]
  connect_bd_net -net channel_emulator_channel_out [get_bd_pins Output_selector/channel_out] [get_bd_pins channel_emulator/channel_out] [get_bd_pins ila_monitoring/channel_out]
  connect_bd_net -net clock_generator_Q [get_bd_pins clock_generator/clk125M_assert] [get_bd_pins ila_monitoring/clk125M_assert]
  connect_bd_net -net clock_generator_clk22M58 [get_bd_pins Output_selector/clk2M8224] [get_bd_pins clock_generator/clk2M8224]
  connect_bd_net -net clock_generator_clk44k1 [get_bd_pins clock_generator/clk44k1] [get_bd_pins fsk_mapper_0/clk] [get_bd_pins psk_mapper_0/clk] [get_bd_pins random_bitstream_gen_fsk/clk] [get_bd_pins random_bitstream_gen_psk/clk]
  connect_bd_net -net clock_generator_clk45M159 [get_bd_pins Output_selector/clk45M159] [get_bd_pins adder/CLK] [get_bd_pins clock_generator/clk45M159] [get_bd_pins fsk_modulator/clk45M] [get_bd_pins mult_fsk/CLK] [get_bd_pins mult_psk/CLK] [get_bd_pins psk_modulator/clk45M]
  connect_bd_net -net clock_generator_clk90M3168 [get_bd_pins channel_emulator/clk90] [get_bd_pins clock_generator/clk90M3168] [get_bd_pins ila_monitoring/clk90M]
  connect_bd_net -net clock_generator_clockdiv [get_bd_pins clock_generator/clockdiv] [get_bd_pins ila_monitoring/clockdiv]
  connect_bd_net -net clock_generator_peripheral_reset [get_bd_pins Output_selector/RST] [get_bd_pins clock_generator/peripheral_reset]
  connect_bd_net -net freq_in1_1 [get_bd_pins fsk_mapper_0/freq_out] [get_bd_pins fsk_modulator/freq_in1]
  connect_bd_net -net freq_in2_1 [get_bd_pins psk_mapper_0/freq_out] [get_bd_pins psk_modulator/freq_in2]
  connect_bd_net -net fsk_gain_set_1 [get_bd_pins PS_to_PL/gain_fsk] [get_bd_pins ila_monitoring/fsk_gain_set]
  connect_bd_net -net fsk_modulator_fsk_out [get_bd_pins Output_selector/fsk_out] [get_bd_pins fsk_modulator/fsk_out] [get_bd_pins ila_monitoring/fsk_out] [get_bd_pins mult_fsk/A]
  connect_bd_net -net mult_gen_1_P [get_bd_pins Output_selector/psk_gain_out] [get_bd_pins adder/A] [get_bd_pins ila_monitoring/psk_gain_out] [get_bd_pins mult_psk/P]
  connect_bd_net -net multiplier_0_fsk_gain_out [get_bd_pins Output_selector/fsk_gain_out] [get_bd_pins adder/B] [get_bd_pins ila_monitoring/fsk_gain_out] [get_bd_pins mult_fsk/P]
  connect_bd_net -net phase_in_1 [get_bd_pins psk_mapper_0/phase_out] [get_bd_pins psk_modulator/phase_in]
  connect_bd_net -net probe0_1 [get_bd_pins fsk_modulator/mod_fsk_out] [get_bd_pins ila_monitoring/out_mod_fsk]
  connect_bd_net -net psk_gain_set_1 [get_bd_pins PS_to_PL/gain_psk] [get_bd_pins ila_monitoring/psk_gain_set]
  connect_bd_net -net psk_modulator_m_axis_data_tdata [get_bd_pins ila_monitoring/out_mod_psk] [get_bd_pins psk_modulator/mod_psk_out]
  connect_bd_net -net psk_modulator_psk_out [get_bd_pins Output_selector/psk_out] [get_bd_pins ila_monitoring/psk_out] [get_bd_pins mult_psk/A] [get_bd_pins psk_modulator/psk_out]
  connect_bd_net -net random_bitstream_gen_0_data_out [get_bd_pins Output_selector/fsk_bitstream] [get_bd_pins fsk_mapper_0/sel] [get_bd_pins ila_monitoring/fsk_bitstream_out] [get_bd_pins random_bitstream_gen_fsk/data_out]
  connect_bd_net -net random_bitstream_gen_psk_data_out [get_bd_pins Output_selector/psk_bitstream] [get_bd_pins ila_monitoring/psk_bitstream_out] [get_bd_pins psk_mapper_0/sel] [get_bd_pins random_bitstream_gen_psk/data_out]
  connect_bd_net -net sw_1 [get_bd_ports sw] [get_bd_pins PS_to_PL/sw]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


