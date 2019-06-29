
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
    call writefile(["test"],fnameescape(filename))
    " if !empty(g:ttodo#ftplugin#edit_note)
    "     exec g:ttodo#ftplugin#edit_note fnameescape(filename)
    " endif

endfun

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
