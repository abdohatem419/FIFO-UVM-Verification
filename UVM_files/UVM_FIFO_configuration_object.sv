//===========================================================
// Project:     FIFO UVM Testbench
// File:        configuration_object_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines a configuration object class 
//              (`fifo_configuration_object`) that inherits from 
//              `uvm_object` and holds a virtual interface for the FIFO.
//===========================================================

package configuration_object_pkg;

    //===========================================================
    // Import the UVM package and macros
    //===========================================================
    import uvm_pkg::*;           // Import the Universal Verification Methodology (UVM) package
    `include "uvm_macros.svh"    // Include UVM macros for object utilities

    //===========================================================
    // Class:       fifo_configuration_object
    // Description: This class represents a configuration object that 
    //              holds a virtual interface (`fifo_vif`) for the FIFO.
    //===========================================================
    class fifo_configuration_object extends uvm_object;

        //===========================================================
        // Macro:       `uvm_object_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_object_utils(fifo_configuration_object)

        //===========================================================
        // Variable:    fifo_vif
        // Description: A virtual interface to the FIFO, used to connect 
        //              the UVM environment to the DUT interface.
        //===========================================================
        virtual FIFO_INT fifo_vif;

        //===========================================================
        // Function:    new
        // Description: Constructor for the configuration object class. 
        //              Initializes the class with the given name or 
        //              the default name ("fifo_configuration_object").
        //===========================================================
        function new(string name = "fifo_configuration_object");
            super.new(name);  // Call the base class constructor
        endfunction

    endclass // fifo_configuration_object

endpackage // configuration_object_pkg
