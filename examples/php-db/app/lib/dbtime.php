<php
require_once '../etc/credentials.php';

function geConnection(): PDO {


}
function dbTime(): text{
    $conString="pgsql:host={$dbhost};port=5432;dbname={$dbname};user={$dbuser};password={$dbpassword}";
    $conn=new PDO($conString);
    $sql ='select now() as time';
    $statement = $db->query($sql);
    $stmt = $db->prepare($sql);
    $stmt->execute();
    $result='';
    foreach ($stmt as $row) {
        $resuls .= $row['name'] . "</h1><br />";
    }

}