class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)
  
  virtual interface alu_if vinf; 
  alu_env env;
  alu_sequence seq; 
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in Test")
    end
    env = alu_env::type_id::create("env",this);
    seq = alu_sequence::type_id::create("seq",this);
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this,"Objection started");
    seq.start(env.agent.seqr);
    phase.drop_objection(this,"Objection finished");
  endtask : run_phase

endclass : alu_test
