`include "uvm_macros.svh"
import uvm_pkg::*;
class seq_item extends uvm_sequence_item;
  rand int data1;
  rand int data2;
 `uvm_object_utils(seq_item)
  function new(string name="seq_item");
    super.new(name);
  endfunction
 endclass
 
 class sequence1 extends uvm_sequence#(seq_item);
 seq_item req;
  `uvm_object_utils(sequence1)
  function new(string name="sequence1");
    super.new(name);
  endfunction
  task body();
      `uvm_info(get_type_name(),"Inside sequence1",UVM_LOW);
       req=seq_item::type_id::create("req");
       start_item(req);
       assert(req.randomize());
       finish_item(req);
    endtask
    endclass
    
    
    
class sequence2 extends uvm_sequence#(seq_item);
 seq_item req;
  `uvm_object_utils(sequence2)
  function new(string name="sequence2");
    super.new(name);
  endfunction
  task body();
      `uvm_info(get_type_name(),"Inside sequence2",UVM_LOW);
       req=seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    endtask
    endclass
    
 class sequencer1 extends uvm_sequencer#(seq_item);
   `uvm_component_utils(sequencer1)
      function new(string name="sequencer1",uvm_component parent);
         super.new(name,parent);
      endfunction
 endclass
 
 
  class sequencer2 extends uvm_sequencer#(seq_item);
   `uvm_component_utils(sequencer2)
      function new(string name="sequencer2",uvm_component parent);
         super.new(name,parent);
      endfunction
 endclass
 
class virtual_sequencer extends uvm_sequencer;
   `uvm_component_utils(virtual_sequencer)
   sequencer1 seqr1;
   sequencer2 seqr2;
   function new(string name="virtual_sequencer",uvm_component parent);
      super.new(name,parent);
  endfunction
   endclass
   
class virtual_sequence extends uvm_sequence;
sequence1 seq1;
sequence2 seq2;

  `uvm_object_utils(virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)
   function new(string name="virtual_sequence");
      super.new(name);
   endfunction
   task body();
      `uvm_info(get_type_name(),"inside virtual sequence",UVM_LOW);
      seq1=sequence1::type_id::create("seq1");
      seq2=sequence2::type_id::create("seq2");
      fork
      seq1.start(p_sequencer.seqr1);
      seq2.start(p_sequencer.seqr2);
      join
   endtask
   endclass  
  
      
   class base_driver extends uvm_driver#(seq_item);
     `uvm_component_utils(base_driver)
      function new(string name="base_driver",uvm_component parent);
        super.new(name,parent);
      endfunction
      function void build_Phase(uvm_phase phase);
        super.build_phase(phase);
      endfunction
      
      task run_phase(uvm_phase phase);
      seq_item req;
      forever
      begin
             seq_item_port.get_next_item(req);
             drive(req);
             seq_item_port.item_done(); 
      end
      endtask
      virtual task drive(seq_item req);
         `uvm_info(get_type_name(),"DRIVING FROM THE BASE DRIVER",UVM_LOW);
          #50;
    endtask
    endclass
    
    
    class driver1 extends base_driver#(seq_item);
      `uvm_component_utils(driver1)
      function new(string name="driver1",uvm_component parent);
         super.new(name,parent);
        endfunction
       virtual task drive(seq_item req);
         `uvm_info(get_type_name(),"DRIVING FROM DRIVER1",UVM_LOW);
          #50;
    endtask
    endclass
         
    
       class driver2 extends base_driver#(seq_item);
      `uvm_component_utils(driver2)
      function new(string name="driver2",uvm_component parent);
         super.new(name,parent);
        endfunction
       virtual task drive(seq_item req);
         `uvm_info(get_type_name(),"DRIVING FROM DRIVER2",UVM_LOW);
          #50;
    endtask
    endclass
    
    class agent1 extends uvm_agent;
     `uvm_component_utils(agent1)
        driver1 d1;
        sequencer1 seq1;
        function new(string name="agent1",uvm_component parent);
           super.new(name,parent);
        endfunction 
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          d1=driver1::type_id::create("d1",this);
          seq1=sequencer1::type_id::create("seq1",this);
        endfunction
        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          d1.seq_item_port.connect(seq1.seq_item_export);
       endfunction
       endclass
       
    
    class agent2 extends uvm_agent;
     `uvm_component_utils(agent2)
        driver2 d2;
        sequencer2 seq2;
        function new(string name="agent2",uvm_component parent);
           super.new(name,parent);
        endfunction 
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          d2=driver2::type_id::create("d2",this);
          seq2=sequencer2::type_id::create("seq2",this);
        endfunction
        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          d2.seq_item_port.connect(seq2.seq_item_export);
       endfunction
       endclass
       
       class env extends uvm_env;
       agent1 a1;
       agent2 a2;
       virtual_sequencer v;
         `uvm_component_utils(env)
         function new(string name="env",uvm_component parent);
             super.new(name,parent);
         endfunction
         function void build_phase(uvm_phase phase);
           a1=agent1::type_id::create("a1",this);
           a2=agent2::type_id::create("a2",this);
           v=virtual_sequencer::type_id::create("v",this);
         endfunction
         function void connect_phase(uvm_phase phase);
           super.connect_phase(phase);
           v.seqr1 = a1.seq1;
           v.seqr2 = a2.seq2;
         endfunction
        endclass
        
        
        class test extends uvm_test;
           `uvm_component_utils(test)
           env e;
           virtual_sequence vseq;
           function new(string name="test",uvm_component parent);
              super.new(name,parent);
           endfunction
           function void build_phase(uvm_phase phase);
             super.build_phase(phase);
             e=env::type_id::create("e",this);
           endfunction
           task run_phase(uvm_phase phase);
              phase.raise_objection(this);
              vseq=virtual_sequence::type_id::create("vseq");
               vseq.start(e.v);
               phase.drop_objection(this);
               endtask
               endclass
               
               module top;
               initial begin
                 run_test("test");
              end
              endmodule
       
    


UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(20867) @ 0: reporter [UVM/COMP/NAMECHECK] This implementation of the component name checks requires DPI to be enabled
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(78) @ 0: uvm_test_top.e.v@@vseq [virtual_sequence] inside virtual sequence
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(19) @ 0: uvm_test_top.e.a1.seq1@@seq1 [sequence1] Inside sequence1
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(36) @ 0: uvm_test_top.e.a2.seq2@@seq2 [sequence2] Inside sequence2
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(120) @ 0: uvm_test_top.e.a1.d1 [driver1] DRIVING FROM DRIVER1
UVM_INFO D:/uvm_copy/uvm_copy.srcs/sources_1/new/uvm.sv(132) @ 0: uvm_test_top.e.a2.d2 [driver2] DRIVING FROM DRIVER2
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(19968) @ 50000: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO C:/Xilinx/2025.1/Vivado/data/system_verilog/uvm_1.2/xlnx_uvm_package.sv(13673) @ 50000: reporter [UVM/REPORT/SERVER] 
         
     
    
    
