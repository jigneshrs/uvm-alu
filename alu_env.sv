class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)
  
 
  alu_agent agent;
  alu_resMonitor resMonitor;
  alu_monitor monitor;
  alu_scoreboard scoreboard;
  
  virtual interface alu_if vinf;
 
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in Env")
    end
    agent = alu_agent::type_id::create("agent",this);
    resMonitor   = alu_resMonitor::type_id::create("resMonitor",this);
    monitor   = alu_monitor::type_id::create("monitor",this);
    scoreboard    = alu_scoreboard::type_id::create("scoreboard",this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    monitor.mon_port.connect(scoreboard.sb_port);
    resMonitor.mon_resPort.connect(scoreboard.sb_resPort);
  endfunction : connect_phase
 
endclass : alu_env
