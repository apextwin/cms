<?
    class Faq extends Module
	{   
        function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'faq';
        } 
		function GetXML()
		{
		    global $Processor, $DB, $cfg;
            $realm = $Processor->realm;
		    if($_POST[faq])
		    {
		        $class = 'faq';
		        $data = $_POST[$class];
                if(!preg_match("/[0-9a-z_]+@[0-9a-z_^\.]+\.[a-z]{2,4}/i", $data['email']))
				{
					$xml .= "<MSG>введён некорректный e-mail!</MSG>";
					return $xml;
				}
    		    if($data['quser'] && $data['question'])
    		    {
                    $email = $data['email'];
                    $data['answered'] = 0;
                    $data['atime'] = 0;
                    $view = new Viewer();
                    $name = 'question';
                    $DB->Execute("INSERT INTO T_NODE (name, class, disabled) VALUES (?,?,?)", Array($name, $class, 1));
                    $nodeid = $DB->Identity();
                    $view->SetNodeRealm($nodeid, $realm, '0');
                    $valid_data = $view->ValidateInputData($class, $nodeid);
                    $view->SaveNodeData($nodeid, $valid_data);
                    $view->DeleteRealmCache($realm);
                    //print_r($valid_data);
                    $xml = "<MSG>Ваш вопрос успешно добавлен, ответ на него появятся здесь после рассмотрения консультантом. Пожалуйста учитывайте, что консультантам нужно некоторое время для формирования ответа.</MSG>";

                    $subject = "Задали новый вопрос";
					$headers = "From:\"".$cfg[email]."\r\n";
					$headers .= "Content-Type: text/html; charset=utf-8; ";
					$headers .= "MIME-Version: 1.0 ";
					$msg = "Добавлен новый вопрос в раздел: /".$Processor->Uri;
					$letter ="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body leftmargin=\"10\" topmargin=\"10\">".$msg."</body></html>";
					mail($cfg[email], $subject, $letter, $headers);
                }
            }
			return $xml;
		}
	}
?>