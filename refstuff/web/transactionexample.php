<?php

/**
 * Transaction example. Make a reservation against an item, debiting an account.
 */

require_once 'PDODataSource.php';
require_once 'simple_table.php';
/**
 * Typically you create the connection once, and use it throughout the processing of the request to a response.
 */
$ds = new PDODataSource("presidentDB");
$conn = $ds->getConnection();

/**
 * Make a reservation. At least two tables are involved, the credits table and the resource (what to reserve) table.
 * @param PDOConnection $conn
 * @param array $reservationParams
 */
function makeReservation( PDOConnection $conn, array $reservationParams ) {
    $queryText1 = <<<'SQL'
insert into reservation (date_from, date_to, item, for_customer) values(?,?,?,?)
SQL;
    $queryText2 = <<<'SQL'
update accounts set credit=credit-? where account_id=?
SQL;
    // prints out current bill
    $queryText3 = <<<'SQL'
select * from reservation r join accounts a on(a.account_id=r.for_customer) 
    where c.account=?
SQL;
    try {
        $conn->beginTransaction();
        $stmt1 = $conn->prepare( $queryText1 );
        $stmt1->execute( [
            $reservationParams[ 'date_from' ],
            $reservationParams[ 'date_to' ],
            $reservationParams[ 'item' ],
            $reservationParams[ 'account' ]
        ] );
        $stmt2 = $conn->prepare( $queryText2 );
        $stmt2->execute( [
            $reservationParams[ 'total_cost' ],
            $reservationParams[ 'account' ]
        ] );
        $conn->commit();

        print_simple_table( $conn, $queryText3, $reservationParams[ 'account' ] );
    } catch ( PDOException $ex ) {
        $conn->rollBack();
    }
}
