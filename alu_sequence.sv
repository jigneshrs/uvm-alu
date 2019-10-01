class alu_sequence extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(alu_sequence);

  function new(string name = "alu_sequence");
    super.new(name);
  endfunction

	task body();
	  alu_seq_item seq;
	  
	  seq = alu_seq_item :: type_id :: create("seq");
	  `uvm_info(get_type_name(),"Sequence start",UVM_MEDIUM)	
	  
	  repeat(500) begin	
	  start_item(seq);
	  seq.randomize() with {seq.ctl==2'b00;seq.stopin==1'b0;seq.pushin==1'b1;};
	  finish_item(seq);
	  end
	  
	  repeat(500) begin	
	  start_item(seq);
	  seq.randomize() with {seq.ctl==2'b01;seq.stopin==1'b0;seq.pushin==1'b1;};
	  finish_item(seq);
	  end
	  
	  repeat(500) begin	
	  start_item(seq);
	  seq.randomize() with {seq.ctl==2'b10;seq.stopin==1'b0;seq.pushin==1'b1;};
	  finish_item(seq);
	  end

	  repeat(500) begin	
	  start_item(seq);
	  seq.randomize() with {seq.ctl==2'b11;seq.stopin==1'b0;seq.pushin==1'b1;};
	  finish_item(seq);
	  end
	  
	  repeat(500) begin	
	  start_item(seq);
	  seq.randomize() with {seq.ctl==2'b11;seq.stopin==1'b0;seq.pushin==1'b0;};
	  finish_item(seq);
	  end	
	endtask: body
	
endclass
