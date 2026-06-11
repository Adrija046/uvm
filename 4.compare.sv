`include "uvm_macros.svh"
import uvm_pkg::*;

class base_packet extends uvm_object;

   `uvm_object_utils(base_packet)
   function new(string name="base_packet");
       super.new(name);
    endfunction
    int a,b;
    virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
       base_packet bph;
       $cast(bph,rhs);
       if((this.a==bph.a)&&(this.b==bph.b))
         return 1;
       endfunction
       endclass
       
       
 module tb;
     base_packet bph1;
     base_packet bph2;
     initial begin
        bph1=base_packet::type_id::create("bph1");
        bph2=base_packet::type_id::create("bph2");
        bph1.a=60;
        bph2.a=60;
        bph1.b=80;
        bph2.b=80;
         if(bph1.compare(bph2)) 
            $display("comparison successful");
          else
          $display("comparison failed");
        end

endmodule
       
