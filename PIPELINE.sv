//ほんまにパイプラインか？

module Install(
    input bit ck,
    input shortint memory,
    output shortint inst
);
    always @(posedge ck)begin
        inst<=memory;
    end
endmodule


module Programcounter(
    input bit ck,
    input logic next_pc,
    output logic pc
);
    always @(posedge ck)begin
        pc<=next_pc;
    end
endmodule


module Split(
    input bit ck,
    input logic inst,
    output logic [0:3] opcode,
    output logic [0:3] Rd,
    output logic [0:3] Rs,
    output logic [0:3] Rs2,
    output logic [0:3] Rb,
    output logic [0:3] disp4,
    output logic [0:7] imm8,
    output logic [0:8] disp9;
);


endmodule


module Operation(
    input bit ck,
    input 
)

endmodule


module PIPELINE();
    logic [0:15][0:15] general_register = 0;
    logic [0:511][0:15] memory;
    logic [0:10] pc =0;
    logic [0:10] a =0;
    logic [0:15] inst;

    logic halt = 1;

    logic [0:3] opcode;
    logic [0:3] Rd;
    logic [0:3] Rs;
    logic [0:7] imm8;
    logic [0:3] disp4;
    logic [0:8] disp9;
    
    bit ck = 1;

    always #100 ck <= (~ck) && halt;

    initial begin
        memory[0] <= 24'b01_0000_000001_000001_000001;
        memory[1] <= 24'b01_0000_000001_000001_000001;
        memory[2] <= 24'b10_0000_000000_000000_000001;
        #4000 $finish(0);
   
    end


    Install module_install(.ck(ck), .memory(memory[pc]),.inst(inst));
    Programcounter module_pc(.ck(ck),.next_pc(a),.*);

    always @(posedge ck) begin

    a<=pc+1;
            $display("reg_f1: %d     pc: %d",reg_file[1],pc);


    end


endmodule 