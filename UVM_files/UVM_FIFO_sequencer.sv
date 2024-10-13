//===========================================================
// Project:     FIFO UVM Testbench
// File:        sequencer_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_sequencer` class, 
//              which controls the generation of sequence items 
//              (transactions) for the FIFO UVM testbench.
//===========================================================

package sequencer_pkg;

    //===========================================================
    // Import the necessary packages for sequence items, UVM, and macros
    //===========================================================
    import sequence_item_pkg::*;   // Import definitions of sequence items
    import uvm_pkg::*;             // Import UVM framework
    `include "uvm_macros.svh"      // Include UVM macros for component utilities

    //===========================================================
    // Class:       fifo_sequencer
    // Description: This class is the UVM sequencer that generates 
    //              and controls the flow of `fifo_sequence_item` 
    //              transactions. It interacts with the driver in 
    //              the UVM environment to drive the FIFO design.
    //===========================================================
    class fifo_sequencer extends uvm_sequencer #(fifo_sequence_item);

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_sequencer);

        //===========================================================
        // Function:    new
        // Description: Constructor for the sequencer class. It initializes 
        //              the sequencer with a given name and optional parent component.
        //===========================================================
        function new(string name = "fifo_sequencer", uvm_component parent = null);
            super.new(name, parent);  // Call the base class constructor
        endfunction

    endclass  // fifo_sequencer

endpackage  // sequencer_pkg
