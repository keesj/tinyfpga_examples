`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module main_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 100;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;


reg reset;
reg en;
wire trigger_out;
reg echo_in;

//-- Instantiation of the unit to test
sr04 UUT (
           .clk(clk),
           .reset(reset),
           .en(en),
           .sensor_trigger_out(trigger_out),
           .sensor_echo_in(echo_in)
         );


initial begin


  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, main_tb);

  reset =1;
  en=0;
  #1;
  reset =0;
  en =1;
  #10;
  echo_in=1;
  #5;
  echo_in=0;
  
  #(DURATION) $display("End of simulation");
  $finish;
end

endmodule