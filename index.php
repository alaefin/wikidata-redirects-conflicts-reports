<?php
// Name of the wiki ("elwiki", "itwikt", ...)
if ( !isset( $argv[1] ) ) {
    echo "No wiki provided, exiting...\n";
    return;
}
if ( !\in_array( $argv[1], \json_decode( \file_get_contents( __DIR__ . '/wikilist.json' ) ) ) ) {
    echo "Can't work with that wiki, exiting...\n";
    return;
}
$wiki = $argv[1];

// Instantiating PDO with the db replica credentials
$config = \parse_ini_file( __DIR__ . '/replica.my.cnf' );
try {
    $pdo = new \PDO( 'mysql:host=wikidatawiki.labsdb;dbname=wikidatawiki_p', $config['user'], $config['password'], [ \PDO::ATTR_EMULATE_PREPARES => false, \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION ] );

    // Performing the actual query formed by replacing the %1$s placeholder in sprintf.sql .
    // This could use some 'SELECT ... INTO outfile' magic,
    // but FILE wasn't GRANTed on `%\_p`.* ,
    // and I'd rather avoid an additional step involving `s<id>\_\_%`.* .
    // Maybe this avoidance isn't rooted in anything ?
    $resultset = $pdo->query( \sprintf( \file_get_contents( __DIR__ . '/sprintf.sql' ), $wiki ) );
    $report = \fopen( '/data/project/wikidata-redirects-conflicts-reports/report', 'w' );

    // Fetching the data and writing the CSV report outside public_html/ ,
    // so no incomplete report is published
    while ( $redirectConflict = $resultset->fetch( \PDO::FETCH_ASSOC ) ) {
        \fputcsv( $report, $redirectConflict);
    }

    // Moving the finished CSV report to public_html/
    \rename( '/data/project/wikidata-redirects-conflicts-reports/report', '/data/project/wikidata-redirects-conflicts-reports/public_html/' . $wiki . (new \DateTime( "now", new \DateTimeZone( 'UTC' ) ) )->format( 'Y-m-d' ) . '.csv' );
}
catch ( \Exception $e ) {
    \file_put_contents( __DIR__ . '/sqlexceptions.log', $e->getMessage(), \FILE_APPEND );
}
