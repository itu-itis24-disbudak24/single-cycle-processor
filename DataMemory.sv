module DataMemory(

    input logic write, // Yazma denetimi
    input logic clk,
    input logic rst,
    input logic [31:0]in_data, // Yazilacak veri
    input logic [31:0]addr, // okunacak verinin adresi (ilk iki bite bakilmaz)
    input logic [2:0]funct3, // komutun icindeki funct alani

    output logic [31:0]out



);

logic [31:0]data[0:1023];
logic [31:0]full_word;

typedef enum logic[2:0] {
    
    //store islemleri
    SB = 3'b000,
    SH = 3'b001,
    SW = 3'b010,

    //load islemleri

    LW = 3'b010 , 
    LB = 3'b000 ,
    LH =  3'b001 , 
    LHU = 3'b101 ,
    LBU = 3'b100

  } op_type;

logic [9:0]word_addr;
assign word_addr = addr[11:2];



always_ff@(posedge clk or negedge rst)begin

    if(!rst)begin
        
        for(int i = 0 ; i<1024 ; i++)begin
        
            data[i] <= 32'b0 ; 
        end

    end
    else begin
        
        if(write)begin
            
             case (funct3)
                SB: // sb (Store Byte)
                    case (addr[1:0])
                        2'b00: data[word_addr][7:0]   <= in_data[7:0];
                        2'b01: data[word_addr][15:8]  <= in_data[7:0];
                        2'b10: data[word_addr][23:16] <= in_data[7:0];
                        2'b11: data[word_addr][31:24] <= in_data[7:0];
                    endcase
                SH: // sh (Store Half)
                    if (addr[1]) data[word_addr][31:16] <= in_data[15:0];
                    else         data[word_addr][15:0]  <= in_data[15:0];
                SW: // sw (Store Word)
                    data[word_addr] <= in_data;
                default: data[word_addr] <= in_data;
             
             endcase
        end

    end


end

always_comb begin

   full_word = data[addr[11:2]];

   case (funct3)
          
            LB: // lb (Load Byte - İşaretli)
                case (addr[1:0])
                    2'b00: out = {{24{full_word[7]}},  full_word[7:0]};
                    2'b01: out = {{24{full_word[15]}}, full_word[15:8]};
                    2'b10: out = {{24{full_word[23]}}, full_word[23:16]};
                    2'b11: out = {{24{full_word[31]}}, full_word[31:24]};
                endcase
                
            LBU: // lbu (Load Byte Unsigned - Sıfır Uzatmalı)
                case (addr[1:0])
                    2'b00: out = {24'b0, full_word[7:0]};
                    2'b01: out = {24'b0, full_word[15:8]};
                    2'b10: out = {24'b0, full_word[23:16]};
                    2'b11: out = {24'b0, full_word[31:24]};
                endcase

            LH: // lh (Load Half - İşaretli)
                // Half-word genellikle 2 bayt hizalı (aligned) olur (0 veya 2)
                out = (addr[1]) ? {{16{full_word[31]}}, full_word[31:16]} 
                                : {{16{full_word[15]}}, full_word[15:0]};

            LHU: // lhu (Load Half Unsigned)
                out = (addr[1]) ? {16'b0, full_word[31:16]} 
                                : {16'b0, full_word[15:0]};

            LW: // lw (Load Word - 32 Bit)
                out = full_word;

            default: out = full_word;
   
        endcase
    

end



endmodule