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
        <p>Make your reservations here</p>
        <?php
        print_simple_table($con, "select * from customers order by 2", []);
        print_simple_table($con, "select * from rental_items order by 2", []);
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
                "startDate": "2018-09-11",
                "endDate": "2018-09-14",
                locale: {format: 'YYYY-MM-DD'}

            });
        </script>
    </body>
</html>
