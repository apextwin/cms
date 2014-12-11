<?
#Node library. version 1.0
#### TEST TEST
class Viewer
{
    function Viewer()
    {

    }
    function LoadNodeData($node, $type='full')
    {
        global $DB, $cfg, $Processor;
        $query = "SELECT a.node, a.name, a.class, a.disabled, a.login, a.highlight, a.viewcounter, a.topcounter, a.time, a.userrating, b.realm FROM T_NODE as a LEFT JOIN T_NODE_REALM as b ON a.node=b.node WHERE a.node='".$node."' LIMIT 0, 1";
        $rs = $DB->Execute($query);
        if(!$rs->EOF)
        {
            $cl = $rs->fields['class'];
            $tpl = $cfg[xsldir]."/nodes/".$cl.".xsl";
            $Processor->Template->addtemplate($tpl);
            if($rs->fields['highlight'] < time() && $rs->fields['highlight'] != '')
            {
                $DB->Execute("UPDATE T_NODE SET highlight='' WHERE node=\"{$node}\" LIMIT 1");
                $highlight = '';
            }
            else $highlight = date("d.m.Y", $rs->fields['highlight']);
            $rss=$DB->Execute("SELECT * FROM T_NODE_REALM AS a LEFT JOIN T_REALM as b ON a.realm=b.realm WHERE a.node=? AND a.mode=?", Array($node, '0'));
            $rlname = "/".$rss->fields['name'];
            
            $xml .= "<NODE login=\"{$rs->fields['login']}\" class=\"{$rs->fields['class']}\" node=\"{$rs->fields['node']}\" realm=\"{$rs->fields['realm']}\" disabled=\"{$rs->fields['disabled']}\" highlight=\"{$highlight}\" time=\"{$time}\" viewcounter=\"{$rs->fields['viewcounter']}\"  topcounter=\"{$top_counter}\" userrating=\"{$rs->fields['userrating']}\" realmname=\"{$rlname}\">";
            $xml .= "<NAME><![CDATA[".stripslashes($rs->fields['name'])."]]></NAME>";
            
            $rss = $DB->Execute("SELECT * FROM T_USERS WHERE login=? LIMIT 1", Array($this->login));
            while(!$rss->EOF)
            {   
                $xml .= "<USER";
                foreach($rss->fields as $k => $v)
                {
                    if(!is_integer($k) && $k != 'params')$xml.=" $k =\"$v\"";
                }
                $xml.="/>";
                $rss->MoveNext();
            }
            $rss->close();
            
            $rss=$DB->Execute("SELECT * FROM T_NODE_REALM WHERE node=? AND mode=?", Array($node, '1'));
            if(!$rss->EOF)
            {
                $xml.="<ATREALMS>";
                while(!$rss->EOF)
                {
                    $xml .= "<REALM realm=\"{$rss->fields['realm']}\" mode=\"{$rss->fields['mode']}\"/>";
                    $rss->MoveNext();
                }
                $xml.="</ATREALMS>";
                $rss->close();
            }
            switch($cfg['cache'])
            {
                case 'file':
                    $cache = $cfg[cachedir]."/".$node.".xml";
                    if(!is_file($cache))
                    {    
                        $innerxml = $this->NodeXML($node, $rs->fields['disabled'], $cl);
                        file_put_contents($cache,$innerxml);
                        chmod("$cache",0644);
                        $xml .= $innerxml;
                    }
                    else $xml .= file_get_contents($cache);    
                break;
                case 'apc':
                    $cache = apc_fetch('node'.$node, $res);
                    if($res)$xml .= $cache; 
                    else
                    {
                        $innerxml = $this->NodeXML($node, $rs->fields['disabled'], $cl);
                        apc_store('node'.$node, $innerxml, 43200);
                        $xml .= $innerxml;  
                    }
                break;
                case '0':
                    $xml .= $this->NodeXML($node, $rs->fields['disabled'], $cl);
                break;    
            }
            $xml .= "</NODE>";
        }
        return $xml;
    }

