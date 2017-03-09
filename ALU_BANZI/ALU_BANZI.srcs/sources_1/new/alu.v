`timescale 1ns / 1ps

module ALU(
input [3:0] a,
input enter,
output reg [7:0][7:0] seg
);

reg [1:0] state;
reg [3:0] A;
reg [3:0] B;
reg [2:0] Operator;
reg [7:0] out;

integer i;

initial
begin
// ��������A״̬
state[1:0] = 2'b_00;
end

always @ (*)
begin
if (state[1:0] == 2'b_00 && enter == 1)
begin
    // ����A
    A[3:0] = a[3:0];
    // ��ʾA
    for (i=3;i>=0;i=i-1)
        displayNumber(A[i],seg[i][7:0]);
    // ��������B״̬
    state[1:0] = 2'b_01;
end
else if (state[1:0] == 2'b_01 && enter == 1)
begin
    // ����B
    B[3:0] = a[3:0];
    // ��ʾB
    for (i=3;i>=0;i=i-1)
        displayNumber(B[i],seg[i][7:0]);
    // �������������״̬
    state[1:0] = 2'b_10;
end
else if (state[1:0] == 2'b_10 && enter == 1)
begin
    // ���������
    Operator[2:0] = a[2:0];
    // �������״̬
    state[1:0] = 2'b_11;

    // ����
    case(Operator[2:0])
        3'b000: out[7:0] = {4'b0000,A[3:0]};
        3'b001: out[7:0] = {4'b0000,A[3:0]} + {4'b0000,B[3:0]};
        3'b010: out[7:0] = {4'b0000,A[3:0]} - {4'b0000,B[3:0]};
        3'b011: out[7:0] = {4'b0000,A[3:0]} / {4'b0000,B[3:0]};
        3'b100: out[7:0] = {4'b0000,A[3:0]} % {4'b0000,B[3:0]};
        3'b101: out[7:0] = {4'b0000,A[3:0]} * {4'b0000,B[3:0]};
        3'b110: out[7:0] = {3'b000,A[3:0],1'b0};
        3'b111: out[7:0] = {5'b00000,A[2:0]};
    endcase
    
    // ��������
    for (i=7;i>=0;i=i-1)
        displayNumber(out[i],seg[i][7:0]);
end
else if (state[1:0] == 2'b_11 && enter == 1)
begin
    // ִ��AC����
    A[3:0] = 4'b0000;
    B[3:0] = 4'b0000;
    Operator[2:0] = 3'bzzz;
    state[1:0] = 2'b_00;
end
end

task displayNumber;
    input reg number;
    output reg [7:0] seg;
    case (number)
        0:seg[7:0] = 8'b0000_0110;
        1:seg[7:0] = 8'b0000_0000;
    endcase
endtask
endmodule