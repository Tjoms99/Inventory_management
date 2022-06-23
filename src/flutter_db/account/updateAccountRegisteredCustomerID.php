<?php
include '../conn.php';

$id = $_POST['id'];
$registered_customer_id = $_POST['registered_customer_id'];

$id = intval($id);

$sql = "UPDATE `accounts` SET `registered_customer_id` = '$registered_customer_id' WHERE `accounts`.`id` = $id";
$conn->query($sql);
