<?php
include 'conn.php';

$id = $_POST['id'];
$id = intval($id);

$sql = "DELETE FROM accounts WHERE `accounts`.`id` = $id";
$conn->query($sql);
