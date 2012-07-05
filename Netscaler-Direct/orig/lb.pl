use SOAP::Lite;		# troubleshoot: append: +trace=>"debug";
import SOAP::Data 'name';		# to set data values (q.v.)
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
print $result->{'message'} ."\n";
	

 $result = $soap->enablensfeature(name('feature'=> 'LB' ))	->result;
print "enablensfeature LB:" . $result->{'message'}."\n";

 $result = $soap->addserver(name('name'=> 's1' ),name('ipaddress'=> '10.102.3.81' ),name('domain'=> '' ),name('state'=> 'VALNOTSET' ))	->result;
print "addserver s1:" . $result->{'message'}."\n";

 $result = $soap->addserver(name('name'=> 's2' ),name('ipaddress'=> '10.102.3.82' ),name('domain'=> '' ),name('state'=> 'VALNOTSET' ))	->result;
print "addserver s2:" . $result->{'message'}."\n";

 $result = $soap->addservice(name('name'=> 'svc1' ),name('ip'=> '' ),name('servername'=> 's1' ),name('servicetype'=> 'HTTP' ),name('port'=> '80' ),name('cleartextport'=> '0xFFFFFFFF' ),name('cachetype'=> 'VALNOTSET' ),name('state'=> 'VALNOTSET' ))	->result;
print "addservice svc1:" . $result->{'message'}."\n";

 $result = $soap->addservice(name('name'=> 'svc2' ),name('ip'=> '' ),name('servername'=> 's2' ),name('servicetype'=> 'HTTP' ),name('port'=> '80' ),name('cleartextport'=> '0xFFFFFFFF' ),name('cachetype'=> 'VALNOTSET' ),name('state'=> 'VALNOTSET' ))	->result;
print "addservice svc2:" . $result->{'message'}."\n";

 $result = $soap->getserver(name('name'=> '' ),name('internaL'=> 'false' ))	->result;
print "getserver null:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinternaL::$obj->{internaL}\tipaddress::$obj->{ipaddress}\tstate::$obj->{state}\tdomain::$obj->{domain}\tdomainresolveretry::$obj->{domainresolveretry}\tservicename::$obj->{servicename}\tservicegroupname::$obj->{servicegroupname}\ttranslationip::$obj->{translationip}\ttranslationmask::$obj->{translationmask}";
}
}

 $result = $soap->getservice(name('name'=> '' ),name('all'=> 'false' ),name('internaL'=> 'false' ))	->result;
print "getservice null:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tall::$obj->{all}\tinternaL::$obj->{internaL}\tservername::$obj->{servername}\tservicetype::$obj->{servicetype}\tserviceconftype::$obj->{serviceconftype}\tport::$obj->{port}\tvalue::$obj->{value}\tcleartextport::$obj->{cleartextport}\tgslb::$obj->{gslb}\tcachetype::$obj->{cachetype}\tmaxclient::$obj->{maxclient}\tmaxreq::$obj->{maxreq}\tcacheable::$obj->{cacheable}\tcip::$obj->{cip}\tcipheader::$obj->{cipheader}\tusip::$obj->{usip}\tuseproxyport::$obj->{useproxyport}\tsc::$obj->{sc}\tweight::$obj->{weight}\tsp::$obj->{sp}\trtspsessionidremap::$obj->{rtspsessionidremap}\tfailedprobes::$obj->{failedprobes}\tclttimeout::$obj->{clttimeout}\ttotalprobes::$obj->{totalprobes}\tsvrtimeout::$obj->{svrtimeout}\tserverid::$obj->{serverid}\tcka::$obj->{cka}\ttcpb::$obj->{tcpb}\tcmp::$obj->{cmp}\tmaxbandwidth::$obj->{maxbandwidth}\taccessdown::$obj->{accessdown}\tsvrstate::$obj->{svrstate}\tdelay::$obj->{delay}\tipaddress::$obj->{ipaddress}\tmonitorname::$obj->{monitorname}\tmonthreshold::$obj->{monthreshold}\tmonstate::$obj->{monstate}\tmonstatcode::$obj->{monstatcode}\tresponsetime::$obj->{responsetime}\tdownstateflush::$obj->{downstateflush}\tstatechangetimesec::$obj->{statechangetimesec}\tstatechangetimemsec::$obj->{statechangetimemsec}\ttimesincelaststatechange::$obj->{timesincelaststatechange}\ttickssincelaststatechange::$obj->{tickssincelaststatechange}\tstateupdatereason::$obj->{stateupdatereason}\trunningmonstate::$obj->{runningmonstate}\tscpolicyname::$obj->{scpolicyname}\tdospolicyname::$obj->{dospolicyname}";
}
}

 $result = $soap->addlbvserver(name('name'=> 'vlb1' ),name('servicetype'=> 'HTTP' ),name('ipaddress'=> '10.102.3.101' ),name('port'=> '80' ),name('range'=> '0xFFFFFFFF' ),name('state'=> 'VALNOTSET' ),name('vipheader'=> '' ))	->result;
