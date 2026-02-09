module RegisterFile(

    input logic clk,
    input logic rst,

    input logic write, //yazma denetimi
    input logic [4:0]rs_1,
    input logic [4:0]rs_2,
    input logic [4:0]dst_r, //hedef yazmac
    input logic [31:0]data, // "yaz" denetimi ile yazilacak veri

    output logic [31:0]out_r1,
    output logic [31:0]out_r2

);




logic [31:0]registers[0:31];
assign registers[0] = 32'b0;

always_comb begin

    out_r1 = registers[rs_1];
    out_r2 = registers[rs_2];



end




always_ff@(posedge clk or negedge rst )begin

    if(!rst)begin

        for(int i = 1 ; i<32 ; i++)begin
            registers[i] <= 32'b0;

        end
       

    end
    
    else begin
   
        if(write && dst_r != 5'b0)begin // ilk registerin(x0) 0 degeri tasidigini  garanti ettim

            registers[dst_r] <= data;

        end
        

    end



end


endmodule