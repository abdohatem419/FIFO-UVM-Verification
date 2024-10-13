//===========================================================
// Project:     FIFO UVM Testbench
// File:        coverage_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This package defines the `fifo_coverage` class 
//              responsible for collecting and sampling functional 
//              coverage from the FIFO design during the simulation.
//===========================================================

package coverage_pkg;

    //===========================================================
    // Import the necessary packages for sequences, UVM, and macros
    //===========================================================
    import sequence_item_pkg::*;   // Import sequence item definitions
    import uvm_pkg::*;             // Import Universal Verification Methodology (UVM) package
    `include "uvm_macros.svh"      // Include UVM macros for component utilities

    //===========================================================
    // Class:       fifo_coverage
    // Description: This class is responsible for collecting coverage 
    //              of the FIFO design based on various control signals. 
    //              It utilizes UVM analysis ports to sample the data 
    //              from the monitor and analyze functional coverage.
    //===========================================================
    class fifo_coverage extends uvm_component;

        //===========================================================
        // Macro:       `uvm_component_utils
        // Description: Declares factory registration for the class.
        //===========================================================
        `uvm_component_utils(fifo_coverage)

        //===========================================================
        // Variable:    cov_export
        // Description: Analysis export used to receive data from the 
        //              monitor for coverage sampling.
        //===========================================================
        uvm_analysis_export #(fifo_sequence_item) cov_export;

        //===========================================================
        // Variable:    fifo_cov
        // Description: TLM FIFO for storing coverage items received 
        //              from the monitor.
        //===========================================================
        uvm_tlm_analysis_fifo #(fifo_sequence_item) fifo_cov;

        //===========================================================
        // Variable:    cov_item
        // Description: Item for capturing the FIFO transaction data 
        //              that will be used for sampling coverage.
        //===========================================================
        fifo_sequence_item cov_item;
        
        //===========================================================
        // Covergroup:  cvr_gb
        // Description: The covergroup that defines coverpoints and 
        //              cross coverage for various FIFO signals.
        //===========================================================
        covergroup cvr_gb;
        
            //===========================================================
            // Coverpoints: Various control signals of the FIFO
            // Description: These coverpoints capture the status and 
            //              behavior of the FIFO's control signals such 
            //              as read enable, write enable, full, empty, etc.
            //===========================================================
            cp_rd_en:       coverpoint cov_item.rd_en;
            cp_wr_en:       coverpoint cov_item.wr_en;
            cp_wr_ack:      coverpoint cov_item.wr_ack;
            cp_overflow:    coverpoint cov_item.overflow;
            cp_full:        coverpoint cov_item.full;
            cp_empty:       coverpoint cov_item.empty;
            cp_almostfull:  coverpoint cov_item.almostfull;
            cp_almostempty: coverpoint cov_item.almostempty;
            cp_underflow:   coverpoint cov_item.underflow;

            //===========================================================
            // Cross Coverage: Interaction of control signals
            // Description: Captures the combined behavior of key 
            //              control signals to analyze how the FIFO 
            //              behaves under various conditions.
            //===========================================================
            cross cp_rd_en, cp_wr_en, cp_wr_ack;
            cross cp_rd_en, cp_wr_en, cp_overflow;
            cross cp_rd_en, cp_wr_en, cp_full;
            cross cp_rd_en, cp_wr_en, cp_empty;
            cross cp_rd_en, cp_wr_en, cp_almostfull;
            cross cp_rd_en, cp_wr_en, cp_almostempty;
            cross cp_rd_en, cp_wr_en, cp_underflow;

        endgroup  // cvr_gb

        //===========================================================
        // Function:    new
        // Description: Constructor for the coverage component class. 
        //              Initializes the covergroup for sampling coverage.
        //===========================================================
        function new(string name = "fifo_coverage",uvm_component parent = null);
            super.new(name, parent);  // Call the base class constructor
            cvr_gb = new();           // Initialize the covergroup
        endfunction

        //===========================================================
        // Function:    build_phase
        // Description: UVM build phase where the analysis export 
        //              and FIFO for coverage are created.
        //===========================================================
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);   // Create the analysis export
            fifo_cov = new("fifo_cov", this);       // Create the FIFO for coverage
        endfunction

        //===========================================================
        // Function:    connect_phase
        // Description: Connects the coverage export to the analysis 
        //              export of the monitor to receive transactions.
        //===========================================================
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(fifo_cov.analysis_export);  // Connect the analysis port to FIFO
        endfunction

        //===========================================================
        // Task:        run_phase
        // Description: The main task that continuously samples coverage 
        //              by retrieving transactions from the FIFO and 
        //              invoking the covergroup sample.
        //===========================================================
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo_cov.get(cov_item);   // Retrieve the next coverage item from FIFO
                cvr_gb.sample();          // Sample the covergroup with the new item
            end
        endtask

    endclass  // fifo_coverage

endpackage  // coverage_pkg