print "addlbvserver vlb1:" . $result->{'message'}."\n";

 $result = $soap->addlbvserver(name('name'=> 'vlb2' ),name('servicetype'=> 'SSL' ),name('ipaddress'=> '10.102.3.102' ),name('port'=> '443' ),name('range'=> '0xFFFFFFFF' ),name('state'=> 'VALNOTSET' ),name('vipheader'=> '' ))	->result;
print "addlbvserver vlb2:" . $result->{'message'}."\n";

 $result = $soap->getlbvserver(name('name'=> 'vlb1' ))	->result;
print "getlbvserver vlb1:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinsertvserveripport::$obj->{insertvserveripport}\tvipheader::$obj->{vipheader}\tvalue::$obj->{value}\tipaddress::$obj->{ipaddress}\tipmapping::$obj->{ipmapping}\tport::$obj->{port}\trange::$obj->{range}\tservicetype::$obj->{servicetype}\ttype::$obj->{type}\tstate::$obj->{state}\teffectivestate::$obj->{effectivestate}\tstatus::$obj->{status}\tlbrrreason::$obj->{lbrrreason}\tcachetype::$obj->{cachetype}\tredirect::$obj->{redirect}\tprecedence::$obj->{precedence}\tredirecturl::$obj->{redirecturl}\tauthentication::$obj->{authentication}\thomepage::$obj->{homepage}\tdnsvservername::$obj->{dnsvservername}\tdomain::$obj->{domain}\tpolicyname::$obj->{policyname}\tservicename::$obj->{servicename}\tweight::$obj->{weight}\tdynamicweight::$obj->{dynamicweight}\tcachevserver::$obj->{cachevserver}\tbackupvserver::$obj->{backupvserver}\tpriority::$obj->{priority}\tclttimeout::$obj->{clttimeout}\tsomethod::$obj->{somethod}\tsopersistence::$obj->{sopersistence}\tsopersistencetimeout::$obj->{sopersistencetimeout}\tsothreshold::$obj->{sothreshold}\tlbmethod::$obj->{lbmethod}\thashlength::$obj->{hashlength}\tdataoffset::$obj->{dataoffset}\thealth::$obj->{health}\tdatalength::$obj->{datalength}\tnetmask::$obj->{netmask}\trule::$obj->{rule}\tresrule::$obj->{resrule}\tgotopriorityexpression::$obj->{gotopriorityexpression}\truletype::$obj->{ruletype}\tgroupname::$obj->{groupname}\tm::$obj->{m}\tpersistencetype::$obj->{persistencetype}\ttimeout::$obj->{timeout}\tcookiedomain::$obj->{cookiedomain}\tpersistmask::$obj->{persistmask}\tpersistencebackup::$obj->{persistencebackup}\tbackuppersistencetimeout::$obj->{backuppersistencetimeout}\tcacheable::$obj->{cacheable}\tpq::$obj->{pq}\tsc::$obj->{sc}\trtspnat::$obj->{rtspnat}\tsessionless::$obj->{sessionless}\tmap::$obj->{map}\tconnfailover::$obj->{connfailover}\tredirectportrewrite::$obj->{redirectportrewrite}\tdownstateflush::$obj->{downstateflush}\tdisableprimaryondown::$obj->{disableprimaryondown}\tthresholdvalue::$obj->{thresholdvalue}\tinvoke::$obj->{invoke}\tlabeltype::$obj->{labeltype}\tlabelname::$obj->{labelname}\tcookieipport::$obj->{cookieipport}\tvserverid::$obj->{vserverid}\tversion::$obj->{version}\ttotalservices::$obj->{totalservices}\tactiveservices::$obj->{activeservices}\tstatechangetimesec::$obj->{statechangetimesec}\tstatechangetimemsec::$obj->{statechangetimemsec}\ttickssincelaststatechange::$obj->{tickssincelaststatechange}\thits::$obj->{hits}\tsvcipaddress::$obj->{svcipaddress}\tsvcport::$obj->{svcport}\tsvctype::$obj->{svctype}\tsvcstate::$obj->{svcstate}\tservicegroupname::$obj->{servicegroupname}\tscpolicyname::$obj->{scpolicyname}\tscpolicypriority::$obj->{scpolicypriority}\tdospolicyname::$obj->{dospolicyname}\tdospolicypriority::$obj->{dospolicypriority}\trwpolicyname::$obj->{rwpolicyname}\trwpolicypriority::$obj->{rwpolicypriority}\trwpolicygotoprioexpression::$obj->{rwpolicygotoprioexpression}\trwpolicybindpoint::$obj->{rwpolicybindpoint}\trwinvoke::$obj->{rwinvoke}\trwpolicyinvokelabeltype::$obj->{rwpolicyinvokelabeltype}\trwpolicyinvokelabelname::$obj->{rwpolicyinvokelabelname}\tcachepolicyname::$obj->{cachepolicyname}\tcachepolicypriority::$obj->{cachepolicypriority}\tcachepolicygotoprioexpression::$obj->{cachepolicygotoprioexpression}\tcachepolicybindpoint::$obj->{cachepolicybindpoint}\tcacheinvoke::$obj->{cacheinvoke}\tcachepolicyinvokelabeltype::$obj->{cachepolicyinvokelabeltype}\tcachepolicyinvokelabelname::$obj->{cachepolicyinvokelabelname}\trsppolicyname::$obj->{rsppolicyname}\trsppolicypriority::$obj->{rsppolicypriority}\trsppolicygotoprioexpression::$obj->{rsppolicygotoprioexpression}\trspinvoke::$obj->{rspinvoke}\trsppolicyinvokelabeltype::$obj->{rsppolicyinvokelabeltype}\trsppolicyinvokelabelname::$obj->{rsppolicyinvokelabelname}\tcsvserver::$obj->{csvserver}\tcswpolicyname::$obj->{cswpolicyname}\tpriority::$obj->{priority}";
}
}

 $result = $soap->getlbvserver(name('name'=> 'vlb2' ))	->result;
