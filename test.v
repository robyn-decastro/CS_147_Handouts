

module tb_regFile 

  
   parameter BYPASS_GATED_BY_RST = 0;

   reg         clk, rst, wen;
   reg  [2:0]  r1sel, r2sel, wsel;
   reg  [15:0] wdata;

   wire [15:0] r1, r2, b1, b2;
   wire        err, berr;

   regFile dut (
      .read1Data(r1), .read2Data(r2), .err(err),
      .clk(clk), .rst(rst), .read1RegSel(r1sel), .read2RegSel(r2sel),
      .writeRegSel(wsel), .writeData(wdata), .writeEn(wen));

   regFile_bypass dutb (
      .read1Data(b1), .read2Data(b2), .err(berr),
      .clk(clk), .rst(rst), .read1RegSel(r1sel), .read2RegSel(r2sel),
      .writeRegSel(wsel), .writeData(wdata), .writeEn(wen));

   // ---------------- clock ----------------
   initial clk = 0;
   always #5 clk = ~clk;

   // ---------------- reference model ----------------
   reg [15:0] model [0:7];
   reg        check_data;     // off until the first reset has been applied
   integer    errors, checks;
   integer    i, j, seed;
   reg [15:0] e1, e2, be1, be2;
   reg        byp1, byp2;

   task fail;
      input [8*40-1:0] what;
      begin
         errors = errors + 1;
         $display("FAIL @%0t: %0s | rst=%b wen=%b wsel=%0d wdata=%h r1sel=%0d r2sel=%0d | r1=%h r2=%h b1=%h b2=%h err=%b berr=%b",
                  $time, what, rst, wen, wsel, wdata, r1sel, r2sel, r1, r2, b1, b2, err, berr);
      end
   endtask

   // Compare all outputs against the model (inputs must be X-free).
   task check_outputs;
      begin
         checks = checks + 1;
         if (check_data) begin
            e1 = model[r1sel];
            e2 = model[r2sel];
            if (r1 !== e1) fail("regFile read1Data mismatch");
            if (r2 !== e2) fail("regFile read2Data mismatch");

            byp1 = wen && (r1sel == wsel) && (!BYPASS_GATED_BY_RST || !rst);
            byp2 = wen && (r2sel == wsel) && (!BYPASS_GATED_BY_RST || !rst);
            be1  = byp1 ? wdata : e1;
            be2  = byp2 ? wdata : e2;
            if (b1 !== be1) fail("bypass read1Data mismatch");
            if (b2 !== be2) fail("bypass read2Data mismatch");
         end
         if (err  !== 1'b0) fail("regFile err should be 0");
         if (berr !== 1'b0) fail("bypass err should be 0");
      end
   endtask

   // Update model for the posedge that just happened.
   task model_edge;
      begin
         if (rst === 1'b1) begin
            for (j = 0; j < 8; j = j + 1) model[j] = 16'h0000;
            check_data = 1;
         end else if (wen === 1'b1) begin
            model[wsel] = wdata;
         end
      end
   endtask

   // One full clock cycle with known inputs.
   task cycle;
      input        t_rst;
      input [2:0]  t_wsel;
      input [15:0] t_wdata;
      input        t_wen;
      input [2:0]  t_r1;
      input [2:0]  t_r2;
      begin
         @(negedge clk);
         rst = t_rst; wsel = t_wsel; wdata = t_wdata; wen = t_wen;
         r1sel = t_r1; r2sel = t_r2;
         #2;
         check_outputs;
         @(posedge clk);
         model_edge;
      end
   endtask

   // Read every register through both ports (no write, no reset).
   task read_all;
      begin
         for (i = 0; i < 8; i = i + 1)
            cycle(0, 3'd0, 16'h0000, 0, i[2:0], 3'd7 - i[2:0]);
      end
   endtask

   // Fill registers with distinct nonzero values.
   task fill_all;
      begin
         for (i = 0; i < 8; i = i + 1)
            cycle(0, i[2:0], 16'hA500 + (i * 16'h0111) + 16'h0001, 1, i[2:0], 3'd0);
      end
   endtask

   // Drive inputs that include X and check that err goes high in both DUTs.
   // (Data outputs are not checked here.) t_rst=1 keeps X writes from
   // corrupting the registers.
   task expect_err;
      input [8*32-1:0] what;
      begin
         #2;
         checks = checks + 1;
         if (err  !== 1'b1) begin errors = errors + 1; $display("FAIL @%0t: regFile err not 1 for %0s", $time, what); end
         if (berr !== 1'b1) begin errors = errors + 1; $display("FAIL @%0t: bypass err not 1 for %0s", $time, what); end
         @(posedge clk);
         model_edge;
      end
   endtask

   // ---------------- watchdog ----------------
   initial begin
      #2000000;
      $display("TIMEOUT");
      $finish;
   end

   // ---------------- main sequence ----------------
   initial begin
      errors = 0; checks = 0; check_data = 0; seed = 147;
      for (j = 0; j < 8; j = j + 1) model[j] = 16'h0000;
      rst = 1; wen = 0; wsel = 0; wdata = 0; r1sel = 0; r2sel = 0;

      $display("--- T1: initial reset, everything reads 0 ---");
      cycle(1, 0, 16'h0000, 0, 0, 1);
      cycle(1, 0, 16'h0000, 0, 2, 3);
      read_all;

      $display("--- T2: basic writes and reads ---");
      fill_all;
      read_all;

      $display("--- T3: writeEn=0 must not write ---");
      for (i = 0; i < 8; i = i + 1)
         cycle(0, i[2:0], 16'hDEAD, 0, i[2:0], 3'd0);
      read_all;

      $display("--- T4: reset with wen=0 clears ALL registers ---");
      fill_all;
      cycle(1, 3'd0, 16'h0000, 0, 3'd0, 3'd1);
      read_all;

      $display("--- T5: reset has priority over a simultaneous write (every target reg) ---");
      for (i = 0; i < 8; i = i + 1) begin
         fill_all;
         cycle(1, i[2:0], 16'hFFFF, 1, i[2:0], 3'd0);
         read_all;                    // all eight must be 0, including reg i
      end

      $display("--- T6: reset held for several cycles while writing ---");
      fill_all;
      for (i = 0; i < 6; i = i + 1)
         cycle(1, i[2:0], 16'h1234 + i, 1, i[2:0], 3'd7 - i[2:0]);
      read_all;

      $display("--- T7: writes work immediately after reset releases ---");
      fill_all;
      cycle(1, 3'd0, 16'h0000, 0, 3'd0, 3'd0);
      cycle(0, 3'd5, 16'hBEEF, 1, 3'd5, 3'd5);   // first cycle after reset
      cycle(0, 3'd0, 16'h0000, 0, 3'd5, 3'd4);
      read_all;

      $display("--- T8: single-cycle reset between two writes ---");
      cycle(0, 3'd2, 16'hAAAA, 1, 3'd2, 3'd2);
      cycle(1, 3'd2, 16'hBBBB, 1, 3'd2, 3'd2);
      cycle(0, 3'd2, 16'hCCCC, 1, 3'd2, 3'd1);
      read_all;

      $display("--- T9: reset is synchronous: a pulse that misses posedge is ignored ---");
      fill_all;
      @(negedge clk);
      rst = 0; wen = 0; wsel = 0; wdata = 0; r1sel = 0; r2sel = 0;
      #1 rst = 1;                    // rises after negedge
      #2 rst = 0;                    // falls at negedge+3, before the posedge at +5
      @(posedge clk);
      model_edge;                    // rst=0, wen=0 -> model unchanged
      read_all;                      // values must be preserved

      $display("--- T10: reset asserted but dropped just before the edge, with a write ---");
      fill_all;
      @(negedge clk);
      rst = 1; wen = 1; wsel = 3'd4; wdata = 16'h7777; r1sel = 3'd4; r2sel = 3'd0;
      #3 rst = 0;                    // still before the posedge, write should win
      @(posedge clk);
      model_edge;                    // rst=0, wen=1 -> model[4]=7777
      read_all;

      $display("--- T11: reset then read-while-write (bypass vs reset) ---");
      fill_all;
      cycle(1, 3'd6, 16'h9999, 1, 3'd6, 3'd6);
      cycle(0, 3'd6, 16'h4242, 1, 3'd6, 3'd6);
      read_all;

      $display("--- T12: X inputs must raise err (reset keeps regs clean) ---");
      cycle(1, 0, 16'h0000, 0, 0, 0);

      @(negedge clk);
      rst = 0; wen = 0; wsel = 0; wdata = 16'bx; r1sel = 0; r2sel = 0;
      expect_err("writeData = X");

      @(negedge clk);
      rst = 0; wen = 0; wsel = 0; wdata = 16'h1111; r1sel = 3'bx; r2sel = 0;
      expect_err("read1RegSel = X");

      @(negedge clk);
      rst = 0; wen = 0; wsel = 0; wdata = 16'h1111; r1sel = 0; r2sel = 3'bx;
      expect_err("read2RegSel = X");

      @(negedge clk);
      rst = 1; wen = 1'bx; wsel = 3'd1; wdata = 16'h1111; r1sel = 0; r2sel = 0;
      expect_err("writeEn = X");

      @(negedge clk);
      rst = 1; wen = 0; wsel = 3'bx; wdata = 16'h1111; r1sel = 0; r2sel = 0;
      expect_err("writeRegSel = X");

      // Back to clean inputs: err must drop to 0 and registers must read 0.
      cycle(1, 0, 16'h0000, 0, 0, 0);
      read_all;

      $display("--- T13: random test with frequent resets ---");
      for (i = 0; i < 4000; i = i + 1) begin
         cycle(($random(seed) & 7) == 0,          // reset ~1 in 8
               $random(seed),                     // wsel (low 3 bits)
               $random(seed),                     // wdata (low 16 bits)
               $random(seed),                     // wen (low bit)
               $random(seed),                     // r1sel
               $random(seed));                    // r2sel
      end
      read_all;

      $display("-----------------------------------------");
      if (errors == 0) $display("PASS: %0d checks, 0 errors", checks);
      else             $display("FAILED: %0d errors in %0d checks", errors, checks);
      $finish;
   end

endmodules