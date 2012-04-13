CSS Syntax Checker
==================

  John Gruber  
  Copyright © 2005  
  <http://daringfireball.net/projects/csschecker/>  
  Version 1.0.1  
  Monday, 24 October 2005

  Version 1.0.2  
  Thursday 12 Apr 2012 (Happy Birthday BBedit!)


What's new in 1.0.2
-------------------

* Perl Scripts are no longer hidden in the BBedit Script Menu, so "CSS Syntax Check.pl" 
was renamed to "zz)CSS Syntax Check Helper.pl" to better distinguish the actual 
AppleScript you'd use. This rename is reflected in the installation notes below.

* Adjusted the scripts so they work in BBedit Project Windows and support the newer 
W3C Validator results format.


Installation
------------

BBEdit CSS Syntax Checker consists of two script files: one
AppleScript and one Perl:

*	CSS Syntax Check.scpt
*	zz)CSS Syntax Check Helper.pl

Both scripts are essential. The easiest way to install these scripts
is to put both of them in your BBEdit scripts folder:

	~/Library/Application Support/BBEdit/Scripts/

Technically, this "Scripts" folder is intended just for AppleScripts
(to be truly pedantic, it's intended for *OSA* scripts). However, it's
harmless to store the Perl script here (it won't show up in your
Scripts menu), and the AppleScript assumes the Perl script is in the
same folder as itself.


Usage
-----

Open a CSS file and choose "CSS Syntax Check" from BBEdit's Scripts
menu. It will probably take a second or two to run.

*	If there are no errors or warnings, you should see a dialog
	box saying so.

*	If there are any errors or warnings, you should get a BBEdit
	results browser showing the errors and warnings.


Super-Cool Bonus Feature
------------------------

If you run it against an HTML document, it will perform a CSS syntax
check against the contents of the first `<style>...</style>` tag pair
in the document. In other words, even if your CSS isn't in a
standalone CSS file, you can still syntax-check it with this script.
This is quite handy for developers who use inline CSS during
development to avoid browser caching issues.


Using It as a Menu Script in BBEdit
-----------------------------------

For extra fun, you can make an alias to the "CSS Syntax Check.scpt"
script and place it (the alias) in your BBEdit Menu Scripts folder.
Name the alias "Check•Document Syntax" (that's an Option-8 bullet). It
makes no difference if you use the ".scpt" extension in the alias
name. The alias should end up here:

	~/Library/Application Support/BBEdit/Menu Scripts/Check•Document Syntax

After you've done this, you should now be able to invoke the CSS
syntax checker using the Markup -> Check -> Document Syntax command,
the same one used for checking HTML documents.

The AppleScript's `menuselect()` handler does the CSS syntax checking if
the frontmost text document is set to the CSS source language;
otherwise it passes the command on to BBEdit's regular HTML checker.

In other words, if you call this script from BBEdit's Scripts menu, it
will always run a CSS syntax check against the front text window. If
you call it using the Markup -> Check -> Document Syntax menu script,
it will only do a CSS syntax check if the front document's source
language is set to CSS, otherwise it will be passed along to BBEdit to
be checked as HTML.

The point of this is that it allows you to use the same keyboard
shortcut to check both HTML and CSS files.


Known Issues
------------

*	The results browser for errors and warnings will not appear if
	the front document is untitled (i.e. a new document that has never
	been saved to disk). It "just works" if the front window is dirty,
	but associated with an on-disk file, but it doesn't work if the
	front document has never been saved. This is due to a known
	limitation in BBEdit's scripting interface for results browsers.

*	The actual work of CSS syntax checking is performed by the W3C's
	online CSS Validator: <http://jigsaw.w3.org/css-validator/>. Thus,
	this script only works while you are connected to the Internet.

*	If you have more than one `<style>` tag in an HTML document, only
	the contents of the first one will be checked.

