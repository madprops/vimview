let g:current_file_index = 0
let g:files = []

" Function to shuffle a list using Fisher-Yates algorithm
function! Shuffle(list)
  let l = a:list
  for i in range(len(l) - 1, 1, -1)
    let j = rand() % (i + 1)
    let temp = l[i]
    let l[i] = l[j]
    let l[j] = temp
  endfor
  return l
endfunction

function! ScrollDown(timer)
  " Scroll down 3 lines without moving the cursor
  execute "normal! 3\<C-E>"

  " Check if we are at the end of the document
  if line('w$') == line('$')
    echo "Reached the end of the document"
    call timer_stop(a:timer)
    call SwitchToNextFile()
  endif
endfunction

function! SwitchToNextFile()
  " Increment the file index
  let g:current_file_index += 1

  " Wrap around to the first file if we reach the end of the list
  if g:current_file_index >= len(g:files)
    let g:current_file_index = 0
  endif

  " Open the next file
  execute 'edit' g:files[g:current_file_index]

  " Restart the timer
  let s:timer = timer_start(1000, 'ScrollDown', {'repeat': -1})
endfunction

function! Main()
  " Use a bug to hide the cursor
  set t_ve=

  " Clear the prompt
  echo ""

  " Get python files
  let all_files = split(glob("*.py"), "\n")
  let filtered = filter(all_files, 'v:val !~ "^_"')
  let g:files = Shuffle(filtered)

  " Initialize the current file index
  let g:current_file_index = 0

  " Open the first file
  execute 'edit' g:files[g:current_file_index]

  " Start a timer to call ScrollDown every second
  let s:timer = timer_start(1000, 'ScrollDown', {'repeat': -1})
endfunction

call Main()