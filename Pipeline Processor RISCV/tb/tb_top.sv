`timescale 1ns / 1ps

module Top_tb;

    logic clk;
    logic rst;

    integer cycle;


    Top dut (
        .clk(clk),
        .rst(rst)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period
    end

    initial begin
        rst = 1;
        cycle = 0;

        // Hierarchy trace: Top (dut) -> Memory (memory) -> DataMem (DataMem) -> memory array
        dut.memory.DataMem.memory[0] = 8'h2A; // LSB
        dut.memory.DataMem.memory[1] = 8'h00;
        dut.memory.DataMem.memory[2] = 8'h00;
        dut.memory.DataMem.memory[3] = 8'h00; // MSB

        // Safe Reset drop (Aligns cleanly between clock edges)
        #22;
        rst = 0;

        #500;
        $finish;
    end

    always @(posedge clk) begin
        if (rst)
            cycle <= 0;
        else
            cycle <= cycle + 1;
    end

    always @(posedge clk) begin
        if (!rst) begin

            $display("\n==========================================================");
            $display("Cycle = %0d   Time = %0t", cycle, $time);
            $display("==========================================================");

            //---------------- FETCH ----------------
            $display("[FETCH]");
            $display("PCD       = 0x%08h", dut.PCD);
            $display("InstrD    = 0x%08h", dut.InstrD);
            $display("PCPlus4D  = 0x%08h", dut.PCPlus4D);

            //---------------- DECODE ----------------
            $display("\n[DECODE]");
            $display("Rs1E      = %0d", dut.Rs1E);
            $display("Rs2E      = %0d", dut.Rs2E);
            $display("RdE       = %0d", dut.RdE);
            $display("ImmExtE   = 0x%08h", dut.ImmExtE);

            //---------------- EXECUTE ----------------
            $display("\n[EXECUTE]");
            $display("ALUResultM = 0x%08h", dut.ALUResultM);
            $display("PCTargetE  = 0x%08h", dut.PCTargetE);
            $display("PCSrcE     = %0b", dut.PCSrcE);

            //---------------- MEMORY ----------------
            $display("\n[MEMORY]");
            $display("WriteDataM = 0x%08h", dut.WriteDataM);
            $display("RdM        = %0d", dut.RdM);
            $display("RegWriteM  = %0b", dut.RegWriteM);

            //---------------- WRITEBACK ----------------
            $display("\n[WRITEBACK]");
            $display("ResultW    = 0x%08h", dut.ResultW);
            $display("RdW        = %0d", dut.RdW);
            $display("RegWriteW  = %0b", dut.RegWriteW);

            //---------------- HAZARD UNIT ----------------
            $display("\n[HAZARD]");
            $display("ForwardAE  = %0b", dut.ForwardAE);
            $display("ForwardBE  = %0b", dut.ForwardBE);
            $display("StallF     = %0b", dut.StallF);
            $display("StallD     = %0b", dut.StallD);
            $display("FlushD     = %0b", dut.FlushD);
        end
    end

    //----------------------------------------
    // Continuous Upgraded Monitor Tracker
    //----------------------------------------
    initial begin
        // Hierarchy trace: Top (dut) -> Decode (decode) -> RegFile (RegisterFile) -> reg_memory array
        $monitor(
        "Time: %0t | PC: 0x%08h | INSN: %h | ALU_Out: 0x%08h | RegW: %b | x1: %h | x2: %h | x3: %h | clk: %b",
        $time,
        dut.PCD,
        dut.InstrD,
        dut.ALUResultM,
        dut.RegWriteW,
        dut.decode.RegisterFile.reg_memory[1],
        dut.decode.RegisterFile.reg_memory[2],
        dut.decode.RegisterFile.reg_memory[3],
        clk
        );
    end

endmodule