`timescale 1ns/1ps

module floating_adder (
 input wire [31:0] inp1 , input [31:0] inp2 , output reg[31:0] out
);
 reg signa, signb;
 reg [7:0] exp_a, exp_b ;
 reg [7:0] diff;
 reg [22:0] ruffa, ruffb;
 reg[24:0] ans;
 reg[23:0] mant_a, mant_b;
 reg into;
 always @(inp1 or inp2) begin
 into = 0;
 signa = inp1[31]; signb = inp2[31];
 exp_a = inp1[31:23]; exp_b = inp2[31:23];
 mant_a = {1'b1, inp1[22:0]}; mant_b = {1'b1, inp2[22:0]};
 if(signa == signb) begin // addition
 if(exp_a > exp_b) begin
 diff = exp_a - exp_b;
 ruffb = mant_b >> diff;
 ans = ruffb + mant_a;
 if(ans[24] == 1) begin
 ans = ans >> 1;
 exp_a = exp_a + 1;
 end
 else begin
 ans = ans;
 end
 out = {signa , exp_a , ans[22:0]};
 end
 else begin
 diff = exp_b - exp_a;
 ruffa = mant_a >> diff;
 ans = ruffa + mant_b;
 if(ans[24] == 1) begin
 ans = ans >> 1;
 exp_b = exp_b + 1;
 end
 else begin
 ans = ans;
 end
 out = {signb, exp_b , ans[22:0]};
 end
 end
 else begin // subtraction
 if(inp1[30:0] > inp2[30:0]) begin // a>b
 diff = exp_a - exp_b;
 ruffb = mant_b >> diff;
 mant_a = mant_a - ruffb;
 if(mant_a[23] == 1) begin
 exp_a = exp_a;
 mant_a = mant_a;
 end
 else if(mant_a[22] == 1) begin
 exp_a = exp_a - 1;
 mant_a = mant_a << 1;
 end
 else if(mant_a[21] == 1) begin
 exp_a = exp_a - 2;
 mant_a = mant_a << 2;
 end
 else if(mant_a[20] == 1) begin
 exp_a = exp_a - 3;
 mant_a = mant_a << 3;
 end
 else if(mant_a[19] == 1) begin
 exp_a = exp_a - 4;
 mant_a = mant_a << 4;
 end
 else if(mant_a[18] == 1) begin
 exp_a = exp_a - 5;
 mant_a = mant_a << 5;
 end
 else if(mant_a[17] == 1) begin
 exp_a = exp_a - 6;
 mant_a = mant_a << 6;
 end
 else if(mant_a[16] == 1) begin
 exp_a = exp_a - 7;
 mant_a = mant_a << 7;
 end
 else if(mant_a[15] == 1) begin
 exp_a = exp_a - 8;
 mant_a = mant_a << 8;
 end
 else if(mant_a[14] == 1) begin
 exp_a = exp_a - 9;
 mant_a = mant_a << 9;
 end
 else if(mant_a[13] == 1) begin
 exp_a = exp_a - 10;
 mant_a = mant_a << 10;
 end
 else if(mant_a[12] == 1) begin
 exp_a = exp_a - 11;
 mant_a = mant_a << 11;
 end
 else if(mant_a[11] == 1) begin
 exp_a = exp_a - 12;
 mant_a = mant_a << 12;
 end
 else if(mant_a[10] == 1) begin
 exp_a = exp_a - 13;
 mant_a = mant_a << 13;
 end
 else if(mant_a[9] == 1) begin
 exp_a = exp_a - 14;
 mant_a = mant_a << 14;
 end
 else if(mant_a[8] == 1) begin
 exp_a = exp_a - 15;
 mant_a = mant_a << 15;
 end
 else if(mant_a[7] == 1) begin
 exp_a = exp_a - 16;
 mant_a = mant_a << 16;
 end
 else if(mant_a[6] == 1) begin
 exp_a = exp_a - 17;
 mant_a = mant_a << 17;
 end
 else if(mant_a[5] == 1) begin
 exp_a = exp_a - 18;
 mant_a = mant_a << 18;
 end
 else if(mant_a[4] == 1) begin
 exp_a = exp_a - 19;
 mant_a = mant_a << 19;
 end
 else if(mant_a[3] == 1) begin
 exp_a = exp_a - 20;
 mant_a = mant_a << 20;
 end
 else if(mant_a[2] == 1) begin
 exp_a = exp_a - 21;
 mant_a = mant_a << 21;
 end
 else if(mant_a[1] == 1) begin
 exp_a = exp_a - 22;
 mant_a = mant_a << 22;
 end
 else if(mant_a[0] == 1) begin
 exp_a = exp_a - 23;
 mant_a = mant_a << 23;
 end
 else begin
 exp_a = exp_a;
 mant_a = mant_a;
 end

 out = {signa , exp_a , mant_a[22:0]};
 end
 else begin // b>a
 diff = exp_b - exp_a;
 ruffb = mant_a >> diff;
 mant_a = mant_b - ruffb;
 exp_a = exp_b;
 if(mant_a[23] == 1) begin
 exp_a = exp_a;
 mant_a = mant_a;
 end
 else if(mant_a[22] == 1) begin
 exp_a = exp_a - 1;
 mant_a = mant_a << 1;
 end
 else if(mant_a[21] == 1) begin
 exp_a = exp_a - 2;
 mant_a = mant_a << 2;
 end
 else if(mant_a[20] == 1) begin
 exp_a = exp_a - 3;
 mant_a = mant_a << 3;
 end
 else if(mant_a[19] == 1) begin
 exp_a = exp_a - 4;
 mant_a = mant_a << 4;
 end
 else if(mant_a[18] == 1) begin
 exp_a = exp_a - 5;
 mant_a = mant_a << 5;
 end
 else if(mant_a[17] == 1) begin
 exp_a = exp_a - 6;
 mant_a = mant_a << 6;
 end
 else if(mant_a[16] == 1) begin
 exp_a = exp_a - 7;
 mant_a = mant_a << 7;
 end
 else if(mant_a[15] == 1) begin
 exp_a = exp_a - 8;
 mant_a = mant_a << 8;
 end
 else if(mant_a[14] == 1) begin
 exp_a = exp_a - 9;
 mant_a = mant_a << 9;
 end
 else if(mant_a[13] == 1) begin
 exp_a = exp_a - 10;
 mant_a = mant_a << 10;
 end
 else if(mant_a[12] == 1) begin
 exp_a = exp_a - 11;
 mant_a = mant_a << 11;
 end
 else if(mant_a[11] == 1) begin
 exp_a = exp_a - 12;
 mant_a = mant_a << 12;
 end
 else if(mant_a[10] == 1) begin
 exp_a = exp_a - 13;
 mant_a = mant_a << 13;
 end
 else if(mant_a[9] == 1) begin
 exp_a = exp_a - 14;
 mant_a = mant_a << 14;
 end
 else if(mant_a[8] == 1) begin
 exp_a = exp_a - 15;
 mant_a = mant_a << 15;
 end
 else if(mant_a[7] == 1) begin
 exp_a = exp_a - 16;
 mant_a = mant_a << 16;
 end
 else if(mant_a[6] == 1) begin
 exp_a = exp_a - 17;
 mant_a = mant_a << 17;
 end
 else if(mant_a[5] == 1) begin
 exp_a = exp_a - 18;
 mant_a = mant_a << 18;
 end
 else if(mant_a[4] == 1) begin
 exp_a = exp_a - 19;
 mant_a = mant_a << 19;
 end
 else if(mant_a[3] == 1) begin
 exp_a = exp_a - 20;
 mant_a = mant_a << 20;
 end
 else if(mant_a[2] == 1) begin
 exp_a = exp_a - 21;
 mant_a = mant_a << 21;
 end
 else if(mant_a[1] == 1) begin
 exp_a = exp_a - 22;
 mant_a = mant_a << 22;
 end
 else if(mant_a[0] == 1) begin
 exp_a = exp_a - 23;
 mant_a = mant_a << 23;
 end
 else begin
 exp_a = exp_a;
 mant_a = mant_a;
 end
 out = {signb , exp_a , mant_a[22:0]};
 end
 //Write the code when both are opposite signs
 end
 end
endmodule
