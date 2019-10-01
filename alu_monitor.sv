class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual interface alu_if vinf; 
  alu_seq_item req;
  uvm_analysis_port #(alu_seq_item) mon_port;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_port = new("mon_port",this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface failed in Monitor")
    end
  endfunction : build_phase

task run_phase(uvm_phase phase);
  begin
    fork 
      forever begin
  	@(posedge vinf.clk);
  	if(vinf.pushin && (vinf.rst==0) && (vinf.stopout==0)) begin
  	  req = new();
  	  req.a   = vinf.a;
  	  req.b   = vinf.b;
  	  req.ci  = vinf.ci;
  	  req.ctl = vinf.ctl;
  	  mon_port.write(req);
  	end
      end
    join_none
  end
endtask : run_phase

endclass
