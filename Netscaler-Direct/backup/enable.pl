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

if ($ENV{"SERVICE_NAME"}) { $SERVICE_NAME = $ENV{"SERVICE_NAME"}; } else { die "SERVICE_NAME unset!"; }
if ($ENV{"NS_HOSTNAME"}) { $NS_HOSTNAME = $ENV{"NS_HOSTNAME"}; } else { $NS_HOSTNAME = "localhost"; }
if ($ENV{"NS_USERNAME"}) { $NS_USERNAME = $ENV{"NS_USERNAME"}; } else { $NS_USERNAME = "nsroot"; }
if ($ENV{"NS_PASSWORD"}) { $NS_PASSWORD = $ENV{"NS_PASSWORD"}; } else { $NS_PASSWORD = "nsroot"; }
if ($ENV{"LOCAL_IP"}) { $LOCAL_IP = $ENV{"LOCAL_IP"}; } else { $LOCAL_IP = "127.0.0.1"; } # set to .e.g. "PRIVATE_IP"
if ($ENV{"LOCAL_PORT"}) { $LOCAL_PORT = $ENV{"LOCAL_PORT"}; } else { $LOCAL_PORT = "80"; }
if ($ENV{"SERVICE_TYPE"}) { $SERVICE_TYPE = $ENV{"SERVICE_TYPE"}; } else { $SERVICE_TYPE = "http"; }
if ($ENV{"VSERVER_NAME"}) { $VSERVER_NAME = $ENV{"VSERVER_NAME"}; } else { $VSERVER_NAME = "www"; }
# TODO: Set SERVICE_NAME to RS_INSTANCE_UUID or RS_SERVER_NAME or ?
if ($ENV{"INSTANCE_ID"}) { $INSTANCE_ID = $ENV{"INSTANCE_ID"}; } else { $INSTANCE_ID = "unknown"; }

#RS_INSTANCE_UUID

# <does not work!> $ENV{"INSTANCE_ID"} ne "" ? $INSTANCE_ID = $ENV{"INSTANCE_ID"} : $INSTANCE_ID = "i-1234xyz";

print "NS_HOSTNAME = ", $NS_HOSTNAME, "\n";
print "NS_USERNAME = ", $NS_USERNAME, "\n";
print "NS_PASSWORD = ", $NS_PASSWORD, "\n";
print "INSTANCE_ID = ", $INSTANCE_ID, "\n";
print "SERVICE_TYPE = ", $SERVICE_TYPE, "\n";
print "LOCAL_IP = ", $LOCAL_IP, "\n";
print "LOCAL_PORT = ", $LOCAL_PORT, "\n";
print "VSERVER_NAME = ", $VSERVER_NAME, "\n";
print "SERVICE_NAME = ", $SERVICE_NAME, "\n";

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

# Add a service
print "Add service: '$SERVICE_NAME' '$LOCAL_IP' '$SERVICE_TYPE' '$LOCAL_PORT'\n";
$result = $soap->addservice( name('name' => $SERVICE_NAME),
				 name('IP' => $LOCAL_IP),
				 name('servicetype' => $SERVICE_TYPE),
				 name('port' => $LOCAL_PORT) )
	->result;
if ($result->{rc}!=0) {
	die "Add service error: ", $result->{'message'}, "\n";
}

# TODO: Add monitor page?
# Bind monitors
print "Bind monitor to service: '$SERVICE_TYPE' '$SERVICE_NAME'\n";
$result = $soap->bindlbmonitor( name('monitorname' => $SERVICE_TYPE),
				name('servicename' => $SERVICE_NAME) )
	->result;

if ($result->{rc}!=0) {
	print STDERR "Bind monitor error: ", $result->{'message'}, "\n";
	print STDERR "Removing service: ", $SERVICE_NAME, "\n";
	$result = $soap->rmservice( name('name' => $SERVICE_NAME) )->result;
	if ($result->{rc}!=0) {
		print STDERR "Could not remove service: ", $result->{'message'}, "\n";
	}
	die;
}

# Bind service to vserver
print "Bind lb vserver to service: '$VSERVER_NAME' '$SERVICE_NAME'\n";
$result = $soap->bindlbvserver( name('name' => $VSERVER_NAME),
				name('servicename' => $SERVICE_NAME) )
	->result;

if ($result->{rc}!=0) {
	print STDERR "Bind lb vserver to service error: ", $result->{'message'}, "\n";
	print STDERR "Removing service: ", $SERVICE_NAME, "\n";
	$result = $soap->rmservice( name('name' => $SERVICE_NAME) )->result;
	if ($result->{rc}!=0) {
		print STDERR "Could not remove service: ", $result->{'message'}, "\n";
	}
	die;
}

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
