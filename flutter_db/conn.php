<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "Testdb";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn) {
    //echo "Success";
} else {
    //echo "Failed";
}
