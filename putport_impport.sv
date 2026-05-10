`include "uvm_macros.svh"
import uvm_pkg::*;
class transaction extends uvm_object;
`uvm_object_utils(transaction)
rand int data;
  function new(string name="transaction");
     super.new(name);
  endfunction
 function void display(string message);
 $display("%s:the value of data is :%d",message,data);
 endfunction
 endclass
 
 class uvm_generator extends uvm_component;
 uvm_blocking_put_port#(transaction) put_port;
  `uvm_component_utils(uvm_generator)

  function new(string name="uvm_generator",uvm_component parent);
     super.new(name,parent);
     put_port=new("put_port",this);
  endfunction
  
  task run_phase(uvm_phase phase);
  transaction txn;
  txn=transaction::type_id::create("txn");
  assert(txn.randomize());
  put_port.put(txn);
  endtask
  endclass
  
  class driver extends uvm_driver;
  uvm_blocking_put_imp#(transaction,driver)put_imp;
  `uvm_component_utils(driver)
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
    put_imp=new("put_port",this);
  endfunction
  task put(transaction txn);
    txn.display("driver");
  endtask
  endclass
  
  
  class agent extends uvm_agent;
   `uvm_component_utils(agent)
   uvm_generator g;
   driver d;
   function new(string name="agent",uvm_component parent);
      super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      g=uvm_generator::type_id::create("g",this);
      d=driver::type_id::create("d",this);
   endfunction
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      g.put_port.connect(d.put_imp);
  endfunction
  endclass
  
  class test extends uvm_test;
      `uvm_component_utils(test)
     agent a;
     function new(string name="test",uvm_component parent);
       super.new(name,parent);
     endfunction
     function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       a=agent::type_id::create("a",this);
    endfunction
    endclass
       
   module tb;
   initial begin
   run_test("test");
   end
   endmodule

///////////////////////////////////////////////////////////////////////
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
driver:the value of data is : 1220217796
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---
