
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

function! ttodo#note#New(task) abort
	"Tlibtrace 'ttodo', a:task
	let path = s:generate_path(a:task)
	call tlib#dir#Ensure(fnamemodify(path, ':p:h'))
	let msg = s:initial_message(a:task)
	call s:write_note(a:task,msg)

	if !empty(g:ttodo#ftplugin#edit_note)
		silent exec g:ttodo#ftplugin#edit_note fnameescape(path)
	endif
endfun

function! ttodo#note#Exists(task) abort
	let path = s:generate_path(a:task)
	return filereadable(path)
endfunction

function! ttodo#note#Log(task) abort
	let log = tlib#string#Input('message: ')
	let timestamp = strftime("%T@%d-%m-%Y")
	let msg = timestamp . ": " . log
	call s:write_note(a:task,[msg])
endfunction

function! s:write_note(task,msg) abort
	let path = s:generate_path(a:task)
	call writefile(a:msg,fnameescape(path),"a")
endfunction

function! s:initial_message(task)
	let id = get(a:task,"id","none")
	let timestamp = strftime('%d-%m-%Y %I:%M %p')
	
	let msg = ['---', 
				\    'tittle: Log file for task ID: ' . id,
				\    'createdOn: ' . timestamp,
				\    '---'
				\]
  return msg
endfunction

function! s:generate_path(task) abort
	let id = get(a:task,"id","none")
	if id == "none"
		echohl WarningMsg
		throw 'Ttodo: Task must have id'
		echohl NONE
	endif
	let dir = expand('%:p:h')
	let path = tlib#file#Join([dir,"notes",id . ".md"])
	return path
endfun
