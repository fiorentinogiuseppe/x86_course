# README
``
nasm kernel.asm -f bin -o kernel.bin
``

``
dd if=kernel.bin of=padded.img bs=100M conv=sync
``

``
VBoxManage convertfromraw --format VDI padded.img my_kernel_x86.vdi
``
