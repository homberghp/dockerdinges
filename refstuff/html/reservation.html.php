<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Simple Hotel Reservations</title>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
        <link rel="stylesheet" type="text/css" href="css/style.css" />
    </head>
    <body>
        <p>Make your reservations here</p>
        <?php
        print_simple_table($con, "select * from customers order by 2", [], 'customers');
        print_simple_table($con, "select * from rental_items order by 2", [],'items');
        //echo "<pre>$queryText3</pre>";
        $queryText4 = <<<'SQL'
        select r.*,c.customer_name,c.customer_email,ri.* from reservations r 
        join customers c on(c.customer_id=r.for_customer) join  rental_items ri using(item_id)
        order by 2 desc
        SQL;
        print_simple_table($con, $queryText4, [],'customer and reservations ');

        ?>
        <form action="transactionexample.php" method="post"><span>For customer
            <select name="customer">
                <?= $optionsCustomer ?>
            </select> reserve:
            <select name="item">
                <?= $optionsItem ?>
            </select></span><br/>
            <input name="dates" type="text"/>
            <button type='submit'>Book</button>
        </form>
        <script type="text/javascript" style="font-size: 120%;">
            $('input[name="dates"]').daterangepicker({
                "showWeekNumbers": false,
                "showISOWeekNumbers": false,
                "timePicker24Hour": true,
                "alwaysShowCalendars": true,
                locale: {format: 'YYYY-MM-DD'}

            });
        </script>
    </body>
</html>
