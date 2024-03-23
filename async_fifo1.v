// Top level wrapper
//
module async_fifo1
(
  input   winc, wclk, wrst_n,//winc write enable signal
  input   rinc, rclk, rrst_n,//rinc read enable signal
  input   [DSIZE-1:0] wdata,

  output  [DSIZE-1:0] rdata,
  output  wfull,
  output  rempty
);
  parameter DSIZE = 8;
  parameter ASIZE = 4;
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w #(.ADDRSIZE(ASIZE)) sync_r2w (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rptr(rptr),
    .wq2_rptr(wq2_rptr),
  );
  sync_w2r #(.ADDRSIZE(ASIZE)) sync_w2r (
        .rclk(rclk),
    .rrst_n(rrst_n),
    .wptr(wptr),
    .rq2_wptr(rq2_wptr),
  );
  fifomem #(.DATASIZE(DSIZE) , .ADDRSIZE(ASIZE)) fifomem (
    .winc(winc),
    .wfull(wfull),
    .wclk(wclk),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata),


  );
  rptr_empty #(.ADDRSIZE(ASIZE) ) rptr_empty (

    .rinc(rinc),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rq2_wptr(rq2_wptr),
    .rempty(rempty),
    .raddr(raddr),
    .rptr(rptr),

  );
  wptr_full #(.ADDRSIZE(ASIZE)) wptr_full (

    .winc(winc),
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wq2_rptr(wq2_rptr),
    .wfull(wfull),
    .waddr(waddr),
    .wptr(wptr)

  );

endmodule
