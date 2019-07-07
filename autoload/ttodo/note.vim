
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

function! ttodo#note#New(task) abort "{{{
	"Tlibtrace 'ttodo', a:task
	let path = ttodo#note#Path(a:task)
	call tlib#dir#Ensure(fnamemodify(path, ':p:h'))
	let msg = ttodo#note#InitialMessage(a:task)
	call writefile(msg,fnameescape(path))
endfun
"}}}

function! ttodo#note#Exists(task) abort "{{{
	let path = ttodo#note#Path(a:task)
	return filereadable(path)
endfunction
"}}}

function! ttodo#note#View(task) abort "{{{2
	let path = ttodo#note#Path(a:task)

	if !filereadable(path)
		throw 'Cannot read note'
	endif

	exe g:ttodo#ftplugin#edit_note . ' ' . path
endf
"}}}

function! ttodo#note#InitialMessage(task) " {{{2
	let id = get(a:task,"id","none")
	let timestamp = strftime('%d-%m-%Y %I:%M %p')
	
	let msg = ['---', 
				\    'tittle: Log file for task ID: ' . id,
				\    'createdOn: ' . timestamp,
				\    '---'
				\]
  return msg
endfunction
"}}}

function! ttodo#note#Path(task) abort "{{{2
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
"}}}

