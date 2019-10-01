class alu_seq_item extends uvm_sequence_item;
  `uvm_object_utils(alu_seq_item)
  rand bit[7:0] a,b;
  bit [7:0]z;
  bit cout;
  rand bit pushin,ci;
  rand bit [1:0] ctl;
  bit stopout,pushout,stopin;
  bit rst; 

  function new (string name = "alu_seq_item");
    super.new(name);
  endfunction: new
  
endclass

