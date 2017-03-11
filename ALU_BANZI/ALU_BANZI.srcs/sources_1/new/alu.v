`timescale 1ns / 1ps

module ALU(
    input [3:0] a,
    input enter,
    output reg [7:0] dig,
    output reg [7:0] seg0,
    output reg [7:0] seg1
    );

    reg [1:0] state;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] Operator;
    reg [7:0] out;
    reg [2:0] flag;
    reg sel;
    reg clk;
    integer i;

    initial
    begin
    // 进入输入A状态
    state[1:0] = 2'b_00;
    flag[2:0] = 3'b000;
    clk = 0;
    sel = 0;
    i=0;
    end

    always
    begin
        #1 clk = ~clk;
        #5 flag[2:0] = flag[2:0] + 3'b001;
        #5 i = i==7?0:i+1;
        #20 sel = ~sel;
    end

    always @ (posedge enter)
        state[1:0] = state[1:0] + 2'b_01;

    always @(posedge enter)
    begin
    if (state[1:0] == 2'b_00)
        begin
            // 输入A
            A[7:0] = {4'b0000,a[3:0]};
            // 显示A    
            out[7:0] = A[7:0];
        end
        else if (state[1:0] == 2'b_01)
        begin
            // 输入B
            B[7:0] = {4'b0000,a[3:0]};
            // 显示B
            out[7:0] = B[7:0];
        end
        else if (state[1:0] == 2'b_10)
        begin
            // 输入运算符
            Operator[2:0] = a[2:0];
        end
        // 计算
        if (state[1:0] == 2'b_11)
            case(Operator[2:0])
                3'b000: out[7:0] = A[7:0];
                3'b001: out[7:0] = A[7:0] + B[7:0];
                3'b010: out[7:0] = A[7:0] - B[7:0];
                3'b011: out[7:0] = A[7:0] / B[7:0];
                3'b100: out[7:0] = A[7:0] % B[7:0];
                3'b101: out[7:0] = A[7:0] * B[7:0];
                3'b110: out[7:0] = {A[6:0],1'b0};
                3'b111: out[7:0] = {1'b0,A[7:1]};
            endcase
    end

    always @(posedge clk)
    begin
        // 刷新数码管
        if (out[i] == 1)
            if (sel == 0) 
                seg0[7:0] = 8'b0000_0110;
            else 
                seg1[7:0] = 8'b0000_0110;
        else
            if (sel == 0) 
                seg0[7:0] = 8'b0000_0000;
            else 
                seg1[7:0] = 8'b0000_0000;
        case (flag[2:0])
            3'b000: dig[7:0] = 8'b1111_1110;
            3'b001: dig[7:0] = 8'b1111_1101;
            3'b010: dig[7:0] = 8'b1111_1011;
            3'b011: dig[7:0] = 8'b1111_0111;
            3'b100: dig[7:0] = 8'b1110_1111;
            3'b101: dig[7:0] = 8'b1101_1111;
            3'b110: dig[7:0] = 8'b1011_1111;
            3'b111: dig[7:0] = 8'b0111_1111;
        endcase
    end
endmodule
