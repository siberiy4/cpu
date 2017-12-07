// `include "conpc.sv"

module cpu();
    reg [0:31][0:23] reg_file = 0;
    reg [0:300][0:23] memory; 
    reg [0:31] pc = 0;
    reg conpc = 0;
    reg [0:5] npc = 0;
    reg [0:23] inst; // current instruction
    reg [0:1] flag=0;

    reg halt = 1;

    reg [0:1] optype;
    reg [0:3] op;
    reg [0:5] rd;
    reg [0:5] rs;
    reg [0:5] c;
    reg ck = 1;
    always #100 ck <= (~ck) && halt;
    
    initial begin
        // memory[0] <= 24'b01_0000_000001_000000_000001;
        // //[1]を１にする
        // memory[1] <= 24'b01_0000_000010_000000_000101;
        // //i=5の宣言
        // memory[2] <= 24'b00_0100_000011_000010_000000;
        
        // memory[3] <= 24'b00_0110_000001_000001_000111; 
        // memory[4] <= 24'b00_0010_000001_000001_000010;
        // memory[5] <= 24'b01_0001_000010_000010_000001;
        // memory[6] <= 24'b10_0000_000000_000000_000001;
        // memory[7] <= 24'b11_1111_000001_000001_000001;
        
        
        memory[0] <= 24'b01_0000_000001_000001_000001;
        memory[1] <= 24'b01_0000_000001_000001_000001;
        memory[2] <= 24'b10_0000_000000_000000_000001;
         #4000 $finish(0);

    end


    task  calculation(input op, input rd, input rs, input c);
        case (op)   
            /* add */  4'b0000 : begin
                reg_file[rd] <= reg_file[rs] + reg_file[c];
                end
            /* sub */  4'b0001 :
                reg_file[rd] <= reg_file[rs] - reg_file[c];
            /* mul */  4'b0010 :
                reg_file[rd] <= reg_file[rs] * reg_file[c];
            /* and */  4'b1001 :
                reg_file[rd] <= reg_file[rs] & reg_file[c];
            /* or  */  4'b1010 :
                reg_file[rd] <= reg_file[rs] | reg_file[c];
            /* xor */  4'b1011 : 
                reg_file[rd] <= reg_file[rs] ^ reg_file[c];
            /* glt */  4'b0100 :
                reg_file[rd] <= reg_file[rs] > reg_file[c];
            /* eq  */  4'b0101 :
                reg_file[rd] <= reg_file[rs] == reg_file[c];
            /* beq */  4'b0110 :
                if(reg_file[c]==reg_file[rs]) pc <= reg_file[rd];
            /* bne */  4'b0111 :
                if(reg_file[c]!=reg_file[rs]) pc <= reg_file[rd];
        endcase
    endtask

    task  Calculus(input op, input rd, input rs, input c);        
        case(op)
            /* addi */ 4'b0000 : 
                reg_file[rd] <= reg_file[rs] + c;
            /* subi */ 4'b0001 :
                reg_file[rd] <= reg_file[rs] - c;
            /* muli */ 4'b0010 :
                reg_file[rd] <= reg_file[rs] * c;
            /* rdndi */ 4'b1001 :
                reg_file[rd] <= reg_file[rs] & c;
            /* ori  */ 4'b1010 :
                reg_file[rd] <= reg_file[rs] | c;
            /* xori */ 4'b1011 :
                reg_file[rd] <= reg_file[rs] ^ c;
            /* glti */ 4'b0100 :
                reg_file[rd] <= reg_file[rs] > c;
            /* eqi  */ 4'b0101 :
                reg_file[rd] <= reg_file[rs]&&reg_file[rs] == reg_file[c];
            /* sw   */ 4'b1100 :
                memory[rs+c] <= reg_file[rd];
            /* lw   */ 4'b1101 :
                reg_file[rd] <= memory[rs+c]; 
            /* beqi */ 4'b0110 :
                if(reg_file[rs]==c) pc<=reg_file[rd];
            /* bnei */ 4'b0111 :
                if(reg_file[rs]!=c) pc<=reg_file[rd];
        endcase
    endtask
    


task jump(input rd,input c);
            /* jump */ 
                reg_file[rd]<=c;
endtask //automatic

task  Control(input op);
        case(op)
            /* nop */ 4'b0000 :;
            /* halt */4'b1111 :
                halt <= 0;
        endcase
endtask //automatic
  
    always @(posedge ck) begin
        if (conpc==1) begin
            pc<=npc;
        end
        else begin pc <= pc + 1; end
    end
  
    always @(posedge ck) begin
        inst <= memory[pc];
    end
    always @(posedge ck) begin
        optype <= inst[0:1];
        op <= inst[2:5];
        rd  <= inst[6:11];
        rs  <= inst[12:17];
        c  <= inst[18:23];


    if (flag==3)begin
        optype<=2'b11;
        op<=4'b0000;
        flag<=2;
    end

    if (flag==2)begin
        optype<=2'b11;
        op<=4'b0000;
        flag<=1;
    end


        $display("optype: %b", optype);
        $display("inst: %b", inst);

        if(optype==2'b00)begin
            calculation(op,rd,rs,c);
        end

        if (optype==2'b01) begin
            Calculus(op,rd,rs,c);
        end



        if (optype==2'b11) begin
            Control(op);
        end

        if (optype==2'b10) begin
           conpc<=1;
           npc<= c;
           flag<=3;
            optype<=2'b11;
            op<=4'b0000;
        end else begin
            conpc<=0;
        end
    
        // PC module_PC(._pc(pc),.next_pc(conpc));

        $display("reg_f1: %d     pc: %d",reg_file[1],pc);
     end




endmodule

