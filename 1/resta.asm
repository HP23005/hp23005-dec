org 100h               ; Dirección de inicio para archivos .COM en modo real (DOS)

start:
    ; --- Resta de tres números ---
    mov ax, 100         ; Cargar el primer número en AX → AX = 100
    sub ax, 10         ; Restar el segundo número → AX = 10
    sub ax, 5          ; Restar el tercer número → AX = 5

    ; --- Conversión de número decimal en AX a ASCII ---
    mov bx, 10         ; Divisor para obtener cada dígito decimal
    mov si, ascii_buffer + 5    ; SI apunta al final del buffer donde se guardarán los dígitos ASCII

.convert:
    xor dx, dx         ; Limpiar DX antes de la división (div usa DX:AX)
    div bx             ; AX / 10 → cociente en AX, residuo (resto) en DX
    add dl, '0'        ; Convertir dígito en DX a carácter ASCII (0–9 → '0'–'9')
    dec si             ; Mover el puntero SI una posición atrás
    mov [si], dl       ; Guardar el carácter ASCII en el buffer
    cmp ax, 0          ; ¿Quedan más dígitos?
    jne .convert       ; Si sí, seguir dividiendo

.print:
    mov ah, 2          ; Función de impresión de carácter en INT 21h
    mov dl, [si]       ; Cargar el siguiente carácter desde el buffer
    int 21h            ; Imprimir el carácter en pantalla
    inc si             ; Avanzar al siguiente carácter
    cmp si, ascii_buffer + 6    ; ¿Llegamos al final del buffer?
    jne .print         ; Si no, seguir imprimiendo

    ; --- Finalizar el programa ---
    mov ah, 4Ch        ; Función de salida del programa (INT 21h)
    int 21h            ; Llamada al sistema para salir

ascii_buffer: times 6 db 0       ; Buffer de 6 bytes para almacenar caracteres ASCII del número