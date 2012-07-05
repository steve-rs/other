#!perl -w

# Sample perl script, removes configuration that was added by setConfig.pl

# Output:
# > perl ~/rmConfig.pl <NS IP> nsroot nsroot
# login: Done
# rm vserver vip_1: Done
# rm service s1: Done
# rm service s2: Done
# save ns config: Done
# logout: Done
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

# Remove entities created by setConfig.pl
print "rm vserver vip_1: ";
$result = $soap->rmvserver( name('name' => 'vip_1') )->result;
print $result->{'message'} . "\n";
print "rm service s1: ";
$result = $soap->rmservice( name('name' => 's1') )->result;
print $result->{'message'} . "\n";
print "rm service s2: ";
$result = $soap->rmservice( name('name' => 's2') )->result;
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
