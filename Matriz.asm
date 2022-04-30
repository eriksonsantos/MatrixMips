.data 
	N: 2
	matriz1: .word 1,2,3,4	#Matriz1[N][N]
	matriz2: .word 11 12 13 14	#Matriz2[N][N]
	matrizResult: .space 16	#N² *4
	
	
	
	
.text 
	
	#jal transposta		#Salta pro endereço da função transposta		
	#jal soma 		#Salta pro endereço da função soma
	jal multiplicacao		#Salta pro endereço da função multiplicacao
	
	j end			#Termina o programa

	



soma:
	
	addi $t2,$0,0		#i
	addi $t3,$0,0		#j
	
	for:
	
		for2:
			lw $t1, N		#Carrega a dimensão da matriz
			mul $t0,$t1,4	#4*SIZE
			addi $t1,$0,4
			#Matriz[i][j] = t0*i + t1*j
			
			
			mul $t4,$t0,$t2		#t4 = SIZE² *i
			mul $t5,$t1,$t3		#t5 = SIZE *j
			add $t6,$t4,$t5		#t6 = t4+t5
			
			la $t0,matriz1		#Carrega o endereço base da primeira matriz
		
			add $t7,$t0,$t6		#t7 =  endereço base da matriz1 mais o deslocamento t6
			lw $s0,0($t7)		#Carrega o valor da matriz dessa posição em s0
			
			la $t0,matriz2		#Carrega o endereço base da segunda matriz
			
			add $t7,$t0,$t6		#t7 =  endereço base da matriz2 mais o deslocamento t6
			lw $s1,0($t7)		#Carrega o valor da matriz2 dessa posição em s1
			
			add $s2,$s0,$s1		#Soma o valor das duas matrizes
			
			la $t0,matrizResult	#Carrega o endereço base da matrizResultado
			
			add $t7,$t0,$t6		#t7 =  endereço base da matrizResult mais o deslocamento t6
			sw  $s2,0($t7)		#Escreve o valor da soma na posição t7
			
		
			add $t3,$t3,1		#j = j+1
			lw $t1, N		#Carrega a dimensão da matriz
			
			bne $t3,$t1,for2		#if j!=SIZE retorna para o for2
		
		addi $t3,$0,0	#j = 0
		add $t2,$t2,1	#i = i+1
		
		
		
		bne $t2,$t1,for	#if i!=SIZE retorna para o for
	
	jr $ra		#Retorna pra função principal

transposta:

	addi $t2,$0,0		#i
	addi $t3,$0,0		#j
	
	forB:
	
		for2B:
			lw $t1, N		#Carrega a dimensão da matriz
			
			mul $t0,$t1,4	#4*SIZE
			addi $t1,$0,4
			#Matriz[i][j] = t0*i + t1*j
			
		
			mul $t4,$t0,$t2		#t4 = 16*i
			mul $t5,$t1,$t3		#t5 = 4*j
			add $s0,$t4,$t5		#s0 = t4+t5	[i][j]
			
			mul $t4,$t0,$t3		#t4 = 16*j
			mul $t5,$t1,$t2		#t5 = 4*i
			add $s1,$t4,$t5		#s1 = t4+t5	[j][i]
			
			la $t0,matriz1		#Carrega o endereço base da primeira matriz
			
			add $t7,$t0,$s1		#t7 =  endereço base da matriz1 mais o deslocamento t7-> & matriz1[j][i]
			lw $s2,0($t7)		#Carrega o valor da matriz1 dessa posição em s2
			
			la $t0,matrizResult	#Carrega o endereço base da matrizResultado
			
			add $t8,$t0,$s0		#t8 = endereço base da matrizResult mais o deslocamento t8-> &matrizResult[i][j]
							
			sw  $s2,0($t8)		#matrizResult[i][j] = matriz[j][i]
			
		
			add $t3,$t3,1		#j = j+1
			lw $t1, N		#Carrega a dimensão da matriz
			
			bne $t3,$t1,for2B		#if j!=SIZE retorna para o for2
		
		addi $t3,$0,0	#j = 0
		add $t2,$t2,1	#i = i+1
		bne $t2,$t1,forB	#if i!=SIZE retorna para o for
	
	jr $ra		#Retorna pra função principal




multiplicacao:
	
	addi $t2,$0,0		#i
	addi $t3,$0,0		#j
	addi $t8,$0,0		#inner
	
	forA:	#for(i=0;i<N;i++)
	
		for2A:	#for(j=0;j<N;j++)
					
				for3A:	#for(inner=0;inner<N;inner++)
					lw $t1, N		#Carrega a dimensão da matriz
					
					mul $t0,$t1,4	#4*SIZE
					addi $t1,$0,4
					#Matriz[i][j] = t0*i + t1*j
					
					
					mul $t4,$t0,$t2		#t4 = 16*i
					mul $t5,$t1,$t3		#t5 = 4*j
					add $s0,$t4,$t5		#s0 = t4+t5	[i][j]
					
					mul $t4,$t0,$t2		#t4 = 16*i
					mul $t5,$t1,$t8		#t5 = 4*inner
					add $s1,$t4,$t5		#s5 = t4 + t5 [i][inner]
					
					mul $t4,$t0,$t8		#t4 = 16*inner
					mul $t5,$t1,$t3		#t5 = 4*j
					add $s2,$t4,$t5		#s5 = t4 + t5 [inner][j]
					
					la $t0,matriz1		#Carrega o endereço base da primeira matriz
					
					add $t4,$t0,$s1		#t4=endereço base da matriz1 mais o deslocamento s1 -> &matriz1[i][inner]
					lw $t5,0($t4)		#t5 == matriz1[i][inner]
					
					la $t0,matriz2		#Carrega o endereço base da segunda matriz
					
					add $t4,$t0,$s2		#t4=endereço base da matriz2 mais o deslocamento s6 -> &matriz2[inner][j]	
					lw $t6,0($t4)		#t6 == matriz2[inner][j]
					
					la $t0,matrizResult	#Carrega o endereço base da matrizResultado
					
					add $t4,$t0,$s0		#t4=endereço base da matrizResult mais o deslocamento s0 -> &matrizResult[j][j]
					lw $t7,0($t4)		#t7 == matrizResult[i][j]
					
					mul $t5,$t5,$t6		#t5 = matriz1[i][inner]*matriz2[inner][j]
					add $t5,$t5,$t7		#t5 = t5 + matrizResult[i][j]
					
					sw $t5,0($t4)		#Escreve o valor na posicao t4 ->matrizResult[i][j] = t5
				
				
				
					add $t8,$t8,1		#inner = inner +1
					lw $t1, N		#Carrega a dimensão da matriz
					
					bne $t8,$t1,for3A		#if inner!= 4 retorna para for3
				
			
			addi $t8,$0,0		#inner = 0
			add $t3,$t3,1		#j = j+1
			bne $t3,$t1,for2A		#if j!=4 retorna para o for2
		
		addi $t3,$0,0	#j = 0
		add $t2,$t2,1	#i = i+1
		bne $t2,$t1,forA	#if i!=4 retorna para o for
	
	jr $ra		#Retorna pra função principal




end:
	