    function NodeXML($node, $disabled, $cl)
    {       
        global $DB;
        $rss = $DB->Execute("SELECT T_NODE_DATA.value, T_NODE_DATA.dataindex, T_NODE_DATANAME.dataname FROM T_NODE_DATA JOIN T_NODE_DATANAME ON T_NODE_DATA.dataid = T_NODE_DATANAME.dataid WHERE T_NODE_DATA.node=?", Array($node));
        while(!$rss->EOF)
        {
            $name = $rss->fields['dataname'];
            $value = $rss->fields['value'];
            $data[$name]["{$rss->fields['dataindex']}"] = $value;
            $rss->MoveNext();
        }
        $rss->close();
        $DB->Execute("DELETE FROM T_SEARCH WHERE node=? LIMIT 1", Array($node));
        if($disabled != 1 && $search_data != '')
        {
            $search_data = $this->GetSearchData($data, $cl);
            $DB->Execute("INSERT INTO T_SEARCH (node, textdata) VALUES(?, ?)", Array($node, $search_data));
        }
        return $this->CreateXML($cl, $data, $node, $type);    
    }

    function GetSearchData($data, $cl)
    {
        $xml = simplexml_load_file('datatypes/'.$cl.'.xml');
        $fs = $xml->xpath("//FIELD");
        $counter = 0;
        $sf=Array('title', 'content');
        foreach($fs as $n)
        {
            if( in_array($n['name'], $sf) )
            {
                switch($n['type'])
                {
                    case 'numeric':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'string':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'text':
                        if($data["{$n['name']}"])$str .= strip_tags(implode(",", $data["{$n['name']}"]))." \n\r";
                    break;
                    case 'image':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'datetime':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'file':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'list':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                    case 'node':
                        if($data["{$n['name']}"])$str .= implode(",", $data["{$n['name']}"])." \n\r";
                    break;
                }
            }
        }
        return $str;
    }

