module FIFO_Syn_Counter_Methods_TB () ;
// --- local_parameter --- // 
localparam D = 8  ;
localparam W = 16 ;  
// --- inputs --- // 
 reg clk , rst ; 
 reg w_en , r_en ;
 reg [W-1 : 0] in_data ;  
// --- outputs --- // 
wire [W-1 : 0] out_data ;
wire full ,empty ;

// --- instantiate --- // 
FIFO_Syn_Counter_Methods  #(.Depth(D) ,.Width(W)) DUT (
.clk(clk) ,
.rst(rst) , 
.w_en(w_en),
.r_en(r_en),
.in_data(in_data), 
.out_data(out_data), 
.full(full) ,
.empty(empty)  
) ;
// --- clock_generator --- // 
always #1 clk = ~clk ; 

// --- stimulus --- //
initial 
    begin 
    rst= 0 ; clk = 0 ; w_en = 0 ;  r_en = 0 ;
    
    # 4 rst = 1 ; 
    //drive(20);
    //drive(10);
    #2   w_en = 1 ;   in_data = 1 ;
    #2   w_en = 1 ;   in_data = 2 ;
    #2   w_en = 1 ;   in_data = 3 ;
    #2   w_en = 1 ;   in_data = 4 ;
    #2   w_en = 1 ;   in_data = 5 ;
    #2   w_en = 1 ;   in_data = 6 ;
    #2   w_en = 1 ;   in_data = 7 ;
    #2   w_en = 1 ;   in_data = 8 ;
    #2   w_en = 1 ;   in_data = 9 ;
    #2   w_en = 1 ;   in_data = 10 ;
    #2   w_en = 1 ;   in_data = 11 ;
    #2    w_en = 0 ;   
    #20   r_en = 1 ;   

    end
// --- task & functions --- //  
integer i = 0 ;
 
// - push_task - // 
task push () ;
begin 
    w_en = 1 ;
    in_data = i*i ; 
    i = i +1 ; 
end 
endtask 

// -pop_task - // 
task pop() ;
    r_en = 1 ; 
endtask  

// -delay_task - //
task drive (input delay ) ;
    begin 
    w_en = 0 ; r_en = 0 ;
    fork 
        begin 
            repeat(10) begin @(posedge clk) push() ;end 
            w_en = 0 ;    
        end 
        begin 
            #delay;
            repeat(10) begin @(posedge clk) pop() ;end 
            r_en = 0 ;    
        end
    join 
    end
endtask         


endmodule 