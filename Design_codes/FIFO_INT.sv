//===========================================================
// Project:     FIFO Interface for Verification
// File:        FIFO_INT.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: Interface definition for a FIFO module, providing 
//              all necessary signals for writing, reading, and 
//              managing the status of the FIFO. It includes parameters 
//              for FIFO width and depth, and a modport to define 
//              the signals for the DUT (Design Under Test).
//===========================================================

interface FIFO_INT (
    clk // Clock signal
);

//===========================================================
// Parameters
//===========================================================
parameter FIFO_WIDTH = 16; // Width of the FIFO (number of bits per entry)
parameter FIFO_DEPTH = 8;  // Depth of the FIFO (number of entries)

//===========================================================
// Signal Declarations
//===========================================================
logic [FIFO_WIDTH-1:0] data_in;   // Input data to be written into the FIFO
logic rst_n;                      // Active-low reset signal
logic wr_en;                      // Write enable signal
logic rd_en;                      // Read enable signal
logic [FIFO_WIDTH-1:0] data_out;  // Output data read from the FIFO
logic wr_ack;                     // Acknowledge signal for write operation
logic overflow;                   // Overflow flag (set when writing to a full FIFO)
logic full;                       // Full flag (set when FIFO is full)
logic empty;                      // Empty flag (set when FIFO is empty)
logic almostfull;                 // Almost full flag (set when FIFO is near full capacity)
logic almostempty;                // Almost empty flag (set when FIFO is near empty)
logic underflow;                  // Underflow flag (set when reading from an empty FIFO)

//===========================================================
// Modport Declarations
//===========================================================
// Defines the signals that the DUT (Design Under Test) will use
modport DUT (
    input clk,               // Clock signal input
    input data_in,           // Data input signal
    input rst_n,             // Reset signal input
    input wr_en,             // Write enable input
    input rd_en,             // Read enable input
    output data_out,         // Data output signal
    output wr_ack,           // Write acknowledge output
    output overflow,         // Overflow flag output
    output full,             // Full flag output
    output empty,            // Empty flag output
    output almostfull,       // Almost full flag output
    output almostempty,      // Almost empty flag output
    output underflow         // Underflow flag output
);

endinterface
