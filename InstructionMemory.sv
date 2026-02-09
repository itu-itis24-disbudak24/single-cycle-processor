module InstructionMemory(

    output logic [31:0]out_inst , 
    input  logic [9:0]address  // PC degerinin 3. bitinden 12.bitine kadar bakilir 


);

logic [31:0]instructions[0:1023] ; 


assign  out_inst = instructions[address];


endmodule