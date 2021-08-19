<?php

/**
 * Print a simple html formatted table using a PDO connection, a query text and an optional array of parameters 
 * to be used in the query text which is used to prepare a statement.
 * The parameters should be given in the order where they occur in the statement.
 * 
 * @param PDO $conn connection to use
 * @param string $queryText the sql code
 * @param array $queryParams params to the prepared statement.
 */
function print_simple_table(PDO $conn, string $queryText, array $queryParams, string $tabledef = "<table border=1 class='simple-table'>\n") {
    try {
        $stmt = $conn->prepare($queryText);

        $stmt->execute($queryParams);

        // process the result
        //<editor-fold>
        echo $tabledef;
        $columnCount = $stmt->columnCount();
        $header1 = "";
        $header2 = "";
        $header1 .= "\t<tr>";
        $colAlign = [];
        for ($i = 0; $i < $columnCount; $i++) {
            $column0Meta = $stmt->getColumnMeta($i);
            $header1 .= "\t\t<th>{$column0Meta['name']}</th>\n";
            $header2 .= "\t\t<th>{$column0Meta['native_type']}</th>\n";
            $colAlign[] = ($column0Meta['pdo_type'] == 1 ||$column0Meta['native_type']=='money') ? 'num' : 'txt';
        }
        echo "{$header1}\t</tr>\n $header2\t</tr>\n";
        while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
            printRow($row, $colAlign, $columnCount);
        }
        echo "</table>\n";
        //</editor-fold>
    } catch (PDOException $ex) {
        echo "<pre>got exception " . $ex->getMessage();
        echo $ex->getTraceAsString()
        . "</pre>"; // dump stack trace. In production, log it.
    }
}
/**
 * Print a row of data.
 * @param array $row to print 
 * @param array $colAlign the alignment derived from meta data
 * @param int $columnCount count of columns
 */
function printRow(array $row, array $colAlign, int $columnCount) {
    echo "\t<tr>\n";
    for ($c = 0; $c < $columnCount; $c++) {
        echo "\t\t<td class='{$colAlign[$c]}'>{$row[$c]}</td>\n";
    }
    echo "\t</tr>\n";
}
