<?php
/* It's including the file connexion.php which is a file that contains the connection to the database. */
include '../db/connexion.php';
    

    $email = $_POST['email'];
    $pass = sha1($_POST['pass']);

    try{
        if(isset($email,$pass)){
            $req = $DB->query("SELECT * FROM users WHERE email=? AND password=?",[$email,$pass]);
            
            $exist = $req->rowCount();
           if($exist == 1){
               $array = $req->fetch();
                $msg = "success Connection";
                $success = 1;
           }else{
               $msg = "email or password is incorrect ";
               $success = 0;
           }
        }else{
            $success = 0;
            $msg = "error empty data";
        }
    }catch(PDOException $th){
        $msg = "erreur sur:".$th->getMessage();
    }
    echo json_encode([
        "data"=>[
            $msg,
            $success,
            $array
        ]
    ]);
