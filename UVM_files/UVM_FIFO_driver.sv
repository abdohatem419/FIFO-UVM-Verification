//===========================================================
// Project:     FIFO UVM Testbench
// File:        driver_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_driver` class,
//              which drives the FIFO interface signals based 
//              on the sequence items received from the sequencer.
//===========================================================

package driver_pkg;

    //===========================================================
    // Import necessary packages for configuration objects,
    // sequence items, and UVM components.
    //===========================================================
    import configuration_object_pkg::*; // Import configuration object definitions
    import sequence_item_pkg::*;        // Import sequence item definitions
    import uvm_pkg::*;                  // Import UVM framework
    `include "uvm_macros.svh"         // Include UVM macros

    //===========================================================
    // Class:       fifo_driver
    // Description: This class is responsible for driving the FIFO 
    //              signals based on the sequence items received 
    //              from the sequencer.
    //===========================================================
    class fifo_driver extends uvm_driver #(fifo_sequence_item);

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_driver);

        virtual FIFO_INT fifo_vif;           // Virtual interface for FIFO signals
        fifo_sequence_item fifo_seq_item;    // FIFO sequence item to drive

        //===========================================================
        // Function:    new
        // Description: Constructor for the FIFO driver, 
        //              calls the base class constructor.
        //===========================================================
        function new(string name = "fifo_driver", uvm_component parent = null);
            super.new(name, parent); // Call the base class constructor
        endfunction

        //===========================================================
        // Task:        run_phase
        // Description: Run phase of the driver. Continuously fetches 
        //              sequence items and drives the FIFO interface 
        //              signals accordingly.
        //===========================================================
        task run_phase(uvm_phase phase);
            super.run_phase(phase); // Call the base class run phase
            forever begin
                fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item"); // Create a new sequence item
                seq_item_port.get_next_item(fifo_seq_item); // Get the next sequence item from the sequencer
                @(negedge fifo_vif.clk); // Wait for the negative edge of the clock
                
                // Drive FIFO signals based on the sequence item
                fifo_vif.rst_n   = fifo_seq_item.rst_n;   // Set reset signal
                fifo_vif.wr_en   = fifo_seq_item.wr_en;   // Set write enable signal
                fifo_vif.rd_en   = fifo_seq_item.rd_en;   // Set read enable signal
                fifo_vif.data_in = fifo_seq_item.data_in; // Set input data signal
                
                seq_item_port.item_done(); // Indicate that item processing is done
                `uvm_info("run_phase", fifo_seq_item.convert2string_stimulus(), UVM_HIGH) // Log stimulus information
            end
        endtask
    endclass // fifo_driver

endpackage // driver_pkg
