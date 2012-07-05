#!perl -w

# Sample perl script to demonstrate NetScaler API "get" methods

# Output:
# > perl getConfig.pl <NS IP> nsroot nsroot
# login: Done
# getlbvserver: Done
# vip_1:	100.1.1.1:80(HTTP)	DOWN
# getlbvserver  vip_1: Done
# Services bound to vip_1:
# 	s1: 10.1.1.11:80(HTTP)	DOWN
# 	s2:	10.1.1.12:80(HTTP)	DOWN
# getlbvserver(nonesuch): Return code is 258
# No such resource
# logout: EOF
# >

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

# Get load-balancing vservers
print "getlbvserver: ";
$result = $soap->getlbvserver( )->result;
print $result->{'message'} . "\n";
if ($result->{rc}==0) {
	# Dump some information about each vserver
	foreach $vs ( @{$result->{List}} ) {
		print "$vs->{name}:\t$vs->{ipaddress}:$vs->{port}($vs->{servicetype})\t$vs->{state}\n"; 
	}
}

# Get load-balancing vserver vip_1
print "getlbvserver  vip_1: ";
$result = $soap->getlbvserver(name('name'=>"vip_1" ))->result;
print $result->{'message'} . "\n";
if ($result->{rc}==0) {
	# Dump information about bound entities
	$vs = @{$result->{List}}[0];
	print "Services bound to $vs->{name}:\n";
	foreach my $svcname ( @{$vs->{servicename}} ) {
		my $result2 = $soap->getservice(name('name'=>$svcname) )->result;
		if ($result2->{rc}==0) {
			my $svc = @{$result2->{List}}[0];
			print "$svc->{name}:\t$svc->{ipaddress}:$svc->{port}($svc->{servicetype})\t$svc->{svrstate}\n"; 
		}
	}
	print "\n";
}

# Error: no such vserver
print "getlbvserver(nonesuch): ";
$result = $soap->getlbvserver( name('name' => 'nonesuch') )->result;
print "Return code is " . $result->{rc} . "\n";
print $result->{'message'} . "\n";


# Logout
print "logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit;
