#!/usr/bin/env perl


use Redis::Client;
use Data::Dumper;


my %host_app_hash = (
	"test1.example.com" => "app1_1_10",
	"test2.example.com" => "app2_1_10",
	"test3.example.com" => "app3_1_10",
	"test4.example.com" => "app4_1_10",
	"test5.example.com" => "app5_1_10",
);


my %app_info_hash = (
	"app1_1_10" => {	
		max_connections => 10000, 
		auth => 0,
		quota => 0,
		route_list => [
			"127.0.0.1:9001",
			"127.0.0.1:9002",
			"127.0.0.1:9003",
		],
		http_basic_auth => {
			username => "app1",
			password => "pass",
			method => "basic",
		}
	},

	"app2_1_10" => {
		max_connections => 10000, 
		auth => 0,
		quota => 0,
		route_list => [
			"127.0.0.1:9004",
			"127.0.0.1:9005",
		],
		http_basic_auth => {
			username => "app2",
			password => "pass",
			method => "basic",
		}
	},

	"app3_1_10" => {
		max_connections => 10000, 
		auth => 0,
		quota => 0,
		route_list => [
			"127.0.0.1:9004",
			"127.0.0.1:9005",
		],
		http_basic_auth => {
			username => "app3",
			password => "pass",
			method => "basic",
		}
	},

	"app4_1_10" => {
		max_connections => 10000, 
		auth => 0,
		quota => 0,
		route_list => [
			"127.0.0.1:9004",
			"127.0.0.1:9005",
		],
		http_basic_auth => {
			username => "app4",
			password => "pass",
			method => "basic",
		}
	},

	"app5_1_10" => {
		max_connections => 10000, 
		auth => 0,
		quota => 0,
		route_list => [
			"127.0.0.1:9004",
			"127.0.0.1:9005",
		],
		http_basic_auth => {
			username => "app5",
			password => "pass",
			method => "basic",
		}
	},


);


my %instance_digest_hash = (
	"127.0.0.1:9001" => "asdf1",
	"127.0.0.1:9002" => "asdf2",
	"127.0.0.1:9003" => "asdf3",
	"127.0.0.1:9004" => "asdf4",
	"127.0.0.1:9005" => "asdf5",

);

#print Dumper(%host_app_hash);
#print Dumper(%app_info_hash);
#print Dumper(%instance_digest_hash);


my $r = Redis::Client->new(host=>"127.0.0.1", port=>63790);
die "Connect to redis server failed." unless $r;


for my $host (keys (%host_app_hash)) {
	my $app_name = $host_app_hash{$host};
	print "host = $host, app_name = $app_name.\n";
	
	$r->set($host => $app_name);
	$r->lpush("app_domain_list", $host);

}

for my $app_name (values (%host_app_hash)) {
	my $app_hash = $app_info_hash{$app_name};
	my $app_route_list = $app_name."_instance_list";
#	die Dumper($app_hash);
#	die Dumper($$app_hash{max_connections});

	$r->hset($app_name, max_connections=>$$app_hash{max_connections});
	$r->hset($app_name, auth=>$$app_hash{auth});
	$r->hset($app_name, quota=>$$app_hash{quota});
	$r->hset($app_name, route_list=>$app_route_list);

	while (my $instance = shift $$app_hash{route_list}) {
		print "add route $instance to $app_route_list.\n";
		$r->lpush($app_route_list => $instance);
		$r->set($instance => $instance_digest_hash{$instance});
		my $key = $instance_digest_hash{$instance}."_$app_name";
		print "key = $key.\n";
		$r->set($key, $instance);	
	}

	my $app_auth_ref =  $$app_hash{http_basic_auth};
	my $auth_name = $app_name."_auth";
	$r->hset($auth_name, username=>$$app_auth_ref{username});
	$r->hset($auth_name, password=>$$app_auth_ref{password});
	$r->hset($auth_name, method=>$$app_auth_ref{method});
	print "auth_info : $auth_name, $$app_auth_ref{username}, $$app_auth_ref{password}, $$app_auth_ref{method}\n";
}


for my $instance (keys %instance_digest_hash) {
	$r->set($instance => $instance_digest_hash{$instance});

}
$r->quit;
