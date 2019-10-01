import uvm_pkg::*;
`include "uvm_macros.svh"
`include "alu_if.sv"
`include "alu_seq_item.sv"
`include "alu_sequence.sv"
`include "alu_sequencer.sv"
`include "alu_driver.sv"
`include "alu_agent.sv"
`include "alu_monitor.sv"
`include "alu_resMonitor.sv"
`include "alu_scoreboard.sv"
`include "alu_env.sv"
`include "alu_test.sv"

module alu_top();
  reg clk,rst;
	
  alu_if alu_vinf(.clk(clk), .rst(rst));
 
  alu d(alu_vinf.clk, alu_vinf.rst, alu_vinf.pushin, alu_vinf.stopout, alu_vinf.ctl,
	alu_vinf.a, alu_vinf.b,
        alu_vinf.ci, alu_vinf.pushout, alu_vinf.cout, alu_vinf.z, alu_vinf.stopin);

  initial begin
    uvm_config_db#(virtual alu_if)::set(null,"*","vinf",alu_vinf);
    run_test("alu_test");
  end

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
  end
 
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars;
  end 
endmodule : alu_top
