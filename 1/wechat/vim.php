<?php
/**
	微信公众帐号(vimtips)开发者模式,默认用户输入任何文字，均返回同一个图文信息,链接地址为Web site,可以根据变量$keyword，即用户输入的信息，进行判断，从而返回相应的信息
	Ubuntu,MySQL,PHP,Openresty,Lua
	/home/ywgx/
	0/ 1/ bin/ media/ etc/ log/ lib/
*/
define("TOKEN", "uber");
define("SERVER",'vimtips.mobi');
define("MUS_SERVER",'vimtips.mobi');
define("PIC_SERVER",'vimtips.mobi');
define("MUS_PATH",'/home/ywgx/media/mus');
define("PIC_PATH",'/home/ywgx/media/pic');
define("WSQ","http://m.wsq.qq.com/263027741");
define("FILE_P",'/home/ywgx/media/text/PicUrl');
define("FILE_S",'/home/ywgx/media/text/Saying');
define("FILE_M",'/home/ywgx/media/text/Musing');
$wechatObj = new wechatCallbackapi();

if (! isset ($_GET ['echostr'])) {
	$wechatObj->responseMsg();
} else {
	$wechatObj->valid();
}

class wechatCallbackapi
{
	public function valid()
	{
		$echoStr = $_GET["echostr"];
		if($this->checkSignature()){
			echo $echoStr;
			exit;
		}
	}
	public function responseMsg()
	{
		$postStr = $GLOBALS["HTTP_RAW_POST_DATA"];
		if (!empty($postStr)){
			$postObj = simplexml_load_string($postStr, 'SimpleXMLElement', LIBXML_NOCDATA);
			$fromUsername = $postObj->FromUserName;
			$type = $postObj->MsgType;
			$customevent = $postObj->Event;
			$toUsername = $postObj->ToUserName;
			$keyword = trim($postObj->Content);
			$time = time();
			$sign = 0;
			$textTpl = "<xml>
				<ToUserName><![CDATA[%s]]></ToUserName>
				<FromUserName><![CDATA[%s]]></FromUserName>
				<CreateTime>%s</CreateTime>
				<MsgType><![CDATA[%s]]></MsgType>
				<Content><![CDATA[%s]]></Content>
				<FuncFlag>0</FuncFlag>
				</xml>";
			$picTpl = "<xml>
				<ToUserName><![CDATA[%s]]></ToUserName>
				<FromUserName><![CDATA[%s]]></FromUserName>
				<CreateTime>%s</CreateTime>
				<MsgType><![CDATA[%s]]></MsgType>
				<ArticleCount>1</ArticleCount>
				<Articles>
				<item>
				<Title><![CDATA[%s]]></Title>
				<Description><![CDATA[%s]]></Description>
				<PicUrl><![CDATA[%s]]></PicUrl>
				<Url><![CDATA[%s]]></Url>
				</item>
				</Articles>
				<FuncFlag>1</FuncFlag>
				</xml> "; 
			$musicTpl = "<xml>
				<ToUserName><![CDATA[%s]]></ToUserName>
				<FromUserName><![CDATA[%s]]></FromUserName>
				<CreateTime>%s</CreateTime>
				<MsgType><![CDATA[%s]]></MsgType>
				<Music>
				<Title><![CDATA[%s]]></Title>
				<Description><![CDATA[%s]]></Description>
				<MusicUrl><![CDATA[%s]]></MusicUrl>
				<HQMusicUrl><![CDATA[%s]]></HQMusicUrl>
				</Music>
				<FuncFlag>0</FuncFlag>
				</xml> ";
			switch ($type)
			{
				case "event";
				if( $customevent == "subscribe" )
				{
					//pic & turl	
					$image = "http://vimtips.mobi/chan.jpg";
					$turl  = "http://mp.weixin.qq.com/s?__biz=MjM5NDg1OTI0MA==&mid=200404092&idx=1&sn=e424f36500b833f700020a432e5c2df7#rd";
					//desc	
					$des = exec('cat /proc/loadavg');
					//title 
					$title = "Waiting for you so long";
					//sign
					$sign = 1;
				}
				break;
				case "image";
				{
					$contentStr = "So beautiful!";
				}
				break;
				case "location";
				{
					$contentStr = "Oh, I'm here";
				}
				break;
				case "link";
				{
					$contentStr = "What's this?";
				}
				break;
				case "text";
				{
					switch ($keyword)
					{
					case "7":
						$contentStr = WSQ;
						break;
					case "s":
						$contentStr = exec('cd /home/ywgx/media/text/;wc -l PicUrl');
						break;
					case "q":
						$file = FILE_S;
						$cmd = "shuf -n1 ".$file;
						$contentStr = exec($cmd);
						break;
					case "m":
						$path = MUS_PATH;
						$server = MUS_SERVER;
						$cmd = "cd /home/ywgx/media/mus;shuf -n1 -e *";
						$id=exec($cmd);
						//music
						$music = "http://{$server}/{$id}";
						//title
						$title = $id;
						//des
						$file = FILE_M;
						$media = file($file);
						$cmd = "shuf -n1 ".$file;
						$des = exec($cmd);
						//MuiscUrl
						$MusicUrl = $music;
						//HQMusicUrl
						$HQMusicUrl= $music;
						//sign
						$sign = 2;
						break;
					case "e":
						$stime = microtime(true);
						//pic & turl	
						$file = FILE_P;
						$cmd  = "tail -n1 ".$file;
						$image = exec($cmd);
						$turl  = WSQ;
						//des
						$file = FILE_S;
						$cmd = "shuf -n1 ".$file;
						$des = exec($cmd);
						//title	
						$etime = microtime(true);
						$ttime = $etime-$stime;
						$str_total=var_export($ttime,TRUE);
						if(substr_count($str_total,"E")){
							$float_total=floatval(substr($str_total,5));
							$ttime=$float_total/100000;
						}
						$title = (string)$ttime;
						//sign
						$sign = 1;
						break;
					default:
						$stime = microtime(true);
						//pic & turl	
						$file = FILE_P;
						$cmd  = "shuf -n1 ".$file;
						$image = exec($cmd);
						$turl  = WSQ;
						//des
						$file = FILE_S;
						$cmd = "shuf -n1 ".$file;
						$des = exec($cmd);
						//title	
						$etime = microtime(true);
						$ttime = $etime-$stime;
						$str_total=var_export($ttime,TRUE);
						if(substr_count($str_total,"E")){
							$float_total=floatval(substr($str_total,5));
							$ttime=$float_total/100000;
						}
						$title = (string)$ttime;
						//sign
						$sign = 1;
						break;
					}
				}
				break;
			}
			switch ($sign)
			{
			case 0:
				$msgType = "text";
				$resultStr = sprintf($textTpl, $fromUsername, $toUsername, $time, $msgType,$contentStr);
				echo $resultStr;
				break;
			case 1:
				$msgType = "news";
				$resultStr = sprintf($picTpl, $fromUsername, $toUsername, $time, $msgType, $title,$des,$image,$turl);
				echo $resultStr;
				break;
			case 2:
				$msgType = "music";
				$resultStr = sprintf($musicTpl, $fromUsername, $toUsername, $time, $msgType, $title,$des,$MusicUrl,$HQMusicUrl);
				echo $resultStr;
				break;
			}
		}else {
			echo "";
			exit;
		}
	}
	private function checkSignature()
	{
		$signature = $_GET["signature"];
		$timestamp = $_GET["timestamp"];
		$nonce = $_GET["nonce"];	
		$token = TOKEN;
		$tmpArr = array($token, $timestamp, $nonce);
		sort($tmpArr,SORT_STRING);
		$tmpStr = implode( $tmpArr );
		$tmpStr = sha1( $tmpStr );
		if( $tmpStr == $signature ){
			return true;
		}else{
			return false;
		}
	}
}
?>
