//
// This is the DUT interface
//
interface alu_if(input clk, input rst);

reg clk,rst;
logic [1:0] ctl;
logic pushin;
logic pushout;
logic stopin;
logic stopout;
logic [7:0] a;
logic [7:0] b;
logic ci;
logic cout;
logic [7:0] z;

/*clocking cb @(posedge(clk));
endclocking
*/

modport dut(input clk, input rst, input pushin, output stopout, input ctl, input a, input b, input ci, output pushout, output cout, output z, input stopin);

endinterface : alu_if
