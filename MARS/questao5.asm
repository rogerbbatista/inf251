li $t1, 0 # inicializa a soma (t1) com 0
li $t0, 0 # inicializa a vari�vel de parada com 0
lw $t2, 200 ($gp) # suponha o come�o do vetor em mem(gp+200) e seu fim quando uma posi��o for 0
li $t3, 0 # inicializa a vari�vel auxiliar de "pular" posi��es com 0
loop: beq $t2, $t0, FIM # quando o valor t2 == t0 ou seja t2 == 0 paramos a execu��o, pois chegamos ao fim do vetor
add $t1, $t1, $t2 # acrescenta o valor de t2 � soma t1
addi $t3, $t3, 4 # aumentamos t3 em 4
lw $t2, 200($t3) # t2 = 200 + t3, logo pegamos o pr�ximo valor que est� na posi��o anterior + 4
jal loop
FIM: nop