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
  
