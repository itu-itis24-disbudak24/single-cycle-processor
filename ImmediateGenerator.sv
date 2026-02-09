module ImmediateGenerator(

        input logic [31:0]instr,
        input logic [6:0]op,
        output logic [31:0]imm
       
);

typedef enum logic[6:0] { 

    I_TYPE_ADD = 7'b0010011,
    I_TYPE_LOAD = 7'b0000011,
    I_TYPE_JALR = 7'b1100111,
    S_TYPE = 7'b0100011,
    B_TYPE = 7'b1100011,
    J_TYPE = 7'b1101111,
    U_TYPE = 7'b0110111

 } op_type;



always_comb begin
   
    case(op) 

        I_TYPE_ADD : imm = { {20{instr[31]}} , instr[31:20] };
        I_TYPE_LOAD : imm = { {20{instr[31]}} , instr[31:20] };
        I_TYPE_JALR : imm = { {20{instr[31]}} , instr[31:20] };
        S_TYPE : imm = {{20{instr[31]}} , instr[31:25] , instr[11:7] };
        B_TYPE : imm = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 }; //buyruklar cift sayilar halinde adreslendigi icin en saga sonradan 0 eklenir
        J_TYPE : imm = {{11{instr[31]}}, instr[31] , instr[19:12] , instr[20] , instr[30:21] , 1'b0  };
        U_TYPE : imm = {instr[31:12] , 12'b0};
        default : imm = 32'b0;


    endcase


end


endmodule