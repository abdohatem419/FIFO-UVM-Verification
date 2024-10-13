//===========================================================
// Project:     FIFO UVM Testbench
// File:        agent_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_agent` class, which 
//              is a UVM agent responsible for coordinating the 
//              interactions between the driver, sequencer, and 
//              monitor in a UVM environment. The agent also handles
//              the configuration object and analysis port for 
//              connecting the monitor's output.
//===========================================================

package agent_pkg;
    import configuration_object_pkg::*;  // Import configuration object package
    import driver_pkg::*;                // Import driver package
    import monitor_pkg::*;               // Import monitor package
    import sequence_item_pkg::*;         // Import sequence item package
    import reset_sequence_pkg::*;        // Import reset sequence package
    import read_only_sequence_pkg::*;    // Import read-only sequence package
    import write_only_sequence_pkg::*;   // Import write-only sequence package
    import read_write_sequence_pkg::*;   // Import read-write sequence package
    import sequencer_pkg::*;             // Import sequencer package
    import uvm_pkg::*;                   // Import UVM base package
    `include "uvm_macros.svh"            // Include UVM macros for utility functions

    //===========================================================
    // Class:        fifo_agent
    // Description:  UVM agent class that contains the driver, 
    //               sequencer, and monitor for the FIFO environment.
    //===========================================================
    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent); // UVM macro to provide factory registration for the agent

        //===========================================================
        // Member Variables
        //===========================================================
        fifo_driver drv;                        // FIFO driver instance
        fifo_sequencer sqr;                     // FIFO sequencer instance
        fifo_monitor mtr;                       // FIFO monitor instance
        fifo_configuration_object obj;          // Configuration object for setting up the agent
        uvm_analysis_port #(fifo_sequence_item) agent_conn; // Analysis port to send sequence items to a scoreboard or analysis component

        //===========================================================
        // Constructor:  new
        // Description:  Class constructor, initializes the agent
        //===========================================================
        function new(string name = "fifo_agent", uvm_component parent = null);
            super.new(name, parent);  // Call parent constructor (uvm_agent)
        endfunction

        //===========================================================
        // Function:     build_phase
        // Description:  Build phase where agent components are created and 
        //               configuration object is retrieved from the UVM config DB.
        //===========================================================
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);  // Call parent build_phase function

            // Retrieve configuration object from the UVM configuration database
            if(!uvm_config_db#(fifo_configuration_object)::get(this,"","FIFO_CONFIG_OBJ",obj)) begin
                `uvm_fatal("build phase","Unable to get the configuration object");  // Fatal error if configuration object is not found
            end

            // Create instances of the driver, sequencer, and monitor
            drv = fifo_driver::type_id::create("drv", this);
            sqr = fifo_sequencer::type_id::create("sqr", this);
            mtr = fifo_monitor::type_id::create("mtr", this);

            // Initialize the analysis port
            agent_conn = new("agent_conn", this);
        endfunction

        //===========================================================
        // Function:     connect_phase
        // Description:  Connect phase where connections between 
        //               components and virtual interfaces are established.
        //===========================================================
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);  // Call parent connect_phase function

            // Connect the virtual interface from the configuration object to the driver and monitor
            drv.fifo_vif = obj.fifo_vif;
            mtr.fifo_vif = obj.fifo_vif;

            // Connect sequencer's item export to the driver's sequence item port
            drv.seq_item_port.connect(sqr.seq_item_export);

            // Connect the monitor's analysis port to the agent's analysis port
            mtr.mon_ap.connect(agent_conn);
        endfunction
    endclass
endpackage
