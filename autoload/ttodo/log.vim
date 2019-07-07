
function! ttodo#log#Simple(path,msg) abort "{{{2
	let timestamp = strftime("%T@%d-%m-%Y")
	let log = timestamp . ":" . a:msg
	call s:write_note(a:path,[log])
endfunction
"}}}

function! ttodo#log#Span(task,msg) abort "{{{2
	
endf
"}}}

function! s:write_note(path,msg) abort "{{{2
	call writefile(a:msg,fnameescape(a:path),"a")
endfunction
"}}}

