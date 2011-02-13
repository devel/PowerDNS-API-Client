use Test::More;

my $user     = $ENV{API_USER};
my $password = $ENV{API_PASSWORD};

plan skip_all => "API_USER and API_PASSWORD environment variables must be set"
    unless $user and $password;

use_ok('PowerDNS::API::Client');
ok( my $api = PowerDNS::API::Client->new(
        user     => $user,
        password => $password,
        server   => 'http://localhost:5000/',
    )
);

my $testdomain = 'foo-' . time . ".test";

ok( my $r = $api->call(GET => 'domain/'), 'get list of domains');
isa_ok( $r->{domains}, 'ARRAY', 'got array of domains' );

ok( my $r = $api->call(PUT => 'domain/', domain => $testdomain ), 'add domain');
is( $r->{domain}->{name}, $testdomain, 'got right name back');
is( $r->{domain}->{type}, 'MASTER', 'is MASTER');

ok( my $r = $api->call(PUT => 'domain/', domain => $testdomain ), 'add duplicate domain');
is( $r->{error}, 'domain exists', 'got error indicating duplicate domain');
is( $r->{http_status}, 409, '409 status');

# TODO:
# ok( my $r = $api->call(DELETE => 'domain/', domain => $testdomain ), 'delete domain');



done_testing;
