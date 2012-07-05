#!/usr/bin/perl -w

# Sample perl script to demonstrate NetScaler API

# Output:
# > perl ~/setConfig.pl <NS IP> nsroot nsroot
# login: Done
# add service s1: Done
# add service s2: Done
# set service s1: Done
# bind monitor s1: Done
# bind monitor s2: Done
# add lb vserver vip_1: Done
# bind lb vserver s1: Done
# bind lb vserver s2: Done
# save ns config: Done
# logout: Done
# >

use SOAP::Lite;			# troubleshoot: append: +trace=>"debug";
import SOAP::Data 'name';	# to set data values (q.v.)
use HTTP::Cookies;		# server uses client cookie for auth

## BEGIN CONFIGURATION.

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

# Add some services
print "add service s1: ";
$result = $soap->addservice( name('name' => 's1'),
							 name('IP' => '173.194.38.128'),
							 name('servicetype' => 'http'),
							 name('port' => '80') )
	->result;
print $result->{'message'} . "\n";
print "add service s2: ";
$result = $soap->addservice( name('name' => 's2'),
				      name('IP' => '173.194.38.129'),
				      name('servicetype' => 'http'),
				      name('port' => '80') )
	->result;
print $result->{'message'} . "\n";

# Modify a service
print "set service s1: ";
$result = $soap->setservice( name('name' => 's1'),
			     name('cacheable' => 'YES') )
	->result;
print $result->{'message'} . "\n";

# Bind monitors
print "bind monitor s1: ";
$result = $soap->bindlbmonitor( name('monitorname' => 'http'),
				       name('servicename' => 's1') )
	->result;
print $result->{'message'} . "\n";

print "bind monitor s2: ";
$result = $soap->bindlbmonitor( name('monitorname' => 'http'),
					name('servicename' => 's2') )
	->result;
print $result->{'message'} . "\n";

# Add a load-balancing vserver
print "add lb vserver vip_1: ";
$result = $soap->addlbvserver( name('name' => 'vip_1'),
					 name('servicetype' => 'http'),
					 name('IPaddress' => '10.0.1.32'),
					 name('port' => '80'),
					 name('lbmethod' => 'roundrobin') )
	->result;
print $result->{'message'} . "\n";

# Bind services to vserver
print "bind lb vserver s1: ";
$result = $soap->bindlbvserver( name('name' => 'vip_1'),
					   name('servicename' => 's1') )
	->result;
print $result->{'message'} . "\n";

print "bind lb vserver s2: ";
$result = $soap->bindlbvserver( name('name' => 'vip_1'),
					    name('servicename' => 's2') )
	->result;
print $result->{'message'} . "\n";

# Save configuration
print "save ns config: ";
$result = $soap->savensconfig()->result;
print $result->{'message'} . "\n";

# Logout
print "logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit;
