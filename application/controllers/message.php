<?php

	class Message extends CI_Controller{
		

		function __construct()
		{
			parent::__construct();

			$this->load->model("Messages");
		}


		public function save()
		{
			
			if ( $_SERVER['REQUEST_METHOD'] === 'POST' )
			{
	       
	            $postText = trim( file_get_contents('php://input', FILE_TEXT, NULL, 0, 102400) );
				$post_arr = json_decode($postText, true);
	       		$response= array('response' => array('0' => $this->Messages->save($post_arr)));
	       		echo json_encode($response);

	       }
	       else
	       {
	       		$answer = array('response' => false);
	       		echo json_encode($answer);
	       } 
		}

		public function save_all()
		{
			
			if ( $_SERVER['REQUEST_METHOD'] === 'POST' )
			{
	       
	            $postText = trim( file_get_contents('php://input', FILE_TEXT, NULL, 0, 102400) );
				$post_arr = json_decode($postText, true);
	       		$response= array('response' => array('0' => $this->Messages->save_all($post_arr)));
	       		echo json_encode($response);

	       }
	       else
	       {
	       		$answer = array('response' => false);
	       		echo json_encode($answer);
	       } 
		}

	}
?>