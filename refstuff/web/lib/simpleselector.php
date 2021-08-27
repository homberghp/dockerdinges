<?php

/**
 * Create an option list from a query. The query should have as a minimum two columns: name and value.
 * @param PDO $con
 * @param string $queryText
 * @param array $queryArgs
 * @return the options list as string
 */
function simpleOptionList(PDO $con, string $queryText, array $queryParams) {
    $result = '';
    try {
        $stmt = $con->prepare($queryText);
        $stmt->execute($queryParams);
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
           $result .= "<option value='{$row['value']}'>{$row['name']}</option>\n";
        }
    } catch (PDOException $ex) {

        echo "<pre>got exception " . $ex->getMessage();
        echo $ex->getTraceAsString()
        . "</pre>"; // dump stack t
    }
    return $result;
}
