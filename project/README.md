# README
``
nasm kernel.asm -f bin -o kernel.bin
``

``
giuseppe@giuseppe-Nitro-AN515-51:~/Curso Quarentena/x86/project$ dd if=kernel.bin of=./kernel.img status=progress
``

``
dd if=kernel.img of=padded.img bs=100M conv=sync
``

``
VBoxManage convertfromraw --format VDI kernel.img my_kernel_x86.vdi

`` 
