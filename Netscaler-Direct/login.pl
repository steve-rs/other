#!/usr/bin/perl -w

# Perl script to access NetScaler API

#use SOAP::Lite;			# troubleshoot: append: +trace=>"debug";
use SOAP::Lite +trace => 'debug';
import SOAP::Data 'name';	# to set data values (q.v.)
use HTTP::Cookies;		# server uses client cookie for auth

# Cookie object.  Server sends cookie for client authentication.
my $cookies = HTTP::Cookies->new(ignore_discard => 1, hide_cookie2 => 1);

##############################
## BEGIN CONFIGURATION.
# Temporary config

if ($ENV{"NS_HOSTNAME"}) { $NS_HOSTNAME = $ENV{"NS_HOSTNAME"}; } else { $NS_HOSTNAME = "localhost"; }
if ($ENV{"NS_USERNAME"}) { $NS_USERNAME = $ENV{"NS_USERNAME"}; } else { $NS_USERNAME = "nsroot"; }
if ($ENV{"NS_PASSWORD"}) { $NS_PASSWORD = $ENV{"NS_PASSWORD"}; } else { $NS_PASSWORD = "nsroot"; }

##############################

# Create the soap object
my $soap = SOAP::Lite
    # service URI and cookie object
    -> proxy("http://$NS_HOSTNAME/soap", cookie_jar=>$cookies)
    ;

# Log on
print "login: ";
my $result = $soap->login( name('username'=>$NS_USERNAME), 
			   name('password'=>$NS_PASSWORD) )
	->result;
print $result->{'message'} . "\n";

# Logout
print "Logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit 0;
