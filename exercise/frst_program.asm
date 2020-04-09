format PE console
entry start

include ''

section '.text' code readable executable

start:
  inc eax
  inc eax
  dec eax
  inc eax

  push 0
  call [ExitProcess]

section '.idata' import data readable

library kernel, ''

import kernel,\
       ExitProcess, 'ExitProcess'