print "getlbvserver vlb2:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinsertvserveripport::$obj->{insertvserveripport}\tvipheader::$obj->{vipheader}\tvalue::$obj->{value}\tipaddress::$obj->{ipaddress}\tipmapping::$obj->{ipmapping}\tport::$obj->{port}\trange::$obj->{range}\tservicetype::$obj->{servicetype}\ttype::$obj->{type}\tstate::$obj->{state}\teffectivestate::$obj->{effectivestate}\tstatus::$obj->{status}\tlbrrreason::$obj->{lbrrreason}\tcachetype::$obj->{cachetype}\tredirect::$obj->{redirect}\tprecedence::$obj->{precedence}\tredirecturl::$obj->{redirecturl}\tauthentication::$obj->{authentication}\thomepage::$obj->{homepage}\tdnsvservername::$obj->{dnsvservername}\tdomain::$obj->{domain}\tpolicyname::$obj->{policyname}\tservicename::$obj->{servicename}\tweight::$obj->{weight}\tdynamicweight::$obj->{dynamicweight}\tcachevserver::$obj->{cachevserver}\tbackupvserver::$obj->{backupvserver}\tpriority::$obj->{priority}\tclttimeout::$obj->{clttimeout}\tsomethod::$obj->{somethod}\tsopersistence::$obj->{sopersistence}\tsopersistencetimeout::$obj->{sopersistencetimeout}\tsothreshold::$obj->{sothreshold}\tlbmethod::$obj->{lbmethod}\thashlength::$obj->{hashlength}\tdataoffset::$obj->{dataoffset}\thealth::$obj->{health}\tdatalength::$obj->{datalength}\tnetmask::$obj->{netmask}\trule::$obj->{rule}\tresrule::$obj->{resrule}\tgotopriorityexpression::$obj->{gotopriorityexpression}\truletype::$obj->{ruletype}\tgroupname::$obj->{groupname}\tm::$obj->{m}\tpersistencetype::$obj->{persistencetype}\ttimeout::$obj->{timeout}\tcookiedomain::$obj->{cookiedomain}\tpersistmask::$obj->{persistmask}\tpersistencebackup::$obj->{persistencebackup}\tbackuppersistencetimeout::$obj->{backuppersistencetimeout}\tcacheable::$obj->{cacheable}\tpq::$obj->{pq}\tsc::$obj->{sc}\trtspnat::$obj->{rtspnat}\tsessionless::$obj->{sessionless}\tmap::$obj->{map}\tconnfailover::$obj->{connfailover}\tredirectportrewrite::$obj->{redirectportrewrite}\tdownstateflush::$obj->{downstateflush}\tdisableprimaryondown::$obj->{disableprimaryondown}\tthresholdvalue::$obj->{thresholdvalue}\tinvoke::$obj->{invoke}\tlabeltype::$obj->{labeltype}\tlabelname::$obj->{labelname}\tcookieipport::$obj->{cookieipport}\tvserverid::$obj->{vserverid}\tversion::$obj->{version}\ttotalservices::$obj->{totalservices}\tactiveservices::$obj->{activeservices}\tstatechangetimesec::$obj->{statechangetimesec}\tstatechangetimemsec::$obj->{statechangetimemsec}\ttickssincelaststatechange::$obj->{tickssincelaststatechange}\thits::$obj->{hits}\tsvcipaddress::$obj->{svcipaddress}\tsvcport::$obj->{svcport}\tsvctype::$obj->{svctype}\tsvcstate::$obj->{svcstate}\tservicegroupname::$obj->{servicegroupname}\tscpolicyname::$obj->{scpolicyname}\tscpolicypriority::$obj->{scpolicypriority}\tdospolicyname::$obj->{dospolicyname}\tdospolicypriority::$obj->{dospolicypriority}\trwpolicyname::$obj->{rwpolicyname}\trwpolicypriority::$obj->{rwpolicypriority}\trwpolicygotoprioexpression::$obj->{rwpolicygotoprioexpression}\trwpolicybindpoint::$obj->{rwpolicybindpoint}\trwinvoke::$obj->{rwinvoke}\trwpolicyinvokelabeltype::$obj->{rwpolicyinvokelabeltype}\trwpolicyinvokelabelname::$obj->{rwpolicyinvokelabelname}\tcachepolicyname::$obj->{cachepolicyname}\tcachepolicypriority::$obj->{cachepolicypriority}\tcachepolicygotoprioexpression::$obj->{cachepolicygotoprioexpression}\tcachepolicybindpoint::$obj->{cachepolicybindpoint}\tcacheinvoke::$obj->{cacheinvoke}\tcachepolicyinvokelabeltype::$obj->{cachepolicyinvokelabeltype}\tcachepolicyinvokelabelname::$obj->{cachepolicyinvokelabelname}\trsppolicyname::$obj->{rsppolicyname}\trsppolicypriority::$obj->{rsppolicypriority}\trsppolicygotoprioexpression::$obj->{rsppolicygotoprioexpression}\trspinvoke::$obj->{rspinvoke}\trsppolicyinvokelabeltype::$obj->{rsppolicyinvokelabeltype}\trsppolicyinvokelabelname::$obj->{rsppolicyinvokelabelname}\tcsvserver::$obj->{csvserver}\tcswpolicyname::$obj->{cswpolicyname}\tpriority::$obj->{priority}";
}
}

 $result = $soap->bindlbvserver_service(name('name'=> 'vlb1' ),name('servicename'=> 'svc1' ),name('weight'=> '0xFFFFFFFF' ))	->result;
