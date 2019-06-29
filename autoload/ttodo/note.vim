
" Settings {{{
if !exists('g:ttodo#ftplugin#edit_note')
	" If non-empty, edit a newly added reference to a note right away.
	"
	" Possible (potentially useful) values:
	"   - split
	"   - hide edit
	"   - tabedit
	let g:ttodo#ftplugin#edit_note = ''
endif
" }}}

function! ttodo#note#New(task) abort
	Tlibtrace 'ttodo', task
	let filename = s:generate_path(a:task)

	if s:note_exists(filename) == 1
		echohl WarningMsg
		throw 'Ttodo: Task note already exists'
		echohl NONE
	endif

	Tlibtrace 'ttodo', filename
	call tlib#dir#Ensure(fnamemodify(filename, ':p:h'))
	let msg = s:initial_message(a:task)
	call writefile(msg,fnameescape(filename))

	if !empty(g:ttodo#ftplugin#edit_note)
		silent exec g:ttodo#ftplugin#edit_note fnameescape(filename)
	endif

endfun

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

function! s:note_exists(path) abort
	return filereadable(a:path)
endfun
