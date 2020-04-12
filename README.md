# Projeto de feriadão - x86

Neste projeto tentei reproduzir o tutorial [Real mode assembly I](https://wiki.osdev.org/Real_mode_assembly_bare_bones) o objetivo era aprender um pouco mais de x86.

Todo o código principal esta em `src/main_kernel.asm`. Nele o código esta totalmente descrito linha por linha.

Para poder montar e criar uma .`vdi` para testar no `virtualbox` o processo é o seguinte:

```
1. nasm src/main_kernel.asm -f bin -o bin/main_kernel.bin

2. dd if=bin/main_kernel.bin of=img/main_kernel.img bs=100M conv=sync

3. VBoxManage convertfromraw --format VDI img/main_kernel.img vdi/my_kernel_x86.vdi

```

No passo 1 criamos o arquivo objeto a partir do nosso arquivo `.asm`. Após isso no passo 2 criamos uma imagem e devido a problemas de ao converter o `.img` para `.vdi` insiro a parte `bs=100M conv=sync`. Assim o passo 3 utiliza a `tool` do `virtualbox` para criar o arquivo `.vid`.
