//ほんまにパイプラインか？

module pipelinecpu();
    reg [0:15][0:15] general_register = 0;
    reg [0:511][0:15] memory;
    reg [0:10] pc =0;
    reg [0:15] inst;

    reg halt = 1;

    reg [0:3] opcode;
    reg [0:3] Rd;
    reg [0:3] Rs;
    reg [0:7] imm8;
    reg [0:3] disp4;
    reg [0:8] disp9;
    
    always #100 ck <= (~ck) && halt;

