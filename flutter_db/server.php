<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "Testdb";
$table = "Accounts"; // lets create a table named Employees.

// we will get actions from the app to do operations in the database...
$action = "GET_ALL";

// Create Connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check Connection
if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
    return;
}

// If connection is OK...

// If the app sends an action to create the table...
if ("CREATE_TABLE" == $action) {
    $sql = "CREATE TABLE IF NOT EXISTS $table ( 
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            account_name VARCHAR(200) NOT NULL,
            account_role VARCHAR(200) NOT NULL
            )";

    if ($conn->query($sql) === TRUE) {
        // send back success message
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Get all employee records from the database
if ("GET_ALL" == $action) {
    $db_data = array();
    $sql = "SELECT id, account_name, account_role from $table ORDER BY id DESC";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Add an Employee
if ("ADD_ACC" == $action) {
    // App will be posting these values to this server
    $account_name = $_POST["account_name"];
    $account_role = $_POST["account_role"];
    $sql = "INSERT INTO $table (account_name, account_role) VALUES ('$account_name', '$account_role')";
    $result = $conn->query($sql);
    echo "success";
    $conn->close();
    return;
}

// Remember - this is the server file.
// I am updating the server file.
// Update an Employee
if ("UPDATE_ACC" == $action) {
    // App will be posting these values to this server
    $account_id = $_POST['account_id'];
    $account_name = $_POST["account_name"];
    $account_role = $_POST["account_role"];
    $sql = "UPDATE $table SET account_name = '$account_name', account_role = '$account_role' WHERE id = $account_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Delete an Employee
if ('DELETE_ACC' == $action) {
    $account_id = $_POST['account_id'];
    $sql = "DELETE FROM $table WHERE id = $account_id"; // don't need quotes since id is an integer.
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}
