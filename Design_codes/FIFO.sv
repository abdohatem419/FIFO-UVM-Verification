////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_INT.DUT fifo_interface_instance);
 
localparam max_fifo_addr = $clog2(fifo_interface_instance.FIFO_DEPTH);

reg [fifo_interface_instance.FIFO_WIDTH-1:0] mem [fifo_interface_instance.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		wr_ptr <= 0;
		fifo_interface_instance.overflow <= 0;
		fifo_interface_instance.wr_ack <= 0;
	end
	else if (fifo_interface_instance.wr_en && count < fifo_interface_instance.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_interface_instance.data_in;
		fifo_interface_instance.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_interface_instance.wr_ack <= 0; 
		if (fifo_interface_instance.full && fifo_interface_instance.wr_en)
			fifo_interface_instance.overflow <= 1;
		else
			fifo_interface_instance.overflow <= 0;
	end
end

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		rd_ptr <= 0;
		fifo_interface_instance.underflow <= 0;
	end
	else if (fifo_interface_instance.rd_en && count != 0) begin
		fifo_interface_instance.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin 
		if (fifo_interface_instance.empty && fifo_interface_instance.rd_en)
			fifo_interface_instance.underflow <= 1;
		else
			fifo_interface_instance.underflow <= 0;
	end
end

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		count <= 0;
	end
	else begin
		if	( (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b10) && (!fifo_interface_instance.full)) || 
		(({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.empty))) 
			count <= count + 1;
		else if ((({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b01) && (!fifo_interface_instance.empty)) || 
		(({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.full)))
			count <= count - 1;
	end
end

assign fifo_interface_instance.full = (count == fifo_interface_instance.FIFO_DEPTH)? 1 : 0;
assign fifo_interface_instance.empty = (count == 0)? 1 : 0;
assign fifo_interface_instance.almostfull = (count == fifo_interface_instance.FIFO_DEPTH-1)? 1 : 0; 
assign fifo_interface_instance.almostempty = (count == 1)? 1 : 0;

endmodule