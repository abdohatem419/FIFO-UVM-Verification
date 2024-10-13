//===========================================================
// Project:     FIFO UVM Testbench
// File:        sequence_item_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_sequence_item` class, 
//              which represents the sequence item used in UVM for 
//              FIFO operations, including various data signals and 
//              constraints for randomization.
//===========================================================

package sequence_item_pkg;

    //===========================================================
    // Import the UVM package and include UVM macros
    //===========================================================
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_sequence_item
    // Description: This class represents a sequence item for the FIFO 
    //              testbench, inheriting from `uvm_sequence_item`. 
    //              It includes parameters for data width, depth, and 
    //              various control signals for FIFO operations.
    //===========================================================
    class fifo_sequence_item extends uvm_sequence_item;

        //===========================================================
        // Macro:       `uvm_object_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_object_utils(fifo_sequence_item)

        //===========================================================
        // Parameters for FIFO configuration
        //===========================================================
        parameter WIDTH_F = 16;         // Width of data in bits
        parameter DEPTH_F = 8;          // Depth of FIFO
        parameter RD_EN_ON_DIST = 30;   // Probability distribution for read enable
        parameter WR_EN_ON_DIST = 70;   // Probability distribution for write enable

        //===========================================================
        // Random variables for FIFO sequence item
        //===========================================================
        rand logic [WIDTH_F-1:0] data_in;   // Input data for FIFO
        rand logic rst_n, wr_en, rd_en;      // Control signals: reset, write enable, read enable
        logic [WIDTH_F-1:0] data_out;        // Output data from FIFO
        logic wr_ack, overflow;               // Acknowledgment and overflow flags
        logic full, empty, almostfull, almostempty, underflow; // FIFO status flags

        //===========================================================
        // Function:    new
        // Description: Constructor for the FIFO sequence item, 
        //              initializes the item with a given name.
        //===========================================================
        function new(string name = "fifo_sequence_item");
            super.new(name);  // Call the base class constructor
        endfunction

        //===========================================================
        // Function:    convert2string
        // Description: Converts the FIFO sequence item data to a 
        //              string representation for reporting.
        //===========================================================
        function string convert2string();
            return $sformatf("%s rst_n = 0b%b , data_in = 0b%b , wr_en = 0b%b , rd_en = 0b%b , data_out = 0b%b , wr_ack = 0b%b , overflow = 0b%b, 
            underflow = 0b%b , full = 0b%b , empty = 0b%b , almostfull = 0b%b , almostempty = 0b%b",
            super.convert2string(),
            rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);
        endfunction

        //===========================================================
        // Function:    convert2string_stimulus
        // Description: Converts relevant control signals and input 
        //              data to a string for stimulus reporting.
        //===========================================================
        function string convert2string_stimulus();
            return $sformatf("rst_n = 0b%b , data_in = 0b%b , wr_en = 0b%b , rd_en = 0b%b", rst_n, data_in, wr_en, rd_en);
        endfunction

        //===========================================================
        // Constraints for randomization of control signals
        //===========================================================
        constraint reset_n {
            rst_n dist {
                0 := 20,  // Probability for reset active
                1 := 80   // Probability for reset inactive
            };
        }

        constraint write_enable {
            wr_en dist {
                0 := 100 - WR_EN_ON_DIST,  // Probability for write disable
                1 := WR_EN_ON_DIST         // Probability for write enable
            };
        }

        constraint read_enable {
            rd_en dist {
                0 := 100 - RD_EN_ON_DIST,  // Probability for read disable
                1 := RD_EN_ON_DIST         // Probability for read enable
            };
        }
    endclass  // fifo_sequence_item

endpackage  // sequence_item_pkg
