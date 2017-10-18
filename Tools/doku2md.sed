#! /bin/sed
#
# Title:
#  doku2md.sed
# From:
#  Original: http://dokuwiki.oreda.net/dokuwiki-markdown.html
#  Modified by: seirios@seirios.org
#
# Usage: 
#  sed -f dokuwiki2markdown.sed input.txt > output.txt
#
# for /usr/bin/what:
#  @(#)doku2md.sed Sed script for Dokuwiki form to Markdown.
 
#Header
s/^======/#/
s/^=====/##/
s/^====/###/
s/^===/####/
s/^==/#####/
s/^=/######/
 
s/======$//
s/=====$//
s/====$//
s/===$//
s/==$//
s/=$//
 
#------------------------------------------------------
#link
#------------------------------------------------------
s#\[\[\(.*\)|\(.*\)\]\] *|#[\2](\1)|#g
s#\[\[\(.*\)|\(.*\)\]\]#[\2](\1)#g
 
#code/file
# Markdown cannot set filename or format
s/<code>/```/
s/<\/code>/```/
s/<file>/```/
s/<\/file>/```/
s/<note>/```/
s/<\/note>/```/
 
#delete %%
s/%%//g
 
#break line
s#\\\\#<br>#g
 
#-------------------------
#plugin
#-------------------------
#Table Width Plugin
/^|</d
 
#color plugin
s#</color>##
s#<color.*>##
 
#Syntaxhighlighter
s/<sxh \([a-zA-Z0-9]*\).*/\n```\1/
s/<sxh>/\n```bash/
s/<\/sxh>/```\n/
 
s#<sxh bash.*>#```bash#
s#<sxh python.*>#```python#
s#<sxh php.*>#```php#
s#<sxh sql.*>#```sql#
