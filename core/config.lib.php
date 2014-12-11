<?
    #Config library. version 1.0
	class Config
	{
		var $data;
		function __construct()
		{
            Global $DB;
            $rs=$DB->Execute("SELECT * FROM T_CONF");
            if($rs)
            {
                while(!$rs->EOF)
                {
                    $this->data[$rs->fields['namespace']][$rs->fields['confkey']] = $rs->fields['confvalue'];
                    $rs->MoveNext();     
                }	
                $rs->close();
            }
		}
		function SetVar($ns, $key, $value)
		{
            Global $DB;
            $DB->Execute("INSERT INTO T_CONF (namespace, confkey, confvalue) VALUES (?, ?, ?)", Array($ns, $key, $value));
            return TRUE;         
		}
        function EditVar($ns, $key, $value)
		{
            Global $DB;
            $DB->Execute("UPDATE T_CONF SET confvalue=? WHERE namespace=? AND confkey=?", Array($value, $ns, $key));
            return TRUE;         
		}
        function DelVar($ns, $key)
		{
            Global $DB;
            $DB->Execute("DELETE FROM T_CONF WHERE namespace=? AND confkey=? LIMIT 1", Array($ns, $key));
            return TRUE;         
		}
        function Getmoduleconf($ns)
        {
            return $this->data[$ns];          
        }
        function Setmoduleconf($ns, $data)
        {
            Global $DB;
            foreach($data as $k=>$v)$DB->Execute("INSERT INTO T_CONF (namespace, confkey, confvalue) VALUES (?, ?, ?)", Array($ns, $k, $v));
            return TRUE;    
        }	
	};
?>