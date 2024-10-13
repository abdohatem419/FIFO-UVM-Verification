//===========================================================
// Project:     FIFO UVM Testbench with SVA
// File:        SVA.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-10-13
// Description: This module defines SystemVerilog Assertions (SVA) 
//              for verifying the correct behavior of a FIFO design. 
//              The properties check FIFO signals like `full`, `empty`,
//              `overflow`, `underflow`, and ensure proper counter
//              and pointer operations.
//===========================================================

module SVA (FIFO_INT.DUT fifo_interface_instance); // Bind the interface instance to the assertions

    `ifdef SIM  // Conditional compilation for simulation

    //===========================================================
    // Property:     write_acknowledge
    // Description:  Ensures `wr_ack` is asserted when a write 
    //               operation occurs (wr_en is high and FIFO is not full).
    //===========================================================
    property write_acknowledge;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            (fifo_interface_instance.wr_en && !fifo_interface_instance.full) |=> fifo_interface_instance.wr_ack;
    endproperty

    //===========================================================
    // Property:     full_flag
    // Description:  Ensures the `full` flag is asserted when 
    //               the FIFO count reaches FIFO_DEPTH.
    //===========================================================
    property full_flag;
        @(posedge fifo_interface_instance.clk) 
            (DUT.count == fifo_interface_instance.FIFO_DEPTH) |-> fifo_interface_instance.full == 1;
    endproperty

    //===========================================================
    // Property:     empty_flag
    // Description:  Ensures the `empty` flag is asserted when 
    //               the FIFO count reaches 0.
    //===========================================================
    property empty_flag;
        @(posedge fifo_interface_instance.clk) 
            (DUT.count == 0) |-> fifo_interface_instance.empty == 1;
    endproperty

    //===========================================================
    // Property:     almostfull_flag
    // Description:  Ensures the `almostfull` flag is asserted when 
    //               the FIFO count is one less than FIFO_DEPTH.
    //===========================================================
    property almostfull_flag;
        @(posedge fifo_interface_instance.clk) 
            (DUT.count == fifo_interface_instance.FIFO_DEPTH-1) |-> fifo_interface_instance.almostfull;
    endproperty

    //===========================================================
    // Property:     almostempty_flag
    // Description:  Ensures the `almostempty` flag is asserted when 
    //               the FIFO count is 1.
    //===========================================================
    property almostempty_flag;
        @(posedge fifo_interface_instance.clk) 
            (DUT.count == 1) |-> fifo_interface_instance.almostempty;
    endproperty

    //===========================================================
    // Property:     overflow_flag
    // Description:  Ensures the `overflow` flag is asserted when 
    //               a write is attempted while the FIFO is full.
    //===========================================================
    property overflow_flag;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            (fifo_interface_instance.full && fifo_interface_instance.wr_en) |=> fifo_interface_instance.overflow;
    endproperty

    //===========================================================
    // Property:     underflow_flag
    // Description:  Ensures the `underflow` flag is asserted when 
    //               a read is attempted while the FIFO is empty.
    //===========================================================
    property underflow_flag;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            (fifo_interface_instance.empty && fifo_interface_instance.rd_en) |=> fifo_interface_instance.underflow;
    endproperty

    //===========================================================
    // Property:     counter_operation_up
    // Description:  Ensures the FIFO counter increases when writing 
    //               (wr_en high and rd_en low), or when both wr_en 
    //               and rd_en are high and FIFO is empty.
    //===========================================================
    property counter_operation_up;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            ((({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b10) && (!fifo_interface_instance.full)) || 
            (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.empty))) 
            |=> DUT.count == $past(DUT.count) + 1;
    endproperty

    //===========================================================
    // Property:     counter_operation_down
    // Description:  Ensures the FIFO counter decreases when reading 
    //               (rd_en high and wr_en low), or when both rd_en 
    //               and wr_en are high and FIFO is full.
    //===========================================================
    property counter_operation_down;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            ((({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b01) && (!fifo_interface_instance.empty)) || 
            (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.full))) 
            |=> DUT.count == $past(DUT.count) - 1;
    endproperty

    //===========================================================
    // Property:     read_pointer_operation
    // Description:  Ensures the read pointer (`rd_ptr`) increments 
    //               when a read operation occurs and the FIFO is not empty.
    //===========================================================
    property read_pointer_operation;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            (fifo_interface_instance.rd_en && !fifo_interface_instance.empty) |=> DUT.rd_ptr == $past(DUT.rd_ptr) + 1;
    endproperty

    //===========================================================
    // Property:     write_pointer_operation
    // Description:  Ensures the write pointer (`wr_ptr`) increments 
    //               when a write operation occurs and the FIFO is not full.
    //===========================================================
    property write_pointer_operation;
        @(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) 
            (fifo_interface_instance.wr_en && !fifo_interface_instance.full) |=> DUT.wr_ptr == $past(DUT.wr_ptr) + 1;
    endproperty

    //===========================================================
    // Reset Assertions
    // Description:  These final assertions check that after reset, 
    //               critical signals like counters, flags, and pointers 
    //               are properly reset to their initial values.
    //===========================================================
    always_comb begin
        if(!fifo_interface_instance.rst_n) begin
            a_reset: assert final(DUT.count == 0); // Check if count is reset to 0
            b_reset: assert final(fifo_interface_instance.overflow == 0); // Check if overflow is reset to 0
            c_reset: assert final(fifo_interface_instance.underflow == 0); // Check if underflow is reset to 0
            d_reset: assert final(DUT.wr_ptr == 0); // Check if write pointer is reset to 0
            e_reset: assert final(DUT.rd_ptr == 0); // Check if read pointer is reset to 0
            f_reset: assert final(fifo_interface_instance.wr_ack == 0); // Check if write acknowledge is reset to 0
        end
    end

    //===========================================================
    // Assertion and Coverage Checks
    //===========================================================
    ast1  : assert property(write_acknowledge)        else $fatal("Assertion failed: 'wr_ack' should be asserted when write occurs and FIFO is not full!");
    cvr1  : cover property(write_acknowledge);
    ast2  : assert property(full_flag)                else $fatal("Assertion failed: 'full' flag mismatch with fifo_count!");
    cvr2  : cover property(full_flag);
    ast3  : assert property(empty_flag) 	          else $fatal("Assertion failed: 'empty' flag mismatch with fifo_count!");
    cvr3  : cover property(empty_flag);
    ast4  : assert property(almostfull_flag)          else $fatal("Assertion failed: 'almostfull' flag mismatch with fifo_count!");
    cvr4  : cover property(almostfull_flag);
    ast5  : assert property(almostempty_flag)         else $fatal("Assertion failed: 'almostempty' flag mismatch with fifo_count!");
    cvr5  : cover property(almostempty_flag);
    ast6  : assert property(overflow_flag)            else $fatal("Assertion failed: 'overflow' flag mismatch if full and wr_en it should be asserted!");
    cvr6  : cover property(overflow_flag);
    ast7  : assert property(underflow_flag)           else $fatal("Assertion failed: 'underflow' flag mismatch if empty and rd_en it should be asserted!");
    cvr7  : cover property(underflow_flag);
    ast8  : assert property(counter_operation_up)     else $fatal("Assertion failed: 'count' when wr_en is high and rd_en is low it should increase!");
    cvr8  : cover property(counter_operation_up);
    ast9  : assert property(counter_operation_down)   else $fatal("Assertion failed: 'count' when wr_en is low and rd_en is high it should decrease!");
    cvr9  : cover property(counter_operation_down);
    ast10 : assert property(read_pointer_operation)   else $fatal("Assertion failed: 'rd_ptr' pointer mismatch when read occurs it should increase!");
    cvr10 : cover property(read_pointer_operation);
    ast11 : assert property(write_pointer_operation)  else $fatal("Assertion failed: 'wr_ptr' pointer mismatch when write occurs it should increase!");
    cvr11 : cover property(write_pointer_operation);

    `endif // SIM

endmodule