    function LoadNodeSet($params, $fieldsfilter=NULL, $fieldsorder=NULL)
    {
        global $DB, $cfg;
        $res = array();
        $realm = $params[realm];
        $login = $params[login];
        $datatype = $params[datatype];
        $disabled = $params[disabled];
        $order = $params[order];
        $page = $params[page];
        if($params[pagesize] != '')$pagesize = $params[pagesize];
        else $pagesize=20;
        $query="SELECT a.node FROM T_NODE_REALM as a LEFT JOIN T_NODE as b ON a.node=b.node WHERE ";
        if(is_Array($realm)) $query .= " a.realm IN (".implode(", ", $realm).") AND";
        elseif($realm != NULL) $query .= " a.realm = '{$realm}' AND";
        if($login != NULL) $query .= " b.login = '{$login}' AND";
        if($datatype != NULL) $query .= " b.class = '{$datatype}' AND";
        if($disabled != 0) $query .= " b.disabled = '0' AND";
        $query = substr($query, 0, -4);
        if($order != NULL) $query .= " ORDER BY b.{$order[0]} {$order[1]}";
        $rs = $DB->Execute($query);
        while(!$rs->EOF)
        {
            array_push($res, $rs->fields['node']);
            $rs->MoveNext();
        }
        $rs->close();

        $query = "SELECT * FROM T_NODE_DATANAME";
        $rs = $DB->Execute($query);
        while(!$rs->EOF)
        {
            $datanames[$rs->fields['dataname']] = $rs->fields['dataid'];
            $rs->MoveNext();
        }
        $rs->close();
        if(is_array($fieldsfilter))
        {
            foreach($fieldsfilter as $k=>$v)
            {
                //фильтруем входящий массив $fieldsfilter
                $dataid = $datanames[$k];
                if(is_string($v))if(strpos($v, ','))$v = explode(",", $v);
                if($dataid != '')
                {
                    if(is_array($v))
                    {
                        //это если интервал или "одно из"
                        if($v['from'] != 0 && $v['to'] != 0)$string = "dataid = ".$datanames[$k]." AND value >= ".$v['from']." AND value <= ".$v['to']."";
                        elseif($v['from'] == 0 && $v['to'] != 0)$string = "dataid = ".$datanames[$k]." AND value <= ".$v['to']."";
                        elseif($v['from'] != 0 && $v['to'] == 0)$string = "dataid = ".$datanames[$k]." AND value >= ".$v['from']."";
                        elseif($v[0])$string = "dataid = ".$datanames[$k]." AND value IN ('".implode("','",$v)."')";
                        else $string = '';
                        if($string != '')
                        {
                            $rs = $DB->Execute("SELECT node FROM T_NODE_DATA WHERE ".$string);
                            //echo "SELECT node FROM T_NODE_DATA WHERE ".$string;
                            $curr_filter = array();
                            while(!$rs->EOF)
                            {
                                array_push($curr_filter, $rs->fields[node]);
                                $rs->MoveNext();
                            }
                            $rs->close();
                        }
                    }
                    else
                    {
                        if($v != '')
                        {
                            //это если точное значение
                            $query = "SELECT node FROM T_NODE_DATA WHERE dataid=\"{$dataid}\" AND value=\"{$v}\"";
                            $rs = $DB->Execute($query);
                            $curr_filter = array();
                            while(!$rs->EOF)
                            {
                                array_push($curr_filter, $rs->fields[node]);
                                $rs->MoveNext();
                            }
                            $rs->close();
                        }
                    }
                    if(!is_array($fields_filtered))$fields_filtered = $curr_filter;
                    else $fields_filtered = array_intersect($fields_filtered, $curr_filter);
                }
            }
        }
        if(is_array($fields_filtered))$res = array_intersect($res, $fields_filtered);
        if($fieldsorder!=NULL)
        {
            $field = $fieldsorder[0];
            $dir = $fieldsorder[1];
            $dataid = $datanames[$field];
            $nodeorder = array();

            $query = "SELECT node FROM T_NODE_DATA WHERE dataid=\"{$dataid}\" ORDER BY CAST(value AS decimal) {$dir}";
            $rs = $DB->Execute($query);
            while(!$rs->EOF)
            {
                array_push($nodeorder, $rs->fields[node]);
                $rs->MoveNext();
            }
            $rs->close();

        }
        if(is_Array($nodeorder))$res = array_intersect($nodeorder, $res);
        if(is_Array($realm) && count($realm) > 1)
        {
            $pagesize = 20;
        }
        elseif($realm == NULL && $pagesize != NULL)
        {
            $pagesize = $pagesize;
        }
        if(is_array($res))$res_count = count($res);
        if($res_count > $pagesize)
        {
            $res_paging = array_chunk($res, $pagesize, TRUE);
            $pages = count($res_paging);
            $next = $page + 1;
            $prev = $page - 1;
            $half = intval($cfg[rulersize]/2);//�������� ������ ����� ����� �����
			$start = $page - $half;
			$end = $page + $half;
            
            $paging .= "<PAGING pages=\"$pages\" page=\"$page\">";
            if($page != 1)$paging .= "<FIRST page=\"1\"/><PREV page=\"$prev\"/>";
            
            if($start <= 0)$start = 1;
            if($end > $pages)$end = $pages;
            for($i = $start; $i <= $end; $i++)$paging .= "<PAGE number=\"$i\"/>";
            
            if($page != $pages)$paging .= "<NEXT page=\"$next\"/><LAST page=\"$pages\"/>";
            $paging .= "</PAGING>";
        }
        else $res_paging[0] = $res;
        $xml .= "<CONTENT>";
        $pg = $page-1;
        $curr_page = $res_paging[$pg];
        if(is_array($curr_page))foreach($curr_page as $k=>$v)$xml .= $this->LoadNodeData($v);
        $xml .= $paging;
        $xml .= "</CONTENT>";
        return $xml;
    }

    function SaveNodeData($node, $data)
    {
        global $DB;
        foreach($data as $k=>$v)$datanames .= "'".$k."', ";//собираем имена всех полей
        $datanames = substr($datanames, 0, -2);
        $query = "SELECT * FROM T_NODE_DATANAME WHERE dataname IN (".$datanames.")";
        $rs=$DB->Execute($query);
        while(!$rs->EOF)
        {
            $dn = $rs->fields['dataname'];
            $datanames_valid["{$dn}"] = $rs->fields["dataid"];
            $rs->MoveNext();
        }
        $rs->close();
        foreach($data as $k=>$v)
        {
            if(!$datanames_valid[$k]) //если имени поля в базе нету, то добавляем его в базу
            {
                $DB->Execute("INSERT INTO T_NODE_DATANAME (dataname) VALUES (\"$k\")");
                $dataid = $DB->Identity();
                $data_valid[$dataid] = $v;
            }
            else $data_valid["{$datanames_valid[$k]}"] = $v;
        }
        $query = "INSERT INTO T_NODE_DATA (node, dataid, value) VALUES";
        foreach($data_valid as $k=>$v)$query .= "(\"$node\", \"$k\", \"$v\"),";
        $query = substr($query, 0, -1);
        $DB->Execute($query);
        return TRUE;
    }

