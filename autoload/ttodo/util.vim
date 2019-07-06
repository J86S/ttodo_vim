
function! ttodo#util#LastUpdate() "[{{3
	let now = strftime(g:tlib#date#date_format)
	call s:SetTag('lu',g:tlib#date#date_rx,now)
endf
"}}}
"
function! s:SetTag(name, rx, value) abort "{{{3
  exec 's/\C\%(\s\+'. a:name .':'. escape(a:rx, '/') .'\|$\)/ '. a:name .':'. escape(a:value, '/') .'/'
endf
"}}}
