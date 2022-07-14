<?php
include '../conn.php';

$account_role = $_POST['account_role'];
$customer_id = $_POST['customer_id'];
$res = array();

$pos = strpos($customer_id, '1');

$sql = "SELECT * FROM ITEMS";
$sql = $conn->query($sql);


//Add items depending on role and registered customer id.
while ($row = $sql->fetch_assoc()) {
    if ($account_role == "admin") {
        $res[] = $row;
    } elseif (substr($row['registered_customer_id'], $pos, 1) == "1" && $pos !== false) {
        $res[] = $row;
    }
}
echo json_encode($res);
