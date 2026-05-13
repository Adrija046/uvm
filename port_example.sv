`include "uvm_macros.svh"
 import uvm_pkg::*;
class producer extends uvm_component;
     uvm_put_port#(int) port;
   `uvm_component_utils(producer)
   int data;
   function new(string name="producer",uvm_component parent);
     super.new(name,parent);
     port=new("port",this);
   endfunction
  task run_phase(uvm_phase phase);
     super.run_phase(phase);
     data=20;
    `uvm_info(get_type(),$sfromatf("the value of data is:%0d",data),UVM_LOW);
     port.put(data);
     port.can_put();
  endtask
   endclass
   
   
   class consumer extends uvm_component;
      uvm_imp_port#(int,consumer) imp;
     `uvm_component_utils(consumer)
   function new(string name="consumer",uvm_component parent);
     super.new(name,parent);
     imp=new("imp",this);
   endfunction
   
   task put(int val);
      #10;
      `uvm_info(get_type(),$sformatf("received the data:%0d",val),UVM_LOW);
   endtask
   
   function bit can_put();
       `uvm_info(get_type(),"inside can_put",UVM_NONE);
       return 1;
   endfunction
   endclass
