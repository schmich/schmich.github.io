---
layout: post
title: "Cut-copy-paste in Vim"
---

I love Vim, but I also have `Ctrl+X`, `Ctrl+C`, `Ctrl+V` permanently burned into my brain.
Can we consolidate these two worlds? Yes! Mostly.

`mswin.vim` is distributed with Vim and offers some hints, but it brings a bit of extra baggage,
and still doesn't behave as I'd expect. Instead, I am doing the following:

{% highlight text %}
vnor <C-X> "+x
vnor <C-C> "+y
inor <C-V> <C-O>:set paste<CR><C-R>+<C-O>:set nopaste<CR>
vnor <C-V> :<C-U>set paste<CR>gvc<C-R>+<C-O>:set nopaste<CR><ESC>
{% endhighlight %}

- You can cut and copy in visual mode.
- You can paste in insert mode or visual mode (replacing your selection).
- Pasting does not result in poor formatting.
- `Ctrl+V` still does visual block selection.

For me, at least, this scheme offers the best tradeoffs with the least surprise.

Cut and copy are just using the `+` clipboard register, and paste is just doing `<C-R>+` 
(see `:h i_ctrl-r`) in between `paste`/`nopaste` to preserve the text without having Vim
reformat it. Ugly, but it works.
