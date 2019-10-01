class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)
  
   
  alu_driver driver;
  alu_sequencer seqr;
  
  virtual interface alu_if vinf; 
  
 
  function new(string name = "alu_agent", uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in Agent")
    end
    driver = alu_driver::type_id::create("driver",this);
    seqr   = alu_sequencer::type_id::create("seqr",this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(seqr.seq_item_export);
  endfunction : connect_phase
  
endclass : alu_agent
