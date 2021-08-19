<?php

require_once 'configure.php';
/**
 * Transaction example. Make a reservation against an item, debiting an account.
 */
require_once 'PDODataSource.php';
require_once 'simple_table.php';
/**
 * Typically you create the connection once, and use it throughout the processing of the request to a response.
 */
$ds = (new PDODataSource("hotel_california"))->setHost('db');
$conn = $ds->getConnection();

$queryText1 = <<<'SQL'
insert into reservations (during, item_id, for_customer,reservation_cost) values(daterange(?,?),?,?,?)
SQL;
$queryText2 = <<<'SQL'
update customers set credit=credit-? where customer_id=?
SQL;
// prints out current bill
$queryText3 = <<<'SQL'
select * from reservations r join customers c on(c.customer_id=r.for_customer) 
    where c.customer_id=? 
    order by 1
SQL;

/**
 * Make a reservation. At least two tables are involved, the credits table and the resource (what to reserve) table.
 * @param PDOConnection $conn
 * @param array $reservationParams
 */
function makeReservation(PDO $conn, array $reservationParams) {
    global $queryText1, $queryText2, $queryText3;
    try {
        $conn->beginTransaction();
        //echo "<pre>$queryText1</pre>";
        $stmt1 = $conn->prepare($queryText1);

        $stmt1->execute([
            $reservationParams['date_from'],
            $reservationParams['date_to'],
            $reservationParams['item'],
            $reservationParams['account'],
            $reservationParams['total_cost'],
        ]);
        $stmt2 = $conn->prepare($queryText2);
        $stmt2->execute([
            $reservationParams['total_cost'],
            $reservationParams['account']
        ]);
        $conn->commit();
        //echo "<pre>$queryText2</pre>";
        print_simple_table($conn, $queryText3, [$reservationParams['account']]);
    } catch (PDOException $ex) {
        echo "transaction failed with<pre style='color:#800;font-weight:bold'>" . $ex->getMessage() . "</pre>";
        $conn->rollBack();
    }
}

//phpinfo(INFO_VARIABLES);
$dates =preg_split("/\s\-\s/",$_POST['dates']);
$item= filter_input(INPUT_POST,'item',FILTER_SANITIZE_NUMBER_INT);
$customer= filter_input(INPUT_POST,'customer',FILTER_SANITIZE_NUMBER_INT);
$a = ['date_from' => $dates[0],
    'date_to' => $dates[1],
    'item' => $item,
    'total_cost' => 2 * 5.0,
    'account' => $customer];

?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Simple Hotel Reservations</title><style type='text/css'>
            .num{text-align: right;}
            .simple-table {border-width:1px;border-collapse:collapse}
            tr:nth-child(even) {background: rgba(255,255,255,0.3)}
            tr:nth-child(odd) {background: rgba(192,192,255,0.3)}
        </style>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    </head>
    <body>
<?php
print_simple_table($conn, "select * from customers order by 1", []);

makeReservation($conn, $a);
//echo "<pre>$queryText3</pre>";
$queryText4 = <<<'SQL'
select * from reservations r join customers c on(c.customer_id=r.for_customer) join  rental_items using(item_id)
    order by 1
SQL;
print_simple_table($conn, $queryText4, []);
?>
</body>
</html>