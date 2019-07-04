
" Settings {{{
if !exists('g:ttodo#ftplugin#edit_note')
	" If non-empty, edit a newly added reference to a note right away.
	"
	" Possible (potentially useful) values:
	"   - split
	"   - hide edit
	"   - tabedit
	let g:ttodo#ftplugin#edit_note = 'split +$'
endif
" }}}

function! ttodo#note#InitialMessage(task)
	let id = get(a:task,"id","none")
	let timestamp = strftime('%d-%m-%Y %I:%M %p')
	
	let msg = ['---', 
				\    'tittle: Log file for task ID: ' . id,
				\    'createdOn: ' . timestamp,
				\    '---'
				\]
  return msg
endfunction

function! ttodo#note#New(task) abort
	"Tlibtrace 'ttodo', a:task
	let path = s:generate_path(a:task)
	call tlib#dir#Ensure(fnamemodify(path, ':p:h'))
endfun

function! ttodo#note#Exists(task) abort
	let path = s:generate_path(a:task)
	return filereadable(path)
endfunction

function! ttodo#note#Log(task,msg) abort
	let timestamp = strftime("%T@%d-%m-%Y")
	let log = timestamp . ":" . a:msg
	call s:write_note(a:task,[log])
endfunction

function! ttodo#note#View(task) abort "{{{3
	let path = s:generate_path(a:task)

	if !filereadable(path)
		throw 'Cannot read note'
	endif

	let cmd = g:ttodo#ftplugin#edit_note . ' ' . path

	exe cmd

endf
"}}}

function! s:write_note(task,msg) abort
	let path = s:generate_path(a:task)
	call writefile(a:msg,fnameescape(path),"a")
endfunction

function! s:generate_path(task) abort
	let id = get(a:task,"id","none")
	if id == "none"
		echohl WarningMsg
		throw 'Ttodo: Task must have id'
		echohl NONE
	endif
	let target = fnamemodify(get(a:task,'file','UNK'),':p:h')
	
	if target ==# 'UNK'
		throw 'Cannot get File'
	endif

	return tlib#file#Join([target,"notes",id . ".md"])
endfun