print "bindlbvserver_service vlb1:" . $result->{'message'}."\n";

 $result = $soap->bindlbvserver_service(name('name'=> 'vlb1' ),name('servicename'=> 'svc2' ),name('weight'=> '0xFFFFFFFF' ))	->result;
print "bindlbvserver_service vlb1:" . $result->{'message'}."\n";

 $result = $soap->bindlbvserver_service(name('name'=> 'vlb2' ),name('servicename'=> 'svc1' ),name('weight'=> '0xFFFFFFFF' ))	->result;
print "bindlbvserver_service vlb2:" . $result->{'message'}."\n";

 $result = $soap->bindlbvserver_service(name('name'=> 'vlb2' ),name('servicename'=> 'svc2' ),name('weight'=> '0xFFFFFFFF' ))	->result;
print "bindlbvserver_service vlb2:" . $result->{'message'}."\n";

 $result = $soap->getvserver(name('name'=> 'vlb1' ))	->result;
print "getvserver vlb1:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinsertvserveripport::$obj->{insertvserveripport}\tvipheader::$obj->{vipheader}\tipaddress::$obj->{ipaddress}\tport::$obj->{port}\trange::$obj->{range}\tservicetype::$obj->{servicetype}\tvalue::$obj->{value}\ttype::$obj->{type}\tstate::$obj->{state}\teffectivestate::$obj->{effectivestate}\tstatus::$obj->{status}\tcachetype::$obj->{cachetype}\tredirect::$obj->{redirect}\tprecedence::$obj->{precedence}\tredirecturl::$obj->{redirecturl}\tauthentication::$obj->{authentication}\thomepage::$obj->{homepage}\tdnsvservername::$obj->{dnsvservername}\tdomain::$obj->{domain}\trule::$obj->{rule}\tpolicyname::$obj->{policyname}\thits::$obj->{hits}\tservicename::$obj->{servicename}\tweight::$obj->{weight}\tcachevserver::$obj->{cachevserver}\tbackupvserver::$obj->{backupvserver}\tpriority::$obj->{priority}\tclttimeout::$obj->{clttimeout}\tsomethod::$obj->{somethod}\tsopersistence::$obj->{sopersistence}\tsothreshold::$obj->{sothreshold}\tlbmethod::$obj->{lbmethod}\thashlength::$obj->{hashlength}\tdataoffset::$obj->{dataoffset}\tdatalength::$obj->{datalength}\tnetmask::$obj->{netmask}\tgroupname::$obj->{groupname}\tm::$obj->{m}\tpersistencetype::$obj->{persistencetype}\tcookiedomain::$obj->{cookiedomain}\tpersistmask::$obj->{persistmask}\tpersistencebackup::$obj->{persistencebackup}\ttimeout::$obj->{timeout}\tcacheable::$obj->{cacheable}\tpq::$obj->{pq}\tsc::$obj->{sc}\tsessionless::$obj->{sessionless}\turl::$obj->{url}\treuse::$obj->{reuse}\tdestinationvserver::$obj->{destinationvserver}\tvia::$obj->{via}\tflags::$obj->{flags}\tconnfailover::$obj->{connfailover}\tcasesensitive::$obj->{casesensitive}\tredirectportrewrite::$obj->{redirectportrewrite}\tdownstateflush::$obj->{downstateflush}\tcookieipport::$obj->{cookieipport}\tvserverid::$obj->{vserverid}\tversion::$obj->{version}\ttotalservices::$obj->{totalservices}\tactiveservices::$obj->{activeservices}";
}
}

 $result = $soap->getvserver(name('name'=> 'vlb2' ))	->result;
