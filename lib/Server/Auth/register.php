<?php 
 include '../db/connexion.php';

 $username = $_POST["username"];
 $email = $_POST["email"];
 $phone = $_POST["phone"];
 $pass = $_POST["password"];

    try{
        if(isset($username,$email,$phone,$pass)){
            $req = $DB->query("SELECT * FROM users WHERE email=?",[$email]);
            
            $exist = $req->rowCount();
           if($exist == 0){
                $req = $DB->insert("INSERT INTO users VALUES(null,?,?,?)",[$username,$email, $phone,$password]);

                if($req){
                    $success = 1;
                    $msg = "success Register";
                }else{
                    $success = 0;
                    $msg = "error register";
                }
           }else{
               $msg = "email Already exist";
               $success = 0;
           }
        }else{
            $success = 0;
            $msg = "error empty data";
        }
    }catch(\Throwable $th){
        $msg = "erreur sur:".$th->getMessage();
    }
    echo json_encode([
        "data"=>[
            $msg,
            $success,
            $username,
            $email,
            $tel
        ]
    ]);
