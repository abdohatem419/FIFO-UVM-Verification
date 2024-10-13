//===========================================================
// Project:     FIFO UVM Testbench
// File:        test_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_test` class, which 
//              serves as the main UVM test class for the FIFO 
//              UVM environment. It includes sequences for reset, 
//              write-only, read-only, and read-write operations.
//===========================================================

package test_pkg;

    //===========================================================
    // Import necessary packages for configuration, environment, 
    // sequences, and UVM framework
    //===========================================================
    import configuration_object_pkg::*;  // Import for config object
    import environment_pkg::*;           // Import for test environment
    import reset_sequence_pkg::*;        // Import for reset sequence
    import write_only_sequence_pkg::*;   // Import for write-only sequence
    import read_only_sequence_pkg::*;    // Import for read-only sequence
    import read_write_sequence_pkg::*;   // Import for read-write sequence
    import uvm_pkg::*;                   // Import UVM framework
    `include "uvm_macros.svh"            // Include UVM macros

    //===========================================================
    // Class:       fifo_test
    // Description: This class represents the main test case in the UVM
    //              environment for testing the FIFO design. It includes 
    //              instantiations for environment, configuration object,
    //              virtual interface, and various test sequences.
    //===========================================================
    class fifo_test extends uvm_test;

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_test)

        //===========================================================
        // Test-specific components and objects
        //===========================================================
        fifo_configuration_object fifo_config_obj_test;  // Configuration object
        fifo_environment env;                            // UVM environment instance
        virtual FIFO_INT fifo_vif;                       // Virtual interface handle
        fifo_reset_sequence reset_seq;                   // Reset sequence instance
        fifo_write_only_sequence write_seq;              // Write-only sequence instance
        fifo_read_only_sequence read_seq;                // Read-only sequence instance
        fifo_read_write_sequence read_write_seq;         // Read-write sequence instance

        //===========================================================
        // Function:    new
        // Description: Constructor for the test class, initializes the 
        //              test with a given name and optional parent component.
        //===========================================================
        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name, parent);  // Call the base class constructor
        endfunction

        //===========================================================
        // Function:    build_phase
        // Description: Overrides the build phase to create test components, 
        //              sequences, and configuration objects. Retrieves 
        //              the virtual interface from the configuration database.
        //===========================================================
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Create environment and sequences
            env = fifo_environment::type_id::create("env", this);
            fifo_config_obj_test = fifo_configuration_object::type_id::create("fifo_config_obj_test");
            reset_seq = fifo_reset_sequence::type_id::create("reset_seq");
            write_seq = fifo_write_only_sequence::type_id::create("write_seq");
            read_seq = fifo_read_only_sequence::type_id::create("read_seq");
            read_write_seq = fifo_read_write_sequence::type_id::create("read_write_seq");

            // Retrieve virtual interface from configuration database
            if (!uvm_config_db#(virtual FIFO_INT)::get(this, "", "FIFO_INTERFACE", fifo_config_obj_test.fifo_vif))
                `uvm_fatal("build phase", "Unable to get the virtual interface");

            // Set the configuration object for other components
            uvm_config_db#(fifo_configuration_object)::set(null, "*", "FIFO_CONFIG_OBJ", fifo_config_obj_test);
        endfunction

        //===========================================================
        // Task:        run_phase
        // Description: Main run phase for the test. Sequences for reset, 
        //              write, read, and read-write operations are executed 
        //              in order, with objections raised and dropped to control 
        //              simulation runtime.
        //===========================================================
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);  // Raise objection to keep the simulation running

            // Run reset sequence
            `uvm_info("run phase", "Reset asserted", UVM_LOW)
            reset_seq.start(env.fifo_agent_env.sqr);
            `uvm_info("run phase", "Reset deasserted", UVM_LOW)

            // Run write-only sequence
            `uvm_info("run phase", "Write sequence asserted", UVM_LOW)
            write_seq.start(env.fifo_agent_env.sqr);
            `uvm_info("run phase", "Write sequence deasserted", UVM_LOW)

            // Run read-only sequence
            `uvm_info("run phase", "Read sequence asserted", UVM_LOW)
            read_seq.start(env.fifo_agent_env.sqr);
            `uvm_info("run phase", "Read sequence deasserted", UVM_LOW)

            // Run read-write sequence
            `uvm_info("run phase", "Read-write sequence asserted", UVM_LOW)
            read_write_seq.start(env.fifo_agent_env.sqr);
            `uvm_info("run phase", "Read-write sequence deasserted", UVM_LOW)

            phase.drop_objection(this);  // Drop objection to allow simulation to end
        endtask

    endclass  // fifo_test

endpackage  // test_pkg
