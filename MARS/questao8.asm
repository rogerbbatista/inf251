li $t0, 0 # inicializa a variável de parada com 0
lw $t1, 200 ($gp) # suponha o começo do vetor A em mem(gp+200) e seu fim quando uma posição for 0
lw $t2, 400 ($gp) # suponha o começo do vetor B em mem(gp+400) e seu fim quando uma posição for 0
# suponha o começo do vetor C em mem(gp+600)

li $t4, 0 # inicializa a variável auxiliar de "pular" posições com 0
loop:
beq $t1, $t0, FIM # quando o valor t1 == t0 ou seja t1 == 0 paramos a execução, pois chegamos ao fim do vetor A
beq $t2, $t0, FIM # quando o valor t2 == t0 ou seja t2 == 0 paramos a execução, pois chegamos ao fim do vetor B
sub $t3, $t1, $t2 # acrescenta o valor de t1 - t2 à variável auxiliar t3
sw $t3, 600($t3)
addi $t4, $t4, 4 # aumentamos t4 em 4
lw $t1, 200($t4) # t2 = 200 + t3, logo pegamos o próximo valor que está na posição anterior + 4
lw $t2, 400($t4) # t2 = 200 + t3, logo pegamos o próximo valor que está na posição anterior + 4
jal loop
FIM: nop