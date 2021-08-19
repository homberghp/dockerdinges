<?php
/**
 * @author Pieter van den Hombergh {@code <pieter.van.den.hombergh@gmail.com>}
 */
require_once 'configure.php';
/**
 * Put lib outside web directory, so that the files cannot be read by pointing at them using the browser.
 * The connection configuration parameters are NOT part of the application source code tree, 
 * although they are contained a simple php file, but 
 * inside a directory that is NOT in the include_path nor below the web url.
 * 
 */
require_once 'PDODataSource.php';
require_once 'simple_table.php';
/**
 * Typically you create the connection once, e.g. at login/auth time and use it 
 * throughout the processing of the request to a response.
 */
$ds = (new PDODataSource("presidents"))->setHost('db');
$conn = $ds->getConnection();


/**
 * Using this kind of formatting for query text and prepared statements is both readable
 * and safe, because you can write your SQL in a natural way and no variable interpretation is done, 
 * so SQL injection is avoided too.
 */
$sql = <<<'SQL'
select  pres.id as pres_id,
        pres.name as pres_name, 
        years_served, 
        party, 
        state.name as state_name,
        year_entered 
    from  president  pres
    join state on(state_id_born=state.id) 
    where state.name=? and pres.party=?
SQL;
?>
<!DOCTYPE html>
<html>

    <head lang='en'>
        <style type='text/css'>
            .num{text-align: right;}
            .simple-table {border-width:1px;border-collapse:collapse}
            tr:nth-child(even) {background: rgba(255,255,255,0.3)}
            tr:nth-child(odd) {background: rgba(192,192,255,0.3)}
        </style>
    </head>
    <body>
        <h1>My Ugly demo pages</h1>
        <?php print_simple_table($conn, $sql, ['TEXAS', 'DEMOCRATIC']); ?>

        <h2>Try web page <a href='reservation.php'>hotel california reservation</a> too</h2>
    </body>
</html>
