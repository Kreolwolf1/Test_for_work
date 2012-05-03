<?php

	class Login extends CI_Controller{
		

		function __construct()
		{
			parent::__construct();

			$this->load->model("User");
		}


		public function index()
		{
			
			if ( $_SERVER['REQUEST_METHOD'] === 'POST' )
			{
	       
	            $postText = trim( file_get_contents('php://input', FILE_TEXT, NULL, 0, 102400) );
		        $post_arr = json_decode($postText, true);
	       
	       		$data = $this->User->check_user($post_arr['mail'],$post_arr['pass']);

		        if ($data)
		        {
			        $answer = array('response' => true);
			        echo json_encode($answer);

		        }
		        else
		        {
			        $answer = array('response' => false);
			        echo json_encode($answer);
		        }
	       }
	       else
	       {
	       		$answer = array('response' => false);
	       		echo json_encode($answer);
	       } 
		}

	}
?>