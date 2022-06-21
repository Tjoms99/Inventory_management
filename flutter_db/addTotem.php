<?php
include 'conn.php';

$mac = $_POST['mac'];
$rfid = $_POST['rfid'];

$sql = "INSERT INTO 'totems'('mac', 'rfid') VALUES ('$mac', '$rfid')";

$conn->query($sql);