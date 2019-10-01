class alu_driver extends uvm_driver #(alu_seq_item);
  `uvm_component_utils(alu_driver)

  virtual interface alu_if vinf; 
  alu_seq_item req;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this,"*","vinf",vinf)) begin
      `uvm_fatal(get_type_name(), "Virtual interface error in driver")
    end
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase
  
task run_phase(uvm_phase phase);
  
  vinf.ctl <= 1;
  vinf.pushin <= 0;
  vinf.stopin <= 0;
        $display("----------------Here in Driver 0-------------------");
  fork
  forever
    begin
      seq_item_port.get_next_item(req);
       // $display("----------------Here in Driver 1-------------------");
      if(req.pushin == 0) begin
        vinf.a <= req.a;
        vinf.b <= req.b;
       // $display("----------------Here in Driver 2-------------------");
	vinf.ci <= req.ci;
        vinf.ctl <= req.ctl;
        vinf.pushin <= 0;
        repeat(5)  @(posedge vinf.clk); #1;
      end 
      else begin
        vinf.a <= req.a;
        vinf.b <= req.b;
        vinf.ci <= req.ci;
        vinf.ctl <= req.ctl;
        vinf.pushin <= 1;
        @(posedge vinf.clk);
        while(vinf.stopout) @(posedge vinf.clk);;
        #1;
        vinf.pushin <= 0;
      end
      seq_item_port.item_done();
    end
  join_none
endtask: run_phase
  
endclass : alu_driver