print "getvserver vlb2:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinsertvserveripport::$obj->{insertvserveripport}\tvipheader::$obj->{vipheader}\tipaddress::$obj->{ipaddress}\tport::$obj->{port}\trange::$obj->{range}\tservicetype::$obj->{servicetype}\tvalue::$obj->{value}\ttype::$obj->{type}\tstate::$obj->{state}\teffectivestate::$obj->{effectivestate}\tstatus::$obj->{status}\tcachetype::$obj->{cachetype}\tredirect::$obj->{redirect}\tprecedence::$obj->{precedence}\tredirecturl::$obj->{redirecturl}\tauthentication::$obj->{authentication}\thomepage::$obj->{homepage}\tdnsvservername::$obj->{dnsvservername}\tdomain::$obj->{domain}\trule::$obj->{rule}\tpolicyname::$obj->{policyname}\thits::$obj->{hits}\tservicename::$obj->{servicename}\tweight::$obj->{weight}\tcachevserver::$obj->{cachevserver}\tbackupvserver::$obj->{backupvserver}\tpriority::$obj->{priority}\tclttimeout::$obj->{clttimeout}\tsomethod::$obj->{somethod}\tsopersistence::$obj->{sopersistence}\tsothreshold::$obj->{sothreshold}\tlbmethod::$obj->{lbmethod}\thashlength::$obj->{hashlength}\tdataoffset::$obj->{dataoffset}\tdatalength::$obj->{datalength}\tnetmask::$obj->{netmask}\tgroupname::$obj->{groupname}\tm::$obj->{m}\tpersistencetype::$obj->{persistencetype}\tcookiedomain::$obj->{cookiedomain}\tpersistmask::$obj->{persistmask}\tpersistencebackup::$obj->{persistencebackup}\ttimeout::$obj->{timeout}\tcacheable::$obj->{cacheable}\tpq::$obj->{pq}\tsc::$obj->{sc}\tsessionless::$obj->{sessionless}\turl::$obj->{url}\treuse::$obj->{reuse}\tdestinationvserver::$obj->{destinationvserver}\tvia::$obj->{via}\tflags::$obj->{flags}\tconnfailover::$obj->{connfailover}\tcasesensitive::$obj->{casesensitive}\tredirectportrewrite::$obj->{redirectportrewrite}\tdownstateflush::$obj->{downstateflush}\tcookieipport::$obj->{cookieipport}\tvserverid::$obj->{vserverid}\tversion::$obj->{version}\ttotalservices::$obj->{totalservices}\tactiveservices::$obj->{activeservices}";
}
}

 $result = $soap->bindlbgroup_vserver(name('name'=> 'grp1' ),name('vservername'=> 'vlb1,vlb2' ))	->result;
