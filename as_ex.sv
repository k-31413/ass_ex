// Code your design here

//design.sv

module D_flipflop (
  input clk, rst_n,
  input d,
  output reg q
  );
  
  always@(posedge clk) begin
    if(!rst_n) q <= 0;
    else       q <= d;
  end
  
endmodule

//===========================================================================

//testbench.sv 


// Code your testbench here
// or browse Examples
`include "assertion.sv"
module tb;
  reg clk, rst_n;
  reg d;
  wire q;
  
  D_flipflop dff1(clk, rst_n, d, q);
  D_flipflop dff2(clk, rst_n, d, q);
  
  // To bind with all instances of DUT
  bind D_flipflop assertion_dff all_inst(clk, rst_n, d, q);
  
  // To bind with single instance of DUT
  bind tb.dff2 assertion_dff single_inst(clk, rst_n, d, q);
  
  always #2 clk = ~clk;
  initial begin
    clk = 0; rst_n = 0;
    d = 0;
    
    #3 rst_n = 1;
    
    repeat(6) begin
      d = $urandom_range(0, 1);
      #3 rst_n = $urandom_range(0, 1);
    end
    $finish;
  end
  
  initial begin
    $monitor("At time = %0t: rst_n = %b, d = %b, q = %b", $time, rst_n, d, q);
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule


//===========================================================================

//assertion.sv 


module assertion_dff (
  input clk, rst_n, d, q
);
  
  sequence seq1;
    d ##1 q;
  endsequence 
  
  property prop;
    @(posedge clk) disable iff(rst_n)
    d |=> seq1;
  endproperty
  
  dff_assert: assert property (prop) else $display("Assertion failed at time = %0t", $time);
endmodule