<?
    class xpCache
    {
        var $cache = Array();
        var $cacheclass = Array();
        var $realm;
        var $params;
        
        function xpCache($realm, $params)
        {
            global $cfg, $DB;
            $this->realm = $realm;
            $this->params = $params;
            $rs=$DB->Execute("SELECT * FROM T_CACHE WHERE realm=? AND params=?",Array($this->realm, $this->params));
            while(!$rs->EOF)
            {
                $i = $rs->fields['cache']; 
                $dataclass = $rs->fields['dataclass'];
                $params = $rs->fields['params']; 
                $this->cache[$i]['dataclass'] = $dataclass;
                $this->cache[$i]['xml'] = $rs->fields['xml'];
                $this->cache[$i]['params'] = $params;
                $this->cacheclass[$dataclass] = $i;
                $rs->MoveNext();        
            }
            $rs->close();
            //выбираем отдельно кеш секций
            $rs=$DB->Execute("SELECT * FROM T_CACHE WHERE dataclass=?",Array("xpTree"));
            while(!$rs->EOF)
            {
                $i = $rs->fields['cache']; 
                $dataclass = $rs->fields['dataclass'];
                $this->cache[$i]['dataclass'] = $dataclass;
                $this->cache[$i]['xml'] = $rs->fields['xml'];
                $this->cacheclass[$dataclass] = $i;
                $rs->MoveNext();    
            }
            $rs->close();
            
        }
        
        function xpCheckCache($dataclass)
        {
            $cache_id = $this->cacheclass[$dataclass];
            if(is_numeric($cache_id))return $cache_id;
            else return FALSE;    
        }
        
        function xpGetCache($dataclass)
        {
            $cache_id = $this->cacheclass[$dataclass];
            $xml = $this->cache[$cache_id]['xml'];
            return $xml;
        }
        
        function xpSetCache($xml, $class)
        {
            global $DB;
            $rs = $DB->Execute("INSERT INTO T_CACHE (xml, realm, dataclass, params) VALUES (?, ?, ?, ?)", Array($xml, $this->realm, $class, $this->params));           
        }
        
        function xpClearCache($dataclass)
        {
            global $DB;
            $rs = $DB->Execute("DELETE FROM T_CACHE WHERE dataclass =?",Array($dataclass));
        }
        
        function xpSetFullCache($xml, $class)
        {
            global $DB;
            $rs = $DB->Execute("INSERT INTO T_CACHE (xml, dataclass) VALUES (?, ?)", Array($xml, $class));
        }
    }
?>