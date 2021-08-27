<?php

require_once 'configure.php';
require_once 'PDODataSource.php';
require_once 'simple_table.php';
require_once 'simpleselector.php';
$con = (new PDODataSource('hotel_california', 5432, 'db'))->getConnection();
$queryText = "select customer_name||' ('||customer_email||')' as name, customer_id as value,customer_name from customers order by 3";
$optionsCustomer = simpleOptionList($con, $queryText, []);
$queryText = "select item_description||' ('||item_cost_per_day||'/day)' as name, item_id as value,item_id from rental_items order by 3";
$optionsItem = simpleOptionList($con, $queryText, []);
include_once'reservation.html.php';
