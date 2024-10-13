//===========================================================
// Project:     FIFO UVM Testbench
// File:        scoreboard_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_scoreboard` class, 
//              which serves as a scoreboard for comparing the 
//              output of the FIFO design under test (DUT) with 
//              a reference model. It keeps track of correct 
//              and erroneous outputs and reports the results.
//===========================================================

package scoreboard_pkg;

    //===========================================================
    // Import necessary packages for sequence items and UVM
    //===========================================================
    import sequence_item_pkg::*;     // Import sequence item definitions
    import uvm_pkg::*;                // Import UVM framework
    `include "uvm_macros.svh"       // Include UVM macros

    //===========================================================
    // Class:       fifo_scoreboard
    // Description: Scoreboard class for monitoring the outputs 
    //              of the FIFO DUT, comparing against a reference 
    //              model, and reporting errors and correctness.
    //===========================================================
    class fifo_scoreboard extends uvm_scoreboard;

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_scoreboard)

        //===========================================================
        // Parameters for FIFO configuration
        //===========================================================
        parameter WIDTH = 16;                       // Width of data in bits
        parameter DEPTH = 8;                        // Depth of FIFO
        static int error_count = 0;                 // Count of errors encountered
        static int correct_count = 0;               // Count of correct outputs
        logic [WIDTH-1:0] data_out_ref;             // Reference output data
        parameter max_fifo_addr_ref = $clog2(DEPTH); // Maximum address size for FIFO
        uvm_analysis_export #(fifo_sequence_item) sc_export; // Analysis export for sequence items
        uvm_tlm_analysis_fifo #(fifo_sequence_item) fifo_sc; // TLM FIFO for analysis
        fifo_sequence_item item;                     // Current sequence item
        logic [WIDTH-1:0] fifo_ref [DEPTH-1:0];     // Memory array for FIFO reference
        bit [max_fifo_addr_ref:0] fifo_count_ref;   // Reference count of items in FIFO
        bit [max_fifo_addr_ref-1:0] write_pointer_ref; // Reference write pointer
        bit [max_fifo_addr_ref-1:0] read_pointer_ref;  // Reference read pointer

        //===========================================================
        // Function:    new
        // Description: Constructor for the FIFO scoreboard, initializes 
        //              pointers and counters.
        //===========================================================
        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);  // Call the base class constructor
            write_pointer_ref = 0; 
            read_pointer_ref = 0;
            fifo_count_ref = 0;
        endfunction

        //===========================================================
        // Function:    build_phase
        // Description: Build phase of the scoreboard where analysis 
        //              exports and FIFOs are instantiated.
        //===========================================================
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sc_export = new("sc_export", this); // Create analysis export
            fifo_sc = new("fifo_sc", this);     // Create TLM FIFO
        endfunction

        //===========================================================
        // Function:    connect_phase
        // Description: Connects the analysis export to the TLM FIFO 
        //              during the connect phase.
        //===========================================================
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sc_export.connect(fifo_sc.analysis_export); // Connect analysis export
        endfunction

        //===========================================================
        // Task:        run_phase
        // Description: Main task for processing incoming items, 
        //              comparing outputs, and tracking errors.
        //===========================================================
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo_sc.get(item);                 // Get the next item from the FIFO
                ref_model(item);                   // Call reference model function
                // Compare the output data with the reference data
                if (item.data_out != data_out_ref) begin
                    `uvm_error("run_phase", $sformatf("error encountered expected out = 0b%b , design stimulus and output : %s", data_out_ref, item.convert2string()))
                    error_count++;                 // Increment error count
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct output : %s", item.convert2string()), UVM_HIGH)
                    correct_count++;                // Increment correct count
                end
            end
        endtask

        //===========================================================
        // Function:    report_phase
        // Description: Reports the final counts of correct and error 
        //              cases at the end of simulation.
        //===========================================================
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("correct cases : %d", correct_count), UVM_MEDIUM)
            `uvm_info("report_phase", $sformatf("error cases : %d", error_count), UVM_MEDIUM)
        endfunction

        //===========================================================
        // Function:    ref_model
        // Description: Models the behavior of the FIFO for reference 
        //              checking against the DUT. Updates pointers 
        //              and counts based on the item signals.
        //===========================================================
        function void ref_model(fifo_sequence_item item);
            if (!item.rst_n) begin
                // Reset the reference model states
                write_pointer_ref <= 0; 
                read_pointer_ref <= 0;
                fifo_count_ref <= 0;
            end
            else begin
                // Execute concurrent tasks for write, read, and count logic
                fork
                    begin
                        // Write operation logic
                        if (item.wr_en && !item.full) begin
                            fifo_ref[write_pointer_ref] <= item.data_in; // Write data into reference FIFO
                            write_pointer_ref <= write_pointer_ref + 1; // Update write pointer
                        end
                    end
                    begin
                        // Read operation logic
                        if (item.rd_en && !item.empty) begin
                            data_out_ref <= fifo_ref[read_pointer_ref]; // Read data from reference FIFO
                            read_pointer_ref <= read_pointer_ref + 1; // Update read pointer
                        end
                    end
                    begin
                        // Counter operation logic 
                        if (({item.wr_en, item.rd_en} == 2'b10 && !item.full) || 
                            ({item.wr_en, item.rd_en} == 2'b11 && item.empty)) 
                            fifo_count_ref <= fifo_count_ref + 1; // Increment count
                        else if (({item.wr_en, item.rd_en} == 2'b01 && !item.empty) || 
                                 ({item.wr_en, item.rd_en} == 2'b11 && item.full))
                            fifo_count_ref <= fifo_count_ref - 1; // Decrement count
                    end
                join
            end
        endfunction
    endclass // fifo_scoreboard

endpackage // scoreboard_pkg
