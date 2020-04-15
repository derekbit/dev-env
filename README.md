# Developement Environment and Tools

### Install ctags and cscope
```
apt install -y ctags cscope
```

### Using vimdiff as git diff tool
```
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global alias.vimdiff difftool
```

Run *git vimdiff [file]* and see the changes in VIM.
You can still use the regular git diff command to get the patch output.

Reference: https://michaelthessel.com/using-vimdiff-as-git-diff-tool/


### Some hot keys for vimdiff
- fold
```
zo -> open fold
zc -> close fold
```
### fugitive.vim
https://github.com/tpope/vim-fugitive
https://advancedweb.hu/how-to-compare-file-revisions-with-fugitive-vim/
```
:Glog --oneline
:Gvdiff
```

```
:Gblame
```

- How to get commits for current file rather than revisions

For sake of completeness, once you have the revisions loaded in your buffer, you can browse through them by opening the quickfix list
```
:Glog -- %
:copen
```

Load the last 10 commits for the current file
```
:Glog -10 -- %
```

### Tools
- [JSON validator](https://jsonformatter.curiousconcept.com/)
- [Slides Code Highlighter](https://romannurik.github.io/SlidesCodeHighlighter/)
