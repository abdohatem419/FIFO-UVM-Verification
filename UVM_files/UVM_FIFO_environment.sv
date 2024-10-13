//===========================================================
// Project:     FIFO UVM Testbench
// File:        environment_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_environment` class,
//              which encapsulates the various components of the
//              FIFO verification environment, including agents,
//              scoreboards, and coverage collectors.
//===========================================================

package environment_pkg;

    //===========================================================
    // Import necessary packages for sequence items, agents, 
    // and UVM components
    //===========================================================
    import sequence_item_pkg::*;      // Import sequence item definitions
    import reset_sequence_pkg::*;     // Import reset sequence
    import read_only_sequence_pkg::*; // Import read-only sequence
    import write_only_sequence_pkg::*; // Import write-only sequence
    import read_write_sequence_pkg::*; // Import read-write sequence
    import sequencer_pkg::*;          // Import sequencer definitions
    import agent_pkg::*;              // Import agent definitions
    import coverage_pkg::*;           // Import coverage definitions
    import scoreboard_pkg::*;         // Import scoreboard definitions
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_environment
    // Description: This class manages the FIFO environment by 
    //              instantiating and connecting various components 
    //              like agents, scoreboards, and coverage collectors.
    //===========================================================
    class fifo_environment extends uvm_env;

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_environment)

        fifo_agent fifo_agent_env;      // Instance of the FIFO agent
        fifo_scoreboard fifo_sc;         // Instance of the FIFO scoreboard
        fifo_coverage fifo_cvr;          // Instance of the FIFO coverage collector

        //===========================================================
        // Function:    new
        // Description: Constructor for the FIFO environment, 
        //              calls the base class constructor.
        //===========================================================
        function new(string name = "fifo_environment", uvm_component parent = null);
            super.new(name, parent); // Call the base class constructor
        endfunction

        //===========================================================
        // Function:    build_phase
        // Description: Build phase of the environment. Instantiates 
        //              the FIFO agent, scoreboard, and coverage collector.
        //===========================================================
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            fifo_agent_env = fifo_agent::type_id::create("fifo_agent_env", this); // Create FIFO agent
            fifo_sc = fifo_scoreboard::type_id::create("fifo_sc", this); // Create scoreboard
            fifo_cvr = fifo_coverage::type_id::create("fifo_cvr", this); // Create coverage collector
        endfunction

        //===========================================================
        // Function:    connect_phase
        // Description: Connect phase of the environment. Connects 
        //              the agent's connection to the scoreboard and 
        //              coverage collector.
        //===========================================================
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            fifo_agent_env.agent_conn.connect(fifo_sc.sc_export); // Connect agent to scoreboard
            fifo_agent_env.agent_conn.connect(fifo_cvr.cov_export); // Connect agent to coverage collector
        endfunction

    endclass // fifo_environment

endpackage // environment_pkg
