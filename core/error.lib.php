<?
    class xpError
    {
        var $error;
        var $stack;
        
        function xpError()
        {
            $this->error = FALSE;
            $this->stack = array();
        }
        
        function is_error($error_code, $error_text=NULL)
        {
            $this->error = TRUE;
            $this->stack[$error_code] = $error_text; 
        }
        
        function GetXML()
        {
            if($this->error == TRUE)
            {
                $xml = "<ERRORS>";
                foreach($this->stack as $k => $v)$xml .= "<ERROR code=\"{$k}\">".$v."</ERROR>";    
                $xml .= "</ERRORS>";
            }
            return $xml;
        }
        
        function check_error($error_code)
        {
            if($this->stack[$error_code])return TRUE;
            else return FALSE;    
        }
    }

?>