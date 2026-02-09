module ALU(
    
    input logic [31:0]in_1,
    input logic [31:0]in_2, //anlik deger olabilir 
    input logic [3:0]op,


    output logic [31:0]out,
    output logic zero
);
typedef enum logic [3:0] { 
    
    // --- Control Unit'te Kullandığımız Temel İşlemler ---
    ADD  = 4'b0000, // lw, sw, add, addi, jalr (Toplama)
    SUB  = 4'b1000, // beq, bne, sub (Çıkarma)
    AND  = 4'b0010, // and, andi
    OR   = 4'b0011, // or, ori
    SLT  = 4'b0101, // slt, slti (Küçükse 1 yap)
    
    // --- LUI İçin Özel Tanımladığımız Kod ---
    LUI_OP = 4'b1111, // Giriş 2'yi (Imm) direkt geçir

    // --- Henüz Control Unit'e Eklemediğin (Gelecek İçin) ---
    // Bunlara şimdilik çakışmayan rastgele mantıklı değerler verdim:
    XOR  = 4'b0100, 
    SLL  = 4'b0001, // Shift Left Logical
    SRL  = 4'b0110, // Shift Right Logical
    SRA  = 4'b1101, // Shift Right Arithmetic
    SLTU = 4'b0111  // Set Less Than Unsigned

 } alu_op_type;

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
            LUI_OP: out = in2 ; //immediategenerator da 12 defa kaydirildi zate
            default : out = 32'b0 ;

       
        
            
        endcase

        zero = out == 0 ;
        
    end


endmodule