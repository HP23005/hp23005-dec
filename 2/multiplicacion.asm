org 100h                   ; Dirección de inicio para programas .COM en DOS (código comienza en 0x100)

start:
    ; --- Cargar los números de 8 bits ---
    mov al, 5              ; Carga el número 5 en el registro AL
    mov bl, 4              ; Carga el número 4 en el registro BL

    ; --- Multiplicación ---
    mul bl                ; Multiplica AL × BL → resultado de 8×8 bits en AX

    ; --- Convertir el resultado de AX a ASCII decimal ---
    mov bx, 10            ; Divisor para obtener los dígitos decimales (base 10)
    mov si, ascii_buffer + 5 ; Apunta al final del buffer (última posición disponible)

.convert:
    xor dx, dx            ; Limpia DX antes de la división (para usar DX:AX en la división)
    div bx                ; Divide AX entre 10 → AX = cociente, DX = residuo (0–9)
    add dl, '0'           ; Convierte el residuo (un dígito) en carácter ASCII
    dec si                ; Retrocede una posición en el buffer
    mov [si], dl          ; Almacena el carácter ASCII en la posición actual del buffer
    cmp ax, 0             ; Verifica si el cociente ya es 0 (si no, quedan más dígitos)
    jne .convert          ; Si no es 0, repite para el siguiente dígito

.print:
    mov ah, 2             ; Función 2 de INT 21h: imprimir carácter en DL
    mov dl, [si]          ; Carga el siguiente carácter del número en DL
    int 21h               ; Llama a la BIOS para imprimir el carácter en pantalla
    inc si                ; Avanza a la siguiente posición del buffer
    cmp si, ascii_buffer + 6 ; Compara si llegamos al final del buffer (6 posiciones)
    jne .print            ; Si no llegamos, imprime el siguiente carácter

    ; --- Terminar programa ---
    mov ah, 4Ch           ; Función 4Ch de INT 21h: terminar programa
    int 21h               ; Llama al DOS para salir del programa

ascii_buffer: times 6 db 0 ; Define un buffer de 6 bytes, inicializados en 0 (para máximo 5 dígitos + fin)