`include "uvm_macros.svh"
import uvm_pkg::*;
class seq_item extends uvm_sequence_item;
  rand int data;
 `uvm_object_utils(seq_item)
  function new(string name="seq_item");
    super.new(name);
  endfunction
 endclass
 
 class sequencer extends uvm_sequencer#(seq_item);
     `uvm_component_utils(sequencer)
     function new(string name="sequencer",uvm_component parent);
       super.new(name,parent);
     endfunction
     endclass
     
     class driver extends uvm_driver#(seq_item);
     `uvm_component_utils(driver)
     function new(string name="driver",uvm_component parent);
       super.new(name,parent);
     endfunction
     task run_phase(uvm_phase phase);
     
       forever begin
         seq_item_port.get_next_item(req);
         #50;
         seq_item_port.item_done();
         `uvm_info(get_type_name(),"after item done called",UVM_LOW);
       end
       endtask
     endclass
     
     class sequencee extends uvm_sequence#(seq_item);
     `uvm_object_utils(sequencee)
     seq_item req;
     function new(string name="sequencee");
         super.new(name);
     endfunction
     task body();
       req=seq_item::type_id::create("req");
        wait_for_grant();
        assert(req.randomize());
        send_request(req);
        `uvm_info(get_type_name(),"Before Wait Item dobe",UVM_LOW);
        wait_for_item_done();
     endtask
     endclass
     
     
     class agent extends uvm_agent;
        `uvm_component_utils(agent)
          driver d_h;
          sequencer s;
        function new(string name="agent",uvm_component parent);
          super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          d_h=driver::type_id::create("d_h",this);
          s=sequencer::type_id::create("s",this);
          endfunction
          function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            d_h.seq_item_port.connect(s.seq_item_export);
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
            a=agent::type_id::create("a",this);
         endfunction
         endclass
     
     class test extends uvm_test;
        `uvm_component_utils(test)
         env e;
         sequencee seqh;
          function new(string name="e",uvm_component parent);
            super.new(name,parent);
        endfunction
          function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            e=env::type_id::create("e",this);
            seqh=sequencee::type_id::create("seqh");
         endfunction
         task run_phase(uvm_phase phase);
           super.run_phase(phase);
           phase.raise_objection(this);
           seqh.start(e.a.s);
           phase.drop_objection(this);
           endtask
         endclass
         
         module tb;
         initial begin
           run_test("test");
           end
           endmodule


UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(45) @ 0: uvm_test_top.e.a.s@@seqh [sequencee] Before Wait Item dobe
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(29) @ 50000: uvm_test_top.e.a.d_h [driver] after item done called
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(19968) @ 50000: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 50000: reporter [UVM/REPORT/SERVER
