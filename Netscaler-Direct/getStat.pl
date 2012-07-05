#!/usr/bin/perl -w

# Sample perl script to demonstrate NetScaler API "stat" methods

# Output:
# > perl getStat.pl <NS IP> nsroot nsroot
#
# login: Done
# statlbvserver: Done
# v1       SSL     10.102.6.229    0 DOWN
# statlbvserver  vip_1: No such resource [vserver, vip_1]
#
# logout: EOF
#
#>

use SOAP::Lite;			# troubleshoot: append: +trace=>"debug";
import SOAP::Data 'name';	# to set data values (q.v.)
use HTTP::Cookies;		# server uses client cookie for auth

# Command-line parameters:  <NS IP> <username> <password>
my $NS = shift @ARGV;
$NS = "localhost" if (!$NS);
my $username = shift @ARGV;
$username = "nsroot" if (!$username);
my $password = shift @ARGV;
$password = "nsroot" if (!$password);

# Cookie object.  Server sends cookie for client authentication.
my $cookies = HTTP::Cookies->new(ignore_discard => 1, hide_cookie2 => 1);

# Create the soap object
my $soap = SOAP::Lite
    # service URI and cookie object
    -> proxy("http://$NS/soap", cookie_jar=>$cookies)
    ;

# Log on
print "login: ";
my $result = $soap->login( name('username'=>$username), 
			   name('password'=>$password) )
	->result;
print $result->{'message'} . "\n";

#Stats of load-balancing vservers
print "statlbvserver: ";
$result = $soap->statlbvserver( )->result;
print $result->{'message'} . "\n";
if ($result->{rc}==0) {
    # Dump some information about each vserver
    foreach $vs ( @{$result->{List}} ) {
	print "$vs->{name}\t $vs->{type} \t $vs->{primaryipaddress}\t $vs->{totalresponses} $vs->{state}\n"; 
    }
}


#stats of load-balancing vserver vip_1
print "statlbvserver  vip_1: ";
$result = $soap->statlbvserver(name('name'=>'vip_1' ))->result;
print $result->{'message'} . "\n";
if ($result->{rc}==0) {
	# Dump information about bound entities
	$vs = @{$result->{List}}[0];
	print "$vs->{name}\t $vs->{type} \t $vs->{primaryipaddress}\t $vs->{totalresponses} $vs->{state}\n"; 
	}
	print "\n";

# Logout
print "logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit;
