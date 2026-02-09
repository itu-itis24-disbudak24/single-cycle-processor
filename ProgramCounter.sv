module PC(

    input logic clk,
    input logic rst,
    input logic [31:0]next_out, //PC'nin alacagi yeni deger , disarida ya 4 ile toplanir ya da dallanma varsa anlikla .

    output logic [31:0]out


);

always_ff@(posedge clk or negedge rst)begin

    if(!rst)begin
        out <= 0 ;

    end

    else begin
        
        out <= next_out ;

    end


end




endmodule