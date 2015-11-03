#!/usr/bin/php
<?php
	$teste = `ps aux | grep node | grep -v grep | awk '{print $2}'`;
	if ($teste === NULL){
		$rodar = `node /var/server/ &>>/var/log/node.log & `;
		echo "Server Iniciado \n";
	}
	else {
		echo "Server ja em execucao \n";
	}
?>