    function UpdateNodeData($node, $data)
    {
        global $DB;
        $this->DeleteNodeData($node);
        $this->InsertNodeData($node, $data);
        return TRUE;
    }
    function DeleteNodeData($node)
    {
        global $DB;
        $DB->Execute("DELETE FROM T_NODE_DATA WHERE node=?", Array($node));
        $cache = "cache/node/".$node.".xml";
        if(!is_file($cache))unlink($cache);
        return TRUE;
    }
    function SetNodeRealm($node, $realm, $mode)
    {
        global $DB;
        $DB->Execute("INSERT INTO T_NODE_REALM (node, realm, mode) VALUES (?, ?, ?)", Array($node, $realm, $mode));
        return TRUE;
    }
    function DeleteNodeRealm($node, $mode=0)
    {
        global $DB;
        $DB->Execute("DELETE FROM T_NODE_REALM WHERE node=? AND mode=?", Array($node, $mode));
        return TRUE;
    }
    function DeleteRealmCache($realm)
    {
        $foldername = "cache/realm/".$realm;
        if(file_exists($foldername))
        {
            $scan = glob($foldername.'/*');
            foreach($scan as $index=>$path)unlink($path);
            rmdir($foldername);
        }

        return TRUE;
    }
    function DeleteNodeCache($node)
    {
        $path = "cache/node/".$node.".xml";
        if(file_exists($path))unlink($path);
        return TRUE;
    }
    
    function CreateXML($cl, $data, $nodeid, $type='full')
    {
        global $cfg, $DB;
        $xml = simplexml_load_file('datatypes/'.$cl.'.xml');        
        $datatypexml =  "<DATATYPE";
        foreach($xml->attributes() as $k => $v)$datatypexml .= " ".$k."=\"".$v."\"";
        $datatypexml .= ">";
        foreach($xml->FIELD as $field)
        {
            $fieldxml .= "<FIELD";
            foreach($field->attributes() as $k => $v)$fieldxml .= " ".$k."=\"".$v."\"";
            $fieldxml .= ">";
            if($field->attributes()->type == 'list')$fieldxml .= $this->LoadListData($field->attributes()->parent);
            if($field->attributes()->type == 'tablelink')
            {
                $rs = $DB->Execute("SELECT * FROM ".$field->attributes()->table." WHERE ".$field->attributes()->field."=".$nodeid);
                if($rs && !$rs->EOF)foreach($rs->fields as $key=>$val) $fieldxml .= "<FIELD name=\"$key\">$val</FIELD>";
                $rs->close();
            }
            if($data["{$field->attributes()->name}"])
            {
                foreach($data["{$field->attributes()->name}"] as $id=>$value)
                {            
                    switch($field->attributes()->type)
                    {
                        case 'numeric':
                            $fieldxml .= "<DATA id=\"{$id}\">".$value."</DATA>";            
                        break;
                        case 'string':
                            $fieldxml .= "<DATA id=\"{$id}\"><![CDATA[".stripslashes($value)."]]></DATA>";
                        break;
                        case 'text':
                            $stripped = strip_tags($value);
                            if(mb_strlen($stripped)>400)
                            {
                                $position = mb_strpos($stripped, ' ', 390);
                                $brief = mb_substr($stripped, 0, $position);
                            }
                            else $brief = $stripped;
                            $fieldxml .= "<BRIEF><![CDATA[".$brief."]]></BRIEF>";
                            $fieldxml .= "<DATA><![CDATA[".stripslashes($value)."]]></DATA>"; 
                        break;
                        case 'image':
                            foreach($field->IMAGE as $img=>$val)
                            {
                                $fieldxml .= "<IMAGE";
                                foreach($val->attributes() as $k => $v)$fieldxml .= " ".$k."=\"".$v."\"";
                                $fieldxml .= ">";
                                $fieldxml .= "/".$cfg['filesdir']."/node/".$nodeid."/".$val->attributes()->prefix.$value;
                                $fieldxml .= "</IMAGE>";
                            }
                            $fieldxml .= "<DATA id=\"{$id}\">".$value."</DATA>";
                        break;
                        case 'datetime':
                            $normaly = date("d.m.Y  H:i", $value);
                            $fieldxml .= "<DATA id=\"{$id}\" timestamp=\"".$value."\" normaly=\"".$normaly."\">".date($field->attributes()->format, $value)."</DATA>";
                        break;
                        case 'node':
                            /*$fieldxml .= "<PARENT>";
                            $fieldxml .= $this->LoadNodeData($value, 'simple');
                            $fieldxml .= "</PARENT>"; */
                            //$value
                            $fieldxml .= "<DATA id=\"{$id}\">".$value."</DATA>";
                        break;
                        default:
                            $fieldxml .= "<DATA id=\"{$id}\">".$value."</DATA>";
                        break;  
                    }                   
                }
            }
            $fieldxml .= "</FIELD>";                            
            $datatypexml .= $fieldxml;
            unset($fieldxml);      
        }
        $datatypexml .= "</DATATYPE>";
        return $datatypexml;
    }
    
