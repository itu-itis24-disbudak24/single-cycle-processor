module ControlUnit(

    input logic [6:0]opcode , 
    input logic [2:0]funct3 ,
    input logic [6:0]funct7 ,

    output logic reg_write , //register yazma denetimi
    output logic mem_write , // bellek yazma denetimi
    output logic ALU_src ,  // ikinci register ya da anlik deger
    output logic [1:0]reg_src , // PC+4 , bellekten gelen veri ya da ALU sonucu
    output logic [3:0]ALU_control , //  islem denetimi
    output logic branch , 
    output logic jump



);

logic [1:0]ALU_op;

typedef enum logic[6:0] { 

    R_type = 7'b0110011,
    I_type = 7'b0010011,
    Load = 7'b0000011,
    Store = 7'b0100011,
    Branch = 7'b1100011,
    JAL = 7'b1101111,
    JALR = 7'b1100111,
    LUI = 7'b0110111



 } op_type;



//MAIN DECODER
always_comb begin

    


    case(opcode)

        R_type : begin
            reg_write = 1 ;
            ALU_src = 0;
            mem_write = 0;
            reg_src = 2'b00;
            branch = 0;
            jump = 0;
            ALU_op = 2'b10;
        end
        
        I_type : begin
            reg_write = 1 ;
            ALU_src = 1;
            mem_write = 0;
            reg_src = 2'b00;
            branch = 0;
            jump = 0;
            ALU_op = 2'b10;

        end

        Load : begin
            reg_write = 1;
            ALU_src = 1;
            mem_write = 0;
            reg_src = 2'b01;
            branch = 0;
            jump = 0;
            ALU_op = 2'b00;

        end  

        Store : begin
            reg_write = 0;
            ALU_src = 1;
            mem_write = 1;
            reg_src = 2'bxx;
            branch = 0;
            jump = 0;
            ALU_op = 2'b00;

        end

        Branch : begin
            reg_write = 0 ;
            ALU_src = 0;
            mem_write = 0;
            reg_src = 2'bxx;
            branch = 1;
            jump = 0;
            ALU_op = 2'b01;

        end 

        JAL : begin
            reg_write = 1;
            ALU_src = 1'bx;
            mem_write = 0;
            reg_src = 2'b10;
            branch = 0;
            jump = 1;
            ALU_op = 2'bxx;
        end

        JALR : begin
            reg_write = 1;
            ALU_src = 1;
            mem_write = 0;
            reg_src = 2'b10;
            branch = 0;
            jump = 1;
            ALU_op = 2'b00;
        end

        LUI: begin
            reg_write = 1;
            ALU_src = 1;
            mem_write = 0;
            reg_src = 2'b00;
            branch = 0;
            jump = 0;
            ALU_op = 2'b11;

        end

        default : begin
            reg_write = 0;
            ALU_src = 0;
            mem_write = 0;
            reg_src = 2'b00;
            branch = 0;
            jump = 0;
            ALU_op = 2'b00;

        end



    endcase



end


//ALU DECODER
always_comb begin
        case (ALU_op)
            2'b00: ALU_control = 4'b0000; // LW, SW, JALR için Toplama (ADD)
            2'b01: ALU_control = 4'b1000; // BEQ, BNE için Çıkarma (SUB)
            
            2'b10: begin // R-Type ve I-Type
                case (funct3)
                    3'b000: begin
                        // R-Type SUB (funct7[5]=1) mı? Yoksa I-Type ADD mi?
                        if (opcode[5] && funct7[5]) 
                            ALU_control = 4'b1000; // SUB
                        else 
                            ALU_control = 4'b0000; // ADD
                    end
                    3'b010: ALU_control = 4'b0101; // SLT
                    3'b110: ALU_control = 4'b0011; // OR
                    3'b111: ALU_control = 4'b0010; // AND
                    default: ALU_control = 4'b0000;
                endcase
            end
            
            2'b11: ALU_control = 4'b1111; // LUI için (Opsiyonel, ALU tasarımına bağlı)
            default: ALU_control = 4'b0000;
        endcase
    end

endmodule