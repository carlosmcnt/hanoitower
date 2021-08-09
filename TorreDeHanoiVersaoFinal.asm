%include "io.inc"

section .data
saida db 'Disco %d : torre %d ---> torre %d' ,10,0
discos dd 3

section .text
extern printf

global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx  
    mov edx, [discos]               ;o registrador edx recebe o número de discos que o jogo terá    
    ;Referência para as 3 torres    
    push dword 1                    ;torre de origem +16
    push dword 3                    ;torre de destino +12
    push dword 2                    ;torre de trabalho +8    
    push edx                        ;edx na pilha (número inicial de discos)                
    push ebp                        ;salva o registrador ebp na pilha
    mov ebp, esp                    ;ebp recebe o ponteiro para o topo da pilha (esp)    
    call Parametros_1   
    call FuncaoMoveDisco            ;chamada para executar a FuncaoHanoi    
    call FuncaoImprime              ;chamada para executar a FuncaoImprimir     
    mov ebp,esp                     ;ebp recebe o ponteiro para o topo da pilha (esp)
    pop ebp                         ;remove ebp da pilha
    add esp, byte 16                ;libera mais 16 bits de espaço    
    ret                             ;finaliza o programa       
                                                     
FuncaoMoveDisco:
    push eax                        ;eax com sua torre atual na pilha                       
    push ebx                        ;ebx com sua torre atual na pilha
    push ecx                        ;ecx com sua torre atual na pilha
    push edx                        ;número do disco trabalhado atualmente na pilha
    push ebp                        ;salva o registrador ebp na pilha 
    mov ebp,esp                     ;ebp recebe o ponteiro para o topo da pilha (esp)  
    cmp edx, 1                      ;testa se o número de disco é 1 
    je Desempilha                   ;caso comparação seja positiva: salta para Desempilha    
    call Parametros_2
    call FuncaoMoveDisco
    call FuncaoImprime                 
    call Parametros_1
    call FuncaoImprime                     
    call Parametros_3
    pop ebp
    add esp, byte 16                ;libera mais 16 bits de espaço
    call FuncaoMoveDisco
    ret                             ;retorna para o chamador da sub-rotina
    
Desempilha:
    pop ebp
    add esp, byte 16                ;libera mais 16 bits de espaço    
    ret                             ;retorna para o chamador da sub-rotina

;Parâmetros para a função MoveDisco (disco, origem, destino, trabalho)    
Parametros_1:  
    mov edx, [ebp+4]                ;pega a posição do primeiro elemento da pilha(NumeroDisco) e mov para edx
    mov eax, [ebp+16]               ;torre de origem
    mov ebx, [ebp+12]               ;torre de destino
    mov ecx, [ebp+8]                ;torre de trabalho                    
    ret                             ;retorna para o chamador da sub-rotina

;Parâmetros para a função MoveDisco (disco-1, origem, trabalho, destino)    
;Troca entre trabalho e destino
Parametros_2:
    mov edx, [ebp+4]                ;pega a posição do primeiro elemento da pilha(NumeroDisco) e mov para edx
    dec edx                         ;disco-1
    mov ebx, [ebp+8]                
    mov ecx, [ebp+12]               
    ret

;Parâmetros para a função MoveDisco (disco-1, trabalho, destino, origem)    
;Troca entre trabalho e origem  
Parametros_3:
    mov edx, [ebp+4]                ;pega a posição do primeiro elemento da pilha(NumeroDisco) e mov para edx
    dec edx                         ;disco-1
    mov eax, [ebp+8]                
    mov ecx, [ebp+16]               
    ret
                                                 
FuncaoImprime:
    push ebx                        ;torre de destino
    push eax                        ;torre de origem
    push edx                        ;número do disco
    push saida
    call printf                     ;impressão dos movimentos executados
    add esp, byte 16                   
    ret                             ;retorna para o chamador da sub-rotina