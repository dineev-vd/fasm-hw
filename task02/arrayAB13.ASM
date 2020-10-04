;Вариант 13
;
;Разработать программу, которая выводит одномерный массив A[N], формирует из элементов массива A новый массив B,
;в котором находятся элементы массива A, за исключением элементов, значения которых совпадают с минимальным элементом A


;Выполнил: Динеев Владислав Денисович БПИ191

format PE console
entry start

include 'win32a.inc'

;----------------------------------
section '.data' data readable writable



A_size           dd ?
B_size           dd 0
strScan          db '%d', 0
strInvalidSize   db 'Invalid size, try again', 10, 10, 0
strInputSize     db 'Enter vector size', 10, 0
vec_A            rd 100
vec_B            rd 100
i                dd ?
current          dd ?
strElement       db '[%d]->', 0
strElementOut    db '[%d]= %d', 10, 0
strAOut          db 'Vector A:', 10, 0
strBOut          db 'Vector B:', 10, 0
minValue         dd 0

;----------------------------------
section '.code' code readable executable
start:
;1 -> input
        call VectorInput
;2 -> find minimal value
        call FindMin
;3 -> find minimal value
        call FormB
;4 -> out A
        call PrintA
;5 -> out B
        call PrintB
finish:
        call [getch]
        push 0
        call [ExitProcess]
;--------------1 VectorInput -----------
VectorInput:
        push strInputSize
        call [printf]
        add esp, 4

        push A_size
        push strScan
        call [scanf]
        add esp, 8

        cmp [A_size], 0
        jg readVector

;-------if failed ->--------------------
        push strInvalidSize
        call [printf]
        add esp, 4
        jmp VectorInput
;-------if good-------------------------
readVector:
        xor ebx, ebx
        mov ecx, vec_A
vectorLoop:
        cmp ebx, [A_size]
        jge endLoop
        ;---if ecx>A_size -- end loop---

        mov [i], ebx
        mov [current], ecx

        push ebx
        push strElement
        call [printf]
        add esp, 8

        mov ecx, [current]
        push ecx
        push strScan
        call [scanf]
        add esp, 8

        mov ecx, [current]
        mov ebx, [i]
        add ecx, 4
        inc ebx
        jmp vectorLoop
endLoop:
        ret
;-----------2 find minimal value-----------------
FindMin:
        xor ebx, ebx
        mov ecx, vec_A
        push dword [ecx]
        pop eax
        mov [minValue], eax
minLoop:
        cmp ebx, [A_size]
        jge minLoopEnd
        ;---if ecx>A_size -- end loop---

        mov edx, [minValue]
        cmp [ecx], edx
        jl ifMinFound

minLoopContinue:
        add ecx, 4
        inc ebx
        jmp minLoop
minLoopEnd:
        ret
ifMinFound:
        push dword [ecx]
        pop eax
        mov [minValue], eax
        jmp minLoopContinue

;-----------3 form b------------------
FormB:
        xor ebx, ebx
        mov ecx, vec_A

        xor eax, eax
        mov edx, vec_B

formBLoop:
        cmp ebx, [A_size]
        jge endFormBLoop

        mov [current], ecx
        mov ecx, [ecx]

        cmp [minValue], ecx
        jne ifNotEqual

formBContinue:
        mov ecx, [current]
        inc ebx
        add ecx, 4
        jmp formBLoop

endFormBLoop:
        ret

ifNotEqual:
        mov [edx], ecx
        mov eax, [B_size]
        inc eax
        mov [B_size], eax
        add edx, 4
        jmp formBContinue


;-----------4 vector A out-------------
PrintA:
        push strAOut
        call [printf]
        add esp, 4

        xor ebx, ebx
        mov ecx, vec_A

printALoop:
        cmp ebx, [A_size]
        jge endALoop

        mov [i], ebx
        mov [current], ecx

        push dword [ecx]
        push ebx
        push strElementOut
        call [printf]
        add esp, 12

        mov ebx, [i]
        mov ecx, [current]
        inc ebx
        add ecx, 4
        jmp printALoop
endALoop:
        ret
;-----------5 vector B out-------------
PrintB:
        push strBOut
        call [printf]
        add esp, 4

        xor ebx, ebx
        mov ecx, vec_B

printBLoop:
        cmp ebx, [B_size]
        jge endBLoop

        mov [i], ebx
        mov [current], ecx

        push dword [ecx]
        push ebx
        push strElementOut
        call [printf]
        add esp, 12

        mov ebx, [i]
        mov ecx, [current]
        inc ebx
        add ecx, 4
        jmp printBLoop
endBLoop:
        ret




;------------------------------------
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'