print "bindlbgroup_vserver grp1:" . $result->{'message'}."\n";

 $result = $soap->getlbgroup(name('name'=> 'grp1' ))	->result;
print "getlbgroup grp1:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tvservername::$obj->{vservername}\tpersistencetype::$obj->{persistencetype}\tpersistencebackup::$obj->{persistencebackup}\tbackuppersistencetimeout::$obj->{backuppersistencetimeout}\tpersistmask::$obj->{persistmask}\tcookiedomain::$obj->{cookiedomain}\ttimeout::$obj->{timeout}";
}
}

 $result = $soap->setlbgroup_persistencetype(name('name'=> 'grp1' ),name('persistencetype'=> 'COOKIEINSERT' ))	->result;
print "setlbgroup_persistencetype grp1:" . $result->{'message'}."\n";

 $result = $soap->setlbgroup_timeout(name('name'=> 'grp1' ),name('timeout'=> '10' ))	->result;
print "setlbgroup_timeout grp1:" . $result->{'message'}."\n";

 $result = $soap->getlbgroup(name('name'=> 'grp1' ))	->result;
print "getlbgroup grp1:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tvservername::$obj->{vservername}\tpersistencetype::$obj->{persistencetype}\tpersistencebackup::$obj->{persistencebackup}\tbackuppersistencetimeout::$obj->{backuppersistencetimeout}\tpersistmask::$obj->{persistmask}\tcookiedomain::$obj->{cookiedomain}\ttimeout::$obj->{timeout}";
}
}

 $result = $soap->getvserver(name('name'=> '' ))	->result;
