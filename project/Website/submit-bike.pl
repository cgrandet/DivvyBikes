#!/usr/bin/perl -w
# Program: cass_sample.pl
# Note: includes bug fixes for Net::Async::CassandraCQL 0.11 version

use strict;
use warnings;
use 5.10.0;
use FindBin;

use Scalar::Util qw(
        blessed
    );
use Try::Tiny;

use Kafka::Connection;
use Kafka::Producer;

use Data::Dumper;
use CGI qw/:standard/, 'Vars';

my $fromID = param('fromID');
my $toID = param('toID');
my $day = param('day');
my $month = param('month');
my $frequency = param('frequency');

my ( $connection, $producer );
try {
    #-- Connection
    # $connection = Kafka::Connection->new( host => 'localhost', port => 6667 );
    $connection = Kafka::Connection->new( host => 'hdp-m.c.mpcs53013-2016.internal', port => 6667 );

    #-- Producer
    $producer = Kafka::Producer->new( Connection => $connection );
    # Only put in the station_id and weather elements because those are the only ones we care about
    my $message = "<current_observation><fromID>K".param("fromID")."</fromID>";
    $message .=  "<toID>K".param("toID")."</toID>";
    $message .=  "<day>K".param("day")."</day>";
    $message .= "<month>K".param("month")."</month>";
    $message .= "<frequency>K".param("frequency")."</frequency></current_observation>";

    # Sending a single message
    my $response = $producer->send(
	'bike-trip',          # topic
	0,                                 # partition
	$message                           # message
        );
} catch {
    if ( blessed( $_ ) && $_->isa( 'Kafka::Exception' ) ) {
	warn 'Error: (', $_->code, ') ',  $_->message, "\n";
	exit;
    } else {
	die $_;
    }
};

# Closes the producer and cleans up
undef $producer;
undef $connection;

print header, start_html(-title=>'Submit trip',-head=>Link({-rel=>'stylesheet',-href=>'/table.css',-type=>'text/css'}));
print table({-class=>'CSS_Table_Example', -style=>'width:80%;'},
            caption('Weather report submitted'),
	    Tr([th(["fromID","toID","day","month", "frequency"]),
	        td([$fromID, $toID, $day, $month, $frequency])]));

#print $protocol->getTransport->getBuffer;
print end_html;

