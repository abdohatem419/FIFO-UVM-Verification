//===========================================================
// Project:     FIFO UVM Testbench
// File:        monitor_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_monitor` class, 
//              which monitors the FIFO's signals and generates 
//              corresponding sequence items for analysis.
//===========================================================

package monitor_pkg;

    //===========================================================
    // Import necessary packages for sequence items and UVM
    //===========================================================
    import sequence_item_pkg::*;     // Import sequence item definitions
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_monitor
    // Description: This class monitors the FIFO's signals and 
    //              generates fifo_sequence_item instances to 
    //              capture the current state of the FIFO during 
    //              simulation.
    //===========================================================
    class fifo_monitor extends uvm_monitor;

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_monitor)

        virtual FIFO_INT fifo_vif;         // Virtual interface to access FIFO signals
        fifo_sequence_item fifo_seq_item;  // Sequence item to hold FIFO data
        uvm_analysis_port #(fifo_sequence_item) mon_ap; // Analysis port for reporting

        //===========================================================
        // Function:    new
        // Description: Constructor for the FIFO monitor, calls 
        //              the base class constructor.
        //===========================================================
        function new(string name = "fifo_monitor", uvm_component parent = null);
            super.new(name, parent); // Call the base class constructor
        endfunction

        //===========================================================
        // Function:    build_phase
        // Description: Build phase of the monitor. Creates the 
        //              analysis port.
        //===========================================================
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this); // Initialize analysis port
        endfunction

        //===========================================================
        // Task:        run_phase
        // Description: The main task for the monitor. It captures 
        //              FIFO signals at every negative clock edge 
        //              and generates sequence items for analysis.
        //===========================================================
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Create a new instance of fifo_sequence_item
                fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item");
                
                // Wait for the negative edge of the clock signal
                @(negedge fifo_vif.clk);

                // Capture FIFO signals into the sequence item
                fifo_seq_item.rst_n       = fifo_vif.rst_n;
                fifo_seq_item.data_in     = fifo_vif.data_in;
                fifo_seq_item.wr_en       = fifo_vif.wr_en;
                fifo_seq_item.rd_en       = fifo_vif.rd_en;
                fifo_seq_item.data_out    = fifo_vif.data_out;
                fifo_seq_item.wr_ack      = fifo_vif.wr_ack;
                fifo_seq_item.full        = fifo_vif.full;
                fifo_seq_item.empty       = fifo_vif.empty;
                fifo_seq_item.almostfull  = fifo_vif.almostfull;
                fifo_seq_item.almostempty = fifo_vif.almostempty;
                fifo_seq_item.overflow    = fifo_vif.overflow;
                fifo_seq_item.underflow   = fifo_vif.underflow;

                // Write the sequence item to the analysis port
                mon_ap.write(fifo_seq_item);

                // Log the captured sequence item for debugging
                `uvm_info("run_phase", fifo_seq_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass // fifo_monitor

endpackage // monitor_pkg
