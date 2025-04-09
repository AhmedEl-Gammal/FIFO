module FIFO_Syn_addbit_Methods #  (parameter Depth = 4 , Width= 16  ) (
    input clk,rst , 
    input w_en,r_en,
    input  [Width-1 : 0 ] in_data , 
    output reg [Width-1 : 0 ] out_data ,
    output full,empty 
) ; 

parameter width_ptr = $clog2(Depth) ; 
// --- internal_reg --- // 
reg [$clog2 (Depth) : 0  ] w_ptr, r_ptr;

// --- Memory --- // 
reg [Width-1 : 0 ] mem [0 : Depth-1 ] ;

// --- Write_process --- // 
always@ (posedge clk )
begin
    if (w_en & !full) 
        begin 
        mem[w_ptr[width_ptr-1:0]] <= in_data ;
        w_ptr <= w_ptr +1 ; 
        end 
end     
// --- read_process --- // 
always@ (posedge clk or negedge rst )
begin
    if (!rst)
    begin 
        w_ptr <= 0 ; 
        r_ptr <= 0 ; 
        out_data <= 0 ;
    end 
    else if (r_en & !empty) 
        begin 
        out_data <= mem[r_ptr[width_ptr-1:0]]  ;
        r_ptr <= r_ptr +1 ; 
        end 
end     

// --- wrap_around --- // 
assign wrap_around =  w_ptr[width_ptr] ^ r_ptr[width_ptr] ; 

// --- Full_cindition --- // 
assign full = wrap_around &  ( w_ptr[width_ptr-1 : 0] ==  r_ptr[width_ptr-1:0] ) ;


// --- empty_cindition --- // 
assign empty = !wrap_around &  (w_ptr[width_ptr-1 : 0] ==  r_ptr[width_ptr-1:0] ) ;

endmodule 