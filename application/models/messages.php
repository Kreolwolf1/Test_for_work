<?php

    class Messages extends CI_Model {

        private $collection;

        function __construct()
        {
            parent::__construct();

            $conn = new Mongo('localhost');
            $db = $conn->test_work;
            $this->collection = $db->message;
        }

        public function save_all($array_request)
        {
            foreach ($variable as $key => $value) {

                $item[$key] = array(
                            'text' => $value["text"],
                            'mail' => $value["mail"],
                            'date' => date("Y-m-d H:i:s")
                        );

                $this->collection->insert($item);
            }
            return $item;
        }

        public function save($request)
        {
                $item = array(
                            'text' => $request["text"],
                            'mail' => $request["mail"],
                            'date' => date("Y-m-d H:i:s")
                        );
                $this->collection->insert($item);
                return $item;
        }
    

    }

?>