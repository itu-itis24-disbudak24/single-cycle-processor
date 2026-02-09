module top(

    input logic clk,
    input logic rst


);



//kablolar ALU
 logic [31:0]alu_in_1;
 logic [31:0]alu_in_2; //anlik deger olabilir
 logic [3:0]alu_op;
 logic [31:0]alu_out; //output
 logic alu_zero_flag; //output

 //kablolar ImmediateGenerator

 logic [31:0]instr;
 logic [6:0]opcode;
 logic [31:0]imm; //output

//kablolar ProgramCounter
  logic pc_clk;
  logic pc_rst;
  logic [31:0]next_out; //PC'nin alacagi yeni deger , disarida ya 4 ile toplanir ya da dallanma varsa anlikla .

  logic [31:0]pc_out; //output

//kablolar RegisterFile
  logic rf_clk;
  logic rf_rst;

  logic rf_write; //yazma denetimi
  logic [4:0]rs_1;
  logic [4:0]rs_2;
  logic [4:0]dst_r; //hedef yazmac
  logic [31:0]data; // "yaz" denetimi ile yazilacak veri

  logic [31:0]out_r1; //output
  logic [31:0]out_r2; //output

//kablolar InstructionMemory
 logic [31:0]out_inst ; // output
 logic [9:0]address_inst;


//kablolar DataMemory
 logic dm_write; // Yazma denetimi
 logic dm_clk;
 logic dm_rst;
 logic [31:0]in_data; // Yazilacak veri
 logic [31:0]address_data; // okunacak verinin adresi (ilk iki bite bakilmaz)
 logic [2:0]funct3; // komutun icindeki funct alani

 logic [31:0]dm_out; //output

 //kablolar ControlUnit


     
     logic [6:0]funct7;

     logic reg_write; //output
     logic mem_write; // output
     logic ALU_src;  // output
     logic [1:0]reg_src; // output
     logic [3:0]ALU_control; //  output
     logic branch; //output 
     logic jump; //output

//Instructioni parcalama
assign opcode   = instr[6:0];
assign dst_r  = instr[11:7];
assign funct3   = instr[14:12];
assign rs_1 = instr[19:15];
assign rs_2 = instr[24:20];
assign funct7   = instr[31:25];



always_comb begin

    //ALU giren MUX
    alu_in_2 = ALU_src == 0 ? out_r2 : imm;
    
    //Register giris verisi MUX
    data  = 32'b00 ;
    if(reg_src == 2'b00)begin
        data = alu_out;

    end
    else begin
        if(reg_src == 2'b01)begin
            data = dm_out;

        end
        else begin
            if(reg_src == 2'b10)begin

                data = pc_out + 32'd4;

            end

        end

    end

    //PC'nin sonraki degeri icin MUX
    next_out = (branch&&alu_zero_flag)||(jump&&opcode==7'b1101111) ? (pc_out+imm) : (pc_out + 4) ;
    if(jump&&opcode==7'b1100111)begin
        next_out = alu_out;

    end



end


ALU alu(.in_1(out_r1) , .in_2(alu_in_2) , .op(ALU_control) , .out(alu_out) , .zero(alu_zero_flag));

ImmediateGenerator Imm_Gen(.instr(instr) , .op(opcode) , .imm(imm));

ProgramCounter PC(.clk(clk) , .rst(rst) , .next_out(next_out) , .out(pc_out));

RegisterFile Reg_File(.clk(clk) , .rst(rst) , .write(reg_write) , .rs_1(rs_1) , .rs_2(rs_2) , .dst_r(dst_r) , .data(data) , .out_r1(out_r1) , .out_r2(out_r2));

InstructionMemory Inst_Mem(.out_inst(instr) , .address(pc_out[11:2]));

ControlUnit Control_Unit(.opcode(opcode) , .funct3(funct3) , .funct7(funct7) , .reg_write(reg_write) , .mem_write(mem_write) , .ALU_src(ALU_src) , .reg_src(reg_src) , .ALU_control(ALU_control) , .branch(branch) , .jump(jump) );

DataMemory Data_Mem(.write(mem_write) , .clk(clk) , .rst(rst) , .in_data(out_r2) , .addr(alu_out) , .funct3(funct3) , .out(dm_out));

endmodule