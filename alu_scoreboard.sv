class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
 
  `uvm_analysis_imp_decl(_in)
  `uvm_analysis_imp_decl(_out)

  uvm_analysis_imp_in #(alu_seq_item,alu_scoreboard) sb_port;
  uvm_analysis_imp_out #(alu_seq_item,alu_scoreboard) sb_resPort;  

  virtual interface alu_if vinf;
 
  bit[1:0] ctl_temp;
  logic [8:0] expectedResult, actualResult;

  alu_seq_item pkt;
  alu_seq_item inSeq[$];
  alu_seq_item outSeq[$];
  alu_seq_item inSeq_res;
  alu_seq_item outSeq_res;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    sb_port = new("sb_port",this);
    sb_resPort = new("sb_resPort",this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in scoreboard")
    end
  endfunction : build_phase

  function void write_in(input alu_seq_item in_pkt);
    inSeq.push_back(in_pkt);
  endfunction : write_in

  function void write_out(input alu_seq_item out_pkt);
    outSeq.push_back(out_pkt);
  endfunction : write_out
  
  task run_phase (uvm_phase phase);
      forever begin
        inSeq_res = new();
        outSeq_res = new();
	@(posedge vinf.clk); #1
	if(vinf.pushout) begin
	  if((inSeq.size() && outSeq.size()) >= 1) begin
            inSeq_res  = inSeq.pop_front();
            outSeq_res = outSeq.pop_front();
	  end

	  case(inSeq_res.ctl)
              2'b00: expectedResult = {1'b0,inSeq_res.a};
              2'b01: expectedResult = inSeq_res.a + inSeq_res.b + {8'b0,inSeq_res.ci};
              2'b10: expectedResult = inSeq_res.a - inSeq_res.b + {8'b0,inSeq_res.ci};
              2'b11: expectedResult = inSeq_res.a ^ inSeq_res.b;
          endcase
          
          actualResult = {outSeq_res.cout,outSeq_res.z};

          if(expectedResult == actualResult) begin
              `uvm_info("Results are same", $sformatf("ctl = %b, a = %h, b = %h, cin = %b, cout = %b, actualResult = %h , expectedResult = %h, ",inSeq_res.ctl,inSeq_res.a,
		        inSeq_res.b,inSeq_res.ci,outSeq_res.cout,actualResult,expectedResult),UVM_MEDIUM);
          end
          else begin
              `uvm_info("Results are not same", $sformatf("ctl = %b, a = %h, b = %h, cin = %b, cout = %b,actualResult = %h , expectedResult = %h, ",inSeq_res.ctl,
		        inSeq_res.a,inSeq_res.b,inSeq_res.ci,outSeq_res.cout,actualResult,expectedResult),UVM_MEDIUM);
              `uvm_error("Results are not same", $sformatf("ctl = %b, a = %h, b = %h, cin = %b, cout = %b,actualResult = %h , expectedResult = %h, ",inSeq_res.ctl,inSeq_res.a,inSeq_res.b,inSeq_res.ci,outSeq_res.cout,actualResult,expectedResult));
          end
	end  
      end 
  endtask : run_phase

endclass
