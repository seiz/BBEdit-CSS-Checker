#!/usr/bin/perl

#
# CSS Syntax Check.pl
# Command-line screenscraper for the W3C's CSS Validator.
#
# Copyright (c) 2005 John Gruber
# <http://daringfireball.net/projects/csschecker/>  
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#

use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '1.0.2';
# Thu 12 Apr 2012 (Happy Birthday BBedit!)

use CGI qw/unescapeHTML/;


my $VALIDATOR_URL = 'http://jigsaw.w3.org/css-validator/validator';
my $PATH = $ARGV[0];

# We really ought to use LWP for this, but shelling out to `curl`
# makes life easier for most users because LWP doesn't ship as
# part of the standard Perl library.

# Form Parameters you can modify if you want
# warning=		2=all ; 1=normal ; 0=only important ; no=no warnings at all
# profile=		css1=CSS level 1 ; ccs2=CSS level 2 ; css3=CSS level 3
my $result_html = qx(curl --silent -F "warning=0" -F "profile=css3" -F "vextwarning=false" -F "file=\@$PATH;type=text/css" $VALIDATOR_URL);

# Lame error checking:
if ($result_html !~ m{<html}xms) {
	die "Couldn't get syntax check results from W3C.";
}

my $output = '';

# First, check for errors:
if ($result_html =~ m{<div id="errors">(.+?)</div>\s*</div>}s) {
	my $error_html = $1;
	my @errors = $error_html =~ m{<tr class='error'>.+?</tr>}msg;
	foreach my $error (@errors) {
		my ($line_num) = $error =~ m{Line[ ]? (\d+)}ms;
		my ($error_msg) = $error =~ m{<td class='parse-error'>(.+)</td>}s;

		# Clean up HTML in the error description
		$error_msg =~ s{\n}{}g;
		$error_msg =~ s{<.+?>}{}g;
		$error_msg =~ s{\s+}{ }g;
		$error_msg = unescapeHTML($error_msg);
	
		$output .= "Error: $line_num:\t$error_msg\n";
	}
}

# Then check for warnings:
if ($result_html =~ m{<div id="warnings">(.+?)</div>}ms) {
	print "Got warnings\n";
	my $warning_html = $1;
	my @warnings = $warning_html =~ m{<tr class='warning'>.+?</tr>}msg;
	foreach my $warning (@warnings) {
		my ($line_num) = $warning =~ m{Line[ ]? (\d+)}ms;
		my ($warning_msg) = $warning =~ m{<td class='level.+>(.+)</td>}s;

		# Cleanup html in the warning description
		$warning_msg =~ s{\n}{}g;
		$warning_msg =~ s{<.+?>}{}g;
		$warning_msg =~ s{\s+}{ }g;
		$warning_msg = unescapeHTML($warning_msg);

		$output .= "Warning: $line_num:\t$warning_msg\n";
	}
}


# If there are no errors or warnings, say so:
$output =~ s{\A\s*\z}{No syntax errors detected.\n};
print $output;



__END__

=pod

=head1 NAME

B<CSS Syntax Check> - Command-line interface to the W3C CSS Validator.


=head1 SYNOPSIS

B<name> /path/to/style.css


=head1 DESCRIPTION


=head1 OPTIONS

None.


=head1 BUGS



=head1 VERSION HISTORY

1.0.2

- made it work with the current W3C Validator response format which used different HTML which broke the scraper (s.seiz)
- added some useful options to the curl call, so one can specify the css profile the checker will use (s.seiz)

1.0.1

-	switched from HTML::Entities to CGI.pm's unescapeHTML(), because
	it's standard on older versions of Perl.



=head1 AUTHOR


=head1 COPYRIGHT AND LICENSE

Copyright (c) 2005 John Gruber  
<http://daringfireball.net/>   
All rights reserved.

This is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
