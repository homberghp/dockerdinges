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

$makeReservationQuery = <<<'SQL'
with inp as (
         select ?::date start_reservation,?::date end_reservation, ?::integer as item_id, ?::integer as customer_id
     ),
     validres as (
         select start_reservation cstart_reservation, greatest(start_reservation+1,end_reservation) cend_reservation
          from inp
     ),
     cost as (
          select item_cost_per_day*(cend_reservation - cstart_reservation) rcost
          from validres,rental_items join inp on (inp.item_id=rental_items.item_id)
     ),
     makeres as (
          insert into reservations (during, item_id, for_customer,reservation_cost)
          select daterange(cstart_reservation,cend_reservation), item_id, customer_id, rcost
          from inp,validres,cost
          returning  *
  )
  -- final update to customer credit
  update customers set credit=credit-(select reservation_cost from makeres) where customer_id=(select customer_id  from inp)
       returning *
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
 * Remember that in php, an array is also a hashmap with key,value pairs
 * @param PDOConnection $conn
 * @param array $reservationParams
 */
function makeReservation(PDO $conn, array $reservationParams) : string {
   $result='';
    global $makeReservationQuery, $queryText2, $queryText3;
    try {
        $conn->beginTransaction();
        //echo "<pre>$queryText1</pre>";
        $stmt = $conn->prepare($makeReservationQuery);

        $stmt->execute([
            $reservationParams['date_from'],
            $reservationParams['date_to'],
            $reservationParams['item'],
            $reservationParams['account'],
        ]);

        $result .=resultsetToString($stmt, 'updated customer record');
        $conn->commit();
        $result .= simpleTableToString($conn, $queryText3, [$reservationParams['account']], 'transactions');
    } catch (PDOException $ex) {
        $results= "<div class='errors'><h3 >transaction failed with</h3>
              <pre >" . $ex->getMessage() . "</pre>
             </div>";
        $conn->rollBack();
    }
    return $result;
}

// phpinfo(INFO_VARIABLES);
$dates =preg_split("/\s\-\s/",$_POST['dates']);
$regex_filter=['options' =>[ 'regexp'=> '/^\d{4}-\d{2}-\d{2}/']];
$start_date = filter_var($dates[0], FILTER_VALIDATE_REGEXP, $regex_filter);
$end_date   = filter_var($dates[1], FILTER_VALIDATE_REGEXP, $regex_filter);
$item= filter_input(INPUT_POST,'item',FILTER_SANITIZE_NUMBER_INT);
$customer= filter_input(INPUT_POST,'customer',FILTER_SANITIZE_NUMBER_INT);
$customerTable= simpleTableToString($conn,"select * from customers order by 1", [], 'customers');
$reservationResult= makeReservation($conn, ['date_from' => $start_date,
    'date_to' => $end_date, 'item' => $item, 'account' => $customer]);
$queryText4 = <<<'SQL'
select * from reservations r join customers c on(c.customer_id=r.for_customer) join  rental_items using(item_id)
    order by 2 desc
SQL;
$reservationForUser= simpleTableToString($conn, $queryText4, [],'reservations');

// no more php logic or method calls below this line
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
        <link rel="stylesheet" type="text/css" href="css/style.css" />
    </head>
    <body>
        <h1>My Ugly transaction stats page</h1>
<?=$customerTable;?>
<?=$reservationResult;?>
<?=$reservationForUser;?>
<a href='reservation.php'> back to reservations</a>
</body>
</html>
