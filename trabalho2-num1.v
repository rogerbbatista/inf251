//Nome: Róger Vieira Batista
//Matrícula: 92538

//                           +-----+
//                       0,2 |     | 3
//                 +---------+  3  +---------------------+
//                 |         | 111 <---------+           |
//                 |         +---^-+         |           |
//                 |          1| |2          |0,1,2,3    |
//+-----+       +--v--+      +-v---+      +-----+        |
//|     | 0,1   |     | 0,1  |     | 1    |     |        |
//|  0  +------->  1  +------>  2  +------>  4  |        |
//| 000 | 2,3   | 001 | 3    | 010 |      | 100 |        |
//+--^--+       +--+--+      ++-^--+      +-----+        |
//   |             |          | |                        |
//   |             |2      3,0| |                        |
//   +------------------------+ |0,1,2                   |
//                 |         +-----+      +-----+        |
//                 |         |     | 3    |     |        |
//                 +--------->  3  +------>  5  <--------+
//                           | 011 |      | 101 |
//                           +--^--+      +-----+
//                              |            |0,1,
//                           0,1|2,3         |2,3
//                           +-----+         |
//                           |     |         |
//                           |  6  <---------+
//                           | 110 |
//                           +-----+

//TestBench
//Matrícula em Binário: 10110100101111010
//Entradas: 01 01 10 10 01 01 11 10 10 = 1 1 2 2 1 1 3 2 2

//Flip Flop
module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule

//Estados e Case
module stateCase(clk, reset, a, saida);

input clk, reset;
input [1:0] a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd0, um=3'd1, dois=3'd2, tres=3'd3, quatro =3'd4, cinco =3'd5, seis =3'd6, tresB=3'd7;

assign saida = (state == zero)? 3'd0:
               (state == um)? 3'd1:
               (state == dois)? 3'd2:
	           (state == tres)? 3'd3:
	           (state == quatro)? 3'd4:
	           (state == cinco)? 3'd5:
	           (state == seis)? 3'd6:3'd3;

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
              case (state)
                    zero: state = um;
                    um: if (a == 2'd2) state = tres;
                        else state = dois;
                    dois: if (a == 2'd1) state = quatro;
                          else if (a == 2'd2) state = tresB;
                          else state = zero;
                    tres: if ( a == 2'd3 ) state = cinco;
						  else state = dois;
                    quatro: state = tresB;
                    cinco: state = seis;
                    seis: state = tres;
                    tresB: if (a == 2'd3) state = cinco;
                           else if (a == 2'd1) state = dois;
                           else state = um;
              endcase
     end
endmodule


//Portas Lógicas
module statePorta(input clk, input res, input [1:0] a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;

assign s[0] = e[0];
assign s[1] = e[1];
assign s[2] = e[2]&~e[1] | e[2]&~e[0];
//Usei dois aplicativos de mapa de Karnaugh e nenhum deles deu certo:

//Primeiro:
//assign p[0] = ~e[1]&~e[0] | e[2]&~e[0] | ~e[0]&a[1]&~a[0] | e[2]&e[1]&~a[0] | ~e[2]&~e[1]&a[1]&~a[0] | e[1]&e[0]&a[1]&a[0];
//assign p[1] = ~e[1]&e[0] | e[2]&~e[0] | ~e[2]&e[0]&~a[1] | e[0]&~a[1]&a[0] | ~e[2]&e[1]&a[1]&~a[0];
//assign p[2] = e[2]&~e[1] | e[1]&e[0]&a[1]&a[0] | ~e[2]&e[1]&~e[0]&~a[1]&a[0] | ~e[2]&e[1]&~e[0]&a[1]&~a[0];

//Segundo:
//assign p[0] = ~e[2]&e[0]&~a[1]&~a[0] | e[2]&e[1]&e[0]&a[1] | ~e[1]&e[0]&~a[1] | e[2]&~a[1]&a[0] | ~e[2]&~e[1] | ~e[1]&a[0];
//assign p[1] = e[2]&~e[1]&e[0]&a[1] | e[1]&~a[1]&~a[0] | e[1]&~e[0]&a[1] | ~e[1]&a[0] | ~e[2]&e[1];
//assign p[2] = e[2]&e[1]&e[0]&a[1]&~a[0] | e[2]&~e[1]&~e[0]&a[1]&~a[0] | e[2]&~e[1]&e[0]&~a[1]&~a[0]& | ~e[2]&a[0];

ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 


//Memória
module stateMem(input clk,input res, input [1:0] a, output [2:0] saida);
reg [5:0] StateMachine [0:31]; // 16 linhas (2^entradas = 2^5 = 2^(3 de estado + 5 de entrada)) 
							   // e 6 bits de largura (dout)

initial
begin 
//Por algum motivo, quando eu codifico a linha 6 para 011001 = 6'd25, dá o resultado 101001, então deixei binário
StateMachine[0] = 6'd8; StateMachine[1] = 6'd8; StateMachine[2] = 6'd8; StateMachine[3] = 6'd8;
StateMachine[4] = 6'd17; StateMachine[5] = 6'd17; StateMachine[6] = 011001; StateMachine[7] = 6'd17;
StateMachine[8] = 6'd2; StateMachine[9] = 6'd34; StateMachine[10] = 6'd58;  StateMachine[11] = 6'd2;
StateMachine[12] = 6'd42; StateMachine[13] = 6'd42; StateMachine[14] = 6'd53;  StateMachine[15] = 6'd43;
StateMachine[16] = 6'd60; StateMachine[17] = 6'd60; StateMachine[18] = 6'd60; StateMachine[19] = 6'd60;
StateMachine[20] = 6'd53; StateMachine[21] = 6'd53; StateMachine[22] = 6'd53; StateMachine[23] = 6'd53;
StateMachine[24] = 6'd30; StateMachine[25] = 6'd30; StateMachine[26] = 6'd30; StateMachine[27] = 6'd30;
StateMachine[28] = 6'd11; StateMachine[29] = 6'd19; StateMachine[30] = 6'd11; StateMachine[31] = 6'd43;
end
wire [4:0] address;  // 32 linhas = 5 bits de endereco
					 // (3 entradas do estado + 2 do a)
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida

assign address[1:0] = a;

assign dout = StateMachine[address];
assign saida = dout[2:0];

ff st0(dout[3],clk,res,address[2]);
ff st1(dout[4],clk,res,address[3]);
ff st2(dout[5],clk,res,address[4]);
endmodule


module main;
reg c,res;
reg [1:0] a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

stateCase FSM(c,res,a,saida);
statePorta FSM2(c,res,a,saida1);
stateMem FSM1(c,res,a,saida2);


initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b s %d %d %d",c,res,a,saida,saida1,saida2);
      #1 res=0; a=0;
      #1 res=1;
      #1 a=2'd1;
      #2 a=2'd1;
      #2 a=2'd2;
      #2 a=2'd2;
      #2 a=2'd1;
      #2 a=2'd1;
      #2 a=2'd3;
      #2 a=2'd2;
      #2 a=2'd2;
      $finish ;
    end
endmodule
