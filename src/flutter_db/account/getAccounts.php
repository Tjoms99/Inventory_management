<?php
include '../conn.php';

$customer_id = $_POST['customer_id'];
$account_role = $_POST['account_role'];
$res = array();

$pos = strpos($customer_id, '1');


$sql = "SELECT * FROM ACCOUNTS";
$sql = $conn->query($sql);

//Add accounts depending on role and registered customer id.
while ($row = $sql->fetch_assoc()) {
    if ($account_role == "admin") {
        $res[] = $row;
    } elseif ($row['account_role'] == "admin" || $row['account_role'] == "customer") {
        //Do nothing
    } elseif (substr($row['registered_customer_id'], $pos, 1) == "1" && $pos !== false) {


        $res[] = $row;
    }
}

echo json_encode($res);
