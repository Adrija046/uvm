`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
`uvm_component_utils(driver)
function new(string name="driver",uvm_component parent);
   super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("Build_phase","Build Phase called from driver component",UVM_LOW);
   endfunction  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect phase","connect phase called from driver",UVM_LOW);
    endfunction
endclass


class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
function new(string name="monitor",uvm_component parent);
   super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("Build_phase","Build Phase called from monitor component",UVM_LOW);
   endfunction  
   
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect phase","connect phase called from monitor",UVM_LOW);
    endfunction
endclass


class agent extends uvm_agent;
  `uvm_component_utils(agent)
  driver d;
  monitor m;
  function new(string name="agent",uvm_component parent);
   super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("Build_phase","Build Phase called from agent component",UVM_LOW);
     d=driver::type_id::create("d",this);
     m=monitor::type_id::create("m",this);
   endfunction 
   
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect phase","connect phase called from agent",UVM_LOW);
    endfunction
   endclass

class env extends uvm_env;
  `uvm_component_utils(env)
 agent a;
  function new(string name="env",uvm_component parent);
   super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("Build_phase","Build Phase called from env component",UVM_LOW);
     a=agent::type_id::create("a",this);
 endfunction 
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect phase","connect phase called from env",UVM_LOW);
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
     `uvm_info("Build_phase","Build Phase called from test component",UVM_LOW);
     e=env::type_id::create("e",this);
 endfunction 
 
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect phase","connect phase called from test",UVM_LOW);
    endfunction
    
  function void end_of_elaboration();
    super.end_of_elaboration();
    uvm_top.print_topology();
    endfunction  
    
 endclass
 
module tb;
initial begin
run_test("test");
end 
endmodule



