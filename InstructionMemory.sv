module InstructionMemory(

    output logic [31:0]out_inst , 
    input  logic [9:0]address  // PC degerinin 3. bitinden 12.bitine kadar bakilir 


);

logic [31:0]instructions[0:1023] ; 

// ... (bellek tanımları) ...

    initial begin
        // Başlangıçta hepsini sıfırla
        for (int i = 0; i < 256; i++) instructions[i] = 32'b0;

        // 1. HAZIRLIK: x1=10, x2=10, x3=99
        instructions[0] = 32'h00a00093; // addi x1, x0, 10
        instructions[1] = 32'h00a00113; // addi x2, x0, 10
        instructions[2] = 32'h06300193; // addi x3, x0, 99

        // 2. STORE TESTİ: x3(99)'ü Adres 0'a yaz
        // sw x3, 0(x0)
        instructions[3] = 32'h00302023; 

        // 3. LOAD TESTİ: Adres 0'ı oku, x4'e yaz (x4=99 olmalı)
        // lw x4, 0(x0)
        instructions[4] = 32'h00002203; 

        // 4. BRANCH TESTİ: x1 == x2 ise zıpla (x5'i atla)
        // beq x1, x2, 8 (offset) -> PC, 2 komut ileri gider
        instructions[5] = 32'h00208463; 

        // --- ATLANACAK KOMUT (Burası çalışmamalı) ---
        instructions[6] = 32'h03700293; // addi x5, x0, 55 

        // --- HEDEF KOMUT (PC Buraya gelmeli) ---
        instructions[7] = 32'h00100313; // addi x6, x0, 1 

        // --- SON (NOP) ---
        instructions[8] = 32'h00000013; 
    end
    
    // ... (assign out_inst = ... kodu buranın altında olacak) ...
assign  out_inst = instructions[address];


endmodule