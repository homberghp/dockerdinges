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
function print_simple_table(PDO $conn, string $queryText, array $queryParams, string $caption='undefined' ,string $tabledef = "<table border=1 class='simple-table'>\n") {
  echo simpleTableToString($conn, $queryText, $queryParams,$caption,$tabledef);
}

function simpleTableToString(PDO $conn, string $queryText, array $queryParams, string $caption='undefined' ,string $tabledef = "<table border=1 class='simple-table'>\n") : string{
  $result='';
  try {
        $stmt = $conn->prepare($queryText);

        $stmt->execute($queryParams);
        $result .=resultsetToString($stmt,$caption,$tabledef);
        //</editor-fold>
    } catch (PDOException $ex) {
        $result .= "<pre>got exception "
          . $ex->getMessage()
          .$ex->getTraceAsString()
          . "</pre>"; // dump stack trace. In production, log it.
    }
    return $result;
}
/**
 * print a prepared and executed statement.
*/
function printResultset( PDOStatement $stmt, string $caption='undefined' ,string $tabledef = "<table border=1 class='simple-table'>\n"){
  echo resultsetToString($stmt, $caption, $tabledef);
}

/**
 * Return result set as string, defining a  html table.
 */

function resultsetToString(PDOStatement $stmt, string $caption='undefined' ,string $tabledef = "<table border=1 class='simple-table'>\n"): string {
  $result = $tabledef
      . "<caption>{$caption}</caption>";
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
  $result .= "{$header1}\t</tr>\n $header2\t</tr>\n";
  while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
      $result .= rowToString($row, $colAlign, $columnCount);
  }
  $result .= "</table>\n";
  return $result;
}
/**
 * Print a row of data.
 * @param array $row to print
 * @param array $colAlign the alignment derived from meta data
 * @param int $columnCount count of columns
 */
function printRow(array $row, array $colAlign, int $columnCount) {
  echo rowToString($row, $colAlign,$columnCount);
}

/**
 * create html row from data and alignment info.
 */
function rowToString(array $row, array $colAlign, int $columnCount){
  $result="\t<tr>\n";
  for ($c = 0; $c < $columnCount; $c++) {
      $result .= "\t\t<td class='{$colAlign[$c]}'>{$row[$c]}</td>\n";
  }
    $result .= "\t</tr>\n";
    return $result;
}
