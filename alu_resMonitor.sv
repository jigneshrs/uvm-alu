class alu_resMonitor extends uvm_monitor;
  `uvm_component_utils(alu_resMonitor)
   
  alu_seq_item req;
  uvm_analysis_port #(alu_seq_item) mon_resPort;
	
  virtual interface alu_if vinf; 
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_resPort = new("mon_resPort",this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in result monitor")
    end
  endfunction : build_phase

task run_phase(uvm_phase phase);
  begin
    fork 
      forever begin
  	@(posedge(vinf.clk));
  	if(vinf.pushout && !vinf.rst && !vinf.stopin) begin
  	  req = new();
  	  req.cout   = vinf.cout;
  	  req.z       = vinf.z;
          req.stopout = vinf.stopout;
          req.pushout = vinf.pushout;
  	  mon_resPort.write(req);
  	end
      end
    join_none
  end
endtask : run_phase
endclass : alu_resMonitor

