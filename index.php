<?php

if ( $_SERVER['REQUEST_METHOD'] == "POST" )
{
	$path = '../../data/cryptoTool/';
	$ivFile = 'iv.key';
	$masterFile = 'master.key';
	
	$response = [];

	$string = $_POST['string'];
	$crypt = $_POST['crypt'];
	$isBrowser = $_POST['isBrowser'];	
	
	if ( $crypt === "encrypt" || $crypt === "decrypt" || $string.trim() !== '' )
	{

		$iv = file_get_contents($path . $ivFile);

		$key = file_get_contents($path . $masterFile);

		$method = 'aes-256-cbc';
		
		$wasItSecure = '';

		if ( $crypt === "encrypt" )
		{
			if ( ! $iv )
			{
				$iv = openssl_random_pseudo_bytes(16, $wasItSecure);
				
				if ( ! $wasItSecure )
				{
					$error = "Error setting up encryption..";
					$response['success'] = false;
					$response['error'] = $error;
				}
				else
				{
					file_put_contents($path . $ivFile, utf8_encode(base64_encode($iv)) );
				}
			}

			if ( ! $key )
			{
				$key = openssl_random_pseudo_bytes(32, $wasItSecure );
				
				if ( ! $wasItSecure )
				{
					$error = "Error setting up encryption...";
					$response['success'] = false;
					$response['error'] = $error;
				}
				else
				{
					file_put_contents($path . $masterFile, utf8_encode(base64_encode($key)) );
				}
			}	
	
			$result = openssl_encrypt( $string, $method, $key, 0, $iv );
			$resultURLEncoded = urlencode($result);		
			$resultURLDecoded = urldecode($result);
		
			if ( $result )
			{
				$response['success'] = true;
				$response['result'] = $result;
				$response['resultURLEncoded'] = $resultURLEncoded;
				$response['resultURLDecoded'] = $resultURLDecoded;
			}
			else
			{
				$response['success'] = false;
				$response['error'] = $error;	
			}
		}
		else
		{
			$string = urldecode($string);

			if ( ! $iv || ! $key )
			{
				$error = "Unable to decrypt string...";
				$response['success'] = false;
				$response['error'] = $error;
			}	
			

			$result = openssl_decrypt( $string, $method, $key, 0, $iv );
			
			if ( $result )
			{
				$response['success'] = true;
				$response['result'] = $result;
			}
			else
			{
				$response['success'] = false;
				$response['error'] = $error;	
			}	
		}
	}
	else
	{
		$error = "Improper method";
		$response['success'] = false;		
		$response['error'] = $error;		
	}
}
else if ( $_SERVER['REQUEST_METHOD'] != "GET" )
{
	$error = "What are you tring to do?";
	$response['success'] = false;		
	$response['error'] = $error;		
}


if ( $_SERVER['REQUEST_METHOD'] == "GET" || ( ( $_SERVER['REQUEST_METHOD'] == "POST" ) && $isBrowser ) )
{
?>
	<h1>CryptoTool</h1>
	<form method="post">
		<input type="text" name="string" id="string">
		<select name="crypt" id="crypt">
			<option value="encrypt">Encrypt</option>
			<option value="decrypt">Decrypt</option>
		</select>
		<input type="hidden" name="isBrowser" value="true">
		<input type="submit" value="Submit">
	</form>
	<div>
		<? 
		if ( ! $success )
		{ 
		?>
			<p><?= $error ?></p>
		<? 	
		} 
		?>
	</div>
	<div id="result">
		<p><b>Result</b></p>
		<? 
		if ( $success )
		{ ?>
		<p><?= $result ?></p>
		<? } ?>
	</div>
	<div id="resultURLencoded">
		<p><b>Reult URL Encoded</b></p>
		<? 
		if ( $success )
		{
		?>
		<p><?= $resultURLEncoded ?></p>
		<?
		}
		?>
	</div>
	<div id="resultURLdecoded">
		<p><b>Results URL Decoded</b></p>
		<? 
		if ( $success )
		{
		?>
		<p><?= $resultURLDecoded ?></p>
		<?
		}
		?>
	</div>
<?php
}
else
{
	$jsonResponse = json_encode($response);
	echo $jsonResponse;
}
?>
