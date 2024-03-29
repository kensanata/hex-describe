# Copyright (C) 2021–2022  Alex Schroeder <alex@gnu.org>

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

use Modern::Perl;
use Test::More;
use Test::Mojo;
use utf8;

# No networking.
$ENV{HEX_DESCRIBE_OFFLINE} = 1;
my $t = Test::Mojo->new('Game::HexDescribe');

$t->get_ok('/')
    ->status_is(200)
    ->text_is('h1' => 'Hex Describe')
    ->text_like('textarea[name=map]' => qr/^0101 dark-green trees village$/m);

$t->get_ok('/rules')
    ->status_is(200)
    ->text_is('h1' => 'Hex Describe (rules)')
    ->element_exists('input[value="schroeder"]')
    ->text_like('input + a' => qr/Alex Schroeder/m);

$t->get_ok('/rules/list?load=schroeder')
    ->status_is(200)
    ->text_is('h1' => 'Hex Describe (list of rules)')
    ->content_like(qr/>orcs</);

$t->get_ok('/rule?rule=orcs&load=schroeder')
    ->status_is(200)
    ->text_is('h1' => 'Hex Descriptions (no map)')
    ->text_is('p a' => 'orcs')
    ->text_is('div.description p strong' => 'orcs');

done_testing;
