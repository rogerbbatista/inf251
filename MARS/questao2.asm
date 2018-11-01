lw $t1, 0 ($gp) # Ler A para t1 = mem(gp+0)
lw $t2, 4 ($gp) # Ler B para t3 = mem(gp+4).
lw $t3, 8 ($gp) # Ler C para t3 = mem(gp+8).
slt  $t4,$t1,$t2 #  t4 = 1 if  t1 < t2 = A  <  B; else 0
beq $t4,$t0, MaiorA #  If t4 = t0 = 0, Pula MaiorA
# troca A e B
addi $t4, $t1, 0
addi $t1, $t2, 0
addi $t2, $t4, 0
MaiorA: slt  $t4,$t2,$t3 #  t4 = 1 if  t1 < t2 = A  <  B; else 0
beq $t4,$t0, MaiorB #  If t4 = t0 = 0, Pula MaiorB
# troca B e C
addi $t4, $t2, 0
addi $t2, $t3, 0
addi $t3, $t4, 0
MaiorB: slt  $t4,$t1,$t2 #  t4 = 1 if  t1 < t2 = A  <  B; else 0
beq $t4,$t0, FIM #  If t4 = t0 = 0, Pula FIM
# troca A e B
addi $t4, $t1, 0
addi $t1, $t2, 0
addi $t2, $t4, 0
FIM: nop