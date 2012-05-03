<?php

    class User extends CI_Model {

        private $collection;

        function __construct()
        {
            parent::__construct();

            $conn = new Mongo('localhost');
            $db = $conn->test_work;
            $this->collection = $db->user;
        }

        public function check_user($mail, $pass)
        {
            $request = array(
                            'pass' => $pass,
                            'mail' => $mail
                        );

            $mongo_request = $this->collection->find($request);


            if ($mongo_request->count()>0)
                return true;
            else
                return false;
        }

    }

?>