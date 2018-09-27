//Nome: Róger Vieira Batista
//Matrícula: 92538

//Matrícula em octal: 264572
//Estado    Codificação
//  0           2
//  2           6
//  3           4
//  4           5
//  5           7

//                        Diagrama de Estados
//   +----------------------------------------------------------+
//   |                                                    1     |
//   |                    +----------------------------------+  |0
//   |                    |                                  |  |
//+--v--+             +---v-+           +-----+            +-+--++
//|     | 0,1         |     | 0         |     | 0,1        |     |
//|  2  +------------->  4  +----------->  6  +------------>  5  |
//|     |             |     |           |     |            |     |
//+-----+             +--+--+           +--^--+            +-----+
//                       |                 |
//                       |1                |
//                       |                 |
//                    +--v--+              |
//                    |     | 0,1          |
//                    |  7  +--------------+
//                    |     |
//                    +-----+


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

input clk, reset, a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd2, tres=3'd4, dois=3'd6, quatro=3'd5, cinco =3'd7;

assign saida = (state == zero)? 3'd0:
           (state == dois)? 3'd2:
	   (state == tres)? 3'd3:
	   (state == quatro)? 3'd4:3'd5;

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
              case (state)
                    zero: state = tres;
                    tres: if ( a == 1 ) state = cinco;
						  else state = dois;
                    quatro: if ( a == 1 ) state = tres;
							else state = zero;
                    dois: state = quatro;
                    cinco: state = dois;
              endcase
     end
endmodule


//Portas Lógicas
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;

//Tentativa inicial (porém deu errado e não consegui diagnosticar)
//parameter zero=3'd2, tres=3'd4, dois=3'd6, quatro=3'd5, cinco =3'd7;
//assign s = (e == zero)? 3'd0:
//          (e == dois)? 3'd2:
//	        (e == tres)? 3'd3:
//          (e == quatro)? 3'd4:3'd5;
//assign p[0]  =  e[1]&e[2]&~e[0] | a&~e[0]&~e[1]&e[2]; //9 operadores
//assign p[1]  =  e[0]&e[1] | ~a&~e[1]&e[0] | a&~e[0]&~e[1]&e[2]; //12 operadores
//assign p[2]  =   e[0]&e[1] | e[1]&~e[2] | a&~e[1]&e[0]
//				|e[1]&e[2]&~e[0] | a&~e[0]&~e[1]&e[2]; //18 operadores

assign s = e; 
assign p[0]  =  ~e[1]&~e[2] | a&(e[0]&~e[2] | ~e[0]&e[2]); // 10 operadores
assign p[1]  =  ~a&e[0] | a&e[2] | ~e[1]&~e[2]; // 8 operadores
assign p[2] =   e[1]&~e[0]   | a&e[1]; // 4 operadores
//Total: 22 operadores

ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 


//Memória
module stateMem(input clk,input res, input a, output [2:0] saida);
reg [5:0] StateMachine [0:15]; // 16 linhas (2^entradas = 2⁴ 
							   // e 6 bits de largura (dout)

initial
begin 
StateMachine[0] = 6'd32;

StateMachine[4] = 6'd32;  StateMachine[5] = 6'd32;
StateMachine[8] = 6'd51;  StateMachine[9] = 6'd59;
StateMachine[10] = 6'd20;  StateMachine[11] = 6'd36;
StateMachine[12] = 6'd42;  StateMachine[13] = 6'd42;
StateMachine[14] = 6'd53;  StateMachine[15] = 6'd53;
end
wire [3:0] address;  // 16 linhas = 4 bits de endereco
					 // (3 entradas do estado + a)
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida

assign address[0] = a;
assign dout = StateMachine[address];
assign saida = dout[2:0];

ff st0(dout[3],clk,res,address[1]);
ff st1(dout[4],clk,res,address[2]);
ff st2(dout[5],clk,res,address[3]);
endmodule


module main;
reg c,res,a;
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
      #8 a=1;
      #16 a=0;
      #12 a=1;
      #4;
      $finish ;
    end
endmodule
