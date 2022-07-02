<?php
  // Déclaration d'une nouvelle classe
  class connexionDB {
   private $host = "db5005093161.hosting-data.io";
   private $dbname =  "dbs4263873";
   private $user = "dbu416750";
   private $pass = "cadenat_connecte-01-09-2021";
    public $connexion;
                    
    function __construct($host = null, $dbname = null, $user = null, $pass = null){
      if($host != null){
        $this->host = $host;           
        $this->dbname = $dbname;           
        $this->user = $user;          
        $this->pass = $pass;
      }
      try{
        $this->connexion = new PDO('mysql:host=' . $this->host . ';dbname=' . $this->dbname,
          $this->user, $this->pass, array(PDO::MYSQL_ATTR_INIT_COMMAND =>'SET NAMES UTF8', 
          PDO::ATTR_ERRMODE => PDO::ERRMODE_WARNING));
          
      }catch (PDOException $e){
        echo 'Erreur : Impossible de se connecter  à la BDD !';
        die();
      }
    }
    
    public function query($sql, $data = array()){
      try{

      $req = $this->connexion->prepare($sql);
      $req->execute($data);
      return $req;
    }catch(PDOException $e){
      echo json_encode("error : ".$e.getMessage());
    }
    }
    
    public function insert($sql, $data = []){
      try{

      $req = $this->connexion->prepare($sql);
      $req->execute($data);
      return $req;
      }catch(PDOException $e){
      echo json_encode("error : ".$e.getMessage());
      }
    }
  }
  
  
  // Faire une connexion à votre fonction
  $DB = new connexionDB()
?>
