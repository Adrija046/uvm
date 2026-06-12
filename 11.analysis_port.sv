`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_object;
  rand int data;
  `uvm_object_utils(transaction)
   function new(string name="transaction");
      super.new(name);
   endfunction
endclass


class producer extends uvm_component;
`uvm_component_utils(producer)
  uvm_analysis_port#(transaction) tlm_port;
  function new(string name="producer",uvm_component parent);
     super.new(name,parent);
     tlm_port=new("tlm_port",this);
  endfunction
    transaction t;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t=transaction::type_id::create("t");
    endfunction
 task run_phase(uvm_phase phase);
    super.run_phase(phase);
    assert(t.randomize());
    `uvm_info(get_type_name(),$sformatf("the value of data is %0d",t.data),UVM_NONE);
     tlm_port.write(t);
 endtask
 endclass
 
 class consumer_a extends uvm_component;
 `uvm_component_utils(consumer_a)
uvm_analysis_imp#(transaction,consumer_a) tlm_impa; 
transaction t;
    function new(string name="consumer_a",uvm_component parent);
     super.new(name,parent);
     tlm_impa=new("tlm_impa",this);
  endfunction
  function void write(transaction t);
     `uvm_info(get_type_name(),$sformatf("received value is:%0d",t.data),UVM_LOW);
   endfunction
   endclass
   
   
   class consumer_b extends uvm_component;
 `uvm_component_utils(consumer_b)
uvm_analysis_imp#(transaction,consumer_b) tlm_impb; 
transaction t;
    function new(string name="consumer_b",uvm_component parent);
     super.new(name,parent);
     tlm_impb=new("tlm_impb",this);
  endfunction
  function void write(transaction t);
     `uvm_info(get_type_name(),$sformatf("received value is:%0d",t.data),UVM_LOW);
   endfunction
   endclass
   
    class consumer_c extends uvm_component;
 `uvm_component_utils(consumer_c)
uvm_analysis_imp#(transaction,consumer_c) tlm_impc; 
transaction t;
    function new(string name="consumer_c",uvm_component parent);
     super.new(name,parent);
     tlm_impc=new("tlm_impc",this);
  endfunction
  function void write(transaction t);
     `uvm_info(get_type_name(),$sformatf("received value is:%0d",t.data),UVM_LOW);
   endfunction
   endclass
   
   
   class env extends uvm_env;
   `uvm_component_utils(env)
    producer p;
    consumer_a a;
    consumer_b b;
    consumer_c c;
    function new(string name="env",uvm_component parent);
     super.new(name,parent);
     endfunction
     
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     p=producer::type_id::create("p",this);
     a=consumer_a::type_id::create("a",this);
     b=consumer_b::type_id::create("b",this);
     c=consumer_c::type_id::create("c",this);
   endfunction
   
     
     function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
       p.tlm_port.connect(a.tlm_impa);
       p.tlm_port.connect(b.tlm_impb);
       p.tlm_port.connect(c.tlm_impc);
    endfunction
    endclass
    
    class test extends uvm_test;
      `uvm_component_utils(test)
      env e;
      function new(string name="test",uvm_component parent);
        super.new(name,parent);
      endfunction
      function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e=env::type_id::create("e",this);
     endfunction
    endclass
    
    module tb;
    initial begin
    run_test("test");
    end
    endmodule
   


INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(28) @ 0: uvm_test_top.e.p [producer] the value of data is 1029484034
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(42) @ 0: uvm_test_top.e.a [consumer_a] received value is:1029484034
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(56) @ 0: uvm_test_top.e.b [consumer_b] received value is:1029484034
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(69) @ 0: uvm_test_top.e.c [consumer_c] received value is:1029484034
     
     
     
      
   
