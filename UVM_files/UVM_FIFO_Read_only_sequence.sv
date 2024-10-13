//===========================================================
// Project:     FIFO UVM Testbench
// File:        read_only_sequence_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_read_only_sequence` class, 
//              which implements a sequence for performing 
//              read-only operations on the FIFO. 
//              It generates random read transactions while ensuring 
//              that write operations are disabled.
//===========================================================

package read_only_sequence_pkg;

    //===========================================================
    // Import necessary packages for sequence items and UVM
    //===========================================================
    import sequence_item_pkg::*;     // Import sequence item definitions
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_read_only_sequence
    // Description: This class defines a sequence for performing 
    //              read operations on the FIFO only. It generates 
    //              a specified number of random read transactions 
    //              while ensuring that write operations are disabled.
    //===========================================================
    class fifo_read_only_sequence extends uvm_sequence #(fifo_sequence_item);

        //===========================================================
        // Macro:       `uvm_object_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_object_utils(fifo_read_only_sequence)

        fifo_sequence_item seq_item;  // Sequence item to be used in the sequence

        //===========================================================
        // Function:    new
        // Description: Constructor for the read-only sequence, 
        //              calls the base class constructor.
        //===========================================================
        function new(string name = "fifo_read_only_sequence");
            super.new(name); // Call the base class constructor
        endfunction

        //===========================================================
        // Task:        body
        // Description: The main task for the read-only sequence. 
        //              It generates a number of random read operations 
        //              on the FIFO, ensuring that write operations 
        //              are disabled.
        //===========================================================
        task body;
            // Loop to generate 1000 read transactions
            repeat(1000) begin
                // Create a new instance of fifo_sequence_item
                seq_item = fifo_sequence_item::type_id::create("seq_item");
                
                // Start the sequence item
                start_item(seq_item);
                
                // Randomize the sequence item fields, setting wr_en to 0 and rd_en to 1
                assert(seq_item.randomize() with {wr_en == 0; rd_en == 1;});
                
                // Finish the sequence item
                finish_item(seq_item);
            end
        endtask
    endclass // fifo_read_only_sequence

endpackage // read_only_sequence_pkg