print "getvserver null:" . $result->{'message'}."\n";

if ($result->{rc}==0) {
foreach $obj (@{$result->{List}} ) {
print "name::$obj->{name}\tinsertvserveripport::$obj->{insertvserveripport}\tvipheader::$obj->{vipheader}\tipaddress::$obj->{ipaddress}\tport::$obj->{port}\trange::$obj->{range}\tservicetype::$obj->{servicetype}\tvalue::$obj->{value}\ttype::$obj->{type}\tstate::$obj->{state}\teffectivestate::$obj->{effectivestate}\tstatus::$obj->{status}\tcachetype::$obj->{cachetype}\tredirect::$obj->{redirect}\tprecedence::$obj->{precedence}\tredirecturl::$obj->{redirecturl}\tauthentication::$obj->{authentication}\thomepage::$obj->{homepage}\tdnsvservername::$obj->{dnsvservername}\tdomain::$obj->{domain}\trule::$obj->{rule}\tpolicyname::$obj->{policyname}\thits::$obj->{hits}\tservicename::$obj->{servicename}\tweight::$obj->{weight}\tcachevserver::$obj->{cachevserver}\tbackupvserver::$obj->{backupvserver}\tpriority::$obj->{priority}\tclttimeout::$obj->{clttimeout}\tsomethod::$obj->{somethod}\tsopersistence::$obj->{sopersistence}\tsothreshold::$obj->{sothreshold}\tlbmethod::$obj->{lbmethod}\thashlength::$obj->{hashlength}\tdataoffset::$obj->{dataoffset}\tdatalength::$obj->{datalength}\tnetmask::$obj->{netmask}\tgroupname::$obj->{groupname}\tm::$obj->{m}\tpersistencetype::$obj->{persistencetype}\tcookiedomain::$obj->{cookiedomain}\tpersistmask::$obj->{persistmask}\tpersistencebackup::$obj->{persistencebackup}\ttimeout::$obj->{timeout}\tcacheable::$obj->{cacheable}\tpq::$obj->{pq}\tsc::$obj->{sc}\tsessionless::$obj->{sessionless}\turl::$obj->{url}\treuse::$obj->{reuse}\tdestinationvserver::$obj->{destinationvserver}\tvia::$obj->{via}\tflags::$obj->{flags}\tconnfailover::$obj->{connfailover}\tcasesensitive::$obj->{casesensitive}\tredirectportrewrite::$obj->{redirectportrewrite}\tdownstateflush::$obj->{downstateflush}\tcookieipport::$obj->{cookieipport}\tvserverid::$obj->{vserverid}\tversion::$obj->{version}\ttotalservices::$obj->{totalservices}\tactiveservices::$obj->{activeservices}";
}
}

 $result = $soap->addsslcertkey(name('certkeyname'=> 'test_cert' ),name('cert'=> '/nsconfig/ssl/1024cert.pem' ),name('key'=> '/nsconfig/ssl/1024key.pem' ),name('password'=> 'false' ),name('fipskey'=> '' ),name('inform'=> 'VALNOTSET' ),name('expirymonitor'=> 'VALNOTSET' ),name('notificationperiod'=> '0xFFFFFFFF' ))	->result;
print "addsslcertkey test_cert:" . $result->{'message'}."\n";

 $result = $soap->bindsslcertkey_vserver(name('certkeyname'=> 'test_cert' ),name('vservername'=> 'vlb2' ),name('vserver'=> 'false' ))	->result;
print "bindsslcertkey_vserver test_cert:" . $result->{'message'}."\n";
# Logout
print "logout: ";
$result = $soap->logout()->result;
print $result->{'message'} . "\n";

exit;
