`include "uvm_macros.svh"
import uvm_pkg::*;
class packet extends uvm_object;
 `uvm_object_utils(packet)
rand int data;
 function new(string name="packet");
   super.new(name);
 endfunction
 
 function void display(string s);
 $display("[%s]the value of data is %d",s,data);
 endfunction
 endclass
 
 class generator extends uvm_component;
 uvm_blocking_put_port#(packet) put_port;
  `uvm_component_utils(generator)
  packet p;
 function new(string name="generator",uvm_component parent);
   super.new(name,parent);
   put_port=new("put_port",this);
 endfunction

 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   p=packet::type_id::create("packet");
endfunction


task run_phase(uvm_phase phase);
   p.randomize();
   put_port.put(p);
endtask
endclass


class driver extends uvm_driver;
uvm_blocking_get_port#(packet)get_port;
packet p;
  `uvm_component_utils(driver)
 function new(string name="driver",uvm_component parent);
   super.new(name,parent);
   get_port=new("get_port",this);
 endfunction
 
 task run_phase(uvm_phase phase);
  get_port.get(p);
  p.display("driver");
endtask
endclass


class agent extends uvm_agent;
`uvm_component_utils(agent)
driver d;
generator g;
uvm_tlm_fifo#(packet) fifop;
function new(string name="agent",uvm_component parent);
   super.new(name,parent);
    fifop=new("fifop",this);
endfunction
function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  g=generator::type_id::create("g",this);
  d=driver::type_id::create("d",this);

 endfunction
 
 function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 g.put_port.connect(fifop.put_export);
 d.get_port.connect(fifop.get_export);
 endfunction
 endclass
 
class env extends uvm_env;
agent a;
`uvm_component_utils(env)
function new(string name="env",uvm_component parent);
   super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  a=agent::type_id::create("a",this);
endfunction
 endclass
 
 
 class test extends uvm_test;
env e;
`uvm_component_utils(test)
function new(string name="test",uvm_component parent);
   super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  e=env::type_id::create("e",this);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

 endclass
 
 module tb;
 initial begin
  run_test("test");
 
  end
  endmodule
  
 
 
   

 ///////////////////////////////////////////////////


------------------------------------------------------------
Name                     Type                    Size  Value
------------------------------------------------------------
uvm_test_top             test                    -     @334 
  e                      env                     -     @347 
    a                    agent                   -     @356 
      d                  driver                  -     @434 
        get_port         uvm_blocking_get_port   -     @463 
        rsp_port         uvm_analysis_port       -     @453 
        seq_item_port    uvm_seq_item_pull_port  -     @443 
      fifop              uvm_tlm_fifo #(T)       -     @365 
        get_ap           uvm_analysis_port       -     @404 
        get_peek_export  uvm_get_peek_imp        -     @384 
        put_ap           uvm_analysis_port       -     @394 
        put_export       uvm_put_imp             -     @374 
      g                  generator               -     @415 
        put_port         uvm_blocking_put_port   -     @424 
------------------------------------------------------------

UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
[driver]the value of data is  1905784253
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---
