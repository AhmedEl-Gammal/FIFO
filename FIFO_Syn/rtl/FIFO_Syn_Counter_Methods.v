module FIFO_Syn_Counter_Methods # (parameter Depth= 8 ,Width= 16) (
    input clk , rst ,
    input w_en , r_en ,
    input  [Width-1 : 0] in_data ,
    output reg  [Width-1 : 0] out_data , 
    output full ,empty  
) ; 

// --- internal_Reg  --- // 
reg [$clog2(Depth)-1:0] w_ptr, r_ptr;

reg [$clog2(Depth):0] counter;

// --- memory --- //
reg [Width-1 : 0 ] mem [ 0 : Depth-1 ]  ;  
//reg [Width-1 : 0 ] mem [Depth] ;

// --- write_process --- //
always @ (posedge clk )
begin
    if ( w_en && !full )
    begin 
        mem [w_ptr] <= in_data ; 
        w_ptr <= w_ptr + 1 ;      
    end
end     
// --- read_process --- //
always @ (posedge clk )
begin
    if ( r_en && !empty )
    begin 
        out_data <=  mem[r_ptr] ;    
        r_ptr <= r_ptr + 1 ;      
    end
end     

// --- counter_operation  --- // 
always @(posedge clk or negedge rst )
begin 
    if (!rst) begin 
        r_ptr <= 0 ;
        w_ptr <= 0 ;
        out_data <= 0 ; 
        counter <= 0 ;
    end 
    else begin 
        case({w_en,r_en})
        2'b10 : if (counter < 8 )counter <= counter + 1'b1 ; 
        2'b01 : if (counter > 0 ) counter <= counter - 1'b1 ;
        default : counter <= counter ;   
        endcase 
    end    
end    

// --- full_condition --- // 
assign full = (counter == Depth) ? 1'b1 : 1'b0; 
// --- empty_condition --- // 
assign empty = (counter ==  0 ) ? 1'b1 : 1'b0; 
endmodule 