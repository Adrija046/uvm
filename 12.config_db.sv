
`include "uvm_macros.svh"
import uvm_pkg::*;
class a extends uvm_component;
    `uvm_component_utils(a)
    function new(string name="a",uvm_component parent);
       super.new(name,parent);
    endfunction
    function void display();
     `uvm_info(get_type_name(),"inside class a",UVM_LOW);
   endfunction
  endclass
  
  
  class c extends uvm_component;
    `uvm_component_utils(c)
    function new(string name="c",uvm_component parent);
       super.new(name,parent);
    endfunction
    function void display();
     `uvm_info(get_type_name(),"inside class c",UVM_LOW);
   endfunction
  endclass
  
  
  class b extends uvm_component;
    `uvm_component_utils(b)
    int ctrl;
    c cc;
    function new(string name="b",uvm_component parent);
       super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     if(!uvm_config_db#(int)::get(this,"","control",ctrl))
         `uvm_fatal(get_type_name(),"get function failed");
          if(ctrl)
          cc=c::type_id::create("c",this);
          cc.display();
      endfunction
   function void display();
     `uvm_info(get_type_name(),"inside class b",UVM_LOW);
   endfunction
endclass


class env extends uvm_env;
  `uvm_component_utils(env)
  a aa;
  b bb;
  function new(string name="env",uvm_component parent);
       super.new(name,parent);
 endfunction
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   aa=a::type_id::create("aa",this);
   bb=b::type_id::create("bb",this);
 endfunction
 endclass
 
 class test extends uvm_test;
   env e;
   int ctrl=1;
   `uvm_component_utils(test)
   function new(string name="env",uvm_component parent);
      super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       e=env::type_id::create("e",this);
       uvm_config_db#(int)::set(this,"e.*","control",ctrl);
    endfunction 
    task run_phase(uvm_phase phase);
       super.run_phase(phase);
       e.aa.display();
       e.bb.display();
     endtask
   endclass
   
   module tb;
   initial begin
     run_test("test");
   end
   endmodule


UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(20) @ 0: uvm_test_top.e.bb.c [c] inside class c
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(9) @ 0: uvm_test_top.e.aa [a] inside class a
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(41) @ 0: uvm_test_top.e.bb [b] inside class b
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---
