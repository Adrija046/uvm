`include "uvm_macros.svh"
import uvm_pkg::*;
typedef enum{DATA_1,DATA_2,EXT_DATA1,EXT_DATA2} pkt_type;
pkt_type pkt;
class driver_cb extends uvm_callback;
  `uvm_object_utils(driver_cb)
  function new(string name="driver_cb");
    super.new(name);
  endfunction
  virtual task modify_pkt();
  endtask
endclass

class derived_cb extends driver_cb;
  `uvm_object_utils(derived_cb)
  function new(string name="derived_cb");
    super.new(name);
  endfunction
  task modify_pkt();
    `uvm_info(get_type_name(),"Inside Modify_pkt method injecting extra pkt",UVM_LOW);
    std::randomize(pkt) with {pkt inside{EXT_DATA1,EXT_DATA2};};
  endtask
endclass
  class driver extends uvm_component;
    `uvm_component_utils(driver)
    function new(string name="driver",uvm_component parent);
      super.new(name,parent);
    endfunction
     
    task run_phase(uvm_phase phase);
      drive();
      `uvm_do_callbacks(driver,driver_cb,modify_pkt());
    endtask
    task drive();
      `uvm_info(get_full_name(),"inside driver class method",UVM_LOW);
      std::randomize(pkt) with {pkt==DATA_1;};
    endtask
  endclass

  class env extends uvm_env;
    driver drvh;
    `uvm_component_utils(env)
    function new(string name="env",uvm_component parent);
      super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      drvh=driver::type_id::create("drvh",this);
    endfunction
  endclass

  class base_test extends uvm_test;
    env e;
    `uvm_component_utils(base_test)
    function new(string name="base_test",uvm_component parent);
      super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e=env::type_id::create("e",this);
    endfunction
  endclass
   
   class test2 extends base_test;
   derived_cb dcb;
   `uvm_component_utils(test2)
   function new(string name="test2",uvm_component parent);
      super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     dcb=derived_cb::type_id::create("dcb",this);
     uvm_callbacks#(driver,driver_cb)::add(e.drvh,dcb);
     endfunction
     endclass
     
     
   
  module top;
    initial begin
      run_test("test2");
    end
  endmodule
    
    
         
         
    
    
    
