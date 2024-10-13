//===========================================================
// Project:     FIFO UVM Testbench
// File:        reset_sequence_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_reset_sequence` class, 
//              which implements a reset sequence for the FIFO. 
//              It sets the reset signal and initializes the input 
//              data and control signals to their default states.
//===========================================================

package reset_sequence_pkg;

    //===========================================================
    // Import necessary packages for sequence items and UVM
    //===========================================================
    import sequence_item_pkg::*;     // Import sequence item definitions
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_reset_sequence
    // Description: This class defines a sequence for resetting 
    //              the FIFO, setting appropriate signals to 
    //              ensure the FIFO is in a known state before 
    //              normal operation.
    //===========================================================
    class fifo_reset_sequence extends uvm_sequence #(fifo_sequence_item);

        //===========================================================
        // Macro:       `uvm_object_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_object_utils(fifo_reset_sequence)

        fifo_sequence_item seq_item;  // Sequence item to be used in the sequence

        //===========================================================
        // Function:    new
        // Description: Constructor for the reset sequence, calls 
        //              the base class constructor.
        //===========================================================
        function new(string name = "fifo_reset_sequence");
            super.new(name); // Call the base class constructor
        endfunction

        //===========================================================
        // Task:        body
        // Description: The main task for the reset sequence. It 
        //              initializes the sequence item, sets the 
        //              reset signal and input values, and sends 
        //              the item to the FIFO.
        //===========================================================
        task body;
            // Create a new instance of fifo_sequence_item
            seq_item = fifo_sequence_item::type_id::create("seq_item");

            // Start the sequence item
            start_item(seq_item);
            
            // Set the FIFO control signals for reset
            seq_item.rst_n   = 0;    // Assert reset (active low)
            seq_item.data_in = 0;    // Initialize data input to zero
            seq_item.rd_en   = 0;    // Disable read enable
            seq_item.wr_en   = 0;    // Disable write enable
            
            // Finish the sequence item
            finish_item(seq_item);
        endtask
    endclass // fifo_reset_sequence

endpackage // reset_sequence_pkg
