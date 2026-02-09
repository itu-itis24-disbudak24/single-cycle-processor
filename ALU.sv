module ALU(
    
    input logic [31:0]in_1,
    input logic [31:0]in_2, //anlik deger olabilir 
    input logic [3:0]op,


    output logic [31:0]out,
    output logic zero
);

typedef enum logic[3:0] { 
    
    
    ADD = 4'b00000,
    SUB,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    SRA,
    OR,
    AND


 } alu_op;

    always_comb begin

        case(op) 

            //Aritmetik ve mantik islemleri
            ADD: out = in_1 + in_2;
            SUB: out = in_1 - in_2;
            SLL: out = in_1 << in_2[4:0];
            SLT: out = {31'b0 , $signed(in_1) < $signed(in_2)};
            SLTU:out = {31'b0 , in_1 < in_2} ;
            XOR: out = in_1 ^ in_2;
            SRL: out = in_1 >> in_2[4:0];
            SRA: out = $signed(in_1) >>> in_2[4:0];
            OR:  out = in_1 | in_2;
            AND: out = in_1 & in_2 ; 
            default : out = 32'b0 ;

       
        
            
        endcase

        zero = out == 0 ;
        
    end


endmodule