    function ValidateInputData($datatype, $node)
	{
        global $cfg;
        $result = Array();
        $data = $_POST[$datatype];
        $xml = simplexml_load_file('datatypes/'.$datatype.'.xml');
        foreach($xml->FIELD as $field)
        {
            $value = $data["{$field->attributes()->name}"];
            $key = (string)$field->attributes()->name;
            switch($field->attributes()->type)
            {
                case 'numeric':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = intval($v);
                    else $result["{$key}"] = intval($value);
                break;
                case 'string':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;
                case 'text':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;
                case 'datetime':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = strtotime($v);
                    else
                    {
                        //if($value != NULL)$date = strtotime($value);
                        //else $date = strtotime(date("d.m.Y", time()));
                        if($value != NULL) $date = strtotime($value);
                        else $date = time();
                        $result["{$key}"] = $date;
                    }
                break;
                case 'image':
                    if($_FILES[$datatype]["tmp_name"]["{$key}"] != '')
                    {
                        foreach ($field->children() as $child)
                        {
                            $image = new xpImage($_FILES[$datatype], $key);
                            $foldername = $cfg['filesdir']."/node/".$node;
                            if(!file_exists($foldername))mkdir($foldername);
                            $arr = (array)$child->attributes();
                            //var_dump(Array($key, $arr['@attributes']['prefix'], $foldername, $arr['@attributes']['x'], $arr['@attributes']['y']));
                            $result["{$key}"] = $image->imageUpload($key, $arr['@attributes']['prefix'], $foldername, $arr['@attributes']['x'], $arr['@attributes']['y']);     
                        }
                        break;
                    }
                    else
                    {
                        $result["{$key}"] = $data["current_".$key];
                        break;
                    }
                case 'file':
                    if($_FILES["{$datatype}"]["tmp_name"]["{$key}"] != '')
                    {
                        $foldername = "files/node/".$node;
                        $filename = $_FILES[$datatype]["tmp_name"]["{$key}"];
                        preg_match('/\.([A-Za-z]*)$/',$_FILES[$datatype]['name']["{$key}"],$ext);
                        $newfilename = "files/node/".$node."/".$key.$ext[0];
                        if(!file_exists($foldername))mkdir($foldername);
                        $f = file_get_contents($filename);
    		            file_put_contents($newfilename ,$f);
    		            $result["{$key}"] = $key.$ext[0];
                        break;
                    }
                    else
                    {
                        $result["{$key}"] = $data["current_".$key];
                        break;
                    }
                case 'list':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;
                case 'address':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;
                case 'node':
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;
                default:
                    if(is_array($value))foreach($value as $k=>$v)$result["{$key}"][$k] = $v;
                    else $result["{$key}"] = $value;
                break;    
            }    
        }
        return $result;
    }

    function LoadListData($list=NULL, $parent=NULL)
    {
        global $DB;
        if($list !== NULL)$rs = $DB->Execute("SELECT * FROM T_LIST WHERE list=\"$list\" LIMIT 1");
        else $rs = $DB->Execute("SELECT * FROM T_LIST WHERE parent=\"$parent\"");
        while(!$rs->EOF)
        {
            $xml .= "<LIST id=\"{$rs->fields['list']}\" value=\"{$rs->fields['value']}\" url=\"{$rs->fields['url']}\">";
            $rss = $DB->Execute("SELECT * FROM T_LIST WHERE parent=?", array($rs->fields['list']));
            while(!$rss->EOF)
            {
                $xml .= $this->LoadListData($rss->fields['list'], NULL);
                $rss->MoveNext();
            }
            $xml .= "</LIST>";
            $rss->close();
            $rs->MoveNext();
        }
        $rs->close();
        if(!$xml)$xml = "<LIST parent=\"{$list}\" />";
        return $xml;
    }
}
?>