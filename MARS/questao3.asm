lw $t1, 0 ($gp) # Ler A para t1 = mem(gp+0)
lw $t2, 4 ($gp) # Ler B para t3 = mem(gp+4).
lw $t3, 8 ($gp) # Ler C para t3 = mem(gp+8).
slt  $t4,$t1,$t0 #  t4 = 1 if  t1 < t2 = A  <  B; else 0
beq $t4,$t0, Positivo #  If t4 = t0 = 0, Pula MaiorA
LOOP1: beq $t1, $t0, FIM # verifica se A == 0
sub $t3, $t3, $t2 # subtrai B de C
addi $t1, $t1, 1 # incrementa o valor de A
jal LOOP1
Positivo:
LOOP2: beq $t1, $t0, FIM # verifica se A == 0
add $t3, $t3, $t2 # acrescenta B em C
subi $t1, $t1, 1 # subtrai o valor de A
jal LOOP2
FIM: nop