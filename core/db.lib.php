<?
    #DB library. version 1.0
    #error code d_
	include_once("adodb/adodb.inc.php");	
	class xpDatabase
	{
		var $Connection;
		var $Entity;
		
		function xpDatabase()
		{
			global $cfg, $Error;
			$this->Connection = ADONewConnection($cfg[dbdriver]);
			if(!$this->Connection->PConnect($cfg[dbhost],$cfg[dbuser],$cfg[dbpass],$cfg[dbname]))
			$Error->is_error('d_1', $this->Connection->ErrorMsg());
			$this->Execute("set CHARACTER SET utf8");
			$this->Connection->SetFetchMode(ADODB_FETCH_ASSOC);

		}
		
		function Execute($query, $params = false)
		{
			global $Error;
			$rs = $this->Connection->Execute($query, $params);
			if(!$rs)$Error->is_error('d_2', $this->Connection->ErrorMsg());
			return $rs;
		}
		
		function Close()
		{
            $this->Connection->Close();
        }
		
        function Identity()
		{
			return $this->Connection->Insert_ID();
		}
    };
?>