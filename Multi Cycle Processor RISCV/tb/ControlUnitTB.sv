`timescale 1ns / 1ps

module tb_Control_Unit();

    // --- Clock and Reset Signals ---
    logic CLK;
    logic rst;

    // --- Inputs to DUT ---
    logic [31:0] Instr;
    logic Zero;

    // --- Outputs from DUT ---
    logic PCWrite;
    logic AdrSrc;
    logic MemWrite;
    logic IRWrite;
    logic RegWrite;
    logic [1:0] ResultSrc;
    logic [2:0] ALUControl;
    logic [1:0] ALUSrcB;
    logic [1:0] ALUSrcA;
    logic [1:0] ImmSrc;

    // --- Instantiate the Device Under Test (DUT) ---
    Control_Unit dut (
        .CLK(CLK),
        .rst(rst),
        .Instr(Instr),
        .Zero(Zero),
        .PCWrite(PCWrite),
        .AdrSrc(AdrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .ImmSrc(ImmSrc)
    );

    // --- Clock Generation (50MHz) ---
    always begin
        CLK = 0;
        #10;
        CLK = 1;
        #10;
    end

    // --- Task to Stream Instructions Through Cycles ---
    task automatic run_instruction(
        input logic [31:0] test_instr, 
        input int cycles_to_wait, 
        input logic zero_flag,
        input string label
    );
        $display("\n--- Testing: %s (Instr: 0x%h) ---", label, test_instr);
        Instr = test_instr;
        Zero = zero_flag;
        
        for(int i = 0; i < cycles_to_wait; i++) begin
            @(posedge CLK);
            #1; 
            $display("[Cycle %0d] PCWrite=%b | AdrSrc=%b | MemWrite=%b | IRWrite=%b | RegWrite=%b | ALUControl=%b | ImmSrc=%b", 
                     i, PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, ALUControl, ImmSrc);
        end
    endtask

    // --- Test Vector Generation ---
    initial begin
        // Initialize inputs
        Instr = 32'd0; // Fixed typo here
        Zero = 1'b0;
        rst = 1'b1;
        
        repeat(2) @(posedge CLK);
        #1 rst = 1'b0;
        $display("System Reset De-asserted.");

        // --- Test Vectors ---
        run_instruction(32'b0000000_00001_00010_000_00011_0110011, 4, 1'b0, "R-Type ADD");
        run_instruction(32'b0100000_00001_00010_000_00011_0110011, 4, 1'b0, "R-Type SUB");
        run_instruction(32'b000000000100_00001_010_00010_0000011, 5, 1'b0, "Load Word (lw)");
        run_instruction(32'b0000000_00001_00010_010_00100_0100011, 4, 1'b0, "Store Word (sw)");
        run_instruction(32'b0000000_00001_00010_000_00100_1100011, 3, 1'b1, "BEQ (Branch Taken)");
        run_instruction(32'b0000000_00001_00010_000_00100_1100011, 3, 1'b0, "BEQ (Branch Not Taken)");
        run_instruction(32'b0_0000000000000000000_00001_1101111, 4, 1'b0, "JAL Jump");

        #50;
        $display("\nAll control patterns completed.");
        $finish;
    end

endmodule