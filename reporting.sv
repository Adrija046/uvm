`include "uvm_macros.svh"
import uvm_pkg::*;
class test extends uvm_test;
`uvm_component_utils(test)

function new(string name="test",uvm_component parent);
  super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
  int a=50;
  super.build_phase(phase);
  `uvm_info(get_type_name,"printing fr",UVM_NONE);
 `uvm_info(get_type_name,$sformatf("the value of a:",a),UVM_NONE);
  uvm_report_info(get_type_name,"printing from build phase",UVM_LOW,"uvm.sv",8);
  endfunction
  endclass
  module tb;
  initial begin
     uvm_top.set_report_verbosity_level(UVM_LOW);
     run_test("test");
  end
  endmodule
  ////////////////////
UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(12) @ 0: uvm_test_top [test] printing fr
WARNING: No Format provided for this argument
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(13) @ 0: uvm_test_top [test] the value of a:
UVM_INFO uvm.sv(8) @ 0: uvm_test_top [test] printing from build phase
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/COMP/NAMECHECK]     1
[UVM/RELNOTES]     1
[test]     3

