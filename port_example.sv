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
    `uvm_info(get_type(),$sformatf("the value of data is:%0d",data),UVM_LOW);
     port.put(data);
     port.try_put(data);
     port.can_put();
  endtask
   endclass
   
   
   class consumer extends uvm_component;
      uvm_put_imp#(int,consumer) imp;
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
   
   function bit try_put(int val);
       `uvm_info(get_type(),"inside try_put",UVM_NONE);
       return 1;
   endfunction
   endclass
   
   class env extends uvm_component;
     `uvm_component_utils(env)
     producer p;
     consumer c;
     function new(string name="env",uvm_component parent);
        super.new(name,parent);
     endfunction
     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p=producer::type_id::create("producer",this);
        c=consumer::type_id::create("consumer",this);
     endfunction
     
     function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.port.connect(c.imp);
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
      task run_phase(uvm_phase phase);
        super.run_phase(phase);
       phase.raise_objection(this);
       #50;
       phase.drop_objection(this);
       endtask
        
     endclass
     module tb;
     initial begin
      run_test("test");
     end
     endmodule
     
     
     
     
      
   
