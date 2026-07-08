`timescale 1ns / 1ps

module tb_top_module;

    // ---------------------------------------------------------
    // 1. Testbench Signals
    // ---------------------------------------------------------
    logic clk;
    logic rst;

    // ---------------------------------------------------------
    // 2. Unit Under Test (UUT) Instantiation
    // ---------------------------------------------------------
    top_module uut (
        .clk(clk),
        .rst(rst)
    );

    // ---------------------------------------------------------
    // 3. Clock Generation (10ns Period -> 100MHz)
    // ---------------------------------------------------------
    always #5 clk = ~clk;

    // ---------------------------------------------------------
    // 4. Main Simulation Control Block
    // ---------------------------------------------------------
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        
        $display("\n=========================================================================================");
        $display("         SIMULATING RISC-V MULTICYCLE PROCESSOR TOP MODULE                              ");
        $display("=========================================================================================");
        
        // Hold reset for 2 full clock cycles (20ns)
        #20;
        rst = 0;
        $display("\n[TIME: %0dt] >>> Hardware Reset Released. Processor Execution Started. <<<", $time);

        // Run simulation for 230ns to capture all program instructions
        #230;
        
        $display("\n=========================================================================================");
        $display("                                 SIMULATION CONCLUDED                                    ");
        $display("=========================================================================================");
        $finish;
    end

    // ---------------------------------------------------------
    // 5. Advanced Visual Logger & Instruction Decoder
    // ---------------------------------------------------------
    int instruction_count = 0;
    
    // Internal helper wires for real-time RISC-V decoding
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [2:0]  funct3;
    logic [7:0]  funct7;
    string       decoded_state;

    always @(posedge clk) begin
        if (!rst) begin
            // Small 1ns buffer delay to allow FSM states, registers, 
            // and internal logic boundaries to fully settle before printing.
            #1; 
            
            // Extract core fields from the current instruction register
            opcode = uut.instruction[6:0];
            rd     = uut.instruction[11:7];
            funct3 = uut.instruction[14:12];
            rs1    = uut.instruction[19:15];
            rs2    = uut.instruction[24:20];
            funct7 = uut.instruction[31:25];

            // Map State numbers to descriptive Strings for presentation slides/explanations
            case (uut.control_unit.main_fsm_inst.state)
                0:  decoded_state = "0 [FETCH]";
                1:  decoded_state = "1 [DECODE]";
                2:  decoded_state = "2 [MEM_ADR]";
                3:  decoded_state = "3 [MEM_READ]";
                4:  decoded_state = "4 [MEM_WB]";
                5:  decoded_state = "5 [MEM_WRITE]";
                6:  decoded_state = "6 [EXECUTE]";
                7:  decoded_state = "7 [ALU_WB]";
                8:  decoded_state = "8 [BRANCH]";
                9:  decoded_state = "9 [JAL_WB]";
                default: decoded_state = "UNKNOWN";
            endcase
            
            // A) Detect when a brand new instruction cycle begins (State 0 is Fetch)
            if (uut.control_unit.main_fsm_inst.state == 0) begin
                instruction_count = instruction_count + 1;
                $display("\n=========================================================================================");
                $display(" >>> STARTING INSTRUCTION #%0d | Expected PC: 0x%8h <<<", instruction_count, uut.PC_reg_out);
                $display("=========================================================================================");
            end
            
            // B) Print the ultimate architectural breakdown of this cycle
            $display("[TIME: %40dns] State: %s", $time, decoded_state);
            $display("  |- DATAPATH PATHWAYS:");
            $display("     |-- PC        : 0x%8h  |  Instr Reg : 0x%8h", uut.PC_reg_out, uut.instruction);
            $display("     |-- RS1 Addr  : d'%2d      |  RS2 Addr  : d'%2d     |  RD Addr   : d'%2d", rs1, rs2, rd);
            $display("     |-- Opcode    : 7'b%7b |  Funct3    : 3'b%3b    |  Funct7    : 7'b%7b", opcode, funct3, funct7);
            $display("     |-- ALU Out   : 0x%8h  |  Mux Result: 0x%8h", uut.ALUOut, uut.Result_mux_alu_out);
            
            // C) Explicitly display the active Control Signals from your control unit
            $display("  |- CONTROL SIGNALS:");
            $display("     |-- PCWrite   : %1b  |  IRWrite   : %1b  |  RegWrite  : %1b", 
                     uut.control_unit.PCWrite, uut.control_unit.IRWrite, uut.control_unit.RegWrite);
            $display("     |-- ALUSrcA   : %1b  |  ALUSrcB   : %2b  |  ALUOp     : %2b", 
                     uut.control_unit.ALUSrcA, uut.control_unit.ALUSrcB, uut.control_unit.ALUOp);
            $display("     |-- MemWrite  : %1b  |  ResultSrc : %2b  |  AdrSrc    : %1b", 
                     uut.control_unit.MemWrite, uut.control_unit.ResultSrc, uut.control_unit.AdrSrc);
            $display("-----------------------------------------------------------------------------------------");
            
            // D) Print a distinct boundary marker when an instruction finishes its execution loop
            if (uut.control_unit.main_fsm_inst.state == 7 || 
                uut.control_unit.main_fsm_inst.state == 4 || 
                uut.control_unit.main_fsm_inst.state == 5 || 
                uut.control_unit.main_fsm_inst.state == 8 || 
                uut.control_unit.main_fsm_inst.state == 9) begin
                $display("-------------------------- [Instruction Execution Complete] -----------------------------");
            end
        end
    end

endmodule