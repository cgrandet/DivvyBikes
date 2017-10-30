#!/usr/bin/perl -w
# Creates an html table of flight delays by weather for the given route

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;
use CGI qw/:standard/;

# Read the origin and destination airports as CGI parameters
my $month = param('month');
#  my $dest = param('dest');
 
# Define a connection template to access the HBase REST server
# If you are on out cluster, hadoop-m will resolve to our Hadoop master
# node, which is running the HBase REST server
my $hbase = HBase::JSONRest->new(host => "localhost:8080");

# This function takes a row and gives you the value of the given column
# E.g., cellValue($row, 'delay:rain_delay') gives the value of the
# rain_delay column in the delay family.
# It uses somewhat tricky perl, so you can treat it as a black box
sub cellValue {
    my $row = $_[0];
    my $field_name = $_[1];
    my $row_cells = ${$row}{'columns'};
    foreach my $cell (@$row_cells) {
	if ($$cell{'name'} eq $field_name) {
	    return $$cell{'value'};
	}
    }
    return 'missing';
}

# Query hbase for the route. For example, if the departure airport is ORD
# and the arrival airport is DEN, the "where" clause of the query will
# require the key to equal ORDDEN
my $records = $hbase->get({
  table => 'divvy_trips',
  where => {
    key_begins_with => $month
  },
});
 
my $row1 = @$records[0];
my $row2 = @$records[1];
my $row3 = @$records[2]; 
my $row4 = @$records[3];
my $row5 = @$records[4];
my $row6 = @$records[5];
my $row7 = @$records[6];
my $row8 = @$records[7];
my $row9 = @$records[8];
my $row10 = @$records[9];

# Get the value of all the columns we need and store them in named variables
# Perl's ability to assign a list of values all at once is very convenient here

sub get_from {
    my $row = @_;
    my $from = cellValue($row, 'top10:fromID');
    return $from;
}

sub get_to { 
    my($row) = @_;
    my($to) = cellValue($row,'top10:toID');
    return $to;
}

sub get_freq {
    my($row) = @_;
    my($freq) = cellValues($row,'top10:frequency');
    return $freq; 
}


# Print an HTML page with the table. Perl CGI has commands for all the
# common HTML tags
print header, start_html(-title=>'hello CGI',-head=>Link({-rel=>'stylesheet',-href=>'/table.css',-type=>'text/css'}));

print div({-style=>'margin-left:275px;margin-right:auto;display:inline-block;box-shadow: 10px 10px 5px #888888;border:1px solid #000000;-moz-border-radius-bottomleft:9px;-webkit-border-bottom-left-radius:9px;border-bottom-left-radius:9px;-moz-border-radius-bottomright:9px;-webkit-border-bottom-right-radius:9px;border-bottom-right-radius:9px;-moz-border-radius-topright:9px;-webkit-border-top-right-radius:9px;border-top-right-radius:9px;-moz-border-radius-topleft:9px;-webkit-border-top-left-radius:9px;border-top-left-radius:9px;background:white'}, 
'&nbsp;Trips for ' . $month . '&nbsp;');
print     p({-style=>"bottom-margin:10px"});
print table({-class=>'CSS_Table_Example', -style=>'width:60%;margin:auto;'},
	    Tr([td(['FromID', 'ToID','Frequency']),
		td([cellValue($row1,'final:fromID'),
		    cellValue($row1,'final:toID'),
		    cellValue($row1,'final:frequency')]),
		td([cellValue($row2,'final:fromID'),
		    cellValue($row2,'final:toID'),
		    cellValue($row2,'final:frequency')]),
	        td([cellValue($row3,'final:fromID'),
		    cellValue($row3,'final:toID'),
		    cellValue($row3,'final:frequency')]),
                td([cellValue($row4,'final:fromID'),
		    cellValue($row4,'final:toID'),
		    cellValue($row4,'final:frequency')]),
                td([cellValue($row5,'final:fromID'),
		    cellValue($row5,'final:toID'),
		    cellValue($row5,'final:frequency')]),
                td([cellValue($row6,'final:fromID'),
		    cellValue($row6,'final:toID'),
		    cellValue($row6,'final:frequency')]),
                td([cellValue($row7,'final:fromID'),
		    cellValue($row7,'final:toID'),
		    cellValue($row7,'final:frequency')]),
                td([cellValue($row8,'final:fromID'),
		    cellValue($row8,'final:toID'),
		    cellValue($row8,'final:frequency')]),
                td([cellValue($row9,'final:fromID'),
		    cellValue($row9,'final:toID'),
		    cellValue($row9,'final:frequency')]),
                td([cellValue($row10,'final:fromID'),
		    cellValue($row10,'final:toID'),
		    cellValue($row10,'final:frequency')])])),
		 p({-style=>"bottom-margin:10px"})
    ;

print end_html;
