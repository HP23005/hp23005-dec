section .data
    result_msg db "Resultado: ", 0xA    ; Cadena que se mostrará antes del resultado, incluye salto de línea (0xA)
    ascii_buffer db 11 dup(0)           ; Buffer para almacenar el número convertido en ASCII (10 dígitos máx + '\n')

section .text
    global _start

_start:
    ; --- Realizar división ---
    mov eax, 1000        ; Cargar 1000 en EAX (dividendo)
    mov ebx, 25          ; Cargar 25 en EBX (divisor)
    xor edx, edx         ; Limpiar EDX (parte alta del dividendo)
    div ebx              ; EAX = EAX / EBX, EAX = cociente (resultado), EDX = residuo

    ; --- Guardar resultado en EBX para la conversión ---
    mov ebx, eax         ; Copiar el resultado de la división a EBX para convertirlo en ASCII

    ; --- Convertir número en EBX a cadena ASCII decimal ---
    mov edi, ascii_buffer + 10 ; Puntero al final del buffer
    mov byte [edi], 0xA        ; Colocar salto de línea al final del número

.convert:
    xor edx, edx         ; Limpiar EDX antes de dividir (ya que se usa EDX:EAX)
    mov eax, ebx         ; Mover el número actual a EAX para dividirlo entre 10
    mov ecx, 10          ; Divisor = 10 para obtener los dígitos decimales
    div ecx              ; Divide EAX entre 10 → cociente en EAX, residuo en EDX

    add dl, '0'          ; Convertir residuo (0–9) a carácter ASCII ('0'–'9')
    dec edi              ; Retroceder una posición en el buffer
    mov [edi], dl        ; Almacenar el carácter convertido en el buffer

    mov ebx, eax         ; Actualizar EBX con el nuevo cociente
    test eax, eax        ; Verificar si ya se ha completado la conversión (cociente = 0)
    jnz .convert         ; Si no es cero, repetir el proceso para el siguiente dígito

    ; --- Imprimir mensaje ---
    mov eax, 4           ; syscall número 4: sys_write
    mov ebx, 1           ; descriptor de archivo 1: salida estándar (stdout)
    mov ecx, result_msg  ; puntero al mensaje a imprimir
    mov edx, 11          ; longitud del mensaje (10 caracteres + salto de línea)
    int 0x80             ; llamada al sistema

    ; --- Imprimir el número convertido ---
    mov eax, 4           ; syscall número 4: sys_write
    mov ebx, 1           ; descriptor de archivo 1: stdout
    mov ecx, edi         ; puntero al inicio del número convertido en ASCII
    mov edx, ascii_buffer + 11 ; puntero al final del buffer (posición después del salto de línea)
    sub edx, edi         ; calcular longitud del número a imprimir
    int 0x80             ; llamada al sistema para imprimir el número

    ; --- Terminar el programa ---
    mov eax, 1           ; syscall número 1: sys_exit
    xor ebx, ebx         ; código de salida = 0 (sin error)
    int 0x80             ; llamada al sistema para salir del programa