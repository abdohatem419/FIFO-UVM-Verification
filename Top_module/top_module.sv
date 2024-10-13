//===========================================================
// Project:     FIFO UVM Testbench
// File:        top_module.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This is the top module for the UVM testbench environment. 
//              It includes a clock generation block, instantiation of 
//              the FIFO interface and FIFO DUT, and the binding of 
//              SystemVerilog Assertions (SVA) to the DUT. The UVM 
//              configuration database is used to pass the FIFO interface
//              to the testbench, and the test is initiated using the 
//              `run_test` method.
//===========================================================

module top_module;

    //===========================================================
    // Signal Declarations
    //===========================================================
        bit clk; // Clock signal
    
    //===========================================================
    // Clock Generation
    //===========================================================
        initial begin
            clk = 0;               // Initialize the clock to 0
            forever #1 clk = ~clk;  // Toggle the clock every time unit (1ps or 1ns depending on timescale)
        end
    
    //===========================================================
    // Interface and DUT Instantiation
    //===========================================================
        FIFO_INT fifo_interface_instance (clk);  // Instantiate FIFO interface with clock
        FIFO DUT (fifo_interface_instance);      // Instantiate FIFO DUT and connect it to the interface
    
    //===========================================================
    // Binding Assertions
    //===========================================================
        bind FIFO SVA FIFO_SVA (fifo_interface_instance); // Bind SystemVerilog Assertions (FIFO_SVA) to the DUT using the interface signals
    
    //===========================================================
    // UVM Test Initialization
    //===========================================================
        initial begin
            // Set the FIFO interface in the UVM configuration database, making it accessible from the UVM test environment
            uvm_config_db#(virtual FIFO_INT)::set(null, "uvm_test_top", "FIFO_INTERFACE", fifo_interface_instance);
            run_test("fifo_test"); // Run the UVM test named "fifo_test"
        end
    
    endmodule
    