#!/usr/bin/perl -w

# Perl script to access NetScaler API

use SOAP::Lite;			# troubleshoot: append: +trace=>"debug";
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
if ($ENV{"SERVICE_GROUP_NAME"}) { $SERVICE_GROUP_NAME = $ENV{"SERVICE_GROUP_NAME"}; } else { die "SERVICE_GROUP_NAME unset!"; }
if ($ENV{"SERVICE_IP"}) { $SERVICE_IP = $ENV{"SERVICE_IP"}; } else { $SERVICE_IP = "127.0.0.1"; } # set to .e.g. "PRIVATE_IP"
if ($ENV{"SERVICE_PORT"}) { $SERVICE_PORT = $ENV{"SERVICE_PORT"}; } else { $SERVICE_PORT = "80"; }

print "NS_HOSTNAME = ", $NS_HOSTNAME, "\n";
print "NS_USERNAME = ", $NS_USERNAME, "\n";
print "NS_PASSWORD = ", $NS_PASSWORD, "\n";
print "SERVICE_GROUP_NAME = ", $SERVICE_GROUP_NAME, "\n";
print "SERVICE_IP = ", $SERVICE_IP, "\n";
print "SERVICE_PORT = ", $SERVICE_PORT, "\n";

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

##############################
# Add member to service group
print "Bind service group ip: SERVICEGROUPNAME=$SERVICE_GROUP_NAME IP=$SERVICE_IP PORT=$SERVICE_PORT: ";
$result = $soap->bindservicegroup_ip( name('servicegroupname' => $SERVICE_GROUP_NAME),
				 name('ip' => $SERVICE_IP),
				 name('port' => $SERVICE_PORT) )
	->result;
print $result->{'message'} . "\n";

##############################
## Remove member from service group
#print "Unbind service group ip: SERVICEGROUPNAME=$SERVICE_GROUP_NAME IP=$SERVICE_IP PORT=$SERVICE_PORT: ";
#$result = $soap->unbindservicegroup_ip( name('servicegroupname' => $SERVICE_GROUP_NAME),
#				 name('ip' => $SERVICE_IP),
#				 name('port' => $SERVICE_PORT) )
#	->result;
#print $result->{'message'} . "\n";

##############################
# Save configuration
print "Save ns config: ";
$result = $soap->savensconfig()->result;

if ($result->{rc}!=0) {
	die "Save ns config error: ", $result->{'message'}, "\n";
}

# Logout
print "Logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit 0;
